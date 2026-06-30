<?php
session_start();
if(!isset($_SESSION['usuario_id']) || $_SESSION['usuario_tipo']!=='empleado'){ header('Location: ../index.php'); exit; }
require 'db.php';
?>
<!doctype html>
<html lang="es">
<head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1"><title>Panel Administración - Reparatech</title>
<link rel="stylesheet" href="../css/style.css">
<style>
  .admin-tabs {
    display: flex;
    gap: 8px;
    margin-bottom: 24px;
    border-bottom: 2px solid rgba(0,0,0,0.08);
    flex-wrap: wrap;
  }
  .admin-tab-btn {
    padding: 12px 16px;
    background: transparent;
    border: none;
    border-bottom: 3px solid transparent;
    cursor: pointer;
    font-weight: 600;
    color: rgba(0,0,0,0.6);
    transition: all 200ms ease;
  }
  .admin-tab-btn.active {
    color: var(--color-primario);
    border-bottom-color: var(--color-primario);
  }
  .admin-panel {
    display: none;
  }
  .admin-panel.active {
    display: block;
    animation: fadeInUp 300ms ease;
  }
  @keyframes fadeInUp {
    from { opacity: 0; transform: translateY(8px); }
    to { opacity: 1; transform: none; }
  }
</style>
</head>
<body>
<?php include '../includes/header.php'; ?>
<main class="contenedor">
  <div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:24px;flex-wrap:wrap;gap:12px">
    <h2>Panel de Administración</h2>
    <button class="btn-back" onclick="history.back()">← Volver</button>
  </div>

  <!-- Tabs de navegación -->
  <div class="admin-tabs">
    <button class="admin-tab-btn active" data-tab="reparaciones">🔧 Reparaciones</button>
    <button class="admin-tab-btn" data-tab="productos">🛒 Productos</button>
    <button class="admin-tab-btn" data-tab="ventas">📦 Ventas/Envíos</button>
    <button class="admin-tab-btn" data-tab="logs">📋 Logs</button>
  </div>

  <!-- Panel Reparaciones -->
  <div id="panel-reparaciones" class="admin-panel active">
    <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 24px;">
      <div class="section-card">
        <h3>Registrar Nueva Reparación</h3>
        <form id="form-reparacion">
          <?php
            $marcas = $pdo->query('SELECT id_marca,nombre_marca FROM marcas ORDER BY nombre_marca')->fetchAll();
            $tipos = $pdo->query('SELECT id_tipo,nombre_tipo FROM tipos_equipo ORDER BY nombre_tipo')->fetchAll();
            $colores = $pdo->query('SELECT id_color,nombre_color,hex_code FROM colores ORDER BY nombre_color')->fetchAll();
          ?>
          <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 16px;">
              <div class="input-animated"><label>Nombre(s)</label>
                <input name="cliente_nombre" required placeholder="Ej: Juan">
              </div>
              <div class="input-animated"><label>Apellido(s)</label>
                <input name="cliente_apellido" required placeholder="Ej: García López">
              </div>
          </div>
          <div class="input-animated"><label>Teléfono (Para buscar cliente existente)</label>
            <input name="cliente_telefono" placeholder="Ej: 5512345678">
          </div>
          
          <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 16px;">
              <div class="input-animated"><label>Marca</label>
                <select name="id_marca" required>
                  <option value="">-- Seleccionar marca --</option>
                  <?php foreach($marcas as $m): ?>
                    <option value="<?php echo $m['id_marca'] ?>"><?php echo htmlspecialchars($m['nombre_marca']) ?></option>
                  <?php endforeach; ?>
                </select>
              </div>
              <div class="input-animated"><label>Tipo</label>
                <select name="id_tipo" required>
                  <option value="">-- Seleccionar tipo --</option>
                  <?php foreach($tipos as $t): ?>
                    <option value="<?php echo $t['id_tipo'] ?>"><?php echo htmlspecialchars($t['nombre_tipo']) ?></option>
                  <?php endforeach; ?>
                </select>
              </div>
          </div>

          <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 16px;">
              <div class="input-animated"><label>Modelo</label><input name="modelo" required placeholder="Ej: iPhone 13"></div>
              <div class="input-animated"><label>Color</label>
                <select name="id_color">
                  <option value="">-- Seleccionar color --</option>
                  <?php foreach($colores as $c): ?>
                    <option value="<?php echo $c['id_color'] ?>"><?php echo htmlspecialchars($c['nombre_color']) ?></option>
                  <?php endforeach; ?>
                </select>
              </div>
          </div>

          <div class="input-animated"><label>IMEI / Número de Serie</label><input name="imei_serie" placeholder="Opcional"></div>

          <div class="input-animated"><label>Motivo</label><input name="motivo" placeholder="Ej: Cambio de pantalla"></div>
          <div class="input-animated"><label>Falla</label><textarea name="falla" placeholder="Descripción detallada de la falla"></textarea></div>
          <div class="input-animated"><label>Observaciones</label><textarea name="observaciones" placeholder="Estado físico, rayones, etc."></textarea></div>
          <div class="input-animated"><label>Precio estimado</label><input name="precio" type="number" step="0.01"></div>
          
          <button type="button" id="btn-crear-reparacion" class="btn principal" style="width: 100%; margin-top: 10px;">Crear Reparación</button>
        </form>
        <div id="reparacion-result" style="margin-top:12px"></div>
      </div>

      <div class="section-card">
        <h3>Historial de Reparaciones</h3>
        <div id="historial-list">Cargando...</div>
      </div>
    </div>
  </div>

  <!-- Panel Productos -->
  <div id="panel-productos" class="admin-panel">
    <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 24px;">
      <div class="section-card">
        <h3>Nuevo Producto</h3>
        <form id="form-producto" enctype="multipart/form-data">
          <?php
            // Asegurar que $marcas y $tipos estén disponibles (si no, cargarlos)
            if(!isset($marcas)) $marcas = $pdo->query('SELECT id_marca,nombre_marca FROM marcas ORDER BY nombre_marca')->fetchAll();
            if(!isset($tipos)) $tipos = $pdo->query('SELECT id_tipo,nombre_tipo FROM tipos_equipo ORDER BY nombre_tipo')->fetchAll();
          ?>
          <div class="input-animated"><label>Nombre</label><input name="nombre" required></div>
          <div class="input-animated"><label>Descripción</label><textarea name="descripcion"></textarea></div>
          <div class="input-animated"><label>Marca</label>
            <select name="id_marca">
              <option value="">-- Seleccionar marca (opcional) --</option>
              <?php foreach($marcas as $m): ?>
                <option value="<?php echo $m['id_marca'] ?>"><?php echo htmlspecialchars($m['nombre_marca']) ?></option>
              <?php endforeach; ?>
            </select>
          </div>
          <div class="input-animated"><label>Tipo</label>
            <select name="id_tipo">
              <option value="">-- Seleccionar tipo (opcional) --</option>
              <?php foreach($tipos as $t): ?>
                <option value="<?php echo $t['id_tipo'] ?>"><?php echo htmlspecialchars($t['nombre_tipo']) ?></option>
              <?php endforeach; ?>
            </select>
          </div>
          <div class="input-animated"><label>Categoría (si no seleccionas tipo, puedes escribirla)</label><input name="categoria"></div>
          <div class="input-animated"><label>Precio</label><input name="precio" type="number" step="0.01" required></div>
          <div class="input-animated"><label>Stock</label><input name="stock" type="number" required></div>
          <div class="input-animated"><label>Imagen</label><input type="file" name="imagen" accept="image/*"></div>
          <button type="submit" class="btn principal">Guardar Producto</button>
        </form>
      </div>

      <div class="section-card">
        <h3>Listado de Productos</h3>
        <div id="productos-list">Cargando...</div>
      </div>
    </div>
  </div>

  <!-- Panel Ventas/Envíos -->
  <div id="panel-ventas" class="admin-panel">
    <div class="section-card">
      <h3>Órdenes y Envíos</h3>
      <div id="ventas-list">Cargando...</div>
    </div>
  </div>

  <!-- Panel Logs -->
  <div id="panel-logs" class="admin-panel">
    <div class="section-card">
      <h3>Registro de Actividades</h3>
      <div id="logs-list">Cargando...</div>
    </div>
  </div>
