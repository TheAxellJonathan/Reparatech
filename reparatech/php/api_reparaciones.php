<?php
// API para crear/listar/actualizar reparaciones
header('Content-Type: application/json; charset=utf-8');
require 'db.php';
session_start();

// Debug: log todas las solicitudes
error_log('API Reparaciones: método='.$_SERVER['REQUEST_METHOD'].', GET='.json_encode($_GET).', POST='.json_encode($_POST));

$method = $_SERVER['REQUEST_METHOD'];
$action = $_GET['accion'] ?? ($_POST['accion'] ?? null);

// Si no hay acción en GET/POST y es POST, intentar leer del body JSON
if (!$action && $method === 'POST') {
    $input = file_get_contents('php://input');
    $data = json_decode($input, true);
    if (is_array($data) && isset($data['accion'])) {
        $action = $data['accion'];
        // Guardar data para uso posterior si es necesario, aunque el bloque 'crear' lo lee de nuevo
        // Para evitar leerlo dos veces, podríamos asignarlo a una variable global o estática, 
        // pero por simplicidad y seguridad (el stream php://input se puede leer múltiples veces en configuraciones modernas, 
        // pero a veces no), lo dejaremos así. 
        // Nota: php://input no es seekable, así que mejor guardamos el json decodificado.
        $_POST = array_merge($_POST, $data); // Hack para que el resto del script funcione si usa $_POST
    }
}

