<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width,initial-scale=1">
  <title>Restablecer Contraseña - Reparatech</title>
  <link rel="stylesheet" href="css/style.css">
</head>
<body>
  <?php include 'includes/header.php'; ?>
  
  <main class="contenedor" style="max-width: 600px; margin: 60px auto;">
    <div id="reset-panel" style="background: var(--card); padding: 32px; border-radius: 12px; box-shadow: 0 6px 18px rgba(2,6,23,0.08);">
      
      <!-- Panel 1: Solicitar Reset -->
      <div id="panel-solicitar" class="reset-panel">
        <h2>Recuperar Contraseña</h2>
        <p style="color: rgba(0,0,0,0.6);">Ingresa tu número de teléfono para recibir instrucciones de recuperación</p>
        <form id="form-solicitar">
          <div class="input-animated">
            <label>Número de Teléfono</label>
            <input id="telefono-input" type="text" placeholder="Ej: 5550001234" required>
          </div>
          <button type="submit" class="btn principal">Enviar Instrucciones</button>
        </form>
        <div id="solicitar-resultado" style="margin-top: 16px;"></div>
        <div style="text-align: center; margin-top: 20px;">
          <small>¿Recordaste tu contraseña? <a href="index.php" style="color: var(--color-primario); text-decoration: none;">Volver al inicio</a></small>
        </div>
      </div>

      <!-- Panel 2: Restablecer Contraseña -->
      <div id="panel-restablecer" class="reset-panel" style="display: none;">
        <h2>Restablecer Contraseña</h2>
        <p style="color: rgba(0,0,0,0.6);">Ingresa tu nueva contraseña</p>
        <form id="form-restablecer">
          <div class="input-animated">
            <label>Nueva Contraseña</label>
            <input id="nueva-contrasena" type="password" placeholder="Mínimo 6 caracteres" required>
          </div>
          <div class="input-animated">
            <label>Confirmar Contraseña</label>
            <input id="confirmar-contrasena" type="password" placeholder="Repite la contraseña" required>
          </div>
          <button type="submit" class="btn principal">Actualizar Contraseña</button>
        </form>
        <div id="restablecer-resultado" style="margin-top: 16px;"></div>
      </div>

      <!-- Panel 3: Éxito -->
      <div id="panel-exito" class="reset-panel" style="display: none; text-align: center;">
        <div style="font-size: 4em; margin-bottom: 16px;">✅</div>
        <h2>¡Contraseña Actualizada!</h2>
        <p style="color: rgba(0,0,0,0.6);">Tu contraseña ha sido restablecida correctamente</p>
        <a href="index.php" class="btn principal" style="display: inline-block; margin-top: 16px;">Ir a Iniciar Sesión</a>
      </div>
    </div>
  </main>

  <?php include 'includes/footer.php'; ?>

  <script>
    const urlParams = new URLSearchParams(window.location.search);
    const token = urlParams.get('token');

    // Si hay token, validarlo y mostrar panel de reset
    if (token) {
      fetch('php/api_reset_password.php', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ accion: 'validar_token', token: token })
      })
        .then(r => r.json())
        .then(data => {
          if (data.ok) {
            document.getElementById('panel-solicitar').style.display = 'none';
            document.getElementById('panel-restablecer').style.display = 'block';
          } else {
            showError('panel-solicitar', data.error || 'Token inválido o expirado');
          }
        })
        .catch(() => showError('panel-solicitar', 'Error validando token'));
    }

    // Formulario de solicitud
    document.getElementById('form-solicitar').addEventListener('submit', async (e) => {
      e.preventDefault();
      const telefono = document.getElementById('telefono-input').value.trim();
      const out = document.getElementById('solicitar-resultado');

      const res = await fetch('php/api_reset_password.php', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ accion: 'solicitar', telefono: telefono })
      })
        .then(r => r.json())
        .catch(() => ({ error: 'Error de conexión' }));

      if (res.ok) {
        out.innerHTML = `<div style="background: #d4edda; color: #155724; padding: 12px; border-radius: 8px; border-left: 4px solid #28a745;">
          ✅ ${res.mensaje}
          ${res.test_link ? `<br><small><a href="${res.test_link}" style="color: #155724; text-decoration: underline;">Link de prueba</a></small>` : ''}
        </div>`;
      } else {
        out.innerHTML = `<div style="background: #f8d7da; color: #721c24; padding: 12px; border-radius: 8px; border-left: 4px solid #c00;">❌ ${res.error}</div>`;
      }
    });

    // Formulario de reset
    document.getElementById('form-restablecer').addEventListener('submit', async (e) => {
      e.preventDefault();
      const nueva = document.getElementById('nueva-contrasena').value;
      const confirmar = document.getElementById('confirmar-contrasena').value;
      const out = document.getElementById('restablecer-resultado');

      if (nueva !== confirmar) {
        out.innerHTML = '<div style="background: #f8d7da; color: #721c24; padding: 12px; border-radius: 8px; border-left: 4px solid #c00;">❌ Las contraseñas no coinciden</div>';
        return;
      }

      const res = await fetch('php/api_reset_password.php', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ accion: 'reset', token: token, contrasena: nueva })
      })
        .then(r => r.json())
        .catch(() => ({ error: 'Error de conexión' }));

      if (res.ok) {
        document.getElementById('panel-restablecer').style.display = 'none';
        document.getElementById('panel-exito').style.display = 'block';
      } else {
        out.innerHTML = `<div style="background: #f8d7da; color: #721c24; padding: 12px; border-radius: 8px; border-left: 4px solid #c00;">❌ ${res.error}</div>`;
      }
    });

    function showError(panelId, msg) {
      const panel = document.getElementById(panelId);
      const out = panel.querySelector('[id$="-resultado"]');
      if (out) out.innerHTML = `<div style="background: #f8d7da; color: #721c24; padding: 12px; border-radius: 8px; border-left: 4px solid #c00;">❌ ${msg}</div>`;
    }
  </script>
</body>
</html>
