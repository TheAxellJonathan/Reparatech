<?php
require 'db.php'; header('Content-Type: application/json; charset=utf-8');
$id = intval($_GET['id'] ?? 0);
if(!$id){ echo json_encode(['error'=>'Falta id']); exit; }
$stmt = $pdo->prepare('SELECT * FROM comprobantes WHERE id_reparacion = ?'); $stmt->execute([$id]); $c = $stmt->fetch();
if(!$c){ echo json_encode(['error'=>'No encontrado']); exit; }
echo json_encode($c);
