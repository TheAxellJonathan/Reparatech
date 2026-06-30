<?php
// setup_db.php
// Script para inicializar la base de datos 'reparatech'

define('DB_HOST', '127.0.0.1');
define('DB_USER', 'root');
define('DB_PASS', '');

?>
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width,initial-scale=1">
  <title>Instalación Reparatech</title>
  <style>
    body { font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif; max-width: 600px; margin: 50px auto; padding: 20px; }
    .success { background: #d4edda; border: 1px solid #c3e6cb; color: #155724; padding: 15px; border-radius: 4px; margin: 10px 0; }
    .error { background: #f8d7da; border: 1px solid #f5c6cb; color: #721c24; padding: 15px; border-radius: 4px; margin: 10px 0; }
    .info { background: #d1ecf1; border: 1px solid #bee5eb; color: #0c5460; padding: 15px; border-radius: 4px; margin: 10px 0; }
    .warning { background: #fff3cd; border: 1px solid #ffeaa7; color: #856404; padding: 15px; border-radius: 4px; margin: 10px 0; }
    button { background: #007bff; color: white; border: none; padding: 10px 20px; border-radius: 4px; cursor: pointer; margin: 5px; }
    button:hover { background: #0056b3; }
    a { color: #007bff; text-decoration: none; }
    a:hover { text-decoration: underline; }
    form { margin: 20px 0; }
  </style>
</head>
<body>

<h1>🔧 Inicialización de Reparatech</h1>

<?php
try {
    // 1. Conectar sin seleccionar base de datos
    $pdo = new PDO("mysql:host=" . DB_HOST, DB_USER, DB_PASS, [
        PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION
    ]);
    
    echo '<div class="success">✅ Conexión al servidor MySQL exitosa</div>';

    // Verificar si la BD ya existe
    $checkDb = $pdo->query("SHOW DATABASES LIKE 'reparatech'");
    $dbExists = $checkDb->rowCount() > 0;
    
    // 2. Crear o verificar base de datos
    if (!$dbExists) {
        $pdo->exec("CREATE DATABASE IF NOT EXISTS reparatech DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_spanish_ci");
        echo '<div class="success">✅ Base de datos "reparatech" creada</div>';
    } else {
        echo '<div class="info">ℹ️ Base de datos "reparatech" ya existe</div>';
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            echo '<div class="warning">⚠️ La base de datos ya existe. ¿Deseas actualizar la estructura de tablas?</div>';
            echo '<form method="POST"><button type="submit" name="update" value="1">Actualizar Estructura</button> <button type="submit" name="skip" value="1">Mantener</button></form>';
            exit;
        }
    }

    // 3. Conectar a la BD específica
    $pdo = new PDO("mysql:host=" . DB_HOST . ";dbname=reparatech", DB_USER, DB_PASS, [
        PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION
    ]);

    // Si el usuario quiso actualizar, eliminar constraint problemático si existe
    if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['update'])) {
        try {
            $pdo->exec("ALTER TABLE reparaciones DROP FOREIGN KEY reparaciones_ibfk_1");
            echo '<div class="info">ℹ️ Constraint anterior eliminado</div>';
        } catch (Exception $e) {
            // El constraint puede no existir
        }
    }

    // 4. Leer archivo SQL
    $sqlFile = __DIR__ . '/sql/reparatech.sql';
    if (!file_exists($sqlFile)) {
        throw new Exception("No se encontró el archivo SQL en: $sqlFile");
    }

    // Leer y procesar el archivo SQL
    $lines = file($sqlFile, FILE_SKIP_EMPTY_LINES);
    $cleanSql = '';
    
    foreach ($lines as $line) {
        $trimmed = trim($line);
        
        // Saltar comentarios
        if (strpos($trimmed, '--') === 0 || strpos($trimmed, '/*') === 0) {
            continue;
        }
        
        if (!empty($trimmed)) {
            $cleanSql .= $trimmed . "\n";
        }
    }

    // Dividir por punto y coma y ejecutar cada declaración
    $statements = array_filter(array_map('trim', explode(';', $cleanSql)));
    $count = 0;

    foreach ($statements as $stmt) {
        if (!empty($stmt)) {
            try {
                $pdo->exec($stmt);
                $count++;
            } catch (Exception $e) {
                // Si falla CREATE TABLE es crítico, si es INSERT/UPDATE podemos continuar
                if (strpos($stmt, 'CREATE') === 0 || strpos($stmt, 'ALTER') === 0) {
                    // Mostrar el error pero continuar (puede ser porque ya existe)
                    echo '<div class="info">ℹ️ ' . htmlspecialchars($e->getMessage()) . '</div>';
                } else {
                    // INSERT/UPDATE fallan silenciosamente (datos ya existen)
                }
            }
        }
    }

    echo '<div class="success">✅ Se procesaron ' . $count . ' sentencias SQL</div>';
    
    // Verificar estructura de tablas críticas
    try {
        $tableInfo = $pdo->query("SHOW COLUMNS FROM reparaciones");
        $columns = $tableInfo->fetchAll(PDO::FETCH_ASSOC);
        $hasCorrectFK = false;
        
        $keyInfo = $pdo->query("SELECT CONSTRAINT_NAME FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE WHERE TABLE_NAME='reparaciones' AND COLUMN_NAME='id_cliente'");
        $keys = $keyInfo->fetchAll();
        
        // Si hay constraint viejo (a clientes), arreglarlo
        foreach ($keys as $key) {
            if (strpos($key['CONSTRAINT_NAME'], 'PRIMARY') === false) {
                try {
                    $pdo->exec("ALTER TABLE reparaciones DROP FOREIGN KEY " . $key['CONSTRAINT_NAME']);
                    $pdo->exec("ALTER TABLE reparaciones ADD CONSTRAINT reparaciones_ibfk_cliente FOREIGN KEY (id_cliente) REFERENCES usuarios(id_usuario) ON DELETE CASCADE");
                    echo '<div class="success">✅ Constraint de reparaciones corregido</div>';
                } catch (Exception $e) {
                    echo '<div class="info">ℹ️ ' . htmlspecialchars($e->getMessage()) . '</div>';
                }
                break;
            }
        }
    } catch (Exception $e) {
        // Tabla no existe aún
    }
    
    // Verificar productos
    $check = $pdo->query("SELECT COUNT(*) as total FROM productos");
    $result = $check->fetch();
    $productCount = intval($result['total']);
    
    echo '<div class="info">ℹ️ Productos en base de datos: ' . $productCount . '</div>';
    
    echo '<div class="success">✅ ¡Base de datos lista para usar!</div>';
    
    echo '<p style="margin-top: 30px;"><a href="index.php" style="background: #28a745; color: white; padding: 10px 20px; border-radius: 4px; display: inline-block;">Ir a la Página Principal →</a></p>';

} catch (PDOException $e) {
    echo '<div class="error"><strong>Error de Base de Datos:</strong> ' . htmlspecialchars($e->getMessage()) . '</div>';
} catch (Exception $e) {
    echo '<div class="error"><strong>Error General:</strong> ' . htmlspecialchars($e->getMessage()) . '</div>';
}
?>

</body>
</html>