// Sólo empleados pueden crear reparaciones via panel
if($action === 'crear' && $method === 'POST'){
  error_log('Acción crear detectada');
  
  if(!isset($_SESSION['usuario_id'])){
    http_response_code(403);
    echo json_encode(['error'=>'No hay sesión activa. Usuario_id no definido.']);
    exit;
  }
  
  if($_SESSION['usuario_tipo'] !== 'empleado'){
    http_response_code(403);
    echo json_encode(['error'=>'No autorizado. Tipo de usuario: '.$_SESSION['usuario_tipo']]);
    exit;
  }

  $input = file_get_contents('php://input');
  error_log('Input recibido: '.$input);
  
  $data = json_decode($input, true);
  if(!is_array($data)) {
    error_log('No es JSON válido, usando $_POST');
    $data = $_POST;
  }
  
  // Campos esperados
  $cliente_nombre = trim($data['cliente_nombre'] ?? '');
  $cliente_apellido = trim($data['cliente_apellido'] ?? '');
  $cliente_telefono = trim($data['cliente_telefono'] ?? ''); // Nuevo campo telefono
  $id_marca = (int)($data['id_marca'] ?? 0);
  $modelo = trim($data['modelo'] ?? '');
  $id_tipo = (int)($data['id_tipo'] ?? 0);
  $id_color = (int)($data['id_color'] ?? 0); // Nuevo campo color
  $imei_serie = trim($data['imei_serie'] ?? ''); // Nuevo campo imei
  $motivo = trim($data['motivo'] ?? null);
  $falla = trim($data['falla'] ?? null);
  $observaciones = trim($data['observaciones'] ?? null);
  $precio = floatval($data['precio'] ?? 0.0);
  $id_empleado = $_SESSION['usuario_id'];

  error_log("Datos parseados: nombre='$cliente_nombre', apellido='$cliente_apellido', marca=$id_marca, modelo='$modelo', tipo=$id_tipo");

  if(!$cliente_nombre){
    http_response_code(400);
    echo json_encode(['error'=>'Falta nombre del cliente']);
    exit;
  }
  if(!$cliente_apellido){
    http_response_code(400);
    echo json_encode(['error'=>'Falta apellido del cliente']);
    exit;
  }
  if(!$modelo){
    http_response_code(400);
    echo json_encode(['error'=>'Falta modelo del equipo']);
    exit;
  }
  if(!$id_marca){
    http_response_code(400);
    echo json_encode(['error'=>'Falta marca del equipo']);
    exit;
  }
  if(!$id_tipo){
    http_response_code(400);
    echo json_encode(['error'=>'Falta tipo de equipo']);
    exit;
  }

  try {
    // Crear o buscar usuario cliente automáticamente
    $nombre_completo = $cliente_nombre . ' ' . $cliente_apellido;
    
    $id_cliente = 0;

    // 1. Buscar por teléfono si se proporcionó
    if ($cliente_telefono) {
        $stmt = $pdo->prepare('SELECT id_usuario FROM usuarios WHERE telefono = ? AND tipo_usuario = "cliente"');
        $stmt->execute([$cliente_telefono]);
        $cliente_existente = $stmt->fetch();
        if ($cliente_existente) {
            $id_cliente = $cliente_existente['id_usuario'];
            // Actualizar nombre si es necesario (opcional, aquí no lo hacemos para no sobreescribir)
        }
    }

    // 2. Si no se encontró por teléfono, buscar por nombre (fallback)
    if (!$id_cliente) {
        $stmt = $pdo->prepare('SELECT id_usuario FROM usuarios WHERE nombre = ? AND tipo_usuario = "cliente"');
        $stmt->execute([$nombre_completo]);
        $cliente_existente = $stmt->fetch();
        if ($cliente_existente) {
            $id_cliente = $cliente_existente['id_usuario'];
        }
    }
    
    if($id_cliente) {
      error_log("Cliente existente encontrado: $id_cliente");
    } else {
      // Crear nuevo cliente
      // Si no hay teléfono, generar uno dummy
      $telefono_final = $cliente_telefono ? $cliente_telefono : 'REP-' . date('YmdHis') . '-' . mt_rand(1000, 9999);
      
      $stmt = $pdo->prepare('INSERT INTO usuarios (nombre, telefono, contrasena_hash, tipo_usuario) VALUES (?, ?, ?, "cliente")');
      $hash_dummy = password_hash('temporal', PASSWORD_BCRYPT);
      $result = $stmt->execute([$nombre_completo, $telefono_final, $hash_dummy]);
      
      if(!$result) {
        throw new Exception('Error insertando usuario: ' . json_encode($stmt->errorInfo()));
      }
      
      $id_cliente = $pdo->lastInsertId();
      error_log("Cliente nuevo creado: $id_cliente");
      
      // Registrar en tabla clientes
      $stmt = $pdo->prepare('INSERT INTO clientes (id_cliente, correo, direccion) VALUES (?, ?, ?)');
      $result = $stmt->execute([$id_cliente, null, null]);
      
      if(!$result) {
        throw new Exception('Error registrando en clientes: ' . json_encode($stmt->errorInfo()));
      }
    }
    
    // Crear equipo
    error_log("Creando equipo: marca=$id_marca, tipo=$id_tipo, modelo='$modelo'");
    $stmt = $pdo->prepare('INSERT INTO equipos (id_marca,id_tipo,modelo) VALUES (?,?,?)');
    $result = $stmt->execute([$id_marca,$id_tipo,$modelo]);
    
    if(!$result) {
      throw new Exception('Error creando equipo: ' . json_encode($stmt->errorInfo()));
    }
    
    $id_equipo = $pdo->lastInsertId();
    error_log("Equipo creado: $id_equipo");

    // Verificar que el empleado exista en la tabla empleados
    $stmt = $pdo->prepare('SELECT id_empleado FROM empleados WHERE id_empleado = ?');
    $stmt->execute([$id_empleado]);
    if(!$stmt->fetch()){
        // Si no existe, agregarlo (es un empleado válido en usuarios, pero falta en empleados)
        error_log("Empleado $id_empleado no encontrado en tabla empleados. Creando registro...");
        $stmt = $pdo->prepare('INSERT INTO empleados (id_empleado, puesto, fecha_ingreso) VALUES (?, "Técnico", CURDATE())');
        $stmt->execute([$id_empleado]);
    }

    // Insertar reparación
    error_log("Creando reparación: cliente=$id_cliente, equipo=$id_equipo, empleado=$id_empleado");
    // Usar NULL para id_color si es 0
    $id_color_val = $id_color > 0 ? $id_color : null;
    
    $stmt = $pdo->prepare('INSERT INTO reparaciones (folio,id_cliente,id_equipo,id_empleado,motivo,falla,observaciones,precio,estatus,id_color,imei_serie) VALUES (?,?,?,?,?,?,?,?,?,?,?)');
    $result = $stmt->execute(['',$id_cliente,$id_equipo,$id_empleado,$motivo,$falla,$observaciones,$precio,'En reparación', $id_color_val, $imei_serie]);
    
    if(!$result) {
      throw new Exception('Error creando reparación: ' . json_encode($stmt->errorInfo()));
    }
    
    $id_reparacion = $pdo->lastInsertId();
    error_log("Reparación creada: $id_reparacion");

    // Generar folio
    $folio = 'RPT-'.date('Y').'-'.str_pad($id_reparacion,6,'0',STR_PAD_LEFT);
    $stmt = $pdo->prepare('UPDATE reparaciones SET folio = ? WHERE id_reparacion = ?');
    $stmt->execute([$folio,$id_reparacion]);
    error_log("Folio asignado: $folio");

    // Generar comprobante (no fallar si hay error)
    $pdfRes = ['ok' => false, 'error' => 'No generado'];
    try {
      require_once 'lib_pdf.php';
      $pdfRes = generar_comprobante($pdo, $id_reparacion);
      error_log("PDF generado: ".json_encode($pdfRes));
    } catch(Exception $pdfErr) {
      error_log('Error generando PDF: ' . $pdfErr->getMessage());
    }

    http_response_code(201);
    echo json_encode(['ok'=>true,'id_reparacion'=>$id_reparacion,'folio'=>$folio,'comprobante'=>$pdfRes]);
  } catch(Exception $e) {
    http_response_code(500);
    error_log('Error en crear reparación: ' . $e->getMessage() . ' en ' . $e->getFile() . ':' . $e->getLine());
    echo json_encode(['error'=>'Error: '.$e->getMessage()]);
  }
  exit;
}

