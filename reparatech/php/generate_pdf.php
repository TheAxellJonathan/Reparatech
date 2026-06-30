<?php
// Generar comprobante PDF para una reparacion (cliente y negocio)
require 'db.php'; session_start();
require 'lib_pdf.php';

$id_reparacion = intval($_GET['id'] ?? 0);
if(!$id_reparacion){ echo 'Falta id'; exit; }

$res = generar_comprobante($pdo, $id_reparacion);
// Si se llama por AJAX (JSON expected)
if(strpos($_SERVER['HTTP_ACCEPT'] ?? '','application/json')!==false){ header('Content-Type: application/json; charset=utf-8'); echo json_encode($res); exit; }

// Si es acceso directo por GET, redirigir al archivo generado cuando exista
if(isset($res['ok']) && isset($res['ruta'])){
  $ruta = $res['ruta'];
  // Si es .pdf o .html, enviar al navegador
  $path = __DIR__.'/../'.$ruta;
  if(file_exists($path)){
    header('Content-Type: '.(substr($ruta,-4)=='.pdf'?'application/pdf':'text/html'));
    readfile($path); exit;
  }else{
    echo 'Archivo no encontrado: '.$ruta; exit;
  }
}

echo 'Error: '.json_encode($res);
