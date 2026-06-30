-- ============================================================
--  REPARATECH - DATA MART
--  Archivo: dm_productos.sql
--  Descripción: Inserción de 50 artículos a la venta
--  Nota: La imagen la pone el usuario (campo: imagen)
--        El stock es aleatorio entre 3 y 12
-- ============================================================

USE reparatech;

-- Asegurar marcas necesarias
INSERT IGNORE INTO marcas (nombre_marca) VALUES
('Apple'), ('Samsung'), ('Xiaomi'), ('Huawei'), ('Motorola'),
('Oppo'), ('Sony'), ('LG'), ('Google'), ('OnePlus'),
('Dell'), ('HP'), ('Lenovo'), ('Asus'), ('Anker'),
('Belkin'), ('JBL'), ('Logitech'), ('Generic'), ('Spigen');

-- ============================================================
-- CATEGORÍA: Smartphones
-- ============================================================
INSERT INTO productos (nombre, descripcion, categoria, precio, stock, imagen) VALUES
('iPhone 15 Pro Max 256GB',
 'Pantalla Super Retina XDR 6.7", chip A17 Pro, cámara 48MP, titanio, 5G',
 'Smartphone', 27999.00, 7, NULL),

('iPhone 14 128GB',
 'Pantalla OLED 6.1", chip A15 Bionic, cámara 12MP, modo acción, 5G',
 'Smartphone', 19499.00, 5, NULL),

('Samsung Galaxy S24 Ultra 256GB',
 'Pantalla Dynamic AMOLED 6.8", S-Pen integrado, cámara 200MP, IA integrada',
 'Smartphone', 29999.00, 4, NULL),

('Samsung Galaxy A55 128GB',
 'Pantalla Super AMOLED 6.6", 50MP, batería 5000mAh, 5G, IP67',
 'Smartphone', 9999.00, 9, NULL),

('Xiaomi 14 Pro 256GB',
 'Pantalla AMOLED 6.73", Snapdragon 8 Gen 3, cámara Leica 50MP, carga 120W',
 'Smartphone', 18499.00, 6, NULL),

('Xiaomi Redmi Note 13 Pro 128GB',
 'Pantalla AMOLED 6.67" 120Hz, 200MP, carga rápida 67W, 5G',
 'Smartphone', 7499.00, 11, NULL),

('Motorola Edge 50 Pro 256GB',
 'Pantalla pOLED 144Hz, 50MP ultra-gran angular, carga 125W, 5G',
 'Smartphone', 11499.00, 8, NULL),

('Google Pixel 8 Pro 128GB',
 'Pantalla OLED 6.7", chip Tensor G3, cámara 50MP con IA avanzada, 5G',
 'Smartphone', 20999.00, 5, NULL),

('OnePlus 12 256GB',
 'Pantalla AMOLED 120Hz, Snapdragon 8 Gen 3, cámara Hasselblad 50MP, carga 100W',
 'Smartphone', 17499.00, 7, NULL),

('Huawei Nova 12 SE 256GB',
 'Pantalla AMOLED 6.67" 90Hz, cámara frontal 60MP, carga 66W',
 'Smartphone', 8999.00, 10, NULL),

-- ============================================================
-- CATEGORÍA: Tablets
-- ============================================================
('iPad Pro 12.9" M2 256GB Wi-Fi',
 'Chip M2, pantalla Liquid Retina XDR, compatible Apple Pencil 2, USB-C Thunderbolt',
 'Tablet', 32999.00, 3, NULL),

('iPad Air 10.9" 64GB',
 'Chip M1, pantalla Liquid Retina 10.9", Touch ID, USB-C, compatible con Pencil 2',
 'Tablet', 15999.00, 6, NULL),

('Samsung Galaxy Tab S9 FE 256GB',
 'Pantalla TFT 10.9" 90Hz, Exynos 1380, S-Pen incluido, IP68, batería 10090mAh',
 'Tablet', 11999.00, 8, NULL),

('Xiaomi Pad 6 Pro 256GB',
 'Pantalla WQHD+ 144Hz, Snapdragon 8+ Gen 1, 8600mAh, carga 67W, 4 altavoces',
 'Tablet', 10499.00, 5, NULL),

-- ============================================================
-- CATEGORÍA: Laptops
-- ============================================================
('MacBook Air 13" M2 8GB/256GB',
 'Chip Apple M2, pantalla Liquid Retina 13.6", batería 18h, diseño fanless, MagSafe',
 'Laptop', 28999.00, 4, NULL),

