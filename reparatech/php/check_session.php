<?php
// Endpoint para verificar la sesión del usuario
header('Content-Type: application/json; charset=utf-8');
session_start();

if(!isset($_SESSION['usuario_id'])) {
  http_response_code(401);
  echo json_encode(['loggedin' => false, 'error' => 'No hay sesión activa']);
  exit;
}

echo json_encode([
  'loggedin' => true,
  'usuario_id' => $_SESSION['usuario_id'],
  'usuario_tipo' => $_SESSION['usuario_tipo'] ?? 'desconocido',
  'usuario_nombre' => $_SESSION['usuario_nombre'] ?? 'Sin nombre'
]);
?>