// Listar reparaciones - empleados pueden ver todas; clientes sólo las suyas
if($action === 'listar'){
  if(!isset($_SESSION['usuario_id'])){ http_response_code(403); echo json_encode(['error'=>'No autorizado']); exit; }
  if($_SESSION['usuario_tipo']==='empleado'){
    $stmt = $pdo->query('SELECT r.*, u.nombre as cliente_nombre FROM reparaciones r JOIN usuarios u ON r.id_cliente = u.id_usuario ORDER BY r.fecha_registro DESC');
    $rows = $stmt->fetchAll(); echo json_encode($rows); exit;
  }else{
    $id = $_SESSION['usuario_id'];
    $stmt = $pdo->prepare('SELECT r.* FROM reparaciones r WHERE r.id_cliente = ? ORDER BY r.fecha_registro DESC');
    $stmt->execute([$id]); $rows = $stmt->fetchAll(); echo json_encode($rows); exit;
  }
}

// Cambiar estatus
if($action==='estatus' && $method==='POST'){
  if(!isset($_SESSION['usuario_id']) || $_SESSION['usuario_tipo']!=='empleado'){ http_response_code(403); echo json_encode(['error'=>'No autorizado']); exit; }
  $data = json_decode(file_get_contents('php://input'), true) ?? $_POST;
  $id = (int)$data['id_reparacion'];
  $estatus = $data['estatus'] ?? null;
  $precio_final = isset($data['precio']) ? floatval($data['precio']) : null;
  if(!$id || !$estatus){ http_response_code(400); echo json_encode(['error'=>'Faltan datos']); exit; }
  $stmt = $pdo->prepare('UPDATE reparaciones SET estatus = ?, precio = COALESCE(?, precio) WHERE id_reparacion = ?');
  $stmt->execute([$estatus,$precio_final,$id]);
  echo json_encode(['ok'=>true]); exit;
}

// Buscar por folio (cliente)
if($action==='folio'){
  $folio = $_GET['folio'] ?? '';
  if(!$folio){ http_response_code(400); echo json_encode(['error'=>'Falta folio']); exit; }
  $stmt = $pdo->prepare('SELECT r.*, u.nombre as cliente FROM reparaciones r JOIN usuarios u ON r.id_cliente = u.id_usuario WHERE r.folio = ?');
  $stmt->execute([$folio]);
  $r = $stmt->fetch();
  if(!$r){ http_response_code(404); echo json_encode(['error'=>'No encontrado']); exit; }
  echo json_encode($r);
  exit;
}

