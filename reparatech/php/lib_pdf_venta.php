<?php
require_once 'fpdf.php';

class PDF_Venta extends FPDF {
    function Header() {
        // Logo
        if(file_exists('../img/logo.png')) {
            $this->Image('../img/logo.png', 10, 6, 30);
        }
        $this->SetFont('Arial', 'B', 15);
        $this->Cell(80);
        $this->Cell(30, 10, 'REPARATECH', 0, 0, 'C');
        $this->Ln(20);
    }

    function Footer() {
        $this->SetY(-15);
        $this->SetFont('Arial', 'I', 8);
        $this->Cell(0, 10, 'Pagina ' . $this->PageNo() . '/{nb}', 0, 0, 'C');
    }
}

function generar_ticket_venta($pdo, $id_pedido) {
    // Obtener datos del pedido
    $stmt = $pdo->prepare('SELECT p.*, u.nombre as cliente_nombre, u.telefono as cliente_telefono, e.calle, e.colonia, e.municipio, e.estado, e.codigo_postal, e.telefono_contacto, e.nombres_contacto, e.apellidos_contacto, e.estatus as estatus_envio
                          FROM pedidos p
                          JOIN usuarios u ON p.id_cliente = u.id_usuario
                          LEFT JOIN envios e ON p.id_pedido = e.id_pedido
                          WHERE p.id_pedido = ?');
    $stmt->execute([$id_pedido]);
    $pedido = $stmt->fetch(PDO::FETCH_ASSOC);

    if (!$pedido) return ['error' => 'Pedido no encontrado'];

    // Obtener items
    $stmt = $pdo->prepare('SELECT dp.*, pr.nombre, pr.precio as precio_unitario 
                          FROM detalle_pedido dp 
                          JOIN productos pr ON dp.id_producto = pr.id_producto 
                          WHERE dp.id_pedido = ?');
    $stmt->execute([$id_pedido]);
    $items = $stmt->fetchAll(PDO::FETCH_ASSOC);

    try {
        $pdf = new PDF_Venta();
        $pdf->AliasNbPages();
        $pdf->AddPage();
        $pdf->SetFont('Arial', '', 12);

        // Título
        $pdf->SetFont('Arial', 'B', 14);
        $pdf->Cell(0, 10, 'Ticket de Venta', 0, 1, 'C');
        $pdf->Ln(5);

        // Datos Generales
        $pdf->SetFont('Arial', 'B', 10);
        $pdf->Cell(40, 7, 'Folio Venta:', 0, 0);
        $pdf->SetFont('Arial', '', 10);
        $pdf->Cell(0, 7, 'V-' . str_pad($pedido['id_pedido'], 6, '0', STR_PAD_LEFT), 0, 1);

        $pdf->SetFont('Arial', 'B', 10);
        $pdf->Cell(40, 7, 'Fecha:', 0, 0);
        $pdf->SetFont('Arial', '', 10);
        $pdf->Cell(0, 7, $pedido['fecha'], 0, 1);

        $pdf->Ln(5);

        // Datos Cliente / Envío
        $pdf->SetFillColor(240, 240, 240);
        $pdf->SetFont('Arial', 'B', 10);
        $pdf->Cell(0, 7, 'Informacion del Cliente y Envio', 1, 1, 'L', true);

        $pdf->Cell(40, 7, 'Cliente:', 0, 0);
        $pdf->SetFont('Arial', '', 10);
        $pdf->Cell(0, 7, mb_convert_encoding($pedido['cliente_nombre'], 'ISO-8859-1', 'UTF-8'), 0, 1);

        $pdf->SetFont('Arial', 'B', 10);
        $pdf->Cell(40, 7, 'Tipo Entrega:', 0, 0);
        $pdf->SetFont('Arial', '', 10);
        $pdf->Cell(0, 7, ucfirst($pedido['tipo_entrega']), 0, 1);

        if ($pedido['tipo_entrega'] === 'domicilio') {
            $pdf->SetFont('Arial', 'B', 10);
            $pdf->Cell(40, 7, 'Direccion:', 0, 0);
            $pdf->SetFont('Arial', '', 10);
            $direccion_completa = $pedido['calle'] . ', ' . $pedido['colonia'] . ', ' . $pedido['municipio'] . ', ' . $pedido['estado'] . ' CP: ' . $pedido['codigo_postal'];
            $pdf->MultiCell(0, 7, mb_convert_encoding($direccion_completa, 'ISO-8859-1', 'UTF-8'));
            
            $pdf->SetFont('Arial', 'B', 10);
            $pdf->Cell(40, 7, 'Contacto:', 0, 0);
            $pdf->SetFont('Arial', '', 10);
            $pdf->Cell(0, 7, mb_convert_encoding($pedido['nombres_contacto'] . ' ' . $pedido['apellidos_contacto'] . ' (' . $pedido['telefono_contacto'] . ')', 'ISO-8859-1', 'UTF-8'), 0, 1);
        }

        $pdf->Ln(5);

        // Items
        $pdf->SetFont('Arial', 'B', 10);
        $pdf->Cell(0, 7, 'Productos', 1, 1, 'L', true);
        
        // Cabecera tabla
        $pdf->Cell(100, 7, 'Producto', 1);
        $pdf->Cell(30, 7, 'Cant.', 1, 0, 'C');
        $pdf->Cell(30, 7, 'Precio', 1, 0, 'R');
        $pdf->Cell(30, 7, 'Subtotal', 1, 1, 'R');

        $pdf->SetFont('Arial', '', 10);
        foreach ($items as $item) {
            $pdf->Cell(100, 7, mb_convert_encoding(substr($item['nombre'], 0, 50), 'ISO-8859-1', 'UTF-8'), 1);
            $pdf->Cell(30, 7, $item['cantidad'], 1, 0, 'C');
            $pdf->Cell(30, 7, '$' . number_format($item['precio_unitario'], 2), 1, 0, 'R');
            $pdf->Cell(30, 7, '$' . number_format($item['subtotal'], 2), 1, 1, 'R');
        }

        $pdf->Ln(5);
        $pdf->SetFont('Arial', 'B', 12);
        $pdf->Cell(160, 10, 'Total:', 0, 0, 'R');
        $pdf->Cell(30, 10, '$' . number_format($pedido['total'], 2), 0, 1, 'R');

        $pdf->Ln(10);
        $pdf->SetFont('Arial', 'I', 10);
        $pdf->MultiCell(0, 5, mb_convert_encoding("Gracias por su compra.\nSi seleccionó envío a domicilio, recibirá actualizaciones por WhatsApp.\nEl envío se realizará mediante Estafeta.", 'ISO-8859-1', 'UTF-8'));

        // Guardar
        if (!is_dir(__DIR__ . '/../pdf/ventas')) mkdir(__DIR__ . '/../pdf/ventas', 0777, true);
        $nombre_archivo = 'ticket_venta_' . $id_pedido . '.pdf';
        $ruta = 'pdf/ventas/' . $nombre_archivo;
        $pdf->Output('F', __DIR__ . '/../' . $ruta);

        // Actualizar BD
        $stmt = $pdo->prepare('UPDATE pedidos SET ruta_pdf = ? WHERE id_pedido = ?');
        $stmt->execute([$ruta, $id_pedido]);

        return ['ok' => true, 'ruta' => $ruta];

    } catch (Exception $e) {
        return ['error' => $e->getMessage()];
    }
}
