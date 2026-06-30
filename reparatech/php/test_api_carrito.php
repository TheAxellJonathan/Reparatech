<?php
// Script de prueba simple para verificar la respuesta de api_carrito.php
session_start();

// Simular sesión de usuario
$_SESSION['usuario_id'] = 9; // ID de un usuario cliente de prueba
$_SESSION['usuario_nombre'] = 'Juan Perez';
$_SESSION['usuario_tipo'] = 'cliente';

// Simular carrito con un producto
$_SESSION['carrito'] = [
    ['id' => 1, 'cantidad' => 1]
];

// Simular POST data
$_POST['accion'] = 'crear_pedido';
$_POST['tipo_entrega'] = 'tienda';
$_POST['nombres'] = 'Test';
$_POST['apellidos'] = 'Usuario';
$_POST['telefono'] = '5551234567';
$_POST['calle'] = '';
$_POST['colonia'] = '';
$_POST['municipio'] = '';
$_POST['estado'] = '';
$_POST['pais'] = 'México';
$_POST['codigo_postal'] = '';

echo "<pre>";
echo "=== INICIANDO PRUEBA DE API ===\n";
echo "Usuario ID: " . $_SESSION['usuario_id'] . "\n";
echo "Carrito: " . json_encode($_SESSION['carrito']) . "\n\n";

// Capturar la salida de api_carrito.php
ob_start();
include 'api_carrito.php';
$output = ob_get_clean();

echo "=== RESPUESTA DE API ===\n";
echo htmlspecialchars($output) . "\n";

// Intentar decodificar como JSON
$json = json_decode($output, true);
if($json === null) {
    echo "\n=== ERROR: NO ES JSON VÁLIDO ===\n";
    echo "Error de JSON: " . json_last_error_msg() . "\n";
} else {
    echo "\n=== JSON DECODIFICADO CORRECTAMENTE ===\n";
    echo "OK: " . ($json['ok'] ? 'true' : 'false') . "\n";
    if(isset($json['error'])) {
        echo "Error: " . $json['error'] . "\n";
    }
    if(isset($json['folio_pedido'])) {
        echo "Folio: " . $json['folio_pedido'] . "\n";
    }
}
echo "</pre>";
?>