// Log de acciones
function logAccion($id_usuario, $tipo_accion, $descripcion, $tabla_afectada = '', $id_registro = 0) {
  global $pdo;
  try {
    $ip = $_SERVER['REMOTE_ADDR'] ?? 'N/A';
    $stmt = $pdo->prepare('INSERT INTO logs (id_usuario, tipo_accion, descripcion, tabla_afectada, id_registro, ip_address) VALUES (?, ?, ?, ?, ?, ?)');
    $stmt->execute([$id_usuario, $tipo_accion, $descripcion, $tabla_afectada, $id_registro, $ip]);
  } catch(Exception $e) {
    // Silenciar errores
  }
}

// Obtener una reparación por ID (para editar)
if($action === 'obtener'){
    if(!isset($_SESSION['usuario_id']) || $_SESSION['usuario_tipo']!=='empleado'){ http_response_code(403); echo json_encode(['error'=>'No autorizado']); exit; }
    $id = $_GET['id'] ?? 0;
    if(!$id){ http_response_code(400); echo json_encode(['error'=>'Falta ID']); exit; }
    
    $stmt = $pdo->prepare('SELECT r.*, u.nombre as cliente_nombre, u.telefono as cliente_telefono, e.modelo, e.id_marca, e.id_tipo 
                          FROM reparaciones r 
                          JOIN usuarios u ON r.id_cliente = u.id_usuario 
                          JOIN equipos e ON r.id_equipo = e.id_equipo 
                          WHERE r.id_reparacion = ?');
    $stmt->execute([$id]);
    $r = $stmt->fetch(PDO::FETCH_ASSOC);
    
    if(!$r){ http_response_code(404); echo json_encode(['error'=>'No encontrado']); exit; }
    
    // Separar nombre y apellido si es posible (simple split)
    $parts = explode(' ', $r['cliente_nombre'], 2);
    $r['cliente_nombre_only'] = $parts[0];
    $r['cliente_apellido_only'] = $parts[1] ?? '';
    
    echo json_encode($r);
    exit;
}

// Editar reparación
if($action === 'editar' && $method === 'POST'){
    if(!isset($_SESSION['usuario_id']) || $_SESSION['usuario_tipo']!=='empleado'){ http_response_code(403); echo json_encode(['error'=>'No autorizado']); exit; }
    
    $data = json_decode(file_get_contents('php://input'), true) ?? $_POST;
    $id_reparacion = $data['id_reparacion'] ?? 0;
    
    if(!$id_reparacion){ http_response_code(400); echo json_encode(['error'=>'Falta ID']); exit; }
    
    // Campos a actualizar
    $motivo = $data['motivo'] ?? '';
    $falla = $data['falla'] ?? '';
    $observaciones = $data['observaciones'] ?? '';
    $precio = $data['precio'] ?? 0;
    $estatus = $data['estatus'] ?? '';
    $id_color = isset($data['id_color']) && $data['id_color'] > 0 ? $data['id_color'] : null;
    $imei_serie = $data['imei_serie'] ?? '';
    
    // Actualizar reparación
    $stmt = $pdo->prepare('UPDATE reparaciones SET motivo=?, falla=?, observaciones=?, precio=?, estatus=?, id_color=?, imei_serie=? WHERE id_reparacion=?');
    $res = $stmt->execute([$motivo, $falla, $observaciones, $precio, $estatus, $id_color, $imei_serie, $id_reparacion]);
    
    if($res) echo json_encode(['ok'=>true]);
    else echo json_encode(['error'=>'Error al actualizar']);
    exit;
}

// Eliminar reparación
if($action === 'eliminar' && $method === 'POST'){
    if(!isset($_SESSION['usuario_id']) || $_SESSION['usuario_tipo']!=='empleado'){ http_response_code(403); echo json_encode(['error'=>'No autorizado']); exit; }
    
    $data = json_decode(file_get_contents('php://input'), true) ?? $_POST;
    $id = $data['id'] ?? 0;
    
    if(!$id){ http_response_code(400); echo json_encode(['error'=>'Falta ID']); exit; }
    
    $stmt = $pdo->prepare('DELETE FROM reparaciones WHERE id_reparacion = ?');
    if($stmt->execute([$id])) echo json_encode(['ok'=>true]);
    else echo json_encode(['error'=>'Error al eliminar']);
    exit;
}

http_response_code(400);
echo json_encode(['error'=>'Acción inválida']);
