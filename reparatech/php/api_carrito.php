<?php
// API de carrito usando sesión PHP (no localStorage)
error_reporting(E_ALL);
ini_set('display_errors', 0); // No mostrar errores en output
ob_start(); // Capturar cualquier output no deseado

session_start();
header('Content-Type: application/json; charset=utf-8');

// Función para manejar errores y asegurar respuesta JSON
function handleError($errno, $errstr, $errfile, $errline) {
    ob_clean();
    echo json_encode(['ok' => false, 'error' => "Error PHP: $errstr en $errfile:$errline"]);
    exit;
}
set_error_handler('handleError');

require 'db.php';

// Inicializar carrito en sesión
if(!isset($_SESSION['carrito'])) $_SESSION['carrito'] = [];

$accion = $_GET['accion'] ?? $_POST['accion'] ?? null;

if($accion === 'agregar'){
  $id = (int)($_POST['id'] ?? 0);
  $cantidad = (int)($_POST['cantidad'] ?? 1);
  if($id <= 0){ echo json_encode(['ok'=>false, 'error'=>'ID inválido']); exit; }
  
  // Verificar stock
  $stmt = $pdo->prepare('SELECT stock FROM productos WHERE id_producto = ?');
  $stmt->execute([$id]);
  $prod = $stmt->fetch();
  if(!$prod){ echo json_encode(['ok'=>false, 'error'=>'Producto no existe']); exit; }
  if($prod['stock'] < $cantidad){ echo json_encode(['ok'=>false, 'error'=>'Stock insuficiente']); exit; }
  
  // Agregar o actualizar en carrito
  $existe = false;
  foreach($_SESSION['carrito'] as &$item){
    if($item['id'] == $id){
      $item['cantidad'] += $cantidad;
      $existe = true;
      break;
    }
  }
  if(!$existe) $_SESSION['carrito'][] = ['id'=>$id, 'cantidad'=>$cantidad];
  
  echo json_encode(['ok'=>true, 'mensaje'=>'Producto agregado', 'carrito'=>$_SESSION['carrito']]);
}
elseif($accion === 'eliminar'){
  $id = (int)($_POST['id'] ?? 0);
  $_SESSION['carrito'] = array_filter($_SESSION['carrito'], fn($item) => $item['id'] != $id);
  $_SESSION['carrito'] = array_values($_SESSION['carrito']); // reindexar
  echo json_encode(['ok'=>true, 'carrito'=>$_SESSION['carrito']]);
}
elseif($accion === 'actualizar'){
  $id = (int)($_POST['id'] ?? 0);
  $cantidad = (int)($_POST['cantidad'] ?? 1);
  if($cantidad <= 0){
    $_SESSION['carrito'] = array_filter($_SESSION['carrito'], fn($item) => $item['id'] != $id);
    $_SESSION['carrito'] = array_values($_SESSION['carrito']);
  }else{
    foreach($_SESSION['carrito'] as &$item){
      if($item['id'] == $id){ $item['cantidad'] = $cantidad; break; }
    }
  }
  echo json_encode(['ok'=>true, 'carrito'=>$_SESSION['carrito']]);
}
elseif($accion === 'limpiar'){
  $_SESSION['carrito'] = [];
  echo json_encode(['ok'=>true]);
}
elseif($accion === 'crear_pedido'){
  // Crear pedido desde checkout
  if(!isset($_SESSION['usuario_id'])){
    echo json_encode(['ok'=>false, 'error'=>'No hay sesión de usuario']);
    exit;
  }
  
  if(empty($_SESSION['carrito'])){
    echo json_encode(['ok'=>false, 'error'=>'Carrito vacío']);
    exit;
  }

  $tipo_entrega = $_POST['tipo_entrega'] ?? 'tienda';
  
  // Datos de contacto/envío
  $nombres = $_POST['nombres'] ?? '';
  $apellidos = $_POST['apellidos'] ?? '';
  $telefono = $_POST['telefono'] ?? '';
  
  // Dirección detallada
  $calle = $_POST['calle'] ?? '';
  $colonia = $_POST['colonia'] ?? '';
  $municipio = $_POST['municipio'] ?? '';
  $estado = $_POST['estado'] ?? '';
  $pais = $_POST['pais'] ?? 'México';
  $codigo_postal = $_POST['codigo_postal'] ?? '';
  
  // Construir dirección completa para resumen
  $direccion_completa = "$calle, $colonia, $municipio, $estado, $pais, CP $codigo_postal";

  try{
    $pdo->beginTransaction();

    // Asegurar que el usuario tenga un registro en la tabla clientes
    $stmt = $pdo->prepare('SELECT id_cliente FROM clientes WHERE id_cliente = ?');
    $stmt->execute([$_SESSION['usuario_id']]);
    $cliente_existe = $stmt->fetch();
    
    if(!$cliente_existe) {
      // Crear registro en clientes si no existe
      $stmt = $pdo->prepare('INSERT INTO clientes (id_cliente, correo, direccion) VALUES (?, NULL, NULL)');
      $stmt->execute([$_SESSION['usuario_id']]);
    }

    // Crear pedido
    $stmt = $pdo->prepare('INSERT INTO pedidos (id_cliente, fecha, total, estatus, tipo_entrega) VALUES (?, NOW(), 0, ?, ?)');
    $stmt->execute([$_SESSION['usuario_id'], 'Pagado', $tipo_entrega]);
    $id_pedido = $pdo->lastInsertId();

    $total = 0;
    foreach($_SESSION['carrito'] as $item){
      $id_prod = $item['id'];
      $cantidad = $item['cantidad'];
      
      // Obtener producto y validar stock
      $stmt = $pdo->prepare('SELECT id_producto, precio, stock, nombre FROM productos WHERE id_producto = ? FOR UPDATE');
      $stmt->execute([$id_prod]);
      $prod = $stmt->fetch();
      
      if(!$prod || $prod['stock'] < $cantidad){
        $pdo->rollBack();
        echo json_encode(['ok'=>false, 'error'=>'Stock insuficiente para: '.$prod['nombre']]);
        exit;
      }

      $precio = $prod['precio'];
      $subtotal = $precio * $cantidad;
      $total += $subtotal;

      // Insertar detalle
      $stmt = $pdo->prepare('INSERT INTO detalle_pedido (id_pedido, id_producto, cantidad, subtotal) VALUES (?, ?, ?, ?)');
      $stmt->execute([$id_pedido, $id_prod, $cantidad, $subtotal]);

      // Decrementar stock
      $stmt = $pdo->prepare('UPDATE productos SET stock = stock - ? WHERE id_producto = ?');
      $stmt->execute([$cantidad, $id_prod]);

      // Si stock llega a 0, log
      if($prod['stock'] - $cantidad <= 0){
        $stmt = $pdo->prepare('INSERT INTO logs (id_usuario, tipo_accion, descripcion, fecha_log) VALUES (?, ?, ?, NOW())');
        $stmt->execute([$_SESSION['usuario_id'], 'producto_agotado', 'Producto '.$id_prod.' agotado']);
      }
    }

    // Actualizar total del pedido
    $stmt = $pdo->prepare('UPDATE pedidos SET total = ? WHERE id_pedido = ?');
    $stmt->execute([$total, $id_pedido]);

    // Crear envío (siempre se crea registro en envios para rastrear contacto, aunque sea tienda)
    $estatus_envio = ($tipo_entrega === 'tienda') ? 'Entregado' : 'Pendiente'; // Si es tienda, se asume entregado o listo para recoger? Mejor 'Pendiente' de recoger.
    if($tipo_entrega === 'tienda') $estatus_envio = 'Listo para recoger';
    
    $stmt = $pdo->prepare('INSERT INTO envios (id_pedido, direccion, calle, colonia, municipio, estado, pais, codigo_postal, telefono, nombres_contacto, apellidos_contacto, telefono_contacto, estatus) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)');
    $stmt->execute([$id_pedido, $direccion_completa, $calle, $colonia, $municipio, $estado, $pais, $codigo_postal, $telefono, $nombres, $apellidos, $telefono, $estatus_envio]);

    // Log del pedido
    $stmt = $pdo->prepare('INSERT INTO logs (id_usuario, tipo_accion, descripcion, fecha_log) VALUES (?, ?, ?, NOW())');
    $stmt->execute([$_SESSION['usuario_id'], 'pedido_creado', 'Pedido '.$id_pedido.' creado por $'.$total]);

    $pdo->commit();

    // Generar PDF
    $pdfRes = ['ok' => false];
    try {
        require_once 'lib_pdf_venta.php';
        $pdfRes = generar_ticket_venta($pdo, $id_pedido);
    } catch (Exception $e) {
        error_log("Error generando PDF venta: " . $e->getMessage());
    }

    // --- Notificación WhatsApp al Negocio ---
    // Construir mensaje detallado
    $nl = "%0A"; // Salto de línea para URL encoded
    $msg = "*¡Nuevo Pedido Recibido!* 🎉$nl";
    $msg .= "Folio: *V-" . str_pad($id_pedido, 6, '0', STR_PAD_LEFT) . "*$nl";
    $msg .= "Fecha: " . date('d/m/Y H:i') . "$nl";
    $msg .= "Cliente: $nombres $apellidos$nl";
    $msg .= "Teléfono: $telefono$nl";
    $msg .= "Entrega: *" . ucfirst($tipo_entrega) . "*$nl";
    
    if ($tipo_entrega === 'domicilio') {
        $msg .= "Dirección: $calle, $colonia, $municipio, CP $codigo_postal$nl";
    }

    $msg .= "$nl*Productos:*$nl";
    foreach($_SESSION['carrito'] as $item) {
        // Recuperar nombre para el msj (ya consultado antes pero lo hacemos simple aquí o usamos arrays paralelos si fuera crítico optimizar, pero es rápido)
        // Para simplificar, obtenemos de la BDD o del array $prod en el loop anterior si lo hubiéramos guardado. 
        // Re-consultamos brevemente nombre
        $stmtP = $pdo->prepare("SELECT nombre FROM productos WHERE id_producto = ?");
        $stmtP->execute([$item['id']]);
        $nomP = $stmtP->fetchColumn() ?: 'Producto';
        $msg .= "- {$item['cantidad']}x $nomP$nl";
    }
    $msg .= "$nl*Total: $".number_format($total, 2)."*";

    // NOTA: Aquí iría la llamada real a una API de WhatsApp (ej. Twilio, Ultramsg, WppConnect, etc.)
    // Como no tenemos credenciales, lo simulamos registrando en logs.
    // Ejemplo de implementación real comentada:
    /*
    $api_url = "https://api.tu-proveedor.com/send";
    $data = [
        "phone" => "527448171159", // Número del negocio
        "message" => str_replace("%0A", "\n", $msg)
    ];
    // curl_exec(...)
    */
    
    // Guardamos en log para confirmar que se "envió"
    $stmt = $pdo->prepare('INSERT INTO logs (id_usuario, tipo_accion, descripcion, fecha_log) VALUES (?, ?, ?, NOW())');
    $stmt->execute([$_SESSION['usuario_id'], 'notificacion_whatsapp', "Simulacro envío WhatsApp al negocio: " . substr($msg, 0, 100) . "..."]);

    // Limpiar carrito
    $_SESSION['carrito'] = [];

    echo json_encode(['ok'=>true, 'folio_pedido'=>$id_pedido, 'total'=>$total, 'pdf'=>$pdfRes['ruta'] ?? null, 'whatsapp_msg'=>$msg]);
  }catch(Exception $e){
    $pdo->rollBack();
    echo json_encode(['ok'=>false, 'error'=>$e->getMessage()]);
  }
}
else{
  // GET sin acción = listar carrito
  echo json_encode(['carrito'=>$_SESSION['carrito']]);
}
?>

