<?php
header('Content-Type: application/json; charset=utf-8');
require 'db.php';
session_start();

if(!isset($_SESSION['usuario_id']) || $_SESSION['usuario_tipo'] !== 'empleado') {
  http_response_code(403);
  echo json_encode(['error' => 'Acceso denegado']);
  exit;
}

$accion = $_GET['accion'] ?? '';
$limit = (int)($_GET['limit'] ?? 100);
$offset = (int)($_GET['offset'] ?? 0);

try {
  // Listar logs
  $stmt = $pdo->prepare('
    SELECT l.*, u.nombre as usuario_nombre
    FROM logs l
    LEFT JOIN usuarios u ON l.id_usuario = u.id_usuario
    ORDER BY l.fecha_log DESC
    LIMIT ? OFFSET ?
  ');
  $stmt->execute([$limit, $offset]);
  $logs = $stmt->fetchAll();

  echo json_encode($logs);
} catch(Exception $e) {
  http_response_code(500);
  echo json_encode(['error' => $e->getMessage()]);
}
?>
