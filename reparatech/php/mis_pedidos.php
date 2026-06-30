<?php
session_start();
if (!isset($_SESSION['usuario_id'])) {
    header('Location: ../index.php');
    exit;
}
require 'db.php';

$id_usuario = $_SESSION['usuario_id'];

// Obtener pedidos del usuario
$stmt = $pdo->prepare('
    SELECT p.*, count(dp.id_producto) as num_items 
    FROM pedidos p
    LEFT JOIN detalle_pedido dp ON p.id_pedido = dp.id_pedido
    WHERE p.id_cliente = ?
    GROUP BY p.id_pedido
    ORDER BY p.fecha DESC
');
$stmt->execute([$id_usuario]);
$pedidos = $stmt->fetchAll();
?>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Mis Pedidos - Reparatech</title>
    <link rel="stylesheet" href="../css/style.css">
    <style>
        .orders-container {
            max-width: 1000px;
            margin: 40px auto;
            padding: 20px;
        }
        .order-card {
            background: var(--bg-card);
            border: 1px solid var(--border-light);
            border-radius: 12px;
            padding: 20px;
            margin-bottom: 20px;
            display: flex;
            flex-wrap: wrap;
            gap: 20px;
            justify-content: space-between;
            align-items: center;
            transition: transform 0.2s;
        }
        .order-card:hover {
            transform: translateY(-2px);
            box-shadow: var(--shadow-md);
        }
        .order-info {
            flex: 1;
        }
        .order-header {
            display: flex;
            gap: 15px;
            margin-bottom: 10px;
            color: var(--text-muted);
            font-size: 0.9rem;
        }
        .order-folio {
            font-weight: 700;
            color: var(--primary);
            font-size: 1.1rem;
        }
        .order-total {
            font-weight: 700;
            font-size: 1.2rem;
        }
        .status-badge {
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 0.85rem;
            font-weight: 600;
            background: var(--bg-body);
        }
        .status-pagado { background: #d4edda; color: #155724; }
        .status-pendiente { background: #fff3cd; color: #856404; }
        .status-enviado { background: #cce5ff; color: #004085; }
        .status-cancelado { background: #f8d7da; color: #721c24; }
        
        .btn-download {
            background: var(--bg-body);
            border: 1px solid var(--border-light);
            color: var(--text-main);
            padding: 8px 16px;
            border-radius: 8px;
            display: flex;
            align-items: center;
            gap: 8px;
            font-size: 0.9rem;
            transition: all 0.2s;
        }
        .btn-download:hover {
            background: var(--primary);
            color: white;
            border-color: var(--primary);
            text-decoration: none;
        }
    </style>
</head>
<body>
    <?php include '../includes/header.php'; ?>

    <main class="orders-container">
        <h1 style="margin-bottom: 30px;">Mis Pedidos</h1>

        <?php if (empty($pedidos)): ?>
            <div style="text-align: center; padding: 60px; background: var(--bg-card); border-radius: 20px;">
                <div style="font-size: 40px; margin-bottom: 20px;">🛍️</div>
                <h3>No has realizado pedidos aún</h3>
                <p style="color: var(--text-muted); margin-bottom: 20px;">Descubre nuestros increíbles productos.</p>
                <a href="../index.php" class="btn principal">Ir a la Tienda</a>
            </div>
        <?php else: ?>
            <?php foreach ($pedidos as $p): ?>
                <?php 
                    $estatusClass = 'status-' . strtolower($p['estatus']);
                    $folio = 'V-' . str_pad($p['id_pedido'], 6, '0', STR_PAD_LEFT);
                ?>
                <div class="order-card">
                    <div class="order-info">
                        <div class="order-header">
                            <span>📅 <?= date('d/m/Y h:i A', strtotime($p['fecha'])) ?></span>
                            <span>📦 <?= $p['num_items'] ?> producto(s)</span>
                            <span>🚚 <?= ucfirst($p['tipo_entrega'] ?? 'Tienda') ?></span>
                        </div>
                        <div style="display: flex; align-items: center; gap: 15px;">
                            <span class="order-folio"><?= $folio ?></span>
                            <span class="status-badge <?= $estatusClass ?>"><?= ucfirst($p['estatus']) ?></span>
                        </div>
                    </div>
                    
                    <div style="text-align: right;">
                        <div class="order-total" style="margin-bottom: 10px;">$<?= number_format($p['total'], 2) ?></div>
                        
                        <?php if (!empty($p['ruta_pdf']) && file_exists('../' . $p['ruta_pdf'])): ?>
                            <a href="../<?= $p['ruta_pdf'] ?>" target="_blank" download class="btn-download">
                                📄 Descargar Ticket
                            </a>
                        <?php else: ?>
                            <span style="font-size: 0.85rem; color: var(--text-muted);">Procesando ticket...</span>
                        <?php endif; ?>
                    </div>
                </div>
            <?php endforeach; ?>
        <?php endif; ?>
    </main>

    <?php include '../includes/footer.php'; ?>
</body>
</html>
