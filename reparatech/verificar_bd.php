<?php
// verificar_bd.php - Script para verificar y diagnosticar problemas de BD
header('Content-Type: application/json; charset=utf-8');

define('DB_HOST','127.0.0.1');
define('DB_NAME','reparatech');
define('DB_USER','root');
define('DB_PASS','');

$diagnostico = [];

// 1. Verificar conexión al servidor MySQL
try {
  $pdo = new PDO('mysql:host='.DB_HOST, DB_USER, DB_PASS);
  $diagnostico['conexion_mysql'] = 'OK';
} catch(PDOException $e) {
  $diagnostico['conexion_mysql'] = 'ERROR: ' . $e->getMessage();
  echo json_encode($diagnostico);
  exit;
}

// 2. Verificar si existe la BD
try {
  $pdo = new PDO('mysql:host='.DB_HOST.';dbname='.DB_NAME, DB_USER, DB_PASS);
  $diagnostico['bd_reparatech'] = 'EXISTE';
  
  // 3. Verificar si la tabla productos existe
  $stmt = $pdo->query("SELECT COUNT(*) as total FROM productos");
  $result = $stmt->fetch();
  $diagnostico['tabla_productos'] = 'EXISTE';
  $diagnostico['productos_count'] = intval($result['total']);
  
} catch(PDOException $e) {
  $diagnostico['bd_reparatech'] = 'NO EXISTE - Necesita crear BD';
  $diagnostico['nota'] = 'Ejecutar setup_db.php para inicializar';
}

echo json_encode($diagnostico, JSON_PRETTY_PRINT | JSON_UNESCAPED_UNICODE);
?>
