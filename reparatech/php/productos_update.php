<?php
require 'db.php'; session_start();
header('Content-Type: application/json; charset=utf-8');
if(!isset($_SESSION['usuario_id']) || $_SESSION['usuario_tipo']!=='empleado'){ http_response_code(403); echo json_encode(['error'=>'No autorizado']); exit; }

$id = intval($_POST['id'] ?? 0);
if(!$id){ http_response_code(400); echo json_encode(['error'=>'ID faltante']); exit; }

$nombre = $_POST['nombre'] ?? '';
$descripcion = $_POST['descripcion'] ?? null;
$categoria = $_POST['categoria'] ?? null;
$precio = isset($_POST['precio']) ? floatval($_POST['precio']) : 0.0;
$stock = isset($_POST['stock']) ? intval($_POST['stock']) : 0;

// Obtener producto previo para ruta de imagen
$stmt = $pdo->prepare('SELECT imagen FROM productos WHERE id_producto = ?');
$stmt->execute([$id]);
$prod = $stmt->fetch();
if(!$prod){ http_response_code(404); echo json_encode(['error'=>'Producto no encontrado']); exit; }
$imagen_ruta = $prod['imagen'];

// Si viene nueva imagen, procesarla
if(isset($_FILES['imagen']) && $_FILES['imagen']['error']===0){
  $ext = pathinfo($_FILES['imagen']['name'], PATHINFO_EXTENSION);
  $nuevo = 'uploads/producto_'.time().'_'.mt_rand(1000,9999).'.'.($ext?:'jpg');
  if(!is_dir('../uploads')) mkdir('../uploads',0777,true);
  if(move_uploaded_file($_FILES['imagen']['tmp_name'], '../'.$nuevo)){
    // eliminar antigua si existe
    if($imagen_ruta && file_exists('../'.$imagen_ruta)) @unlink('../'.$imagen_ruta);
    $imagen_ruta = $nuevo;
  }
}

$stmt = $pdo->prepare('UPDATE productos SET nombre=?, descripcion=?, categoria=?, precio=?, stock=?, imagen=? WHERE id_producto = ?');
$stmt->execute([$nombre,$descripcion,$categoria,$precio,$stock,$imagen_ruta,$id]);

echo json_encode(['ok'=>true,'id'=>$id]);
