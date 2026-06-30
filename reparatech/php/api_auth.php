<?php
// API para registro e inicio de sesión (JSON)
header('Content-Type: application/json; charset=utf-8');
require 'db.php';
session_start();

$data = json_decode(file_get_contents('php://input'), true) ?? $_POST;

if(!isset($data['accion'])){ echo json_encode(['error'=>'Acción no especificada']); exit; }

if($data['accion']==='registro'){
  // Campos: nombre, telefono, contrasena, tipo (cliente|empleado), clave_empleado (opcional), correo, direccion, puesto
  $nombre = trim($data['nombre'] ?? '');
  $telefono = trim($data['telefono'] ?? '');
  $contrasena = $data['contrasena'] ?? '';
  $tipo = $data['tipo'] ?? 'cliente';

  if(!$nombre || !$telefono || !$contrasena){ http_response_code(400); echo json_encode(['error'=>'Faltan campos']); exit; }

  // Validar si telefono ya existe
  $stmt = $pdo->prepare('SELECT id_usuario FROM usuarios WHERE telefono = ?');
  $stmt->execute([$telefono]);
  if($stmt->fetch()){ http_response_code(400); echo json_encode(['error'=>'El número ya está registrado']); exit; }

  $hash = password_hash($contrasena, PASSWORD_BCRYPT);

  $pdo->beginTransaction();
  try{
    $stmt = $pdo->prepare('INSERT INTO usuarios (nombre, telefono, contrasena_hash, tipo_usuario) VALUES (?,?,?,?)');
    $stmt->execute([$nombre,$telefono,$hash,$tipo]);
    $id_usuario = $pdo->lastInsertId();

    if($tipo==='cliente'){
      $correo = $data['correo'] ?? null;
      $direccion = $data['direccion'] ?? null;
      $stmt = $pdo->prepare('INSERT INTO clientes (id_cliente, correo, direccion) VALUES (?,?,?)');
      $stmt->execute([$id_usuario,$correo,$direccion]);
    }else{
      // Empleado: validar clave
      $clave = $data['clave_empleado'] ?? '';
      if($clave !== 'reparatech2025'){
        $pdo->rollBack();
        http_response_code(403);
        echo json_encode(['error'=>'Clave de empleado inválida']);
        exit;
      }
      $puesto = $data['puesto'] ?? 'Empleado';
      $fecha_ingreso = date('Y-m-d');
      $stmt = $pdo->prepare('INSERT INTO empleados (id_empleado, puesto, fecha_ingreso) VALUES (?,?,?)');
      $stmt->execute([$id_usuario,$puesto,$fecha_ingreso]);
    }

    $pdo->commit();

    // Iniciar sesión automática
    $_SESSION['usuario_id'] = $id_usuario;
    $_SESSION['usuario_nombre'] = $nombre;
    $_SESSION['usuario_tipo'] = $tipo;

    echo json_encode(['ok'=>true,'mensaje'=>'Registro exitoso','tipo'=>$tipo]);
  }catch(Exception $e){
    $pdo->rollBack();
    http_response_code(500);
    echo json_encode(['error'=>'Error en el servidor: '.$e->getMessage()]);
  }
  exit;
}

if($data['accion']==='login'){
  $telefono = trim($data['telefono'] ?? '');
  $contrasena = $data['contrasena'] ?? '';
  if(!$telefono || !$contrasena){ http_response_code(400); echo json_encode(['error'=>'Faltan campos']); exit; }

  $stmt = $pdo->prepare('SELECT * FROM usuarios WHERE telefono = ?');
  $stmt->execute([$telefono]);
  $u = $stmt->fetch();
  if(!$u || !password_verify($contrasena, $u['contrasena_hash'])){ http_response_code(401); echo json_encode(['error'=>'Credenciales inválidas']); exit; }

  // Cargar datos adicionales según tipo
  $tipo = $u['tipo_usuario'];
  if($tipo==='cliente'){
    $stmt = $pdo->prepare('SELECT * FROM clientes WHERE id_cliente = ?'); $stmt->execute([$u['id_usuario']]); $extra = $stmt->fetch();
  }else{ $stmt = $pdo->prepare('SELECT * FROM empleados WHERE id_empleado = ?'); $stmt->execute([$u['id_usuario']]); $extra = $stmt->fetch(); }

  $_SESSION['usuario_id'] = $u['id_usuario'];
  $_SESSION['usuario_nombre'] = $u['nombre'];
  $_SESSION['usuario_tipo'] = $u['tipo_usuario'];

  echo json_encode(['ok'=>true,'usuario'=>['id'=>$u['id_usuario'],'nombre'=>$u['nombre'],'tipo'=>$u['tipo_usuario']],'extra'=>$extra]);
  exit;
}

if($data['accion']==='logout'){
  session_destroy();
  echo json_encode(['ok'=>true]);
  exit;
}

// Check si está loggeado (para verificación AJAX)
if(isset($_GET['check'])){
  echo json_encode(['loggedin' => isset($_SESSION['usuario_id'])]);
  exit;
}

echo json_encode(['error'=>'Acción desconocida']);
