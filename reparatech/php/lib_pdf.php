<?php
require_once 'fpdf.php';

class PDF extends FPDF {
    function Header() {
        // Logo
        if(file_exists('../img/logo.png')) {
            $this->Image('../img/logo.png', 10, 6, 30);
        }
        // Arial bold 15
        $this->SetFont('Arial', 'B', 15);
        // Movernos a la derecha
        $this->Cell(80);
        // Título
        $this->Cell(30, 10, 'REPARATECH', 0, 0, 'C');
        // Salto de línea
        $this->Ln(20);
    }

    function Footer() {
        // Posición: a 1,5 cm del final
        $this->SetY(-15);
        // Arial italic 8
        $this->SetFont('Arial', 'I', 8);
        // Número de página
        $this->Cell(0, 10, 'Pagina ' . $this->PageNo() . '/{nb}', 0, 0, 'C');
    }
}

function generar_comprobante($pdo, $id_reparacion) {
    // Recuperar datos
    $stmt = $pdo->prepare('SELECT r.*, u.nombre as cliente_nombre, u.telefono as cliente_telefono, e.modelo, m.nombre_marca, t.nombre_tipo, c.nombre_color 
                          FROM reparaciones r 
                          JOIN usuarios u ON r.id_cliente = u.id_usuario 
                          JOIN equipos e ON r.id_equipo = e.id_equipo
                          JOIN marcas m ON e.id_marca = m.id_marca
                          JOIN tipos_equipo t ON e.id_tipo = t.id_tipo
                          LEFT JOIN colores c ON r.id_color = c.id_color
                          WHERE r.id_reparacion = ?');
    $stmt->execute([$id_reparacion]);
    $r = $stmt->fetch(PDO::FETCH_ASSOC);
    
    if (!$r) return ['error' => 'Reparación no encontrada'];

    try {
        $pdf = new PDF();
        $pdf->AliasNbPages();
        $pdf->AddPage();
        $pdf->SetFont('Arial', '', 12);

        // Información del Negocio
        $pdf->SetFont('Arial', 'B', 12);
        $pdf->Cell(0, 10, 'Comprobante de Servicio', 0, 1, 'C');
        $pdf->Ln(5);

        // Datos Generales
        $pdf->SetFont('Arial', 'B', 10);
        $pdf->Cell(40, 7, 'Folio:', 0, 0);
        $pdf->SetFont('Arial', '', 10);
        $pdf->Cell(0, 7, $r['folio'], 0, 1);

        $pdf->SetFont('Arial', 'B', 10);
        $pdf->Cell(40, 7, 'Fecha:', 0, 0);
        $pdf->SetFont('Arial', '', 10);
        $pdf->Cell(0, 7, $r['fecha_registro'], 0, 1);

        $pdf->Ln(5);

        // Datos del Cliente
        $pdf->SetFillColor(230, 230, 230);
        $pdf->SetFont('Arial', 'B', 10);
        $pdf->Cell(0, 7, 'Datos del Cliente', 1, 1, 'L', true);
        
        $pdf->Cell(40, 7, 'Nombre:', 0, 0);
        $pdf->SetFont('Arial', '', 10);
        $pdf->Cell(0, 7, utf8_decode($r['cliente_nombre']), 0, 1);
        
        $pdf->SetFont('Arial', 'B', 10);
        $pdf->Cell(40, 7, 'Telefono:', 0, 0);
        $pdf->SetFont('Arial', '', 10);
        $pdf->Cell(0, 7, $r['cliente_telefono'], 0, 1);

        $pdf->Ln(5);

        // Datos del Equipo
        $pdf->SetFont('Arial', 'B', 10);
        $pdf->Cell(0, 7, 'Datos del Equipo', 1, 1, 'L', true);
        
        $pdf->Cell(40, 7, 'Tipo:', 0, 0);
        $pdf->SetFont('Arial', '', 10);
        $pdf->Cell(0, 7, utf8_decode($r['nombre_tipo']), 0, 1);

        $pdf->SetFont('Arial', 'B', 10);
        $pdf->Cell(40, 7, 'Marca/Modelo:', 0, 0);
        $pdf->SetFont('Arial', '', 10);
        $pdf->Cell(0, 7, utf8_decode($r['nombre_marca'] . ' ' . $r['modelo']), 0, 1);

        if ($r['nombre_color']) {
            $pdf->SetFont('Arial', 'B', 10);
            $pdf->Cell(40, 7, 'Color:', 0, 0);
            $pdf->SetFont('Arial', '', 10);
            $pdf->Cell(0, 7, utf8_decode($r['nombre_color']), 0, 1);
        }

        if ($r['imei_serie']) {
            $pdf->SetFont('Arial', 'B', 10);
            $pdf->Cell(40, 7, 'IMEI / Serie:', 0, 0);
            $pdf->SetFont('Arial', '', 10);
            $pdf->Cell(0, 7, utf8_decode($r['imei_serie']), 0, 1);
        }

        $pdf->Ln(5);

        // Detalles del Servicio
        $pdf->SetFont('Arial', 'B', 10);
        $pdf->Cell(0, 7, 'Detalles del Servicio', 1, 1, 'L', true);

        $pdf->Cell(40, 7, 'Motivo:', 0, 0);
        $pdf->SetFont('Arial', '', 10);
        $pdf->MultiCell(0, 7, utf8_decode($r['motivo']));

        $pdf->SetFont('Arial', 'B', 10);
        $pdf->Cell(40, 7, 'Falla Reportada:', 0, 0);
        $pdf->SetFont('Arial', '', 10);
        $pdf->MultiCell(0, 7, utf8_decode($r['falla']));

        $pdf->SetFont('Arial', 'B', 10);
        $pdf->Cell(40, 7, 'Observaciones:', 0, 0);
        $pdf->SetFont('Arial', '', 10);
        $pdf->MultiCell(0, 7, utf8_decode($r['observaciones']));

        $pdf->Ln(5);
        
        $pdf->SetFont('Arial', 'B', 12);
        $pdf->Cell(140, 10, 'Total Estimado:', 0, 0, 'R');
        $pdf->Cell(0, 10, '$' . number_format($r['precio'], 2), 0, 1, 'R');

        $pdf->Ln(20);

        // Firmas
        $pdf->SetFont('Arial', '', 10);
        $y = $pdf->GetY();
        $pdf->Line(20, $y, 80, $y);
        $pdf->Line(130, $y, 190, $y);
        
        $pdf->Cell(95, 5, 'Firma Cliente', 0, 0, 'C');
        $pdf->Cell(95, 5, 'Firma Reparatech', 0, 1, 'C');

        // Guardar
        if (!is_dir(__DIR__ . '/../pdf')) mkdir(__DIR__ . '/../pdf', 0777, true);
        $nombre_archivo = 'comprobante_' . $r['folio'] . '.pdf';
        $ruta = 'pdf/' . $nombre_archivo;
        $pdf->Output('F', __DIR__ . '/../' . $ruta);

        // Actualizar BD
        $stmt = $pdo->prepare('INSERT INTO comprobantes (id_reparacion, ruta_pdf_cliente, ruta_pdf_negocio) VALUES (?,?,?)');
        $stmt->execute([$id_reparacion, $ruta, $ruta]);

        return ['ok' => true, 'ruta' => $ruta];

    } catch (Exception $e) {
        return ['error' => $e->getMessage()];
    }
}
