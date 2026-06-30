<?php
// Encabezado unificado con logo, nombre y navegación
if(session_status() === PHP_SESSION_NONE) session_start();
$usuario_nombre = isset($_SESSION['usuario_nombre']) ? $_SESSION['usuario_nombre'] : null;
$usuario_tipo = isset($_SESSION['usuario_tipo']) ? $_SESSION['usuario_tipo'] : null; // 'cliente'|'empleado'
?>
<header class="site-header">
  <div class="contenedor header-inner">
    <a href="/reparatech/landing.php" class="logo-link" aria-label="Ir a inicio">
      <div class="logo">
        <img src="/reparatech/img/logo.png" alt="Reparatech" class="logo-img">
        <h1 class="site-title">REPARA<span style="color: var(--primary-light);">TECH</span></h1>
      </div>
    </a>
    
    <nav class="nav-principal">
      <ul>
        <li><a href="/reparatech/landing.php">Inicio</a></li>
        <li><a href="/reparatech/index.php">Tienda</a></li>
        <li><a href="/reparatech/servicios.php">Servicios</a></li>
        <li><a href="/reparatech/contacto.php">Contacto</a></li>
      </ul>
    </nav>

    <div class="header-right">
      <button id="btn-modo" class="btn btn-ghost" title="Cambiar tema">🌓</button>
      <a href="/reparatech/estatus_reparacion.php" class="btn btn-outline">📦 Estatus</a>
      
      <?php if($usuario_nombre): ?>
        <div style="position: relative;">
            <button id="btn-user" class="btn btn-ghost" title="Cuenta">
                👤 <span class="user-greet"><?php echo htmlspecialchars($usuario_nombre); ?></span>
            </button>
            <div id="user-menu" class="user-menu" style="display:none; position: absolute; right: 0; top: 100%; background: var(--bg-card); padding: 1rem; border-radius: var(--radius-md); box-shadow: var(--shadow-lg); min-width: 200px; z-index: 110;">
            <ul style="list-style: none; padding: 0; margin: 0; display: flex; flex-direction: column; gap: 0.5rem;">
                <li><a id="btn-perfil" href="/reparatech/php/cliente_panel.php" style="display: block; padding: 0.5rem; border-radius: var(--radius-sm);">Mi perfil</a></li>
                <li><a id="btn-pedidos" href="/reparatech/php/mis_pedidos.php" style="display: block; padding: 0.5rem; border-radius: var(--radius-sm);">Mis pedidos</a></li>
                <?php if($usuario_tipo === 'empleado'): ?>
                <li><a id="btn-admin" href="/reparatech/php/productos_admin.php" style="display: block; padding: 0.5rem; border-radius: var(--radius-sm);">Panel Admin</a></li>
                <?php endif; ?>
                <li><button id="btn-logout" class="btn btn-ghost" style="width: 100%; justify-content: flex-start; color: var(--danger);">Cerrar sesión</button></li>
            </ul>
            </div>
        </div>
      <?php else: ?>
        <button id="btn-login" class="btn btn-principal">Iniciar sesión</button>
      <?php endif; ?>
      
      <button id="btn-carrito" class="btn btn-ghost" title="Ver carrito">
        🛒 <span id="carrito-count" style="background: var(--danger); color: white; padding: 2px 6px; border-radius: 10px; font-size: 0.75rem;">0</span>
      </button>
    </div>
  </div>
</header>