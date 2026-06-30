<?php
header('Content-Type: application/json; charset=utf-8');
require 'db.php';

try {
    $stmt = $pdo->query('SELECT * FROM colores ORDER BY nombre_color ASC');
    $colores = $stmt->fetchAll(PDO::FETCH_ASSOC);
    echo json_encode($colores);
} catch (Exception $e) {
    http_response_code(500);
    echo json_encode(['error' => 'Error al obtener colores']);
}
