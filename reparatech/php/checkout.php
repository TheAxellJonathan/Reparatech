<?php
session_start();
if(!isset($_SESSION['usuario_id'])) {
  header('Location: ../index.php');
  exit;
}
require 'db.php';

// Inicializar carrito en sesión si no existe
if(!isset($_SESSION['carrito'])) $_SESSION['carrito'] = [];

// Cargar detalles de cada producto
$items = [];
$total = 0;
foreach($_SESSION['carrito'] as $item){
  $stmt = $pdo->prepare('SELECT * FROM productos WHERE id_producto = ?');
  $stmt->execute([$item['id']]);
  $prod = $stmt->fetch();
  if($prod){
    $precio = $prod['precio'] ?? 0;
    $subtotal = $precio * $item['cantidad'];
    $total += $subtotal;
    $items[] = ['producto'=>$prod, 'cantidad'=>$item['cantidad'], 'subtotal'=>$subtotal];
  }
}
?>
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width,initial-scale=1">
  <title>Checkout - Reparatech</title>
  <link rel="stylesheet" href="../css/style.css">
  <style>
    .checkout-grid {
        display: grid;
        grid-template-columns: 1fr 380px;
        gap: 2rem;
    }
    @media (max-width: 900px) {
        .checkout-grid { grid-template-columns: 1fr; }
    }
    .delivery-options {
        display: grid;
        grid-template-columns: 1fr 1fr;
        gap: 1rem;
        margin-bottom: 2rem;
    }
    .delivery-option {
        background: var(--bg-card);
        border: 2px solid var(--border-light);
        border-radius: 12px;
        padding: 1.5rem;
        cursor: pointer;
        transition: all 0.2s;
        text-align: center;
    }
    .delivery-option.active {
        border-color: var(--primary);
        background: rgba(var(--primary-rgb), 0.05);
    }
    .delivery-option:hover {
        border-color: var(--primary);
    }
    .delivery-icon {
        font-size: 2rem;
        margin-bottom: 0.5rem;
        display: block;
    }
    .form-section {
        background: var(--bg-card);
        padding: 2rem;
        border-radius: 20px;
        border: 1px solid var(--border-light);
        margin-bottom: 2rem;
    }
    .form-grid {
        display: grid;
        grid-template-columns: 1fr 1fr;
        gap: 1rem;
    }
    .full-width { grid-column: span 2; }
  </style>
