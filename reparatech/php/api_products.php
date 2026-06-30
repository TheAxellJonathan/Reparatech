<?php
// API para productos - devuelve JSON
header('Content-Type: application/json; charset=utf-8');

try {
  require 'db.php';
  
  if(isset($_GET['id'])){
    $id = (int)$_GET['id'];
    $stmt = $pdo->prepare('SELECT * FROM productos WHERE id_producto = ?');
    $stmt->execute([$id]);
    $prod = $stmt->fetch();
    if(!$prod){
      http_response_code(404);
      echo json_encode(['error'=>'Producto no encontrado']);
      exit;
    }
    echo json_encode($prod);
    exit;
  }
  
  // Busqueda
  if(isset($_GET['search'])){
    $q = '%' . $_GET['search'] . '%';
    $stmt = $pdo->prepare('SELECT * FROM productos WHERE nombre LIKE ? OR descripcion LIKE ? ORDER BY id_producto DESC');
    $stmt->execute([$q, $q]);
    $productos = $stmt->fetchAll();
  } else {
    // Listar todos los productos
    $stmt = $pdo->query('SELECT * FROM productos ORDER BY id_producto DESC');
    $productos = $stmt->fetchAll();
  }
  
  // Si no hay productos, devolver array vacío pero también verificar tabla
  if(empty($productos)){
    echo json_encode([]);
    exit;
  }
  
  echo json_encode($productos);
  
} catch(Exception $e) {
  http_response_code(500);
  echo json_encode(['error' => 'Error al obtener productos: ' . $e->getMessage()]);
}
