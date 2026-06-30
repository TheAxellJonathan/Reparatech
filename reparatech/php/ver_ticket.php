<?php
require 'db.php';
session_start();

if(!isset($_SESSION['usuario_id'])) {
    die('Acceso denegado');
}

$id = $_GET['id'] ?? 0;
if(!$id) die('ID inválido');

$stmt = $pdo->prepare('SELECT ruta_pdf FROM pedidos WHERE id_pedido = ?');
$stmt->execute([$id]);
$p = $stmt->fetch();

if($p && $p['ruta_pdf'] && file_exists('../' . $p['ruta_pdf'])) {
    header('Location: ../' . $p['ruta_pdf']);
} else {
    // Intentar regenerar si no existe (opcional, por ahora solo error)
    echo "El ticket no está disponible o no se ha generado.";
}
?>
