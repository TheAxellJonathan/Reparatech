<?php
require 'db.php'; session_start();
header('Content-Type: application/json; charset=utf-8');
if(!isset($_SESSION['usuario_id']) || $_SESSION['usuario_tipo']!=='empleado'){ http_response_code(403); echo json_encode(['error'=>'No autorizado']); exit; }

$data = json_decode(file_get_contents('php://input'), true) ?? $_POST;
$id = intval($data['id'] ?? 0);
if(!$id){ http_response_code(400); echo json_encode(['error'=>'ID faltante']); exit; }

// obtener imagen para eliminar
$stmt = $pdo->prepare('SELECT imagen FROM productos WHERE id_producto = ?');
$stmt->execute([$id]);
$prod = $stmt->fetch();
if(!$prod){ http_response_code(404); echo json_encode(['error'=>'Producto no encontrado']); exit; }
$imagen = $prod['imagen'];

$stmt = $pdo->prepare('DELETE FROM productos WHERE id_producto = ?');
$stmt->execute([$id]);
if($imagen && file_exists('../'.$imagen)) @unlink('../'.$imagen);

echo json_encode(['ok'=>true]);
