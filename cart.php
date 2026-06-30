<?php
// Página de carrito - carga desde sesión PHP
session_start();
require 'php/db.php';

// Inicializar carrito en sesión si no existe
if(!isset($_SESSION['carrito'])) $_SESSION['carrito'] = [];

// Cargar detalles de cada producto en el carrito
$items = [];
$subtotal = 0;
foreach($_SESSION['carrito'] as $item){
  $stmt = $pdo->prepare('SELECT * FROM productos WHERE id_producto = ?');
  $stmt->execute([$item['id']]);
  $prod = $stmt->fetch();
  if($prod){
    $precio = floatval($prod['precio'] ?? 0);
    $linesubtotal = $precio * $item['cantidad'];
    $subtotal += $linesubtotal;
    $items[] = ['producto' => $prod, 'cantidad' => $item['cantidad'], 'precio' => $precio, 'linesubtotal' => $linesubtotal];
  }
}

$iva = $subtotal * 0.16;
$total = $subtotal + $iva;
?>
<!doctype html>
<html lang="es">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width,initial-scale=1">
  <title>Tu Carrito - Reparatech</title>
  <link rel="stylesheet" href="css/style.css">
  <style>
    .cart-header {
        margin-bottom: 2rem;
        border-bottom: 1px solid var(--border-light);
        padding-bottom: 1rem;
    }
    .cart-empty {
        text-align: center;
        padding: 4rem 2rem;
        background: var(--bg-card);
        border-radius: 20px;
        border: 1px solid var(--border-light);
    }
    .cart-grid {
        display: grid;
        grid-template-columns: 1fr 350px;
        gap: 2rem;
    }
    @media (max-width: 900px) {
        .cart-grid { grid-template-columns: 1fr; }
    }
    .cart-item {
        display: flex;
        gap: 1.5rem;
        padding: 1.5rem;
        background: var(--bg-card);
        border-radius: 16px;
        margin-bottom: 1rem;
        border: 1px solid var(--border-light);
        transition: transform 0.2s ease;
    }
    .cart-item:hover {
        transform: translateY(-2px);
        box-shadow: var(--shadow-md);
    }
    .cart-img {
        width: 100px;
        height: 100px;
        object-fit: cover;
        border-radius: 12px;
    }
    .cart-details {
        flex: 1;
        display: flex;
        flex-direction: column;
        justify-content: space-between;
    }
    .cart-controls {
        display: flex;
        align-items: center;
        gap: 1rem;
        margin-top: 0.5rem;
    }
    .qty-btn {
        width: 32px;
        height: 32px;
        border-radius: 8px;
        border: 1px solid var(--border-light);
        background: var(--bg-body);
        cursor: pointer;
        display: flex;
        align-items: center;
        justify-content: center;
        transition: all 0.2s;
    }
    .qty-btn:hover {
        background: var(--primary);
        color: white;
        border-color: var(--primary);
    }
    .summary-card {
        background: var(--bg-card);
        padding: 2rem;
        border-radius: 20px;
        border: 1px solid var(--border-light);
        position: sticky;
        top: 100px;
        box-shadow: var(--shadow-lg);
    }
    .summary-row {
        display: flex;
        justify-content: space-between;
        margin-bottom: 1rem;
        color: var(--text-muted);
    }
    .summary-total {
        display: flex;
        justify-content: space-between;
        margin-top: 1.5rem;
        padding-top: 1.5rem;
        border-top: 1px solid var(--border-light);
        font-size: 1.5rem;
        font-weight: 700;
        color: var(--text-main);
    }
  </style>
