<?php
// Script para verificar la estructura de la tabla envios
require 'db.php';

try {
    $stmt = $pdo->query("DESCRIBE envios");
    $columns = $stmt->fetchAll(PDO::FETCH_ASSOC);
    
    echo "<h2>Estructura de la tabla 'envios':</h2>";
    echo "<table border='1' cellpadding='5'>";
    echo "<tr><th>Campo</th><th>Tipo</th><th>Null</th><th>Key</th><th>Default</th><th>Extra</th></tr>";
    
    foreach($columns as $col) {
        echo "<tr>";
        echo "<td>" . htmlspecialchars($col['Field']) . "</td>";
        echo "<td>" . htmlspecialchars($col['Type']) . "</td>";
        echo "<td>" . htmlspecialchars($col['Null']) . "</td>";
        echo "<td>" . htmlspecialchars($col['Key']) . "</td>";
        echo "<td>" . htmlspecialchars($col['Default'] ?? 'NULL') . "</td>";
        echo "<td>" . htmlspecialchars($col['Extra']) . "</td>";
        echo "</tr>";
    }
    
    echo "</table>";
    
    echo "<h3>Columnas requeridas por api_carrito.php:</h3>";
    $required_columns = [
        'id_pedido', 'direccion', 'calle', 'colonia', 'municipio', 
        'estado', 'pais', 'codigo_postal', 'telefono', 
        'nombres_contacto', 'apellidos_contacto', 'telefono_contacto', 'estatus'
    ];
    
    $existing_columns = array_column($columns, 'Field');
    
    echo "<ul>";
    foreach($required_columns as $req_col) {
        $exists = in_array($req_col, $existing_columns);
        $status = $exists ? '✓ EXISTE' : '✗ FALTA';
        $color = $exists ? 'green' : 'red';
        echo "<li style='color: $color;'><strong>$req_col</strong>: $status</li>";
    }
    echo "</ul>";
    
} catch(PDOException $e) {
    echo "Error: " . $e->getMessage();
}
?>
