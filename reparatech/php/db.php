<?php
// Conexión a la base de datos usando PDO
// Ajustar credenciales según XAMPP: usuario: root, sin contraseña por defecto
define('DB_HOST','127.0.0.1');
define('DB_NAME','reparatech');
define('DB_USER','root');
define('DB_PASS','');

try{
  $pdo = new PDO('mysql:host='.DB_HOST.';dbname='.DB_NAME.';charset=utf8mb4', DB_USER, DB_PASS, [
    PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
    PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
  ]);
}catch(PDOException $e){
  // Si la solicitud espera JSON (común en APIs), devolver JSON
  if (isset($_SERVER['HTTP_ACCEPT']) && strpos($_SERVER['HTTP_ACCEPT'], 'application/json') !== false) {
      header('Content-Type: application/json; charset=utf-8');
      http_response_code(500);
      echo json_encode(['error' => 'Error de conexión a la base de datos. Asegúrate de haber ejecutado setup_db.php']);
      exit;
  }
  
  // Si es una visita normal, mostrar mensaje amigable
  http_response_code(500);
  die('<div style="padding:20px;text-align:center;font-family:sans-serif;">
        <h1>Error de Conexión</h1>
        <p>No se pudo conectar a la base de datos.</p>
        <p>Por favor, ejecuta <a href="/negocio_reparaciones/setup_db.php">setup_db.php</a> para inicializar el sistema.</p>
        <small style="color:#666">Detalle técnico: ' . $e->getMessage() . '</small>
       </div>');
}