('MacBook Pro 14" M3 Pro 18GB/512GB',
 'Chip M3 Pro, pantalla Liquid Retina XDR 14.2", ProRes, MiniLED, batería 22h',
 'Laptop', 49999.00, 3, NULL),

('Dell XPS 13 Core i7 16GB/512GB',
 'Intel Core i7-1360P, pantalla FHD+ 500nits, 16GB LPDDR5, SSD 512GB, Windows 11',
 'Laptop', 24999.00, 5, NULL),

('HP Pavilion 15 Core i5 8GB/512GB',
 'Intel Core i5-1235U, pantalla FHD IPS 15.6", 8GB RAM, SSD NVMe, Windows 11 Home',
 'Laptop', 13999.00, 7, NULL),

('Lenovo ThinkPad X1 Carbon i7 16GB',
 'Intel Core i7-1365U, pantalla WUXGA IPS 14", 16GB LPDDR5, SSD 1TB, certificación militar',
 'Laptop', 35999.00, 3, NULL),

('Asus ZenBook 14 OLED Ryzen 7 16GB',
 'Ryzen 7 7745HX, pantalla OLED 2.8K 90Hz, 16GB DDR5, SSD 512GB, NumberPad integrado',
 'Laptop', 19499.00, 6, NULL),

-- ============================================================
-- CATEGORÍA: Accesorios (Baterías / Cargadores)
-- ============================================================
('Batería iPhone 14/15 Premium 3279mAh',
 'Capacidad original 3279mAh, ciclos mínimos, incluye adhesivo y herramientas',
 'Batería', 399.00, 12, NULL),

('Batería Samsung Galaxy S23 3900mAh',
 'Batería OEM compatible, alta durabilidad, sin efecto memoria',
 'Batería', 349.00, 12, NULL),

('Batería Xiaomi Redmi Note 11 5000mAh',
 'Capacidad 5000mAh OEM, incluye instrucciones de instalación',
 'Batería', 299.00, 10, NULL),

('Cargador USB-C 65W GaN Anker',
 'Carga rápida PD 3.0, compatible con laptops, teléfonos y tablets, compacto',
 'Cargador', 649.00, 9, NULL),

('Cargador MagSafe 15W iPhone Original',
 'Carga inalámbrica 15W exclusiva MagSafe, compatible iPhone 12 en adelante',
 'Cargador', 899.00, 8, NULL),

('Cargador Inalámbrico 15W Qi2',
 'Estándar Qi2, 15W máximo, compatible iPhone y Android, base antideslizante',
 'Cargador', 549.00, 11, NULL),

-- ============================================================
-- CATEGORÍA: Pantallas / Displays
-- ============================================================
('Pantalla iPhone 13 OLED Premium',
 'Display OLED original con digitalizador, True Tone, 1170x2532px, garantía 6 meses',
 'Pantalla', 1899.00, 7, NULL),

('Pantalla iPhone 12 OLED',
 'Pantalla OLED con ensamble completo, colores calibrados de fábrica',
 'Pantalla', 1599.00, 8, NULL),

('Pantalla Samsung Galaxy S21 Dynamic AMOLED',
 'Super AMOLED 120Hz, 2400x1080px, incluye marco y digitalizador',
 'Pantalla', 2199.00, 5, NULL),

('Pantalla Samsung Galaxy A52 AMOLED',
 'Super AMOLED 90Hz, 2400x1080px, con marco integrado',
 'Pantalla', 1299.00, 9, NULL),

('Pantalla Xiaomi Redmi Note 12 AMOLED',
 'AMOLED 120Hz FHD+ con digitalizador, instalación plug & play',
 'Pantalla', 999.00, 10, NULL),

-- ============================================================
-- CATEGORÍA: Audífonos / Audio
-- ============================================================
('AirPods Pro 2da Generación',
 'Cancelación activa de ruido, audio espacial, chip H2, hasta 30h con estuche',
 'Audífonos', 5499.00, 6, NULL),

('Samsung Galaxy Buds2 Pro',
 'ANC 2.0, audio 360° con Dolby, graves mejorados, resistentes al agua IPX7',
 'Audífonos', 3499.00, 7, NULL),

('JBL Tune 770NC Inalámbricos',
 'Cancelación de ruido adaptativa, 70h batería, Pure Bass, plegables, Bluetooth 5.3',
 'Audífonos', 1999.00, 9, NULL),

