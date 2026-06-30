<?php
require 'db.php';
try {
    $stmt = $pdo->query("DESCRIBE envios");
    $columns = $stmt->fetchAll(PDO::FETCH_ASSOC);
    echo "Columns in envios:\n";
    foreach ($columns as $col) {
        echo $col['Field'] . " (" . $col['Type'] . ")\n";
    }
} catch (PDOException $e) {
    echo "Error: " . $e->getMessage();
}
?>