</head>
<body>
  <?php include 'includes/header.php'; ?>

  <main class="contenedor" style="padding-top: 2rem; padding-bottom: 4rem;">
    <div class="cart-header">
        <h1>Tu Carrito de Compras</h1>
        <p style="color: var(--text-muted);"><?= count($items) ?> productos agregados</p>
    </div>
    
    <?php if(empty($items)): ?>
      <div class="cart-empty fade-in">
        <div style="font-size: 4rem; margin-bottom: 1rem;">🛒</div>
        <h2>Tu carrito está vacío</h2>
        <p style="color: var(--text-muted); margin-bottom: 2rem;">Parece que aún no has agregado nada.</p>
        <a href="index.php" class="btn principal">Explorar Productos</a>
      </div>
    
    <?php else: ?>
      <div class="cart-grid fade-in">
        <section class="cart-items">
            <?php foreach($items as $item): 
              $prod = $item['producto'];
            ?>
            <div class="cart-item" data-id="<?=$prod['id_producto']?>">
              <img src="<?=$prod['imagen'] ?? 'img/productos/placeholder.png'?>" alt="<?=htmlspecialchars($prod['nombre'])?>" class="cart-img">
              <div class="cart-details">
                <div>
                    <h3 style="margin-bottom: 0.5rem;"><?=htmlspecialchars($prod['nombre'])?></h3>
                    <div style="color: var(--primary); font-weight: 600;">$<?=number_format($item['precio'], 2, '.', '')?></div>
                </div>
                
                <div style="display: flex; justify-content: space-between; align-items: center;">
                    <div class="cart-controls">
                        <button class="qty-btn qty-decrease" data-id="<?=$prod['id_producto']?>">−</button>
                        <span class="qty-value" style="font-weight: 600; width: 20px; text-align: center;"><?=$item['cantidad']?></span>
                        <button class="qty-btn qty-increase" data-id="<?=$prod['id_producto']?>">+</button>
                    </div>
                    <div style="text-align: right;">
                        <div style="font-weight: 700; font-size: 1.1rem;">$<?=number_format($item['linesubtotal'], 2, '.', '')?></div>
                        <button class="btn btn-ghost btn-remove" data-id="<?=$prod['id_producto']?>" style="color: var(--danger); padding: 0; font-size: 0.9rem; margin-top: 5px;">Eliminar</button>
                    </div>
                </div>
              </div>
            </div>
            <?php endforeach; ?>
        </section>

        <aside>
            <div class="summary-card">
                <h3 style="margin-bottom: 1.5rem;">Resumen de Compra</h3>
                <div class="summary-row"><span>Subtotal</span><span>$<?=number_format($subtotal, 2, '.', '')?></span></div>
                <div class="summary-row"><span>IVA (16%)</span><span>$<?=number_format($iva, 2, '.', '')?></span></div>
                <div class="summary-total"><span>Total</span><span>$<?=number_format($total, 2, '.', '')?></span></div>
                
                <button id="btn-pagar-cart" class="btn principal" style="width: 100%; margin-top: 2rem; padding: 1rem; font-size: 1.1rem;">
                    Proceder al Pago ➔
                </button>
                
                <div style="display: flex; gap: 10px; margin-top: 1.5rem; justify-content: center; opacity: 0.6;">
                    <span>🔒 Pago Seguro</span>
                    <span>•</span>
                    <span>📦 Envío Garantizado</span>
                </div>
            </div>
        </aside>
      </div>

      <script>
        // Manejar cambios de cantidad
        document.querySelectorAll('.qty-increase').forEach(b => b.addEventListener('click', async function(){
          const id = Number(this.dataset.id);
          const row = this.closest('.cart-item');
          const qtyEl = row.querySelector('.qty-value');
          const newQty = parseInt(qtyEl.textContent) + 1;
          updateCart(id, newQty);
        }));

        document.querySelectorAll('.qty-decrease').forEach(b => b.addEventListener('click', async function(){
          const id = Number(this.dataset.id);
          const row = this.closest('.cart-item');
          const qtyEl = row.querySelector('.qty-value');
          const newQty = Math.max(1, parseInt(qtyEl.textContent) - 1);
          updateCart(id, newQty);
        }));

        async function updateCart(id, qty) {
            const formData = new FormData();
            formData.append('accion', 'actualizar');
            formData.append('id', id);
            formData.append('cantidad', qty);
            
            const res = await fetch('php/api_carrito.php', {method:'POST', body:formData}).then(r=>r.json());
            if(res.ok) location.reload();
            else alert(res.error || 'Error');
        }

        document.querySelectorAll('.btn-remove').forEach(b => b.addEventListener('click', async function(){
          if(!confirm('¿Eliminar producto?')) return;
          const id = Number(this.dataset.id);
          const formData = new FormData();
          formData.append('accion', 'eliminar');
          formData.append('id', id);
          
          const res = await fetch('php/api_carrito.php', {method:'POST', body:formData}).then(r=>r.json());
          if(res.ok) location.reload();
          else alert(res.error || 'Error');
        }));

        document.getElementById('btn-pagar-cart')?.addEventListener('click', () => {
          window.location.href = 'php/checkout.php';
        });
      </script>
    <?php endif; ?>
  </main>

  <?php include 'includes/footer.php'; ?>
</body>
</html>