</main>
<?php include '../includes/footer.php'; ?>
<script src="../js/main.js"></script>
<script>
// Verificar sesión al cargar la página
document.addEventListener('DOMContentLoaded', async function(){
  try {
    const sessionCheck = await fetch('../php/check_session.php').then(r => r.json()).catch(() => ({loggedin: false}));
    console.log('Sesión:', sessionCheck);
    
    if(!sessionCheck.loggedin) {
      alert('Tu sesión ha expirado. Por favor, inicia sesión de nuevo.');
      window.location.href = '../index.php';
      return;
    }
  } catch(e) {
    console.error('Error verificando sesión:', e);
  }
  
  // Resto del código del documento...
  initDashboard();
});

async function initDashboard(){
  // Tab switching
  document.querySelectorAll('.admin-tab-btn').forEach(btn => {
    btn.addEventListener('click', function() {
      const tab = this.getAttribute('data-tab');
      document.querySelectorAll('.admin-tab-btn').forEach(b => b.classList.remove('active'));
      document.querySelectorAll('.admin-panel').forEach(p => p.classList.remove('active'));
      this.classList.add('active');
      document.getElementById('panel-' + tab).classList.add('active');
      
      // Cargar contenido específico
      if(tab === 'reparaciones') loadHistorialReparaciones();
      else if(tab === 'productos') loadProductos();
      else if(tab === 'ventas') loadVentas();
      else if(tab === 'logs') loadLogs();
    });
  });

  // Función para cargar productos
  async function loadProductos(){
    const c = document.getElementById('productos-list');
    c.innerHTML = '';
    const list = await fetch('../php/api_products.php').then(r => r.json()).catch(() => []);
    if(!list.length) { c.innerHTML = '<div>No hay productos</div>'; return; }
    list.forEach(p => {
      const card = document.createElement('div');
      card.style.display = 'flex';
      card.style.gap = '12px';
      card.style.alignItems = 'center';
      card.style.padding = '10px';
      card.style.borderBottom = '1px solid rgba(0,0,0,0.06)';
      card.innerHTML = `
        <img src="../${p.imagen || 'img/productos/placeholder.png'}" style="width:60px;height:60px;object-fit:cover;border-radius:6px">
        <div style="flex:1">
          <div style="font-weight:700">${p.nombre}</div>
          <small style="color:rgba(0,0,0,0.6)">$${Number(p.precio).toFixed(2)} • Stock: ${p.stock}</small>
        </div>
        <div style="display:flex;gap:8px">
          <button class="btn" data-edit="${p.id_producto}">Editar</button>
          <button class="btn" data-delete="${p.id_producto}">Eliminar</button>
        </div>
      `;
      c.appendChild(card);
    });
    attachProductoHandlers();
  }

  function attachProductoHandlers(){
    document.querySelectorAll('[data-edit]').forEach(btn => {
      btn.addEventListener('click', async function(){
        const id = this.getAttribute('data-edit');
        const prod = await fetch('../php/api_products.php?id=' + id).then(r => r.json()).catch(() => null);
        if(!prod) { alert('Error cargando'); return; }
        openEditProductoModal(prod);
      });
    });
    document.querySelectorAll('[data-delete]').forEach(btn => {
      btn.addEventListener('click', async function(){
        const id = this.getAttribute('data-delete');
        if(!confirm('¿Eliminar?')) return;
        const res = await fetch('../php/productos_delete.php', {
          method: 'POST',
          headers: {'Content-Type': 'application/json'},
          body: JSON.stringify({id: id})
        }).then(r => r.json()).catch(() => null);
        if(res && res.ok) { alertCustom('Eliminado'); loadProductos(); }
        else alertCustom(res?.error || 'Error');
      });
    });
  }

  function openEditProductoModal(prod){
    const overlay = document.createElement('div');
    overlay.style.position = 'fixed';
    overlay.style.inset = 0;
    overlay.style.background = 'rgba(2,6,23,0.5)';
    overlay.style.display = 'flex';
    overlay.style.alignItems = 'center';
    overlay.style.justifyContent = 'center';
    overlay.style.zIndex = 9999;
    
    const box = document.createElement('div');
    box.style.width = '600px';
    box.style.maxWidth = '94%';
    box.style.background = 'var(--card)';
    box.style.borderRadius = '12px';
    box.style.padding = '24px';
    
    box.innerHTML = `
      <h3>Editar Producto</h3>
      <form id="edit-prod-form" enctype="multipart/form-data">
        <input type="hidden" name="id" value="${prod.id_producto}">
        <div class="input-animated"><label>Nombre</label><input name="nombre" value="${prod.nombre}"></div>
        <div class="input-animated"><label>Descripción</label><textarea name="descripcion">${prod.descripcion || ''}</textarea></div>
        <div class="input-animated"><label>Categoría</label><input name="categoria" value="${prod.categoria || ''}"></div>
        <div class="input-animated"><label>Precio</label><input name="precio" type="number" step="0.01" value="${Number(prod.precio).toFixed(2)}"></div>
        <div class="input-animated"><label>Stock</label><input name="stock" type="number" value="${prod.stock}"></div>
        <div class="input-animated"><label>Imagen</label><input type="file" name="imagen"></div>
        <div style="display:flex;gap:8px;justify-content:flex-end;margin-top:16px">
          <button type="button" class="btn" id="edit-cancel">Cancelar</button>
          <button type="submit" class="btn principal">Guardar</button>
        </div>
      </form>
    `;
    
    overlay.appendChild(box);
    document.body.appendChild(overlay);
    
    document.getElementById('edit-cancel').addEventListener('click', () => overlay.remove());
    document.getElementById('edit-prod-form').addEventListener('submit', async (e) => {
      e.preventDefault();
      const f = new FormData(e.target);
      const res = await fetch('../php/productos_update.php', {method: 'POST', body: f}).then(r => r.json()).catch(() => null);
      if(res && res.ok) { alertCustom('Actualizado'); overlay.remove(); loadProductos(); }
      else alertCustom(res?.error || 'Error');
    });
  }

  // Historial de reparaciones
  async function loadHistorialReparaciones(){
    const out = document.getElementById('historial-list');
    out.innerHTML = 'Cargando...';
    const res = await fetch('../php/api_reparaciones.php?accion=listar').then(r => r.json()).catch(() => null);
    if(!res || !res.length) { out.innerHTML = '<div>No hay reparaciones</div>'; return; }
    out.innerHTML = '';
    res.forEach(r => {
      const div = document.createElement('div');
      div.style.padding = '12px';
      div.style.borderBottom = '1px solid rgba(0,0,0,0.06)';
      div.style.display = 'flex';
      div.style.justifyContent = 'space-between';
      div.style.alignItems = 'center';
      div.style.gap = '10px';
      div.style.flexWrap = 'wrap';
      
      const estatusColor = r.estatus === 'Entregado' ? '#28a745' : (r.estatus === 'Concluido' ? '#ffc107' : '#007bff');

      div.innerHTML = `
        <div style="flex: 1; min-width: 200px;">
          <div style="font-weight:700; display: flex; align-items: center; gap: 8px;">
            ${r.folio} 
            <span style="font-size: 0.75em; padding: 2px 6px; border-radius: 4px; background: ${estatusColor}20; color: ${estatusColor}; border: 1px solid ${estatusColor}40;">${r.estatus}</span>
          </div>
          <small style="color:rgba(0,0,0,0.6)">${r.cliente_nombre || 'Cliente ' + r.id_cliente} • ${new Date(r.fecha_registro).toLocaleDateString()}</small>
        </div>
        <div style="display: flex; gap: 8px;">
            <button class="btn" onclick="downloadPDF(${r.id_reparacion})" title="Descargar PDF">📄 PDF</button>
            <button class="btn" onclick="editReparacion(${r.id_reparacion})" title="Editar">✏️</button>
            <button class="btn" onclick="deleteReparacion(${r.id_reparacion})" title="Eliminar" style="color: var(--danger);">🗑️</button>
        </div>
      `;
      out.appendChild(div);
    });
  }

  window.downloadPDF = function(id) {
      window.open('../php/generate_pdf.php?id=' + id, '_blank');
  };

  window.deleteReparacion = async function(id) {
      if(!confirm('¿Estás seguro de eliminar esta reparación? Esta acción no se puede deshacer.')) return;
      const res = await fetch('../php/api_reparaciones.php', {
          method: 'POST',
          headers: {'Content-Type': 'application/json'},
          body: JSON.stringify({accion: 'eliminar', id: id})
      }).then(r => r.json()).catch(() => ({error: 'Error de conexión'}));
      
      if(res.ok) {
          alertCustom('Reparación eliminada');
          loadHistorialReparaciones();
      } else {
          alertCustom(res.error || 'Error al eliminar');
      }
  };

  window.editReparacion = async function(id) {
      const rep = await fetch('../php/api_reparaciones.php?accion=obtener&id=' + id).then(r => r.json()).catch(() => null);
      if(!rep || rep.error) { alertCustom('Error cargando datos'); return; }
      
      // Cargar colores
      const colores = await fetch('../php/api_colores.php').then(r => r.json()).catch(() => []);
      
      const overlay = document.createElement('div');
      overlay.style.position = 'fixed';
      overlay.style.inset = 0;
      overlay.style.background = 'rgba(0,0,0,0.5)';
      overlay.style.display = 'flex';
      overlay.style.alignItems = 'center';
      overlay.style.justifyContent = 'center';
      overlay.style.zIndex = 10000;
      
      const box = document.createElement('div');
      box.style.background = 'var(--bg-card)';
      box.style.padding = '24px';
      box.style.borderRadius = '12px';
      box.style.width = '600px';
      box.style.maxWidth = '95%';
      box.style.maxHeight = '90vh';
      box.style.overflowY = 'auto';
      
      let coloresOptions = '<option value="">-- Seleccionar color --</option>';
      colores.forEach(c => {
          const selected = rep.id_color == c.id_color ? 'selected' : '';
          coloresOptions += `<option value="${c.id_color}" ${selected}>${c.nombre_color}</option>`;
      });
      
      box.innerHTML = `
        <h3>Editar Reparación: ${rep.folio}</h3>
        <form id="form-edit-rep">
            <input type="hidden" name="id_reparacion" value="${rep.id_reparacion}">
            <input type="hidden" name="accion" value="editar">
            
            <div class="input-animated"><label>Estatus</label>
                <select name="estatus">
                    <option value="En reparación" ${rep.estatus === 'En reparación' ? 'selected' : ''}>En reparación</option>
                    <option value="Concluido" ${rep.estatus === 'Concluido' ? 'selected' : ''}>Concluido</option>
                    <option value="Entregado" ${rep.estatus === 'Entregado' ? 'selected' : ''}>Entregado</option>
                </select>
            </div>
            
            <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 16px;">
                <div class="input-animated"><label>Color</label>
                    <select name="id_color">
                        ${coloresOptions}
                    </select>
                </div>
                <div class="input-animated"><label>IMEI / Serie</label>
                    <input name="imei_serie" value="${rep.imei_serie || ''}">
                </div>
            </div>
            
            <div class="input-animated"><label>Motivo</label>
                <input name="motivo" value="${rep.motivo || ''}">
            </div>
            
            <div class="input-animated"><label>Falla</label>
                <textarea name="falla" rows="3">${rep.falla || ''}</textarea>
            </div>
            
            <div class="input-animated"><label>Observaciones</label>
                <textarea name="observaciones" rows="3">${rep.observaciones || ''}</textarea>
            </div>
            
            <div class="input-animated"><label>Precio ($)</label>
                <input type="number" name="precio" step="0.01" value="${rep.precio}">
            </div>
            
            <div style="display:flex; justify-content:flex-end; gap:10px; margin-top:20px;">
                <button type="button" class="btn" id="btn-cancel-edit">Cancelar</button>
                <button type="submit" class="btn principal">Guardar Cambios</button>
            </div>
        </form>
      `;
      
      overlay.appendChild(box);
      document.body.appendChild(overlay);
      
      document.getElementById('btn-cancel-edit').addEventListener('click', () => overlay.remove());
      
      document.getElementById('form-edit-rep').addEventListener('submit', async (e) => {
          e.preventDefault();
          const formData = new FormData(e.target);
          const data = Object.fromEntries(formData.entries());
          
          const res = await fetch('../php/api_reparaciones.php', {
              method: 'POST',
              headers: {'Content-Type': 'application/json'},
              body: JSON.stringify(data)
          }).then(r => r.json()).catch(() => ({error: 'Error de conexión'}));
          
          if(res.ok) {
              alertCustom('Reparación actualizada');
              overlay.remove();
              loadHistorialReparaciones();
          } else {
              alertCustom(res.error || 'Error al guardar');
          }
      });
  };

  // Ventas/Envíos
  async function loadVentas(){
    const out = document.getElementById('ventas-list');
    out.innerHTML = 'Cargando...';
    const res = await fetch('../php/api_envios.php?accion=listar').then(r => r.json()).catch(() => null);
    if(!res || !res.length) { out.innerHTML = '<div>No hay pedidos</div>'; return; }
    out.innerHTML = '';
    res.forEach(e => {
      const div = document.createElement('div');
      div.style.padding = '16px';
      div.style.borderBottom = '1px solid rgba(0,0,0,0.06)';
      div.style.display = 'flex';
      div.style.justifyContent = 'space-between';
      div.style.alignItems = 'flex-start';
      div.style.gap = '16px';
      div.style.flexWrap = 'wrap';
      
      const estatus_color = e.estatus === 'Entregado' ? '#28a745' : (e.estatus === 'En camino' ? '#0066cc' : '#ff9800');
      
      // Construir dirección o indicar Tienda
      let infoEntrega = '';
      if(e.direccion && e.direccion.length > 5) {
          infoEntrega = `
            <div style="margin-top: 8px; font-size: 0.9em;">
                <strong>Envío a Domicilio:</strong><br>
                ${e.direccion}<br>
                <span style="color: var(--text-muted);">Contacto: ${e.telefono}</span>
            </div>
          `;
      } else {
          infoEntrega = `<div style="margin-top: 8px; font-weight: 600; color: var(--primary);">🏪 Recoger en Tienda</div>`;
      }

      div.innerHTML = `
        <div style="flex: 1;">
          <div style="display: flex; align-items: center; gap: 10px; margin-bottom: 4px;">
            <span style="font-weight:700; font-size: 1.1em;">Pedido #${e.id_pedido}</span>
            <span style="background:${estatus_color}20; color:${estatus_color}; padding: 2px 8px; border-radius: 12px; font-size: 0.8em; font-weight: 600;">${e.estatus}</span>
          </div>
          <div style="color:rgba(0,0,0,0.7); font-weight: 500;">${e.nombre_cliente}</div>
          <div style="font-weight: 700; margin-top: 4px;">$${Number(e.total).toFixed(2)}</div>
          ${infoEntrega}
        </div>
        <div style="display: flex; flex-direction: column; gap: 8px; align-items: flex-end;">
            <button class="btn" onclick="downloadTicket(${e.id_pedido})" style="display: flex; align-items: center; gap: 6px;">
                📄 Ticket
            </button>
            <button class="btn" data-view-env="${e.id_envio}">Ver Detalles</button>
            <button class="btn" onclick="deletePedido(${e.id_pedido})" style="color: var(--danger);">🗑️ Eliminar</button>
        </div>
      `;
      out.appendChild(div);
    });
  }

  window.downloadTicket = function(id) {
      window.open('../php/ver_ticket.php?id=' + id, '_blank');
  };

  window.deletePedido = async function(id) {
      if(!confirm('¿Estás seguro de eliminar este pedido? Esta acción no se puede deshacer y borrará toda la información asociada.')) return;
      
      try {
          const res = await fetch('../php/api_envios.php?accion=eliminar_pedido', {
              method: 'POST',
              headers: {'Content-Type': 'application/json'},
              body: JSON.stringify({id_pedido: id})
          }).then(r => r.json());

          if(res.ok) {
              alertCustom('Pedido eliminado correctamente');
              loadVentas();
          } else {
              alertCustom(res.error || 'Error al eliminar el pedido');
          }
      } catch(e) {
          console.error(e);
          alertCustom('Error de conexión');
      }
  };

  // Logs
  async function loadLogs(){
    const out = document.getElementById('logs-list');
    out.innerHTML = 'Cargando...';
    const res = await fetch('../php/api_logs.php?limit=50').then(r => r.json()).catch(() => null);
    if(!res || !res.length) { out.innerHTML = '<div>No hay registros</div>'; return; }
    out.innerHTML = '';
    res.forEach(log => {
      const div = document.createElement('div');
      div.style.padding = '10px';
      div.style.borderBottom = '1px solid rgba(0,0,0,0.06)';
      div.innerHTML = `
        <small style="color:rgba(0,0,0,0.6)">${new Date(log.fecha_log).toLocaleString('es-ES')}</small><br>
        <div style="font-weight:600">${log.usuario_nombre || 'Sistema'} - ${log.tipo_accion}</div>
        <small style="color:rgba(0,0,0,0.5)">${log.descripcion}</small>
      `;
      out.appendChild(div);
    });
  }

  // Form de nueva reparación
  document.getElementById('btn-crear-reparacion')?.addEventListener('click', async function(){
    const form = document.getElementById('form-reparacion');
    const fd = new FormData(form);
    const data = Object.fromEntries(fd.entries());
    data.accion = 'crear';
    
    console.log('Datos del formulario:', data);
    
    const out = document.getElementById('reparacion-result');
    out.innerHTML = '<div style="color:#666">Procesando...</div>';
    
    try {
      const res = await fetch('../php/api_reparaciones.php', {
        method: 'POST',
        body: JSON.stringify(data),
        headers: {'Content-Type': 'application/json'}
      });
      
      console.log('Status:', res.status);
      
      const texto = await res.text();
      console.log('Respuesta del servidor:', texto);
      
      let respuesta;
      try {
        respuesta = JSON.parse(texto);
      } catch(e) {
        console.error('Respuesta no es JSON:', texto);
        out.innerHTML = `<div style="color:#c00">❌ Error: Respuesta inválida del servidor<br><small>${texto}</small></div>`;
        return;
      }
      
      if(respuesta.error) {
        out.innerHTML = `<div style="color:#c00">❌ ${respuesta.error}</div>`;
      } else if(respuesta.ok) {
        out.innerHTML = `<div style="color:#080;background:#d4edda;padding:12px;border-radius:8px;border-left:4px solid #28a745">✅ Reparación creada. Folio: <strong>${respuesta.folio}</strong></div>`;
        form.reset();
        loadHistorialReparaciones();
      } else {
        out.innerHTML = `<div style="color:#c00">❌ Error desconocido<br><small>${JSON.stringify(respuesta)}</small></div>`;
      }
    } catch(e) {
      out.innerHTML = `<div style="color:#c00">❌ Error de conexión: ${e.message}</div>`;
      console.error('Error:', e);
    }
  });

  // Form nuevo producto
  document.getElementById('form-producto').addEventListener('submit', async (e) => {
    e.preventDefault();
    const f = new FormData(e.target);
    const res = await fetch('../php/productos_save.php', {method: 'POST', body: f}).then(r => r.json()).catch(() => ({error: 'Error'}));
    if(res.ok) { alertCustom('Producto guardado'); e.target.reset(); loadProductos(); }
    else alertCustom(res.error || 'Error');
  });

  // Cargar historial al abrir
  loadHistorialReparaciones();
}
</script>
</body>
</html>
