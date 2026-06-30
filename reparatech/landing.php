<?php
// Landing page converted to PHP to reuse header/footer includes
// Header include will start session when required
?>
<!doctype html>
<html lang="es">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width,initial-scale=1">
  <title>Reparatech - Expertos en Tecnología</title>
  <link rel="stylesheet" href="css/style.css">
  <link rel="stylesheet" href="css/landing.css">
  <link rel="icon" href="img/logo.png">
</head>
<body>
  <?php include 'includes/header.php'; ?>

  <main>
    <!-- Hero Section -->
    <section class="hero-section">
      <div class="contenedor">
        <div class="hero-content">
          <div class="hero-text slide-up">
            <h1>Tecnología que Funciona para Ti</h1>
            <p class="subtitle">Expertos en reparación, venta y mantenimiento de dispositivos. Tu confianza es nuestra prioridad.</p>
            <div class="cta-buttons">
              <button class="btn principal" onclick="location.href='index.php'">
                🛒 Ir a la Tienda
              </button>
              <button class="btn btn-outline" onclick="location.href='estatus_reparacion.php'">
                📦 Estatus de Reparación
              </button>
            </div>
          </div>
          <div class="hero-visual fade-in">
            <img src="https://images.unsplash.com/photo-1591799264318-7e6ef8ddb7ea?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80" alt="Reparación de dispositivos" loading="lazy">
            
            <!-- Floating Badges -->
            <div class="floating-badge badge-1">
              <div style="background: #dcfce7; color: #166534; padding: 8px; border-radius: 50%;">✓</div>
              <div>
                <strong>Garantía</strong>
                <div style="font-size: 0.8rem; color: var(--text-muted)">En cada reparación</div>
              </div>
            </div>

            <div class="floating-badge badge-2">
              <div style="background: #dbeafe; color: #1e40af; padding: 8px; border-radius: 50%;">⚡</div>
              <div>
                <strong>Rápido</strong>
                <div style="font-size: 0.8rem; color: var(--text-muted)">Servicio express</div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </section>

    <!-- Stats Section -->
    <section class="contenedor">
      <div class="stats-section">
        <div class="stats-grid">
          <div class="stat-item">
            <h3>+5k</h3>
            <p>Reparaciones Exitosas</p>
          </div>
          <div class="stat-item">
            <h3>+2k</h3>
            <p>Clientes Felices</p>
          </div>
          <div class="stat-item">
            <h3>24h</h3>
            <p>Tiempo Promedio</p>
          </div>
          <div class="stat-item">
            <h3>100%</h3>
            <p>Garantizado</p>
          </div>
        </div>
      </div>
    </section>

    <!-- Services Section -->
    <section class="features-section">
      <div class="contenedor">
        <div class="section-header">
          <span class="section-tag">Nuestros Servicios</span>
          <h2>Soluciones Integrales para tus Dispositivos</h2>
          <p>No solo reparamos, devolvemos la vida a tus equipos con componentes de alta calidad y técnicos certificados.</p>
        </div>

        <div class="features-grid">
          <div class="feature-card">
            <div class="feature-icon">📱</div>
            <h3>Reparación de Celulares</h3>
            <p>Cambio de pantallas, baterías, centros de carga y más. Trabajamos con todas las marcas principales.</p>
          </div>
          <div class="feature-card">
            <div class="feature-icon">💻</div>
            <h3>Soporte de Cómputo</h3>
            <p>Mantenimiento preventivo, correctivo, instalación de software y mejoras de rendimiento.</p>
          </div>
          <div class="feature-card">
            <div class="feature-icon">🎮</div>
            <h3>Consolas de Videojuegos</h3>
            <p>Reparación de controles, limpieza interna y solución de problemas de calentamiento.</p>
          </div>
          <div class="feature-card">
            <div class="feature-icon">🛍️</div>
            <h3>Venta de Accesorios</h3>
            <p>Encuentra los mejores cases, cargadores, audífonos y gadgets para complementar tu estilo.</p>
          </div>
          <div class="feature-card">
            <div class="feature-icon">🔧</div>
            <h3>Diagnóstico Gratuito</h3>
            <p>Revisamos tu equipo sin costo para darte un presupuesto exacto y transparente.</p>
          </div>
          <div class="feature-card">
            <div class="feature-icon">🛡️</div>
            <h3>Garantía Extendida</h3>
            <p>Todas nuestras reparaciones cuentan con garantía por escrito para tu tranquilidad.</p>
          </div>
        </div>
      </div>
    </section>

    <!-- Testimonials Section -->
    <section class="features-section" style="background: var(--bg-card);">
      <div class="contenedor">
        <div class="section-header">
          <span class="section-tag">Testimonios</span>
          <h2>Lo que dicen nuestros clientes</h2>
        </div>

        <div class="testimonials-grid">
          <div class="testimonial-card">
            <div class="stars">★★★★★</div>
            <p>"Excelente servicio, repararon mi iPhone en menos de 2 horas y quedó como nuevo. Muy recomendados."</p>
            <div class="client-info">
              <div class="client-avatar" style="background-image: url('https://i.pravatar.cc/150?img=11'); background-size: cover;"></div>
              <div>
                <strong>Carlos Ruiz</strong>
                <div style="font-size: 0.85rem; color: var(--text-muted)">Cliente Frecuente</div>
              </div>
            </div>
          </div>
          <div class="testimonial-card">
            <div class="stars">★★★★★</div>
            <p>"Me salvaron la vida con mi laptop del trabajo. El diagnóstico fue rápido y el precio justo."</p>
            <div class="client-info">
              <div class="client-avatar" style="background-image: url('https://i.pravatar.cc/150?img=5'); background-size: cover;"></div>
              <div>
                <strong>Ana Martínez</strong>
                <div style="font-size: 0.85rem; color: var(--text-muted)">Diseñadora Gráfica</div>
              </div>
            </div>
          </div>
          <div class="testimonial-card">
            <div class="stars">★★★★★</div>
            <p>"Gran variedad de accesorios y la atención es de primera. Definitivamente volveré."</p>
            <div class="client-info">
              <div class="client-avatar" style="background-image: url('https://i.pravatar.cc/150?img=33'); background-size: cover;"></div>
              <div>
                <strong>David López</strong>
                <div style="font-size: 0.85rem; color: var(--text-muted)">Gamer</div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </section>

    <!-- CTA Strip -->
    <section class="contenedor">
      <div class="cta-strip">
        <h2>¿Listo para reparar tu equipo?</h2>
        <p style="max-width: 600px; margin: 1rem auto 2rem;">No dejes que un dispositivo dañado detenga tu día. Visítanos o contáctanos hoy mismo.</p>
        <div class="cta-buttons">
          <button class="btn principal" onclick="location.href='contacto.php'">📞 Contáctanos</button>
          <button class="btn btn-outline" onclick="location.href='faq.php'">❓ Preguntas Frecuentes</button>
        </div>
      </div>
    </section>

  </main>

  <?php include 'includes/footer.php'; ?>

  <script src="js/main.js"></script>
</body>
</html>
