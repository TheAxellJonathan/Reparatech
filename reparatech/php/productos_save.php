<?php
header('Content-Type: application/json; charset=utf-8');
require 'db.php';
session_start();

if(!isset($_SESSION['usuario_id']) || $_SESSION['usuario_tipo']!=='empleado'){
  http_response_code(403);
  echo json_encode(['error'=>'No autorizado']);
  exit;
}

try {
  $nombre = $_POST['nombre'] ?? '';
  $descripcion = $_POST['descripcion'] ?? null;
  $categoria = $_POST['categoria'] ?? null;
  $precio = floatval($_POST['precio'] ?? 0);
  $stock = intval($_POST['stock'] ?? 0);
  $imagen_ruta = null;

  if(!$nombre || $precio <= 0 || $stock < 0){
    http_response_code(400);
    echo json_encode(['error'=>'Nombre, precio y stock válidos son requeridos']);
    exit;
  }

  if(isset($_FILES['imagen']) && $_FILES['imagen']['error']===0){
    $ext = pathinfo($_FILES['imagen']['name'], PATHINFO_EXTENSION);
    $nuevo = 'uploads/producto_'.time().'.'.($ext?:'jpg');
    if(!is_dir('../uploads')) mkdir('../uploads',0777,true);
    if(move_uploaded_file($_FILES['imagen']['tmp_name'], '../'.$nuevo)) $imagen_ruta = $nuevo;
  }

  $stmt = $pdo->prepare('INSERT INTO productos (nombre,descripcion,categoria,precio,stock,imagen) VALUES (?,?,?,?,?,?)');
  $stmt->execute([$nombre,$descripcion,$categoria,$precio,$stock,$imagen_ruta]);
  $id_producto = $pdo->lastInsertId();

  // Log de acción
  $stmt_log = $pdo->prepare('INSERT INTO logs (id_usuario, tipo_accion, descripcion, tabla_afectada, id_registro) VALUES (?, ?, ?, ?, ?)');
  $stmt_log->execute([$_SESSION['usuario_id'], 'INSERT', 'Nuevo producto: '.$nombre, 'productos', $id_producto]);

  http_response_code(201);
  echo json_encode(['ok'=>true, 'id_producto'=>$id_producto, 'mensaje'=>'Producto guardado correctamente']);
} catch(Exception $e) {
  http_response_code(500);
  echo json_encode(['error'=>'Error al guardar: '.$e->getMessage()]);
}
