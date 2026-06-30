<?php
// Página principal de Reparatech - Tienda
session_start();
?>
<!doctype html>
<html lang="es">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width,initial-scale=1">
  <title>Reparatech - Tienda y Reparaciones</title>
  <link rel="stylesheet" href="css/style.css">
  <link rel="icon" href="img/logo.png">
</head>
<body>
  <?php include 'includes/header.php'; ?>

  <main>
    <!-- Hero Section -->
    <section style="padding: 6rem 0; text-align: center; background: radial-gradient(circle at center, rgba(37, 99, 235, 0.1) 0%, transparent 70%);">
      <div class="contenedor fade-in">
        <h1 style="font-size: 3.5rem; margin-bottom: 1rem; background: linear-gradient(135deg, var(--text-main) 0%, var(--primary) 100%); -webkit-background-clip: text; -webkit-text-fill-color: transparent;">
          Tecnología que inspira,<br>Reparaciones que perduran.
        </h1>
        <p style="font-size: 1.2rem; max-width: 600px; margin: 0 auto 2rem;">
          Expertos en dar nueva vida a tus dispositivos y ofrecerte los mejores accesorios del mercado.
        </p>
        <div style="display: flex; gap: 1rem; justify-content: center;">
          <a href="#tienda" class="btn principal" style="padding: 0.8rem 2rem; font-size: 1.1rem;">Ver Productos</a>
          <a href="estatus_reparacion.php" class="btn btn-outline" style="padding: 0.8rem 2rem; font-size: 1.1rem;">Consultar Reparación</a>
        </div>
      </div>
    </section>

    <div class="contenedor">
      <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 2rem;">
        <h2>Nuestros Productos</h2>
        <div class="input-animated" style="width: 300px;">
          <input type="text" id="input-busqueda" placeholder="Buscar productos..." style="padding: 0.6rem 1rem;">
        </div>
      </div>

      <section id="tienda" class="grid-productos slide-up">
        <!-- Productos se cargarán por AJAX -->
        <!-- Placeholder loading state -->
        <div class="producto" style="height: 300px; display: flex; align-items: center; justify-content: center;">
          <p>Cargando productos...</p>
        </div>
      </section>
    </div>
  </main>

  <?php include 'includes/footer.php'; ?>

  <!-- Modal producto -->
  <div id="modal-producto" class="modal">
    <div class="modal-contenido">
      <button class="modal-cerrar" id="modal-cerrar">×</button>
      <div id="modal-body"></div>
    </div>
  </div>

  <!-- Modal login/registro -->
  <div id="modal-auth" class="modal">
    <div class="modal-contenido" style="max-width: 400px;">
      <button class="modal-cerrar" id="modal-auth-cerrar">×</button>
      <div id="auth-body">
        <section id="auth-login" class="auth-panel fade-in">
          <h2 style="text-align: center; margin-bottom: 1.5rem;">Bienvenido de nuevo</h2>
          <form id="form-login">
            <label>Teléfono</label>
            <input name="telefono" required placeholder="Tu número de celular">
            <label>Contraseña</label>
            <input type="password" name="contrasena" required placeholder="••••••••">
            <button class="btn principal" type="submit" style="width: 100%; margin-top: 1rem;">Entrar</button>
          </form>
          <div style="text-align:center; margin-top: 1.5rem;">
            <small style="color: var(--text-muted);">¿No tienes cuenta?</small>
            <button id="btn-show-registro" class="btn btn-ghost" style="color: var(--primary);">Crear cuenta</button>
          </div>
        </section>

        <section id="auth-registro" class="auth-panel fade-in" style="display:none">
          <h2 style="text-align: center; margin-bottom: 1.5rem;">Crear Cuenta</h2>
          <form id="form-registro">
            <label>Nombre</label>
            <input name="nombre" required placeholder="Tu nombre completo">
            <label>Teléfono</label>
            <input name="telefono" required placeholder="Tu número de celular">
            <label>Contraseña</label>
            <input type="password" name="contrasena" required placeholder="Crea una contraseña">
            
            <label>Tipo de usuario</label>
            <select name="tipo" id="reg-tipo">
              <option value="cliente">Cliente</option>
              <option value="empleado">Empleado</option>
            </select>
            
            <div id="clave-empleado" style="display:none">
              <label>Clave de empleado</label>
              <input name="clave_empleado" placeholder="Clave especial">
              <label>Puesto</label>
              <input name="puesto" placeholder="Puesto (ej. Técnico)">
            </div>
            
            <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 1rem; margin-top: 1rem;">
              <button id="btn-back-to-login" type="button" class="btn btn-outline">Volver</button>
              <button class="btn principal" type="submit">Registrar</button>
            </div>
          </form>
        </section>
      </div>
    </div>
  </div>

  <script src="js/main.js"></script>
</body>
</html>