<?php include 'includes/header.php'; ?>
<!doctype html>
<html lang="es">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width,initial-scale=1">
  <title>FAQ - Reparatech</title>
  <link rel="stylesheet" href="css/style.css">
</head>
<body>
  <main class="contenedor">
    <a href="landing.php" class="btn back-btn-fixed">← Volver</a>
    <section class="faq-hero">
      <h2>Preguntas Frecuentes</h2>
      <p style="color:rgba(0,0,0,0.6);max-width:760px;margin:0 auto">Encuentra respuestas a las consultas más comunes sobre reparaciones, envíos y compras.</p>
    </section>

    <section class="section-card faq-list">
      <details>
        <summary>¿Dónde encuentro mi folio de reparación?</summary>
        <p>El folio se entrega en el comprobante cuando dejas tu equipo. Si no lo encuentras, contáctanos por teléfono o correo.</p>
      </details>
      <details>
        <summary>¿Cuánto tarda una reparación?</summary>
        <p>Depende de la complejidad; normalmente entre 3 y 7 días hábiles. En el panel puedes ver el estatus por folio.</p>
      </details>
      <details>
        <summary>¿Cómo funciona el envío?</summary>
        <p>Al procesar tu pedido, se genera un registro de envío y puedes agregar un folio de rastreo cuando se entregue al mensajero.</p>
      </details>
      <details>
        <summary>¿Puedo pagar en línea?</summary>
        <p>Actualmente el sistema registra el pedido y datos de envío; la pasarela de pago está por integrar. Puedes usar el formulario de checkout para capturar dirección y datos.</p>
      </details>
    </section>
  </main>

<?php include 'includes/footer.php'; ?>
<script src="js/main.js"></script>
</body>
</html>