('Sony WH-1000XM5 Over-Ear',
 'ANC líder en industria, LDAC Hi-Res, 30h batería, micrófonos duales',
 'Audífonos', 7499.00, 4, NULL),

-- ============================================================
-- CATEGORÍA: Fundas / Protección
-- ============================================================
('Funda MagSafe iPhone 15 Pro Spigen',
 'Compatibilidad MagSafe total, MagFit, esquinas reforzadas, policarbonato',
 'Funda', 349.00, 12, NULL),

('Funda Samsung Galaxy S24 Ultra Armor',
 'Protección militar MIL-STD-810G, agarre antideslizante, levantamiento de cámara',
 'Funda', 299.00, 11, NULL),

('Funda Folio iPhone 14 Cuero Genuino',
 'Cuero genuino, soporte de pago sin contacto, cierre magnético, ranuras tarjetas',
 'Funda', 599.00, 8, NULL),

('Funda Transparente Xiaomi Redmi Note 12',
 'TPU ultra claro 1.5mm, anti-amarillamiento, esquinas reforzadas',
 'Funda', 99.00, 12, NULL),

-- ============================================================
-- CATEGORÍA: Vidrios Templados
-- ============================================================
('Vidrio Templado iPhone 15 / 15 Pro 2-Pack',
 '9H dureza, oleofóbico, compatible con Face ID, instalación sin burbujas',
 'Vidrio Templado', 149.00, 12, NULL),

('Vidrio Templado Samsung Galaxy S23 Ultra',
 '9H, borde a borde, compatible con lector de huella bajo pantalla',
 'Vidrio Templado', 169.00, 11, NULL),

('Vidrio Templado Xiaomi Redmi Note 13 Pro',
 '9H anti-arañazos, 2.5D, transparencia 99%, pack de 2 unidades',
 'Vidrio Templado', 99.00, 12, NULL),

-- ============================================================
-- CATEGORÍA: Cables y Conectividad
-- ============================================================
('Cable USB-C a USB-C 2m 100W Anker',
 'Carga y datos 100W, carga rápida USB Power Delivery, nylon trenzado',
 'Cable', 249.00, 12, NULL),

('Cable Lightning MFi 1m Belkin',
 'Certificado MFi Apple, carga rápida 18W, 10000 ciclos de doblez, nylon',
 'Cable', 299.00, 10, NULL),

('Cable USB-C a Lightning 1m Apple Original',
 'Carga rápida 20W, datos USB 2.0, certificado Apple, cable trenzado',
 'Cable', 499.00, 9, NULL),

-- ============================================================
-- CATEGORÍA: Smartwatches
-- ============================================================
('Apple Watch Series 9 41mm GPS',
 'Chip S9, pantalla Always-On Retina, ECG, detección de accidentes, WatchOS 10',
 'Smartwatch', 11999.00, 5, NULL),

('Samsung Galaxy Watch 6 44mm',
 'Pantalla Super AMOLED 1.5", Exynos W930, ECG, análisis sueño, 5ATM, Wear OS',
 'Smartwatch', 7499.00, 6, NULL),

('Xiaomi Smart Band 8 Pro',
 'Pantalla AMOLED 1.74" siempre activa, GPS, SpO2, 150+ deportes, 14 días batería',
 'Smartwatch', 1499.00, 11, NULL),

-- ============================================================
-- CATEGORÍA: Herramientas / Servicio Técnico
-- ============================================================
('Kit Destornilladores Precisión 38 en 1',
 'Aluminio + acero S2, puntas magnéticas, torx, pentalobe, cross, ideal reparaciones',
 'Herramienta', 349.00, 8, NULL),

('Pistola de Calor Digital 110V Profesional',
 'Temperatura ajustable 100-480°C, pantalla LCD, 2 velocidades, para separar pantallas',
 'Herramienta', 799.00, 5, NULL),

('Pasta Térmica Kyronaut 1g',
 'Conductividad 12.5 W/mK, ideal para CPUs de laptops, muy baja viscosidad',
 'Herramienta', 199.00, 12, NULL);

-- ============================================================
-- VERIFICACIÓN
-- ============================================================
SELECT COUNT(*) AS total_productos FROM productos;
SELECT categoria, COUNT(*) AS cantidad, MIN(stock) AS stock_min, MAX(stock) AS stock_max
FROM productos
GROUP BY categoria
ORDER BY categoria;
