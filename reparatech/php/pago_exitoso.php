<?php
session_start();
if(!isset($_GET['folio'])) {
    header('Location: ../index.php');
    exit;
}
$folio = htmlspecialchars($_GET['folio']);
$pdf = htmlspecialchars($_GET['pdf'] ?? '');
?>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width,initial-scale=1">
    <title>Pago Exitoso - Reparatech</title>
    <link rel="stylesheet" href="../css/style.css">
    <style>
        .success-container {
            max-width: 600px;
            margin: 80px auto;
            text-align: center;
            padding: 40px;
            background: var(--bg-card);
            border-radius: 20px;
            box-shadow: var(--shadow-lg);
            border: 1px solid var(--border-light);
        }
        .icon-success {
            font-size: 80px;
            color: #28a745;
            margin-bottom: 20px;
            animation: popIn 0.5s cubic-bezier(0.175, 0.885, 0.32, 1.275);
        }
        @keyframes popIn {
            0% { transform: scale(0); opacity: 0; }
            100% { transform: scale(1); opacity: 1; }
        }
        .btn-whatsapp {
            background: #25D366;
            color: white;
            border: none;
        }
        .btn-whatsapp:hover {
            background: #128C7E;
        }
    </style>
</head>
<body>
    <?php include '../includes/header.php'; ?>

    <main class="contenedor">
        <div class="success-container fade-in">
            <div class="icon-success">✅</div>
            <h1 style="margin-bottom: 10px;">¡Pago Completado!</h1>
            <p style="font-size: 1.2rem; color: var(--text-muted); margin-bottom: 30px;">
                Gracias por tu compra. Tu pedido ha sido procesado correctamente.
            </p>
            
            <div style="background: var(--bg-body); padding: 20px; border-radius: 12px; margin-bottom: 30px;">
                <p style="margin-bottom: 5px; font-weight: 600;">Folio de Venta:</p>
                <div style="font-size: 1.5rem; font-weight: 700; color: var(--primary);">V-<?= str_pad($folio, 6, '0', STR_PAD_LEFT) ?></div>
            </div>

            <div style="display: grid; gap: 15px;">
                <?php if($pdf): ?>
                    <a href="../<?= $pdf ?>" target="_blank" class="btn principal" style="display: flex; align-items: center; justify-content: center; gap: 10px;">
                        📄 Descargar Ticket de Compra
                    </a>
                <?php endif; ?>
                
                <div style="margin-top: 20px; border-top: 1px solid var(--border-light); padding-top: 20px;">
                    <p style="margin-bottom: 15px; font-size: 0.95rem;">
                        Te enviaremos la información de rastreo de <strong>Estafeta</strong> a tu WhatsApp.
                    </p>
                    <a href="https://wa.me/527448171159?text=Hola,%20acabo%20de%20hacer%20el%20pedido%20V-<?= $folio ?>%20en%20Reparatech" target="_blank" class="btn btn-whatsapp" style="display: flex; align-items: center; justify-content: center; gap: 10px;">
                        📱 Contactar por WhatsApp
                    </a>
                </div>
                
                <a href="../index.php" class="btn btn-ghost" style="margin-top: 10px;">Volver a la tienda</a>
            </div>
        </div>
    </main>

    <script>
        // Auto-descarga del PDF si existe
        document.addEventListener('DOMContentLoaded', function() {
            const pdfUrl = "<?= $pdf ? '../'.$pdf : '' ?>";
            if(pdfUrl) {
                // Crear enlace temporal y clicarlo
                const link = document.createElement('a');
                link.href = pdfUrl;
                link.download = "Ticket_Venta_<?= $folio ?>.pdf";
                document.body.appendChild(link);
                link.click();
                document.body.removeChild(link);
            }
        });
    </script>

    <?php include '../includes/footer.php'; ?>
</body>
</html>
