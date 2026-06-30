<?php
// Subir imágenes para una reparación (hasta 5)
require 'db.php'; session_start();
header('Content-Type: application/json; charset=utf-8');
if(!isset($_SESSION['usuario_id']) || $_SESSION['usuario_tipo']!=='empleado'){ http_response_code(403); echo json_encode(['error'=>'No autorizado']); exit; }

$id_reparacion = intval($_POST['id_reparacion'] ?? 0);
if(!$id_reparacion){ http_response_code(400); echo json_encode(['error'=>'Falta id_reparacion']); exit; }

if(!is_dir('../uploads')) mkdir('../uploads',0777,true);

$guardadas = [];
for($i=0;$i<5;$i++){
  if(!isset($_FILES["imagen_$i"])) continue;
  $f = $_FILES["imagen_$i"];
  if($f['error']!==0) continue;
  $ext = pathinfo($f['name'], PATHINFO_EXTENSION);
  $nuevo = 'uploads/reparacion_'.$id_reparacion.'_'.time().'_'.$i.'.'.($ext?:'jpg');
  if(move_uploaded_file($f['tmp_name'],'../'.$nuevo)){
    $stmt = $pdo->prepare('INSERT INTO imagenes_reparacion (id_reparacion, ruta_imagen) VALUES (?,?)');
    $stmt->execute([$id_reparacion,$nuevo]);
    $guardadas[] = $nuevo;
  }
}

echo json_encode(['ok'=>true,'guardadas'=>$guardadas]);
