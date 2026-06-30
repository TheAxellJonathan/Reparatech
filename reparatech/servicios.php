<?php
session_start();
?>
<!doctype html>
<html lang="es">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width,initial-scale=1">
  <title>Servicios - Reparatech</title>
  <link rel="stylesheet" href="css/style.css">
  <style>
    .services-hero {
      text-align: center;
      padding: 4rem 1rem;
      background: linear-gradient(to bottom, var(--bg-body), var(--bg-card));
      border-radius: 0 0 2rem 2rem;
      margin-bottom: 3rem;
    }
    .services-grid {
      display: grid;
      grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
      gap: 2rem;
      margin-bottom: 4rem;
    }
    .service-card {
      background: var(--bg-card);
      padding: 2rem;
      border-radius: 1rem;
      border: 1px solid var(--border-light);
      transition: all 0.3s ease;
      position: relative;
      overflow: hidden;
    }
    .service-card:hover {
      transform: translateY(-5px);
      box-shadow: var(--shadow-lg);
      border-color: var(--primary);
    }
    .service-icon {
      font-size: 2.5rem;
      margin-bottom: 1.5rem;
      background: var(--bg-body);
      width: 80px;
      height: 80px;
      display: flex;
      align-items: center;
      justify-content: center;
      border-radius: 50%;
      color: var(--primary);
    }
    .service-card h3 {
      font-size: 1.5rem;
      margin-bottom: 1rem;
    }
    .service-card p {
      color: var(--text-muted);
      line-height: 1.6;
    }
    .cta-section {
      text-align: center;
      padding: 4rem 2rem;
      background: var(--bg-card);
      border-radius: 1rem;
      margin-bottom: 4rem;
      border: 1px solid var(--border-light);
    }
  </style>
</head>
<body>
  <?php include 'includes/header.php'; ?>
  
  <div class="services-hero fade-in">
    <div class="contenedor">
      <h1 style="font-size: 2.5rem; margin-bottom: 1rem;">Nuestros Servicios</h1>
      <p style="font-size: 1.2rem; color: var(--text-muted); max-width: 700px; margin: 0 auto;">
        Soluciones profesionales para tus dispositivos electrónicos. Calidad, rapidez y garantía en cada trabajo.
      </p>
    </div>
  </div>

  <main class="contenedor fade-in">
    <div class="services-grid">
      <!-- Reparación de Celulares -->
      <div class="service-card">
        <div class="service-icon">📱</div>
        <h3>Reparación de Celulares</h3>
        <p>
          Cambio de pantallas, baterías, centros de carga y reparación de placa. Trabajamos con todas las marcas principales: iPhone, Samsung, Xiaomi, Motorola y más.
        </p>
      </div>

      <!-- Reparación de Computadoras -->
      <div class="service-card">
        <div class="service-icon">💻</div>
        <h3>Computadoras y Laptops</h3>
        <p>
          Mantenimiento preventivo y correctivo, actualización de hardware (SSD, RAM), instalación de software, eliminación de virus y recuperación de datos.
        </p>
      </div>

      <!-- Tablets -->
      <div class="service-card">
        <div class="service-icon">📟</div>
        <h3>Tablets e iPads</h3>
        <p>
          Reparación de pantallas, baterías y problemas de encendido. Diagnóstico especializado para devolverle la vida a tu dispositivo.
        </p>
      </div>

      <!-- Venta de Accesorios -->
      <div class="service-card">
        <div class="service-icon">🎧</div>
        <h3>Venta de Accesorios</h3>
        <p>
          Encuentra fundas, micas, cargadores originales y genéricos de alta calidad, audífonos y gadgets para complementar tu experiencia tecnológica.
        </p>
      </div>

      <!-- Diagnóstico -->
      <div class="service-card">
        <div class="service-icon">🔍</div>
        <h3>Diagnóstico Gratuito</h3>
        <p>
          Revisamos tu equipo para identificar la falla exacta. Te entregamos un presupuesto detallado antes de realizar cualquier reparación.
        </p>
      </div>

      <!-- Garantía -->
      <div class="service-card">
        <div class="service-icon">🛡️</div>
        <h3>Garantía por Escrito</h3>
        <p>
          Todas nuestras reparaciones cuentan con garantía. Tu satisfacción y la seguridad de tu equipo son nuestra prioridad.
        </p>
      </div>
    </div>

    <div class="cta-section">
      <h2>¿Necesitas una reparación?</h2>
      <p style="margin: 1rem 0 2rem; color: var(--text-muted);">
        Trae tu equipo hoy mismo o contáctanos para una cotización rápida.
      </p>
      <div style="display: flex; gap: 1rem; justify-content: center; flex-wrap: wrap;">
        <a href="contacto.php" class="btn principal">Contáctanos</a>
        <a href="estatus_reparacion.php" class="btn btn-ghost">Consultar Estatus</a>
      </div>
    </div>
  </main>

  <?php include 'includes/footer.php'; ?>
  <script src="js/main.js"></script>
</body>
</html>