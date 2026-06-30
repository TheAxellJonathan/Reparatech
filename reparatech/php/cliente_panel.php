<?php
session_start();
if(!isset($_SESSION['usuario_id']) || $_SESSION['usuario_tipo']!=='cliente'){ header('Location: ../index.php'); exit; }
require 'db.php';
?>
<!doctype html>
<html lang="es">
<head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1"><title>Cliente - Reparatech</title>
<link rel="stylesheet" href="../css/style.css"></head>
<body>
<?php include '../includes/header.php'; ?>
<main class="contenedor">
  <h2>Consulta de reparación</h2>
  <label>Ingresar folio</label>
  <input id="folio-input">
  <button id="btn-consultar" class="btn">Consultar</button>
  <div id="resultado"></div>
</main>
<script>
document.getElementById('btn-consultar').addEventListener('click', async ()=>{
  const folio = document.getElementById('folio-input').value.trim(); if(!folio) return;
  const res = await fetch('api_reparaciones.php?accion=folio&folio='+encodeURIComponent(folio)).then(r=>r.json());
  if(res.error){ alert(res.error); return; }
  const out = document.getElementById('resultado'); out.innerHTML = `<h3>${res.folio}</h3><p>Estatus: ${res.estatus}</p><p>Precio: $${Number(res.precio).toFixed(2)}</p><p>Observaciones: ${res.observaciones}</p><a href="generate_pdf.php?id=${res.id_reparacion}" target="_blank" class="btn">Descargar comprobante</a>`;
});
</script>
</body>
</html>
