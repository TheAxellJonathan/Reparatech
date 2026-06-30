<?php
header('Content-Type: application/json; charset=utf-8');
require 'db.php';
session_start();

if($_SERVER['REQUEST_METHOD'] !== 'POST') {
  http_response_code(405);
  echo json_encode(['error' => 'Método no permitido']);
  exit;
}

$data = json_decode(file_get_contents('php://input'), true) ?? $_POST;

// Crear pedido desde checkout
if(isset($data['carrito']) && isset($data['nombre'])) {
  if(!isset($_SESSION['usuario_id'])) {
    http_response_code(401);
    echo json_encode(['error' => 'Debe iniciar sesión']);
    exit;
  }

  $id_cliente = $_SESSION['usuario_id'];
  $carrito = $data['carrito'] ?? [];
  $total = (float)($data['total'] ?? 0);
  $nombre = trim($data['nombre'] ?? '');
  $telefono = trim($data['telefono'] ?? '');
  $direccion = trim($data['direccion'] ?? '');
  $codigo_postal = trim($data['codigo_postal'] ?? '');

  if(!$nombre || !$telefono || !$direccion || empty($carrito)) {
    http_response_code(400);
    echo json_encode(['error' => 'Faltan campos requeridos']);
    exit;
  }

  try {
    $pdo->beginTransaction();

    // Crear pedido
    $stmt = $pdo->prepare('INSERT INTO pedidos (id_cliente, total, estatus) VALUES (?, ?, ?)');
    $stmt->execute([$id_cliente, $total, 'Pendiente']);
    $id_pedido = $pdo->lastInsertId();

    // Insertar items del pedido y decrementar stock
    foreach($carrito as $item) {
      $id_producto = (int)$item['id'];
      $cantidad = (int)$item['cantidad'];

      // Obtener precio y stock actual del producto
      $stmt = $pdo->prepare('SELECT precio, stock FROM productos WHERE id_producto = ? FOR UPDATE');
      $stmt->execute([$id_producto]);
      $prod = $stmt->fetch();
      if(!$prod) {
        // producto no existe, abortar
        throw new Exception("Producto no encontrado: $id_producto");
      }

      if($prod['stock'] < $cantidad) {
        // stock insuficiente
        throw new Exception("Stock insuficiente para el producto ID $id_producto");
      }

      $subtotal = $prod['precio'] * $cantidad;
      $stmt = $pdo->prepare('INSERT INTO detalle_pedido (id_pedido, id_producto, cantidad, subtotal) VALUES (?, ?, ?, ?)');
      $stmt->execute([$id_pedido, $id_producto, $cantidad, $subtotal]);

      // Actualizar stock
      $nuevo_stock = $prod['stock'] - $cantidad;
      $stmt = $pdo->prepare('UPDATE productos SET stock = ? WHERE id_producto = ?');
      $stmt->execute([$nuevo_stock, $id_producto]);

      // Si se agotó, generar log
      if($nuevo_stock <= 0) {
        logAccion($_SESSION['usuario_id'], 'producto_agotado', "Producto ID $id_producto agotado tras pedido #$id_pedido", 'productos', $id_producto);
      }
    }

    // Crear registro de envío
    $stmt = $pdo->prepare('INSERT INTO envios (id_pedido, nombre_cliente, direccion, telefono, estatus) VALUES (?, ?, ?, ?, ?)');
    $stmt->execute([$id_pedido, $nombre, $direccion, $telefono, 'En procesamiento']);
    $id_envio = $pdo->lastInsertId();

    // Marcar pedido como Pagado (simulando pago inmediato)
    $stmt = $pdo->prepare('UPDATE pedidos SET estatus = ? WHERE id_pedido = ?');
    $stmt->execute(['Pagado', $id_pedido]);

    // Log de acción
    logAccion($_SESSION['usuario_id'], 'pedido_creado', "Nuevo pedido #$id_pedido creado y pagado", 'pedidos', $id_pedido);

    $pdo->commit();

    echo json_encode([
      'ok' => true,
      'folio_pedido' => $id_pedido,
      'id_envio' => $id_envio,
      'mensaje' => 'Pedido procesado correctamente'
    ]);
  } catch(Exception $e) {
    $pdo->rollBack();
    http_response_code(500);
    echo json_encode(['error' => 'Error procesando pedido: ' . $e->getMessage()]);
  }
  exit;
}

// API antigua de crear_pedido (mantener compatibilidad)
if(isset($data['accion']) && $data['accion'] === 'crear_pedido') {
  if(!isset($_SESSION['usuario_id']) || $_SESSION['usuario_tipo'] !== 'cliente') {
    http_response_code(403);
    echo json_encode(['error' => 'Debe iniciar sesión como cliente']);
    exit;
  }
  $id_cliente = $_SESSION['usuario_id'];
  $items = $data['items'] ?? [];
  if(!count($items)) {
    http_response_code(400);
    echo json_encode(['error' => 'Carrito vacío']);
    exit;
  }

  $total = 0;
  foreach($items as $it) {
    $total += $it['cantidad'] * floatval($it['precio'] ?? 0);
  }

  $pdo->beginTransaction();
  try {
    $stmt = $pdo->prepare('INSERT INTO pedidos (id_cliente, total, estatus) VALUES (?, ?, ?)');
    $stmt->execute([$id_cliente, $total, 'Pendiente']);
    $id_pedido = $pdo->lastInsertId();
    $stmt = $pdo->prepare('INSERT INTO detalle_pedido (id_pedido, id_producto, cantidad, subtotal) VALUES (?, ?, ?, ?)');
    foreach($items as $it) {
      $subtotal = $it['cantidad'] * floatval($it['precio']);
      $stmt->execute([$id_pedido, $it['id_producto'], $it['cantidad'], $subtotal]);
    }
    $pdo->commit();
    echo json_encode(['ok' => true, 'id_pedido' => $id_pedido]);
  } catch(Exception $e) {
    $pdo->rollBack();
    http_response_code(500);
    echo json_encode(['error' => $e->getMessage()]);
  }
  exit;
}

echo json_encode(['error' => 'Acción no especificada']);

function logAccion($id_usuario, $tipo_accion, $descripcion, $tabla_afectada = '', $id_registro = 0) {
  global $pdo;
  try {
    $ip = $_SERVER['REMOTE_ADDR'] ?? 'N/A';
    $stmt = $pdo->prepare('INSERT INTO logs (id_usuario, tipo_accion, descripcion, tabla_afectada, id_registro, ip_address) VALUES (?, ?, ?, ?, ?, ?)');
    $stmt->execute([$id_usuario, $tipo_accion, $descripcion, $tabla_afectada, $id_registro, $ip]);
  } catch(Exception $e) {
    // Silenciar errores de log
  }
}
?>
