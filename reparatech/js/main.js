// main.js - Lógica cliente para Reparatech
document.addEventListener('DOMContentLoaded', function () {
  console.log('Carrito JS cargado');

  // Tema
  const tema = localStorage.getItem('reparatech_tema') || 'claro';
  setTema(tema);
  document.getElementById('btn-modo')?.addEventListener('click', () => {
    const actual = document.documentElement.getAttribute('data-tema') === 'oscuro' ? 'claro' : 'oscuro';
    setTema(actual);
  });

  // Actualizar contador carrito
  actualizarCuentaCarrito();

  // Cargar productos
  if (document.getElementById('tienda')) cargarProductos();

  // Busqueda
  const inputBusqueda = document.getElementById('input-busqueda');
  if(inputBusqueda){
    let debounceTimer;
    inputBusqueda.addEventListener('input', (e) => {
      clearTimeout(debounceTimer);
      debounceTimer = setTimeout(() => {
        cargarProductos(e.target.value);
      }, 300);
    });
  }

  // Botón carrito
  const btnCarrito = document.getElementById('btn-carrito');
  if (btnCarrito) {
    btnCarrito.addEventListener('click', abrirCarrito);
  }

  // Modal auth
  document.getElementById('btn-login')?.addEventListener('click', () => { showLogin(); document.getElementById('modal-auth').classList.add('show') });
  document.getElementById('modal-auth-cerrar')?.addEventListener('click', () => { document.getElementById('modal-auth').classList.remove('show') });

  // Alternar login/registro
  document.getElementById('btn-show-registro')?.addEventListener('click', () => { showRegistro(); });
  document.getElementById('btn-back-to-login')?.addEventListener('click', () => { showLogin(); });
  document.getElementById('reg-tipo')?.addEventListener('change', function (e) {
    document.getElementById('clave-empleado').style.display = e.target.value === 'empleado' ? 'block' : 'none';
  });

  // Formularios auth
  document.getElementById('form-login')?.addEventListener('submit', async function (ev) {
    ev.preventDefault();
    const fd = new FormData(this);
    const data = Object.fromEntries(fd.entries());
    data.accion = 'login';
    const res = await fetch('php/api_auth.php', { method: 'POST', body: JSON.stringify(data) }).then(r => r.json()).catch(e => ({ ok: false }));
    if (res.ok) { alertCustom('Inicio de sesión exitoso'); location.reload(); } else alertCustom(res.error || 'Error');
  });

  document.getElementById('form-registro')?.addEventListener('submit', async function (ev) {
    ev.preventDefault();
    const fd = new FormData(this);
    const data = Object.fromEntries(fd.entries());
    data.accion = 'registro';
    const res = await fetch('php/api_auth.php', { method: 'POST', body: JSON.stringify(data) }).then(r => r.json()).catch(e => ({ ok: false }));
    if (res.ok) { alertCustom('Registro exitoso'); location.reload(); } else alertCustom(res.error || 'Error');
  });

  // User menu
  document.addEventListener('click', function (e) {
    const btnUser = document.getElementById('btn-user');
    const userMenu = document.getElementById('user-menu');
    if (!btnUser || !userMenu) return;
    if (btnUser.contains(e.target)) {
      userMenu.style.display = userMenu.style.display === 'block' ? 'none' : 'block';
      return;
    }
    if (userMenu && !userMenu.contains(e.target)) userMenu.style.display = 'none';
  });

  document.getElementById('btn-logout')?.addEventListener('click', async function () {
    const res = await fetch('php/api_auth.php', { method: 'POST', body: JSON.stringify({ accion: 'logout' }) }).then(r => r.json()).catch(e => ({ ok: false }));
    if (res.ok) { alertCustom('Sesión cerrada'); location.reload(); } else alertCustom('No se pudo cerrar sesión');
  });
});

function setTema(t) {
  document.documentElement.setAttribute('data-tema', t === 'oscuro' ? 'oscuro' : '');
  localStorage.setItem('reparatech_tema', t);
}

function cargarProductos(search = '') {
  const cont = document.getElementById('tienda');
  if (!cont) return;

  const url = search ? `php/api_products.php?search=${encodeURIComponent(search)}` : 'php/api_products.php';

  fetch(url)
    .then(async r => {
      if (!r.ok) throw new Error('Server error: ' + r.status);
      try {
        return await r.json();
      } catch (e) {
        throw new Error('Invalid JSON response');
      }
    })
    .then(data => {
      cont.innerHTML = '';
      if (!Array.isArray(data) || !data.length) { cont.innerHTML = '<p style="text-align:center; padding: 2rem;">No hay productos disponibles</p>'; return; }
      data.forEach(p => {
        const card = document.createElement('article');
        card.className = 'producto fade-in';
        const stock = Number(p.stock || 0);
        const agotado = stock <= 0;
        card.innerHTML = `
          <img src="${p.imagen || 'img/productos/placeholder.png'}" alt="${escapeHtml(p.nombre)}">
          <h4>${escapeHtml(p.nombre)}</h4>
          <p>${escapeHtml(p.descripcion || '')}</p>
          <div class="precio">$${Number(p.precio || 0).toFixed(2)}</div>
          <div style="display:flex;gap:8px;margin-top:8px">
            <button class="btn" onclick="verProducto(${p.id_producto})">Ver</button>
            ${agotado ? `<button class="btn" disabled>Agotado</button>` : `<button class="btn principal" onclick="agregarAlCarrito(${p.id_producto}, 1)">Agregar</button>`}
          </div>
        `;
        cont.appendChild(card);
      });
    })
    .catch(err => {
      console.error(err);
      cont.innerHTML = `
        <div class="card" style="text-align:center; color:var(--danger); border-color:var(--danger);">
          <h3>❌ Error cargando productos</h3>
          <p>No se pudieron cargar los productos. Es posible que la base de datos no esté inicializada.</p>
          <a href="setup_db.php" class="btn btn-outline" style="margin-top:1rem;">Ejecutar Configuración Inicial</a>
        </div>`;
    });
}