</head>
<body>
  <?php include '../includes/header.php'; ?>
  
  <main class="contenedor" style="padding-top: 2rem; padding-bottom: 4rem;">
    <h1 style="margin-bottom: 2rem;">Finalizar Compra</h1>

    <?php if(empty($items)): ?>
      <div style="text-align: center; padding: 4rem;">
        <p>El carrito está vacío.</p>
        <a href="../index.php" class="btn principal">Volver a tienda</a>
      </div>
    <?php else: ?>
    
    <form id="form-checkout" class="checkout-grid">
      <div class="checkout-left">
        
        <!-- Selección de Entrega -->
        <h3 style="margin-bottom: 1rem;">Método de Entrega</h3>
        <div class="delivery-options">
            <div class="delivery-option active" data-value="tienda">
                <span class="delivery-icon">🏪</span>
                <strong>Recoger en Tienda</strong>
                <div style="font-size: 0.9rem; color: var(--text-muted);">Gratis</div>
            </div>
            <div class="delivery-option" data-value="domicilio">
                <span class="delivery-icon">🚚</span>
                <strong>Envío a Domicilio</strong>
                <div style="font-size: 0.9rem; color: var(--text-muted);">Por Estafeta</div>
            </div>
        </div>
        <input type="hidden" name="tipo_entrega" id="tipo_entrega" value="tienda">

        <!-- Datos de Contacto -->
        <div class="form-section">
            <h3 style="margin-bottom: 1.5rem;">Datos de Contacto</h3>
            <div class="form-grid">
                <div class="input-animated">
                    <label>Nombre(s)</label>
                    <input name="nombres" value="<?php echo htmlspecialchars($_SESSION['usuario_nombre'] ?? ''); ?>" required>
                </div>
                <div class="input-animated">
                    <label>Apellido(s)</label>
                    <input name="apellidos" required>
                </div>
                <div class="input-animated full-width">
                    <label>Teléfono Celular</label>
                    <input name="telefono" type="tel" placeholder="10 dígitos" required>
                </div>
            </div>
        </div>

        <!-- Dirección de Envío (Oculto por defecto) -->
        <div id="direccion-section" class="form-section" style="display: none;">
            <h3 style="margin-bottom: 1.5rem;">Dirección de Envío</h3>
            <div class="form-grid">
                <div class="input-animated full-width">
                    <label>Calle y Número</label>
                    <input name="calle" class="address-field">
                </div>
                <div class="input-animated">
                    <label>Colonia</label>
                    <input name="colonia" class="address-field">
                </div>
                <div class="input-animated">
                    <label>Código Postal</label>
                    <input name="codigo_postal" class="address-field">
                </div>
                <div class="input-animated">
                    <label>Municipio / Alcaldía</label>
                    <input name="municipio" class="address-field">
                </div>
                <div class="input-animated">
                    <label>Estado</label>
                    <input name="estado" class="address-field">
                </div>
                <div class="input-animated full-width">
                    <label>País</label>
                    <input name="pais" value="México" readonly style="background: var(--bg-body);">
                </div>
            </div>
        </div>

      </div>

      <!-- Resumen Lateral -->
      <div class="checkout-right">
        <div class="section-card" style="position: sticky; top: 100px;">
            <h3 style="margin-bottom: 1.5rem;">Resumen del Pedido</h3>
            <div style="max-height: 300px; overflow-y: auto; margin-bottom: 1rem;">
                <?php foreach($items as $item): ?>
                    <div style="display: flex; gap: 1rem; margin-bottom: 1rem; padding-bottom: 1rem; border-bottom: 1px solid var(--border-light);">
                        <img src="../<?=$item['producto']['imagen'] ?? 'img/productos/placeholder.png'?>" style="width: 50px; height: 50px; border-radius: 8px; object-fit: cover;">
                        <div style="flex: 1;">
                            <div style="font-size: 0.9rem; font-weight: 600;"><?=htmlspecialchars($item['producto']['nombre'])?></div>
                            <div style="font-size: 0.85rem; color: var(--text-muted);">Cant: <?=$item['cantidad']?></div>
                        </div>
                        <div style="font-weight: 600;">$<?=number_format($item['subtotal'], 2)?></div>
                    </div>
                <?php endforeach; ?>
            </div>
            
            <div style="border-top: 2px solid var(--border-light); padding-top: 1rem;">
                <div style="display: flex; justify-content: space-between; font-size: 1.2rem; font-weight: 700; margin-bottom: 1.5rem;">
                    <span>Total a Pagar:</span>
                    <span>$<?=number_format($total, 2)?></span>
                </div>
                <button type="submit" id="btn-procesar" class="btn principal" style="width: 100%; padding: 1rem;">
                    💳 Pagar Ahora
                </button>
                <div style="text-align: center; margin-top: 1rem; font-size: 0.85rem; color: var(--text-muted);">
                    Al completar la compra aceptas nuestros términos y condiciones.
                </div>
            </div>
        </div>
      </div>
    </form>

    <!-- Modal de pago simulado -->
    <div id="modal-pago" class="modal" style="display:none;align-items:center;justify-content:center">
      <div class="modal-contenido" style="max-width:420px;padding:24px;position:relative">
        <button class="modal-cerrar" id="modal-pago-cerrar">×</button>
        <h3 style="margin-bottom: 1.5rem;">Pago con Tarjeta</h3>
        <form id="form-pago">
          <div class="input-animated"><label>Número de tarjeta</label><input name="num" placeholder="0000 0000 0000 0000" required></div>
          <div style="display:flex;gap:12px">
            <div class="input-animated" style="flex:1"><label>Vencimiento</label><input name="exp" placeholder="MM/AA" required></div>
            <div class="input-animated" style="width:120px"><label>CVC</label><input name="cvv" placeholder="123" required></div>
          </div>
          <div style="display:flex;gap:12px;justify-content:flex-end;margin-top:20px">
            <button type="button" class="btn btn-ghost" id="modal-pago-cancel">Cancelar</button>
            <button type="submit" class="btn principal" id="modal-pago-submit">Pagar $<?=number_format($total, 2)?></button>
          </div>
        </form>
        <div id="checkout-resultado" style="margin-top:16px"></div>
      </div>
    </div>
    <?php endif; ?>
  </main>

  <?php include '../includes/footer.php'; ?>

  <script>
    // Lógica de selección de entrega
    const options = document.querySelectorAll('.delivery-option');
    const inputEntrega = document.getElementById('tipo_entrega');
    const dirSection = document.getElementById('direccion-section');
    const addressFields = document.querySelectorAll('.address-field');

    options.forEach(opt => {
        opt.addEventListener('click', () => {
            options.forEach(o => o.classList.remove('active'));
            opt.classList.add('active');
            const val = opt.dataset.value;
            inputEntrega.value = val;
            
            if(val === 'domicilio') {
                dirSection.style.display = 'block';
                addressFields.forEach(f => f.required = true);
            } else {
                dirSection.style.display = 'none';
                addressFields.forEach(f => f.required = false);
            }
        });
    });

    // Lógica de Checkout
    let datosEnvio = {};
    const modal = document.getElementById('modal-pago');

    document.getElementById('form-checkout')?.addEventListener('submit', function(e){
      e.preventDefault();
      console.log('Procesando checkout...');
      datosEnvio = Object.fromEntries(new FormData(this).entries());
      
      // Mostrar modal
      modal.style.display = 'flex';
      // Forzar reflow para que la transición de opacidad funcione
      void modal.offsetWidth; 
      modal.classList.add('show');
    });

    function cerrarModal(){
        modal.classList.remove('show');
        setTimeout(() => {
            modal.style.display = 'none';
        }, 300); // Esperar a que termine la transición
    }

    document.getElementById('modal-pago-cerrar')?.addEventListener('click', cerrarModal);
    document.getElementById('modal-pago-cancel')?.addEventListener('click', cerrarModal);

    document.getElementById('form-pago')?.addEventListener('submit', async function(ev){
      ev.preventDefault();
      const submitBtn = document.getElementById('modal-pago-submit');
      const originalText = submitBtn.textContent;
      submitBtn.disabled = true;
      submitBtn.textContent = 'Procesando...';

      const fd = new FormData();
      fd.append('accion', 'crear_pedido');
      Object.entries(datosEnvio).forEach(([k,v]) => fd.append(k,v));

      // Simular proceso
      await new Promise(r => setTimeout(r, 1500));

      const res = await fetch('../php/api_carrito.php', {method:'POST', body:fd}).then(r=>r.json()).catch(e=>({ok:false,error:e.message}));

      if(res.ok){
        window.location.href = 'pago_exitoso.php?folio=' + res.folio_pedido + (res.pdf ? '&pdf=' + encodeURIComponent(res.pdf) : '');
      }else{
        submitBtn.disabled = false;
        submitBtn.textContent = originalText;
        const out = document.getElementById('checkout-resultado');
        out.innerHTML = `<div style="color:var(--danger);margin-top:10px;text-align:center">Error: ${res.error || 'Desconocido'}</div>`;
      }
    });
  </script>
</body>
</html>
