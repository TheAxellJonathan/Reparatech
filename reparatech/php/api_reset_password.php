<?php
// API para recuperación de contraseña
header('Content-Type: application/json; charset=utf-8');
require 'db.php';
session_start();

$data = json_decode(file_get_contents('php://input'), true) ?? $_POST;

if (!isset($data['accion'])) {
    echo json_encode(['error' => 'Acción no especificada']);
    exit;
}

// Solicitar reset de contraseña
if ($data['accion'] === 'solicitar') {
    $telefono = trim($data['telefono'] ?? '');
    if (!$telefono) {
        http_response_code(400);
        echo json_encode(['error' => 'Se requiere número de teléfono']);
        exit;
    }

    $stmt = $pdo->prepare('SELECT id_usuario, nombre FROM usuarios WHERE telefono = ?');
    $stmt->execute([$telefono]);
    $usuario = $stmt->fetch();

    if (!$usuario) {
        // No revelar si el usuario existe
        echo json_encode(['ok' => true, 'mensaje' => 'Si el número existe, recibirás un correo con instrucciones']);
        exit;
    }

    // Generar token único
    $token = bin2hex(random_bytes(32));
    $fecha_expiracion = date('Y-m-d H:i:s', time() + 3600); // 1 hora

    try {
        $stmt = $pdo->prepare('INSERT INTO reset_contrasena (id_usuario, token, fecha_expiracion) VALUES (?, ?, ?)');
        $stmt->execute([$usuario['id_usuario'], $token, $fecha_expiracion]);

        // Nota: En producción, aquí enviarías un email con el token
        // Por ahora, devolveremos un link de prueba
        $reset_link = "http://localhost/negocio_reparaciones/reset_password.php?token=" . $token;

        // Log de acción
        logAccion($_SESSION['usuario_id'] ?? NULL, 'reset_password_request', 'Solicitud de reset de contraseña para usuario: ' . $usuario['nombre'], 'usuarios', $usuario['id_usuario']);

        echo json_encode([
            'ok' => true,
            'mensaje' => 'Se ha enviado un enlace de recuperación',
            'test_link' => $reset_link // Solo para desarrollo
        ]);
    } catch (Exception $e) {
        http_response_code(500);
        echo json_encode(['error' => 'Error procesando solicitud: ' . $e->getMessage()]);
    }
    exit;
}

// Validar token
if ($data['accion'] === 'validar_token') {
    $token = trim($data['token'] ?? '');
    if (!$token) {
        http_response_code(400);
        echo json_encode(['error' => 'Token requerido']);
        exit;
    }

    $stmt = $pdo->prepare('SELECT r.id_usuario, u.nombre FROM reset_contrasena r JOIN usuarios u ON r.id_usuario = u.id_usuario WHERE r.token = ? AND r.utilizado = FALSE AND r.fecha_expiracion > NOW()');
    $stmt->execute([$token]);
    $reset = $stmt->fetch();

    if (!$reset) {
        http_response_code(401);
        echo json_encode(['error' => 'Token inválido o expirado']);
        exit;
    }

    echo json_encode(['ok' => true, 'id_usuario' => $reset['id_usuario']]);
    exit;
}

// Resetear contraseña
if ($data['accion'] === 'reset') {
    $token = trim($data['token'] ?? '');
    $contrasena = $data['contrasena'] ?? '';

    if (!$token || !$contrasena) {
        http_response_code(400);
        echo json_encode(['error' => 'Token y contraseña requeridos']);
        exit;
    }

    if (strlen($contrasena) < 6) {
        http_response_code(400);
        echo json_encode(['error' => 'La contraseña debe tener al menos 6 caracteres']);
        exit;
    }

    $stmt = $pdo->prepare('SELECT id_usuario FROM reset_contrasena WHERE token = ? AND utilizado = FALSE AND fecha_expiracion > NOW()');
    $stmt->execute([$token]);
    $reset = $stmt->fetch();

    if (!$reset) {
        http_response_code(401);
        echo json_encode(['error' => 'Token inválido o expirado']);
        exit;
    }

    try {
        $hash = password_hash($contrasena, PASSWORD_BCRYPT);
        
        // Actualizar contraseña
        $stmt = $pdo->prepare('UPDATE usuarios SET contrasena_hash = ? WHERE id_usuario = ?');
        $stmt->execute([$hash, $reset['id_usuario']]);

        // Marcar token como utilizado
        $stmt = $pdo->prepare('UPDATE reset_contrasena SET utilizado = TRUE WHERE token = ?');
        $stmt->execute([$token]);

        // Log de acción
        logAccion($reset['id_usuario'], 'password_reset', 'Contraseña restablecida', 'usuarios', $reset['id_usuario']);

        echo json_encode(['ok' => true, 'mensaje' => 'Contraseña actualizada correctamente']);
    } catch (Exception $e) {
        http_response_code(500);
        echo json_encode(['error' => 'Error actualizando contraseña: ' . $e->getMessage()]);
    }
    exit;
}

echo json_encode(['error' => 'Acción desconocida']);

// Función para registrar en logs
function logAccion($id_usuario, $tipo_accion, $descripcion, $tabla_afectada = '', $id_registro = 0) {
    global $pdo;
    try {
        $ip = $_SERVER['REMOTE_ADDR'] ?? 'N/A';
        $stmt = $pdo->prepare('INSERT INTO logs (id_usuario, tipo_accion, descripcion, tabla_afectada, id_registro, ip_address) VALUES (?, ?, ?, ?, ?, ?)');
        $stmt->execute([$id_usuario, $tipo_accion, $descripcion, $tabla_afectada, $id_registro, $ip]);
    } catch (Exception $e) {
        // Silenciar errores de log
    }
}
?>