function verProducto(id) {
  fetch('php/api_products.php?id=' + id)
    .then(r => r.json())
    .then(p => {
      const body = document.getElementById('modal-body');
      const stock = Number(p.stock || 0);
      const agotado = stock <= 0;
      body.innerHTML = `
        <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 2rem; align-items: start;">
          <img src="${p.imagen || 'img/productos/placeholder.png'}" style="width:100%; aspect-ratio: 1/1; object-fit:cover; border-radius: var(--radius-md); box-shadow: var(--shadow-md);">
          <div>
            <h2 style="margin-bottom: 0.5rem; font-size: 1.8rem;">${escapeHtml(p.nombre)}</h2>
            <div style="font-size: 1.5rem; font-weight: 700; color: var(--primary); margin-bottom: 1rem;">$${Number(p.precio || 0).toFixed(2)}</div>
            
            <p style="color: var(--text-muted); margin-bottom: 1.5rem; line-height: 1.6;">${escapeHtml(p.descripcion || '')}</p>
            
            <div style="display: flex; gap: 1rem; flex-wrap: wrap;">
              ${agotado
          ? `<button class="btn btn-ghost" disabled style="background: var(--bg-body);">🚫 Agotado</button>`
          : `<button class="btn principal" onclick="agregarAlCarrito(${p.id_producto}, 1)" style="flex: 1;">Añadir al Carrito</button>`
        }
            </div>
            <div style="margin-top: 1rem; font-size: 0.9rem; color: var(--text-muted);">
              Stock disponible: <span style="font-weight: 600; color: var(--text-main);">${stock}</span>
            </div>
          </div>
        </div>
      `;
      document.getElementById('modal-producto').classList.add('show');
    })
    .catch(err => { console.error(err); alertCustom('Error cargando producto'); });
}

document.getElementById('modal-cerrar')?.addEventListener('click', () => { document.getElementById('modal-producto').classList.remove('show'); });

function agregarAlCarrito(id, cantidad) {
  const formData = new FormData();
  formData.append('accion', 'agregar');
  formData.append('id', id);
  formData.append('cantidad', cantidad);

  fetch('php/api_carrito.php', { method: 'POST', body: formData, credentials: 'same-origin' })
    .then(r => r.json())
    .then(res => {
      console.log('api_carrito agregar response', res);
      if (res.ok) {
        alertCustom('✅ Producto agregado al carrito');
        // Preferir el carrito enviado en la respuesta para actualizar el contador
        if (res.carrito) {
          const el = document.getElementById('carrito-count');
          if (el) el.textContent = res.carrito.reduce((s, i) => s + (i.cantidad || 0), 0);
        } else {
          actualizarCuentaCarrito();
        }
      } else {
        alertCustom('❌ ' + (res.error || 'Error agregando producto'));
      }
    })
    .catch(err => { console.error('fetch agregarAlCarrito error', err); alertCustom('Error en servidor'); });
}

function actualizarCuentaCarrito() {
  const el = document.getElementById('carrito-count');
  if (!el) return;

  fetch('php/api_carrito.php', { credentials: 'same-origin' })
    .then(r => r.json())
    .then(res => {
      const carrito = res.carrito || [];
      const count = carrito.reduce((sum, item) => sum + (item.cantidad || 0), 0);
      el.textContent = count;
    })
    .catch(err => {
      console.error('Error updating cart:', err);
      el.textContent = '0';
    });
}

function abrirCarrito() {
  // Redirección simple a la página de carrito en la raíz del sitio
  console.log('Navigate to cart: cart.php');
  window.location.href = 'cart.php';
}

function showLogin() {
  document.getElementById('auth-login').style.display = 'block';
  document.getElementById('auth-registro').style.display = 'none';
}

function showRegistro() {
  document.getElementById('auth-login').style.display = 'none';
  document.getElementById('auth-registro').style.display = 'block';
}

function alertCustom(mensaje) {
  const div = document.createElement('div');
  div.style.cssText = `
    position: fixed;
    bottom: 24px;
    right: 24px;
    background: var(--bg-card);
    backdrop-filter: blur(10px);
    color: var(--text-main);
    padding: 1rem 1.5rem;
    border-radius: var(--radius-md);
    box-shadow: var(--shadow-lg);
    z-index: 9999;
    font-weight: 500;
    border: 1px solid var(--border-light);
    animation: slideUp 0.3s ease forwards;
    display: flex;
    align-items: center;
    gap: 0.5rem;
  `;
  div.innerHTML = mensaje;
  document.body.appendChild(div);
  setTimeout(() => {
    div.style.opacity = '0';
    div.style.transform = 'translateY(10px)';
    setTimeout(() => div.remove(), 300);
  }, 3500);
}

function escapeHtml(text) {
  return String(text || '').replace(/[&<>"']/g, m => ({ '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' }[m]));
}
