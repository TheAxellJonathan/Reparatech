<?php
header('Content-Type: application/json; charset=utf-8');
require 'db.php';
 $stmt = $pdo->query('SELECT * FROM marcas ORDER BY nombre_marca');
 echo json_encode($stmt->fetchAll());
