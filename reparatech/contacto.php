<?php
session_start();
?>
<!doctype html>
<html lang="es">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width,initial-scale=1">
  <title>Contacto - Reparatech</title>
  <link rel="stylesheet" href="css/style.css">
  <style>
    .contact-grid {
      display: grid;
      grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
      gap: 2rem;
      margin-top: 2rem;
    }
    .contact-card {
      background: var(--bg-card);
      padding: 2rem;
      border-radius: 1rem;
      border: 1px solid var(--border-light);
      text-align: center;
      transition: transform 0.3s ease, box-shadow 0.3s ease;
    }
    .contact-card:hover {
      transform: translateY(-5px);
      box-shadow: var(--shadow-lg);
    }
    .contact-icon {
      font-size: 3rem;
      margin-bottom: 1rem;
      display: block;
    }
    .contact-btn {
      display: inline-block;
      margin-top: 1rem;
      padding: 0.8rem 1.5rem;
      background: var(--primary);
      color: white;
      border-radius: 0.5rem;
      text-decoration: none;
      font-weight: 600;
      transition: background 0.3s ease;
    }
    .contact-btn:hover {
      background: var(--primary-dark);
    }
    .contact-btn.whatsapp {
      background: #25D366;
    }
    .contact-btn.whatsapp:hover {
      background: #128C7E;
    }
  </style>
</head>
<body>
  <?php include 'includes/header.php'; ?>
  
  <main class="contenedor fade-in">
    <div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:2rem; margin-top: 2rem;">
      <h1>Contáctanos</h1>
      <button class="btn-back" onclick="history.back()">← Volver</button>
    </div>

    <p style="text-align: center; max-width: 600px; margin: 0 auto 3rem; color: var(--text-muted); font-size: 1.1rem;">
      Estamos aquí para ayudarte. Si tienes alguna duda sobre nuestros servicios o productos, no dudes en contactarnos por cualquiera de nuestros medios.
    </p>

    <div class="contact-grid">
      <!-- WhatsApp -->
      <div class="contact-card">
        <span class="contact-icon">📱</span>
        <h3>WhatsApp</h3>
        <p>Atención rápida y personalizada.</p>
        <a href="https://wa.me/527448171159" target="_blank" class="contact-btn whatsapp">Enviar Mensaje</a>
      </div>

      <!-- Email -->
      <div class="contact-card">
        <span class="contact-icon">📧</span>
        <h3>Correo Electrónico</h3>
        <p>Para consultas generales y soporte.</p>
        <a href="mailto:codelink.solutionsweb@gmail.com" class="contact-btn">Enviar Correo</a>
      </div>

      <!-- Ubicación -->
      <div class="contact-card">
        <span class="contact-icon">📍</span>
        <h3>Ubicación</h3>
        <p>Blvd. Magnocentro 48, Col. Huixquilucan,<br>Estado de México, C.P. 52763</p>
        <a href="https://maps.google.com/?q=Blvd.+Magnocentro+48,+Huixquilucan" target="_blank" class="contact-btn" style="background: var(--bg-body); color: var(--text-main); border: 1px solid var(--border-light);">Ver en Mapa</a>
      </div>

      <!-- Horario -->
      <div class="contact-card">
        <span class="contact-icon">⏰</span>
        <h3>Horario de Atención</h3>
        <p>Lunes a Viernes<br>9:00 AM - 6:00 PM</p>
        <p style="margin-top: 0.5rem; font-size: 0.9rem; color: var(--text-muted);">Sábados y Domingos cerrado</p>
      </div>
    </div>
  </main>

  <?php include 'includes/footer.php'; ?>
  <script src="js/main.js"></script>
</body>
</html>