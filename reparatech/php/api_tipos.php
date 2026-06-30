<?php
header('Content-Type: application/json; charset=utf-8');
require 'db.php';
 $stmt = $pdo->query('SELECT * FROM tipos_equipo ORDER BY nombre_tipo');
 echo json_encode($stmt->fetchAll());
