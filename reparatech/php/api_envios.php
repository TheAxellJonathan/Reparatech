<?php
header('Content-Type: application/json; charset=utf-8');
require 'db.php';
session_start();

if(!isset($_SESSION['usuario_id']) || $_SESSION['usuario_tipo'] !== 'empleado') {
  http_response_code(403);
  echo json_encode(['error' => 'Acceso denegado']);
  exit;
}

$accion = $_GET['accion'] ?? $_POST['accion'] ?? '';

// Listar todos los envíos/pedidos
if($accion === 'listar') {
  try {
    $stmt = $pdo->query('
      SELECT e.id_envio, e.id_pedido, e.nombre_cliente, e.direccion, e.telefono, e.estatus, e.folio_rastreo, e.fecha_envio,
             p.total, u.nombre as usuario_nombre
      FROM envios e
      JOIN pedidos p ON e.id_pedido = p.id_pedido
      JOIN usuarios u ON p.id_cliente = u.id_usuario
      ORDER BY e.fecha_envio DESC
    ');
    $envios = $stmt->fetchAll();
    echo json_encode($envios);
  } catch(Exception $e) {
    http_response_code(500);
    echo json_encode(['error' => $e->getMessage()]);
  }
  exit;
}

// Obtener detalles de un envío
if($accion === 'detalles' && isset($_GET['id_envio'])) {
  try {
    $id_envio = (int)$_GET['id_envio'];
    $stmt = $pdo->prepare('
      SELECT e.*, p.id_pedido, p.total
      FROM envios e
      JOIN pedidos p ON e.id_pedido = p.id_pedido
      WHERE e.id_envio = ?
    ');
    $stmt->execute([$id_envio]);
    $envio = $stmt->fetch();
    
    if(!$envio) {
      http_response_code(404);
      echo json_encode(['error' => 'No encontrado']);
      exit;
    }

    // Obtener items del pedido
    $stmt = $pdo->prepare('
      SELECT dp.cantidad, dp.subtotal, p.nombre, p.imagen
      FROM detalle_pedido dp
      JOIN productos p ON dp.id_producto = p.id_producto
      WHERE dp.id_pedido = ?
    ');
    $stmt->execute([$envio['id_pedido']]);
    $items = $stmt->fetchAll();

    // Obtener imágenes de envío
    $stmt = $pdo->prepare('SELECT ruta_imagen FROM imagenes_envio WHERE id_envio = ?');
    $stmt->execute([$id_envio]);
    $imagenes = $stmt->fetchAll();

    echo json_encode(['envio' => $envio, 'items' => $items, 'imagenes' => $imagenes]);
  } catch(Exception $e) {
    http_response_code(500);
    echo json_encode(['error' => $e->getMessage()]);
  }
  exit;
}

// Actualizar estatus de envío
if($accion === 'actualizar_estatus' && $_SERVER['REQUEST_METHOD'] === 'POST') {
  try {
    $data = json_decode(file_get_contents('php://input'), true);
    $id_envio = (int)($data['id_envio'] ?? 0);
    $nuevo_estatus = trim($data['estatus'] ?? '');
    $folio_rastreo = trim($data['folio_rastreo'] ?? null);

    if(!$id_envio || !$nuevo_estatus) {
      http_response_code(400);
      echo json_encode(['error' => 'Datos incompletos']);
      exit;
    }

    // Validar estatus válido
    $estatus_validos = ['En procesamiento', 'Empacado', 'En camino', 'Entregado', 'Cancelado'];
    if(!in_array($nuevo_estatus, $estatus_validos)) {
      http_response_code(400);
      echo json_encode(['error' => 'Estatus inválido']);
      exit;
    }

    $fecha_entrega = ($nuevo_estatus === 'Entregado') ? date('Y-m-d H:i:s') : null;
    
    $stmt = $pdo->prepare('UPDATE envios SET estatus = ?, folio_rastreo = ?, fecha_entrega = ? WHERE id_envio = ?');
    $stmt->execute([$nuevo_estatus, $folio_rastreo, $fecha_entrega, $id_envio]);

    // Log de acción
    logAccion($_SESSION['usuario_id'], 'actualizar_envio', "Envío #$id_envio actualizado a: $nuevo_estatus", 'envios', $id_envio);

    echo json_encode(['ok' => true, 'mensaje' => 'Estatus actualizado']);
  } catch(Exception $e) {
    http_response_code(500);
    echo json_encode(['error' => $e->getMessage()]);
  }
  exit;
}

// Subir imagen de comprobante de entrega
if($accion === 'subir_comprobante' && $_SERVER['REQUEST_METHOD'] === 'POST') {
  try {
    $id_envio = (int)($_POST['id_envio'] ?? 0);
    if(!$id_envio || !isset($_FILES['imagen'])) {
      http_response_code(400);
      echo json_encode(['error' => 'Datos incompletos']);
      exit;
    }

    $file = $_FILES['imagen'];
    $ext = strtolower(pathinfo($file['name'], PATHINFO_EXTENSION));
    if(!in_array($ext, ['jpg', 'jpeg', 'png', 'gif'])) {
      http_response_code(400);
      echo json_encode(['error' => 'Formato no permitido']);
      exit;
    }

    $filename = 'comprobante_' . $id_envio . '_' . time() . '.' . $ext;
    $ruta = '../uploads/' . $filename;
    
    if(!is_dir('../uploads')) mkdir('../uploads', 0755, true);
    
    if(!move_uploaded_file($file['tmp_name'], $ruta)) {
      http_response_code(500);
      echo json_encode(['error' => 'Error subiendo archivo']);
      exit;
    }

    $stmt = $pdo->prepare('INSERT INTO imagenes_envio (id_envio, ruta_imagen) VALUES (?, ?)');
    $stmt->execute([$id_envio, $ruta]);

    logAccion($_SESSION['usuario_id'], 'subir_comprobante', "Comprobante subido para envío #$id_envio", 'imagenes_envio', $pdo->lastInsertId());

    echo json_encode(['ok' => true, 'ruta' => $ruta, 'mensaje' => 'Comprobante subido']);
  } catch(Exception $e) {
    http_response_code(500);
    echo json_encode(['error' => $e->getMessage()]);
  }
  exit;
}

// Eliminar pedido
if($accion === 'eliminar_pedido' && $_SERVER['REQUEST_METHOD'] === 'POST') {
  try {
    $data = json_decode(file_get_contents('php://input'), true);
    $id_pedido = (int)($data['id_pedido'] ?? 0);

    if(!$id_pedido) {
      http_response_code(400);
      echo json_encode(['error' => 'ID de pedido inválido']);
      exit;
    }

    // Eliminar pedido (las FKs en cascada deberían limpiar detalles y envíos, pero verificamos)
    $stmt = $pdo->prepare('DELETE FROM pedidos WHERE id_pedido = ?');
    $stmt->execute([$id_pedido]);

    if($stmt->rowCount() > 0) {
        logAccion($_SESSION['usuario_id'], 'eliminar_pedido', "Pedido #$id_pedido eliminado", 'pedidos', $id_pedido);
        echo json_encode(['ok' => true, 'mensaje' => 'Pedido eliminado correctamente']);
    } else {
        http_response_code(404);
        echo json_encode(['error' => 'Pedido no encontrado o ya eliminado']);
    }
  } catch(Exception $e) {
    http_response_code(500);
    echo json_encode(['error' => $e->getMessage()]);
  }
  exit;
}

echo json_encode(['error' => 'Acción no válida']);

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
