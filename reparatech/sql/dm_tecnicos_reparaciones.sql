-- ============================================================
-- REPARATECH - DATA MART: 15 TÉCNICOS + 100 REPARACIONES
-- Sin stored procedures - compatible con phpMyAdmin
-- Ejecutar DESPUÉS de dm_ventas.sql
-- ============================================================
USE reparatech;

-- ============================================================
-- PASO 0: Asegurar columnas opcionales en reparaciones
-- (por si no se ejecutaron los scripts de migración)
-- ============================================================
ALTER TABLE reparaciones ADD COLUMN IF NOT EXISTS id_color INT DEFAULT NULL;
ALTER TABLE reparaciones ADD COLUMN IF NOT EXISTS imei_serie VARCHAR(100) DEFAULT NULL;

-- ============================================================
-- PASO 1: 15 técnicos empleados
-- ============================================================
INSERT IGNORE INTO usuarios (nombre, telefono, contrasena_hash, tipo_usuario) VALUES
('Miguel Ángel Soto',   '5522000001','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','empleado'),
('Jorge Luis Vega',     '5522000002','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','empleado'),
('Alejandro Ruiz',      '5522000003','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','empleado'),
('Marco Antonio Núñez', '5522000004','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','empleado'),
('Daniel Espinoza',     '5522000005','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','empleado'),
('Óscar Fuentes',       '5522000006','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','empleado'),
('Karla Montes',        '5522000007','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','empleado'),
('Raúl Aguilar',        '5522000008','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','empleado'),
('Adriana Leal',        '5522000009','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','empleado'),
('Gerardo Medina',      '5522000010','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','empleado'),
('Sergio Blanco',       '5522000011','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','empleado'),
('Natalia Campos',      '5522000012','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','empleado'),
('Arturo Rangel',       '5522000013','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','empleado'),
('Ernesto Padilla',     '5522000014','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','empleado'),
('Verónica Ibarra',     '5522000015','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','empleado');

-- PASO 2: Registrar en tabla empleados
INSERT INTO empleados (id_empleado, puesto, fecha_ingreso)
SELECT u.id_usuario, 'Técnico de Reparación', DATE_SUB(CURDATE(), INTERVAL (u.id_usuario MOD 36) MONTH)
FROM usuarios u
WHERE u.telefono IN ('5522000001','5522000002','5522000003','5522000004','5522000005',
                     '5522000006','5522000007','5522000008','5522000009','5522000010',
                     '5522000011','5522000012','5522000013','5522000014','5522000015')
  AND NOT EXISTS (SELECT 1 FROM empleados e WHERE e.id_empleado = u.id_usuario);

-- ============================================================
-- PASO 3: Marcas, tipos y colores necesarios
-- ============================================================
INSERT IGNORE INTO marcas (nombre_marca) VALUES
('Apple'),('Samsung'),('Xiaomi'),('Huawei'),('Motorola'),
('Oppo'),('Sony'),('LG'),('Google'),('Dell'),('HP'),('Lenovo'),('Asus'),('Acer');

INSERT IGNORE INTO tipos_equipo (nombre_tipo) VALUES
('Smartphone'),('Tablet'),('Laptop'),('PC Escritorio'),('Smartwatch');

INSERT IGNORE INTO colores (nombre_color, hex_code) VALUES
('Negro','#000000'),('Blanco','#FFFFFF'),('Gris','#808080'),('Plata','#C0C0C0'),
('Dorado','#FFD700'),('Azul','#0000FF'),('Rojo','#FF0000'),('Verde','#008000'),
('Rosa','#FFC0CB'),('Morado','#800080');

-- ============================================================
-- PASO 4: Equipos (modelos para las reparaciones)
-- ============================================================
INSERT IGNORE INTO equipos (id_marca, id_tipo, modelo)
SELECT m.id_marca, t.id_tipo, eq.mo FROM (
  SELECT 'Apple'    m,'Smartphone' t,'iPhone 13'            mo UNION ALL
  SELECT 'Apple',    'Smartphone',  'iPhone 14 Pro'            UNION ALL
  SELECT 'Apple',    'Smartphone',  'iPhone 12 Mini'           UNION ALL
  SELECT 'Apple',    'Tablet',      'iPad Air 5ta Gen'         UNION ALL
  SELECT 'Apple',    'Laptop',      'MacBook Pro 13 M1'        UNION ALL
  SELECT 'Samsung',  'Smartphone',  'Galaxy S22'               UNION ALL
  SELECT 'Samsung',  'Smartphone',  'Galaxy A53'               UNION ALL
  SELECT 'Samsung',  'Smartphone',  'Galaxy S21 FE'            UNION ALL
  SELECT 'Samsung',  'Tablet',      'Galaxy Tab S8'            UNION ALL
  SELECT 'Xiaomi',   'Smartphone',  'Redmi Note 11'            UNION ALL
  SELECT 'Xiaomi',   'Smartphone',  'POCO X5 Pro'              UNION ALL
  SELECT 'Xiaomi',   'Laptop',      'Mi Notebook Pro 14'       UNION ALL
  SELECT 'Huawei',   'Smartphone',  'P30 Lite'                 UNION ALL
  SELECT 'Huawei',   'Smartphone',  'Y9 Prime'                 UNION ALL
  SELECT 'Motorola', 'Smartphone',  'Moto G84'                 UNION ALL
  SELECT 'Motorola', 'Smartphone',  'Edge 40'                  UNION ALL
  SELECT 'Oppo',     'Smartphone',  'A78'                      UNION ALL
  SELECT 'Sony',     'Smartphone',  'Xperia 5 IV'              UNION ALL
  SELECT 'LG',       'Smartphone',  'V60 ThinQ'                UNION ALL
  SELECT 'Google',   'Smartphone',  'Pixel 7a'                 UNION ALL
  SELECT 'Dell',     'Laptop',      'Inspiron 15 3000'         UNION ALL
  SELECT 'HP',       'Laptop',      'Victus 15'                UNION ALL
  SELECT 'Lenovo',   'Laptop',      'IdeaPad Slim 5i'          UNION ALL
  SELECT 'Asus',     'Laptop',      'VivoBook 15'              UNION ALL
  SELECT 'Acer',     'Laptop',      'Aspire 5'
) eq
JOIN marcas      m ON m.nombre_marca = eq.m
JOIN tipos_equipo t ON t.nombre_tipo = eq.t
WHERE NOT EXISTS (
  SELECT 1 FROM equipos e2
  JOIN marcas m2 ON m2.id_marca = e2.id_marca
  WHERE m2.nombre_marca = eq.m AND e2.modelo = eq.mo
);

-- ============================================================
-- PASO 5: Variables de IDs (técnicos, clientes, equipos, colores)
-- ============================================================
SET @t01=(SELECT id_usuario FROM usuarios WHERE telefono='5522000001' LIMIT 1);
SET @t02=(SELECT id_usuario FROM usuarios WHERE telefono='5522000002' LIMIT 1);
SET @t03=(SELECT id_usuario FROM usuarios WHERE telefono='5522000003' LIMIT 1);
SET @t04=(SELECT id_usuario FROM usuarios WHERE telefono='5522000004' LIMIT 1);
SET @t05=(SELECT id_usuario FROM usuarios WHERE telefono='5522000005' LIMIT 1);
SET @t06=(SELECT id_usuario FROM usuarios WHERE telefono='5522000006' LIMIT 1);
SET @t07=(SELECT id_usuario FROM usuarios WHERE telefono='5522000007' LIMIT 1);
SET @t08=(SELECT id_usuario FROM usuarios WHERE telefono='5522000008' LIMIT 1);
SET @t09=(SELECT id_usuario FROM usuarios WHERE telefono='5522000009' LIMIT 1);
SET @t10=(SELECT id_usuario FROM usuarios WHERE telefono='5522000010' LIMIT 1);
SET @t11=(SELECT id_usuario FROM usuarios WHERE telefono='5522000011' LIMIT 1);
SET @t12=(SELECT id_usuario FROM usuarios WHERE telefono='5522000012' LIMIT 1);
SET @t13=(SELECT id_usuario FROM usuarios WHERE telefono='5522000013' LIMIT 1);
SET @t14=(SELECT id_usuario FROM usuarios WHERE telefono='5522000014' LIMIT 1);
SET @t15=(SELECT id_usuario FROM usuarios WHERE telefono='5522000015' LIMIT 1);

SET @cl01=(SELECT id_usuario FROM usuarios WHERE telefono='5511000001' LIMIT 1);
SET @cl02=(SELECT id_usuario FROM usuarios WHERE telefono='5511000002' LIMIT 1);
SET @cl03=(SELECT id_usuario FROM usuarios WHERE telefono='5511000003' LIMIT 1);
SET @cl04=(SELECT id_usuario FROM usuarios WHERE telefono='5511000004' LIMIT 1);
SET @cl05=(SELECT id_usuario FROM usuarios WHERE telefono='5511000005' LIMIT 1);
SET @cl06=(SELECT id_usuario FROM usuarios WHERE telefono='5511000006' LIMIT 1);
SET @cl07=(SELECT id_usuario FROM usuarios WHERE telefono='5511000007' LIMIT 1);
SET @cl08=(SELECT id_usuario FROM usuarios WHERE telefono='5511000008' LIMIT 1);
SET @cl09=(SELECT id_usuario FROM usuarios WHERE telefono='5511000009' LIMIT 1);
SET @cl10=(SELECT id_usuario FROM usuarios WHERE telefono='5511000010' LIMIT 1);
SET @cl11=(SELECT id_usuario FROM usuarios WHERE telefono='5511000011' LIMIT 1);
SET @cl12=(SELECT id_usuario FROM usuarios WHERE telefono='5511000012' LIMIT 1);
SET @cl13=(SELECT id_usuario FROM usuarios WHERE telefono='5511000013' LIMIT 1);
SET @cl14=(SELECT id_usuario FROM usuarios WHERE telefono='5511000014' LIMIT 1);
SET @cl15=(SELECT id_usuario FROM usuarios WHERE telefono='5511000015' LIMIT 1);
SET @cl16=(SELECT id_usuario FROM usuarios WHERE telefono='5511000016' LIMIT 1);
SET @cl17=(SELECT id_usuario FROM usuarios WHERE telefono='5511000017' LIMIT 1);
SET @cl18=(SELECT id_usuario FROM usuarios WHERE telefono='5511000018' LIMIT 1);
SET @cl19=(SELECT id_usuario FROM usuarios WHERE telefono='5511000019' LIMIT 1);
SET @cl20=(SELECT id_usuario FROM usuarios WHERE telefono='5511000020' LIMIT 1);

-- IDs de equipos
SET @e01=(SELECT e.id_equipo FROM equipos e JOIN marcas m ON m.id_marca=e.id_marca WHERE m.nombre_marca='Apple'    AND e.modelo='iPhone 13'          LIMIT 1);
SET @e02=(SELECT e.id_equipo FROM equipos e JOIN marcas m ON m.id_marca=e.id_marca WHERE m.nombre_marca='Apple'    AND e.modelo='iPhone 14 Pro'       LIMIT 1);
SET @e03=(SELECT e.id_equipo FROM equipos e JOIN marcas m ON m.id_marca=e.id_marca WHERE m.nombre_marca='Apple'    AND e.modelo='iPhone 12 Mini'      LIMIT 1);
SET @e04=(SELECT e.id_equipo FROM equipos e JOIN marcas m ON m.id_marca=e.id_marca WHERE m.nombre_marca='Apple'    AND e.modelo='iPad Air 5ta Gen'    LIMIT 1);
SET @e05=(SELECT e.id_equipo FROM equipos e JOIN marcas m ON m.id_marca=e.id_marca WHERE m.nombre_marca='Apple'    AND e.modelo='MacBook Pro 13 M1'   LIMIT 1);
SET @e06=(SELECT e.id_equipo FROM equipos e JOIN marcas m ON m.id_marca=e.id_marca WHERE m.nombre_marca='Samsung'  AND e.modelo='Galaxy S22'          LIMIT 1);
SET @e07=(SELECT e.id_equipo FROM equipos e JOIN marcas m ON m.id_marca=e.id_marca WHERE m.nombre_marca='Samsung'  AND e.modelo='Galaxy A53'          LIMIT 1);
SET @e08=(SELECT e.id_equipo FROM equipos e JOIN marcas m ON m.id_marca=e.id_marca WHERE m.nombre_marca='Samsung'  AND e.modelo='Galaxy S21 FE'       LIMIT 1);
SET @e09=(SELECT e.id_equipo FROM equipos e JOIN marcas m ON m.id_marca=e.id_marca WHERE m.nombre_marca='Samsung'  AND e.modelo='Galaxy Tab S8'       LIMIT 1);
SET @e10=(SELECT e.id_equipo FROM equipos e JOIN marcas m ON m.id_marca=e.id_marca WHERE m.nombre_marca='Xiaomi'   AND e.modelo='Redmi Note 11'       LIMIT 1);
SET @e11=(SELECT e.id_equipo FROM equipos e JOIN marcas m ON m.id_marca=e.id_marca WHERE m.nombre_marca='Xiaomi'   AND e.modelo='POCO X5 Pro'         LIMIT 1);
SET @e12=(SELECT e.id_equipo FROM equipos e JOIN marcas m ON m.id_marca=e.id_marca WHERE m.nombre_marca='Xiaomi'   AND e.modelo='Mi Notebook Pro 14'  LIMIT 1);
SET @e13=(SELECT e.id_equipo FROM equipos e JOIN marcas m ON m.id_marca=e.id_marca WHERE m.nombre_marca='Huawei'   AND e.modelo='P30 Lite'            LIMIT 1);
SET @e14=(SELECT e.id_equipo FROM equipos e JOIN marcas m ON m.id_marca=e.id_marca WHERE m.nombre_marca='Huawei'   AND e.modelo='Y9 Prime'            LIMIT 1);
SET @e15=(SELECT e.id_equipo FROM equipos e JOIN marcas m ON m.id_marca=e.id_marca WHERE m.nombre_marca='Motorola' AND e.modelo='Moto G84'            LIMIT 1);
SET @e16=(SELECT e.id_equipo FROM equipos e JOIN marcas m ON m.id_marca=e.id_marca WHERE m.nombre_marca='Motorola' AND e.modelo='Edge 40'             LIMIT 1);
SET @e17=(SELECT e.id_equipo FROM equipos e JOIN marcas m ON m.id_marca=e.id_marca WHERE m.nombre_marca='Oppo'     AND e.modelo='A78'                 LIMIT 1);
SET @e18=(SELECT e.id_equipo FROM equipos e JOIN marcas m ON m.id_marca=e.id_marca WHERE m.nombre_marca='Sony'     AND e.modelo='Xperia 5 IV'         LIMIT 1);
SET @e19=(SELECT e.id_equipo FROM equipos e JOIN marcas m ON m.id_marca=e.id_marca WHERE m.nombre_marca='LG'       AND e.modelo='V60 ThinQ'           LIMIT 1);
SET @e20=(SELECT e.id_equipo FROM equipos e JOIN marcas m ON m.id_marca=e.id_marca WHERE m.nombre_marca='Google'   AND e.modelo='Pixel 7a'            LIMIT 1);
SET @e21=(SELECT e.id_equipo FROM equipos e JOIN marcas m ON m.id_marca=e.id_marca WHERE m.nombre_marca='Dell'     AND e.modelo='Inspiron 15 3000'    LIMIT 1);
SET @e22=(SELECT e.id_equipo FROM equipos e JOIN marcas m ON m.id_marca=e.id_marca WHERE m.nombre_marca='HP'       AND e.modelo='Victus 15'           LIMIT 1);
SET @e23=(SELECT e.id_equipo FROM equipos e JOIN marcas m ON m.id_marca=e.id_marca WHERE m.nombre_marca='Lenovo'   AND e.modelo='IdeaPad Slim 5i'     LIMIT 1);
SET @e24=(SELECT e.id_equipo FROM equipos e JOIN marcas m ON m.id_marca=e.id_marca WHERE m.nombre_marca='Asus'     AND e.modelo='VivoBook 15'         LIMIT 1);
SET @e25=(SELECT e.id_equipo FROM equipos e JOIN marcas m ON m.id_marca=e.id_marca WHERE m.nombre_marca='Acer'     AND e.modelo='Aspire 5'            LIMIT 1);

-- IDs de colores
SET @cn=(SELECT id_color FROM colores WHERE nombre_color='Negro'  LIMIT 1);
SET @cb=(SELECT id_color FROM colores WHERE nombre_color='Blanco' LIMIT 1);
SET @cg=(SELECT id_color FROM colores WHERE nombre_color='Gris'   LIMIT 1);
SET @cp=(SELECT id_color FROM colores WHERE nombre_color='Plata'  LIMIT 1);
SET @cd=(SELECT id_color FROM colores WHERE nombre_color='Dorado' LIMIT 1);
SET @ca=(SELECT id_color FROM colores WHERE nombre_color='Azul'   LIMIT 1);
SET @cr=(SELECT id_color FROM colores WHERE nombre_color='Rojo'   LIMIT 1);
SET @cv=(SELECT id_color FROM colores WHERE nombre_color='Verde'  LIMIT 1);
SET @crs=(SELECT id_color FROM colores WHERE nombre_color='Rosa'  LIMIT 1);
SET @cm=(SELECT id_color FROM colores WHERE nombre_color='Morado' LIMIT 1);

-- ============================================================
-- PASO 6: 100 REPARACIONES
-- Formato: INSERT INTO reparaciones(folio,id_cliente,id_equipo,id_empleado,id_color,imei_serie,motivo,falla,observaciones,precio,estatus,fecha_registro)
-- ============================================================

INSERT INTO reparaciones(folio,id_cliente,id_equipo,id_empleado,id_color,imei_serie,motivo,falla,observaciones,precio,estatus,fecha_registro)VALUES('REP-2026-00001',@cl01,@e01,@t01,@cn,'350123456789001','Cambio de pantalla','Pantalla con líneas y sin respuesta táctil','Equipo llega con rayones menores en la carcasa',1800.00,'Entregado','2026-05-02 10:30:00');
INSERT INTO reparaciones(folio,id_cliente,id_equipo,id_empleado,id_color,imei_serie,motivo,falla,observaciones,precio,estatus,fecha_registro)VALUES('REP-2026-00002',@cl02,@e02,@t02,@cb,'350123456789002','Cambio de batería','Batería se drena en menos de 2 horas','Sin evidencia de golpes externos, falla interna',650.00,'Entregado','2026-05-05 11:00:00');
INSERT INTO reparaciones(folio,id_cliente,id_equipo,id_empleado,id_color,imei_serie,motivo,falla,observaciones,precio,estatus,fecha_registro)VALUES('REP-2026-00003',@cl03,@e03,@t03,@cg,'350123456789003','Reparación de placa base','No enciende, posible falla en placa','Pantalla con manchas de líquido, posible daño por humedad',2500.00,'Entregado','2026-05-08 09:15:00');
INSERT INTO reparaciones(folio,id_cliente,id_equipo,id_empleado,id_color,imei_serie,motivo,falla,observaciones,precio,estatus,fecha_registro)VALUES('REP-2026-00004',@cl04,@e04,@t04,@cp,NULL,'Cambio de puerto de carga','Conector flojo, no carga con ningún cable','Estado físico bueno, solo falla funcional',450.00,'Entregado','2026-05-10 14:00:00');
INSERT INTO reparaciones(folio,id_cliente,id_equipo,id_empleado,id_color,imei_serie,motivo,falla,observaciones,precio,estatus,fecha_registro)VALUES('REP-2026-00005',@cl05,@e05,@t05,@cd,'350123456789005','Limpieza interna','Sobrecalentamiento excesivo y rendimiento lento','Dispositivo en buen estado general, sin daños visibles',350.00,'Concluido','2026-05-12 10:30:00');
INSERT INTO reparaciones(folio,id_cliente,id_equipo,id_empleado,id_color,imei_serie,motivo,falla,observaciones,precio,estatus,fecha_registro)VALUES('REP-2026-00006',@cl06,@e06,@t06,@ca,'350123456789006','Cambio de cámara trasera','Cámara toma fotos borrosas sin enfoque','Equipo llega con rayones menores en la carcasa',1200.00,'Concluido','2026-05-15 13:45:00');
INSERT INTO reparaciones(folio,id_cliente,id_equipo,id_empleado,id_color,imei_serie,motivo,falla,observaciones,precio,estatus,fecha_registro)VALUES('REP-2026-00007',@cl07,@e07,@t07,@cr,'350123456789007','Actualización de software','Sistema operativo corrupto, bucle de arranque','Sin evidencia de golpes externos, falla interna',300.00,'Concluido','2026-05-18 09:00:00');
INSERT INTO reparaciones(folio,id_cliente,id_equipo,id_empleado,id_color,imei_serie,motivo,falla,observaciones,precio,estatus,fecha_registro)VALUES('REP-2026-00008',@cl08,@e08,@t08,@cv,NULL,'Recuperación de datos','Almacenamiento dañado, datos inaccesibles','Pantalla con manchas de líquido, posible daño por humedad',800.00,'En reparación','2026-05-20 15:30:00');
INSERT INTO reparaciones(folio,id_cliente,id_equipo,id_empleado,id_color,imei_serie,motivo,falla,observaciones,precio,estatus,fecha_registro)VALUES('REP-2026-00009',@cl09,@e09,@t09,@crs,'350123456789009','Cambio de micrófono','No se escucha la voz al llamar','Estado físico bueno, solo falla funcional',550.00,'En reparación','2026-05-23 10:00:00');
INSERT INTO reparaciones(folio,id_cliente,id_equipo,id_empleado,id_color,imei_serie,motivo,falla,observaciones,precio,estatus,fecha_registro)VALUES('REP-2026-00010',@cl10,@e10,@t10,@cm,'350123456789010','Cambio de altavoz','Altavoz suena distorsionado a alto volumen','Dispositivo en buen estado general, sin daños visibles',500.00,'En reparación','2026-04-02 11:30:00');
INSERT INTO reparaciones(folio,id_cliente,id_equipo,id_empleado,id_color,imei_serie,motivo,falla,observaciones,precio,estatus,fecha_registro)VALUES('REP-2026-00011',@cl11,@e11,@t11,@cn,'350123456789011','Reparación de botones','Botón de encendido atascado sin respuesta','Equipo llega con rayones menores en la carcasa',400.00,'Entregado','2026-04-05 09:30:00');
INSERT INTO reparaciones(folio,id_cliente,id_equipo,id_empleado,id_color,imei_serie,motivo,falla,observaciones,precio,estatus,fecha_registro)VALUES('REP-2026-00012',@cl12,@e12,@t12,@cb,NULL,'Cambio de carcasa','Carcasa rota por impacto, bordes dañados','Sin evidencia de golpes externos, falla interna',750.00,'Entregado','2026-04-08 14:00:00');
INSERT INTO reparaciones(folio,id_cliente,id_equipo,id_empleado,id_color,imei_serie,motivo,falla,observaciones,precio,estatus,fecha_registro)VALUES('REP-2026-00013',@cl13,@e13,@t13,@cg,'350123456789013','Eliminación de virus','Aplicaciones con comportamiento malicioso','Pantalla con manchas de líquido, posible daño por humedad',250.00,'Entregado','2026-04-10 10:15:00');
INSERT INTO reparaciones(folio,id_cliente,id_equipo,id_empleado,id_color,imei_serie,motivo,falla,observaciones,precio,estatus,fecha_registro)VALUES('REP-2026-00014',@cl14,@e14,@t14,@cp,'350123456789014','Formateo y configuración','Sistema extremadamente lento con errores frecuentes','Estado físico bueno, solo falla funcional',200.00,'Entregado','2026-04-12 13:00:00');
INSERT INTO reparaciones(folio,id_cliente,id_equipo,id_empleado,id_color,imei_serie,motivo,falla,observaciones,precio,estatus,fecha_registro)VALUES('REP-2026-00015',@cl15,@e15,@t15,@cd,'350123456789015','Soldadura de componentes','Soldadura fría en conector de audio','Dispositivo en buen estado general, sin daños visibles',900.00,'Concluido','2026-04-15 09:45:00');
INSERT INTO reparaciones(folio,id_cliente,id_equipo,id_empleado,id_color,imei_serie,motivo,falla,observaciones,precio,estatus,fecha_registro)VALUES('REP-2026-00016',@cl16,@e16,@t01,@ca,NULL,'Cambio de pantalla','Pantalla rota con fragmentos visibles','Equipo llega con rayones menores en la carcasa',1800.00,'Concluido','2026-04-18 11:00:00');
INSERT INTO reparaciones(folio,id_cliente,id_equipo,id_empleado,id_color,imei_serie,motivo,falla,observaciones,precio,estatus,fecha_registro)VALUES('REP-2026-00017',@cl17,@e17,@t02,@cr,'350123456789017','Cambio de batería','Batería hinchada, no cierra bien el equipo','Sin evidencia de golpes externos, falla interna',650.00,'Concluido','2026-04-20 15:30:00');
INSERT INTO reparaciones(folio,id_cliente,id_equipo,id_empleado,id_color,imei_serie,motivo,falla,observaciones,precio,estatus,fecha_registro)VALUES('REP-2026-00018',@cl18,@e18,@t03,@cv,'350123456789018','Reparación de placa base','Daño por cortocircuito en placa principal','Pantalla con manchas de líquido, posible daño por humedad',2500.00,'En reparación','2026-04-25 09:00:00');
INSERT INTO reparaciones(folio,id_cliente,id_equipo,id_empleado,id_color,imei_serie,motivo,falla,observaciones,precio,estatus,fecha_registro)VALUES('REP-2026-00019',@cl19,@e19,@t04,@crs,'350123456789019','Cambio de puerto de carga','Puerto USB-C oxidado, no transmite datos','Estado físico bueno, solo falla funcional',450.00,'En reparación','2026-03-03 10:30:00');
INSERT INTO reparaciones(folio,id_cliente,id_equipo,id_empleado,id_color,imei_serie,motivo,falla,observaciones,precio,estatus,fecha_registro)VALUES('REP-2026-00020',@cl20,@e20,@t05,@cm,NULL,'Limpieza interna','Polvo acumulado causa sobrecalentamiento','Dispositivo en buen estado general, sin daños visibles',350.00,'En reparación','2026-03-06 14:00:00');
INSERT INTO reparaciones(folio,id_cliente,id_equipo,id_empleado,id_color,imei_serie,motivo,falla,observaciones,precio,estatus,fecha_registro)VALUES('REP-2026-00021',@cl01,@e21,@t06,@cn,'350123456789021','Cambio de cámara trasera','Lente de cámara fisurado por caída','Equipo llega con rayones menores en la carcasa',1200.00,'Entregado','2026-03-09 09:15:00');
INSERT INTO reparaciones(folio,id_cliente,id_equipo,id_empleado,id_color,imei_serie,motivo,falla,observaciones,precio,estatus,fecha_registro)VALUES('REP-2026-00022',@cl02,@e22,@t07,@cb,'350123456789022','Actualización de software','No inicia sesión, error de autenticación','Sin evidencia de golpes externos, falla interna',300.00,'Entregado','2026-03-12 11:00:00');
INSERT INTO reparaciones(folio,id_cliente,id_equipo,id_empleado,id_color,imei_serie,motivo,falla,observaciones,precio,estatus,fecha_registro)VALUES('REP-2026-00023',@cl03,@e23,@t08,@cg,'350123456789023','Recuperación de datos','SSD con sectores dañados, archivos perdidos','Pantalla con manchas de líquido, posible daño por humedad',800.00,'Entregado','2026-03-15 13:30:00');
INSERT INTO reparaciones(folio,id_cliente,id_equipo,id_empleado,id_color,imei_serie,motivo,falla,observaciones,precio,estatus,fecha_registro)VALUES('REP-2026-00024',@cl04,@e24,@t09,@cp,NULL,'Cambio de micrófono','Micrófono no registra audio en videollamadas','Estado físico bueno, solo falla funcional',550.00,'Entregado','2026-03-18 10:00:00');
INSERT INTO reparaciones(folio,id_cliente,id_equipo,id_empleado,id_color,imei_serie,motivo,falla,observaciones,precio,estatus,fecha_registro)VALUES('REP-2026-00025',@cl05,@e25,@t10,@cd,'350123456789025','Cambio de altavoz','Sin audio en altavoz externo','Dispositivo en buen estado general, sin daños visibles',500.00,'Concluido','2026-03-21 14:45:00');
INSERT INTO reparaciones(folio,id_cliente,id_equipo,id_empleado,id_color,imei_serie,motivo,falla,observaciones,precio,estatus,fecha_registro)VALUES('REP-2026-00026',@cl06,@e01,@t11,@ca,'350123456789026','Reparación de botones','Botones de volumen sin respuesta','Equipo llega con rayones menores en la carcasa',400.00,'Concluido','2026-03-24 09:30:00');
INSERT INTO reparaciones(folio,id_cliente,id_equipo,id_empleado,id_color,imei_serie,motivo,falla,observaciones,precio,estatus,fecha_registro)VALUES('REP-2026-00027',@cl07,@e02,@t12,@cr,'350123456789027','Cambio de carcasa','Tapa trasera rota por impacto fuerte','Sin evidencia de golpes externos, falla interna',750.00,'Concluido','2026-03-27 11:15:00');
INSERT INTO reparaciones(folio,id_cliente,id_equipo,id_empleado,id_color,imei_serie,motivo,falla,observaciones,precio,estatus,fecha_registro)VALUES('REP-2026-00028',@cl08,@e03,@t13,@cv,NULL,'Eliminación de virus','Ransomware bloqueó el acceso al sistema','Pantalla con manchas de líquido, posible daño por humedad',250.00,'En reparación','2026-02-02 10:00:00');
INSERT INTO reparaciones(folio,id_cliente,id_equipo,id_empleado,id_color,imei_serie,motivo,falla,observaciones,precio,estatus,fecha_registro)VALUES('REP-2026-00029',@cl09,@e04,@t14,@crs,'350123456789029','Formateo y configuración','Sistema no responde a ningún comando','Estado físico bueno, solo falla funcional',200.00,'En reparación','2026-02-05 14:30:00');
INSERT INTO reparaciones(folio,id_cliente,id_equipo,id_empleado,id_color,imei_serie,motivo,falla,observaciones,precio,estatus,fecha_registro)VALUES('REP-2026-00030',@cl10,@e05,@t15,@cm,'350123456789030','Soldadura de componentes','Conector de audio con soldadura fría','Dispositivo en buen estado general, sin daños visibles',900.00,'En reparación','2026-02-08 09:00:00');
INSERT INTO reparaciones(folio,id_cliente,id_equipo,id_empleado,id_color,imei_serie,motivo,falla,observaciones,precio,estatus,fecha_registro)VALUES('REP-2026-00031',@cl11,@e06,@t01,@cn,'350123456789031','Cambio de pantalla','Display con líneas verticales permanentes','Equipo llega con rayones menores en la carcasa',1800.00,'Entregado','2026-02-10 11:00:00');
INSERT INTO reparaciones(folio,id_cliente,id_equipo,id_empleado,id_color,imei_serie,motivo,falla,observaciones,precio,estatus,fecha_registro)VALUES('REP-2026-00032',@cl12,@e07,@t02,@cb,NULL,'Cambio de batería','Batería no retiene carga más de 30 minutos','Sin evidencia de golpes externos, falla interna',650.00,'Entregado','2026-02-13 13:15:00');
INSERT INTO reparaciones(folio,id_cliente,id_equipo,id_empleado,id_color,imei_serie,motivo,falla,observaciones,precio,estatus,fecha_registro)VALUES('REP-2026-00033',@cl13,@e08,@t03,@cg,'350123456789033','Reparación de placa base','Falla en circuito de alimentación','Pantalla con manchas de líquido, posible daño por humedad',2500.00,'Entregado','2026-02-16 10:30:00');
INSERT INTO reparaciones(folio,id_cliente,id_equipo,id_empleado,id_color,imei_serie,motivo,falla,observaciones,precio,estatus,fecha_registro)VALUES('REP-2026-00034',@cl14,@e09,@t04,@cp,'350123456789034','Cambio de puerto de carga','Puerto micro-USB doblado por mal uso','Estado físico bueno, solo falla funcional',450.00,'Entregado','2026-02-19 14:00:00');
INSERT INTO reparaciones(folio,id_cliente,id_equipo,id_empleado,id_color,imei_serie,motivo,falla,observaciones,precio,estatus,fecha_registro)VALUES('REP-2026-00035',@cl15,@e10,@t05,@cd,'350123456789035','Limpieza interna','Ventiladores bloqueados por pelusa','Dispositivo en buen estado general, sin daños visibles',350.00,'Concluido','2026-02-22 09:45:00');
INSERT INTO reparaciones(folio,id_cliente,id_equipo,id_empleado,id_color,imei_serie,motivo,falla,observaciones,precio,estatus,fecha_registro)VALUES('REP-2026-00036',@cl16,@e11,@t06,@ca,NULL,'Cambio de cámara trasera','Cámara principal no abre, error de hardware','Equipo llega con rayones menores en la carcasa',1200.00,'Concluido','2026-02-25 11:30:00');
INSERT INTO reparaciones(folio,id_cliente,id_equipo,id_empleado,id_color,imei_serie,motivo,falla,observaciones,precio,estatus,fecha_registro)VALUES('REP-2026-00037',@cl17,@e12,@t07,@cr,'350123456789037','Actualización de software','BIOS corrupta, no arranca el sistema','Sin evidencia de golpes externos, falla interna',300.00,'Concluido','2026-01-03 10:00:00');
INSERT INTO reparaciones(folio,id_cliente,id_equipo,id_empleado,id_color,imei_serie,motivo,falla,observaciones,precio,estatus,fecha_registro)VALUES('REP-2026-00038',@cl18,@e13,@t08,@cv,'350123456789038','Recuperación de datos','Memoria interna dañada por golpe','Pantalla con manchas de líquido, posible daño por humedad',800.00,'En reparación','2026-01-06 14:30:00');
INSERT INTO reparaciones(folio,id_cliente,id_equipo,id_empleado,id_color,imei_serie,motivo,falla,observaciones,precio,estatus,fecha_registro)VALUES('REP-2026-00039',@cl19,@e14,@t09,@crs,'350123456789039','Cambio de micrófono','Interferencia y ruido en llamadas','Estado físico bueno, solo falla funcional',550.00,'En reparación','2026-01-09 09:15:00');
INSERT INTO reparaciones(folio,id_cliente,id_equipo,id_empleado,id_color,imei_serie,motivo,falla,observaciones,precio,estatus,fecha_registro)VALUES('REP-2026-00040',@cl20,@e15,@t10,@cm,NULL,'Cambio de altavoz','Altavoz principal completamente silencioso','Dispositivo en buen estado general, sin daños visibles',500.00,'En reparación','2026-01-12 11:00:00');
INSERT INTO reparaciones(folio,id_cliente,id_equipo,id_empleado,id_color,imei_serie,motivo,falla,observaciones,precio,estatus,fecha_registro)VALUES('REP-2026-00041',@cl01,@e16,@t11,@cn,'350123456789041','Reparación de botones','Botón home físico no funciona','Equipo llega con rayones menores en la carcasa',400.00,'Entregado','2026-01-15 13:30:00');
INSERT INTO reparaciones(folio,id_cliente,id_equipo,id_empleado,id_color,imei_serie,motivo,falla,observaciones,precio,estatus,fecha_registro)VALUES('REP-2026-00042',@cl02,@e17,@t12,@cb,'350123456789042','Cambio de carcasa','Pantalla trasera de vidrio completamente rota','Sin evidencia de golpes externos, falla interna',750.00,'Entregado','2026-01-18 10:45:00');
INSERT INTO reparaciones(folio,id_cliente,id_equipo,id_empleado,id_color,imei_serie,motivo,falla,observaciones,precio,estatus,fecha_registro)VALUES('REP-2026-00043',@cl03,@e18,@t13,@cg,'350123456789043','Eliminación de virus','Spyware roba datos personales','Pantalla con manchas de líquido, posible daño por humedad',250.00,'Entregado','2026-01-21 09:00:00');
INSERT INTO reparaciones(folio,id_cliente,id_equipo,id_empleado,id_color,imei_serie,motivo,falla,observaciones,precio,estatus,fecha_registro)VALUES('REP-2026-00044',@cl04,@e19,@t14,@cp,NULL,'Formateo y configuración','Dispositivo bloqueado por cuenta de Google','Estado físico bueno, solo falla funcional',200.00,'Entregado','2026-01-24 14:00:00');
INSERT INTO reparaciones(folio,id_cliente,id_equipo,id_empleado,id_color,imei_serie,motivo,falla,observaciones,precio,estatus,fecha_registro)VALUES('REP-2026-00045',@cl05,@e20,@t15,@cd,'350123456789045','Soldadura de componentes','Componente SMD desprendido de la placa','Dispositivo en buen estado general, sin daños visibles',900.00,'Concluido','2026-01-27 11:15:00');
INSERT INTO reparaciones(folio,id_cliente,id_equipo,id_empleado,id_color,imei_serie,motivo,falla,observaciones,precio,estatus,fecha_registro)VALUES('REP-2026-00046',@cl06,@e21,@t01,@ca,'350123456789046','Cambio de pantalla','Pantalla negra después de caída','Equipo llega con rayones menores en la carcasa',1800.00,'Concluido','2025-12-01 10:00:00');
INSERT INTO reparaciones(folio,id_cliente,id_equipo,id_empleado,id_color,imei_serie,motivo,falla,observaciones,precio,estatus,fecha_registro)VALUES('REP-2026-00047',@cl07,@e22,@t02,@cr,'350123456789047','Cambio de batería','Laptop no enciende sin estar conectada','Sin evidencia de golpes externos, falla interna',650.00,'Concluido','2025-12-04 13:00:00');
INSERT INTO reparaciones(folio,id_cliente,id_equipo,id_empleado,id_color,imei_serie,motivo,falla,observaciones,precio,estatus,fecha_registro)VALUES('REP-2026-00048',@cl08,@e23,@t03,@cv,NULL,'Reparación de placa base','Laptop no detecta la RAM instalada','Pantalla con manchas de líquido, posible daño por humedad',2500.00,'En reparación','2025-12-08 09:30:00');
INSERT INTO reparaciones(folio,id_cliente,id_equipo,id_empleado,id_color,imei_serie,motivo,falla,observaciones,precio,estatus,fecha_registro)VALUES('REP-2026-00049',@cl09,@e24,@t04,@crs,'350123456789049','Cambio de puerto de carga','Puerto USB-C no carga ni transfiere','Estado físico bueno, solo falla funcional',450.00,'En reparación','2025-12-11 14:15:00');
INSERT INTO reparaciones(folio,id_cliente,id_equipo,id_empleado,id_color,imei_serie,motivo,falla,observaciones,precio,estatus,fecha_registro)VALUES('REP-2026-00050',@cl10,@e25,@t05,@cm,'350123456789050','Limpieza interna','Laptop con temperatura crítica en CPU','Dispositivo en buen estado general, sin daños visibles',350.00,'En reparación','2025-12-14 10:30:00');
INSERT INTO reparaciones(folio,id_cliente,id_equipo,id_empleado,id_color,imei_serie,motivo,falla,observaciones,precio,estatus,fecha_registro)VALUES('REP-2026-00051',@cl11,@e01,@t06,@cn,'350123456789051','Cambio de cámara trasera','Módulo de cámara sin imagen tras caída','Equipo llega con rayones menores en la carcasa',1200.00,'Entregado','2025-12-17 09:00:00');
INSERT INTO reparaciones(folio,id_cliente,id_equipo,id_empleado,id_color,imei_serie,motivo,falla,observaciones,precio,estatus,fecha_registro)VALUES('REP-2026-00052',@cl12,@e02,@t07,@cb,NULL,'Actualización de software','Error crítico de sistema al iniciar','Sin evidencia de golpes externos, falla interna',300.00,'Entregado','2025-12-20 11:30:00');
INSERT INTO reparaciones(folio,id_cliente,id_equipo,id_empleado,id_color,imei_serie,motivo,falla,observaciones,precio,estatus,fecha_registro)VALUES('REP-2026-00053',@cl13,@e03,@t08,@cg,'350123456789053','Recuperación de datos','Datos borrados accidentalmente','Pantalla con manchas de líquido, posible daño por humedad',800.00,'Entregado','2025-12-23 13:45:00');
INSERT INTO reparaciones(folio,id_cliente,id_equipo,id_empleado,id_color,imei_serie,motivo,falla,observaciones,precio,estatus,fecha_registro)VALUES('REP-2026-00054',@cl14,@e04,@t09,@cp,'350123456789054','Cambio de micrófono','Audio de micrófono muy bajo en grabaciones','Estado físico bueno, solo falla funcional',550.00,'Entregado','2025-12-26 10:00:00');
INSERT INTO reparaciones(folio,id_cliente,id_equipo,id_empleado,id_color,imei_serie,motivo,falla,observaciones,precio,estatus,fecha_registro)VALUES('REP-2026-00055',@cl15,@e05,@t10,@cd,'350123456789055','Cambio de altavoz','Altavoz con crujidos a cualquier volumen','Dispositivo en buen estado general, sin daños visibles',500.00,'Concluido','2025-11-02 09:30:00');
INSERT INTO reparaciones(folio,id_cliente,id_equipo,id_empleado,id_color,imei_serie,motivo,falla,observaciones,precio,estatus,fecha_registro)VALUES('REP-2026-00056',@cl16,@e06,@t11,@ca,NULL,'Reparación de botones','Botón de encendido se queda presionado','Equipo llega con rayones menores en la carcasa',400.00,'Concluido','2025-11-05 14:00:00');
INSERT INTO reparaciones(folio,id_cliente,id_equipo,id_empleado,id_color,imei_serie,motivo,falla,observaciones,precio,estatus,fecha_registro)VALUES('REP-2026-00057',@cl17,@e07,@t12,@cr,'350123456789057','Cambio de carcasa','Marco del dispositivo doblado por presión','Sin evidencia de golpes externos, falla interna',750.00,'Concluido','2025-11-08 11:00:00');
INSERT INTO reparaciones(folio,id_cliente,id_equipo,id_empleado,id_color,imei_serie,motivo,falla,observaciones,precio,estatus,fecha_registro)VALUES('REP-2026-00058',@cl18,@e08,@t13,@cv,'350123456789058','Eliminación de virus','Troyano bancario detectado en el dispositivo','Pantalla con manchas de líquido, posible daño por humedad',250.00,'En reparación','2025-11-11 13:30:00');
INSERT INTO reparaciones(folio,id_cliente,id_equipo,id_empleado,id_color,imei_serie,motivo,falla,observaciones,precio,estatus,fecha_registro)VALUES('REP-2026-00059',@cl19,@e09,@t14,@crs,'350123456789059','Formateo y configuración','Contraseña olvidada, necesita reset total','Estado físico bueno, solo falla funcional',200.00,'En reparación','2025-11-14 10:15:00');
INSERT INTO reparaciones(folio,id_cliente,id_equipo,id_empleado,id_color,imei_serie,motivo,falla,observaciones,precio,estatus,fecha_registro)VALUES('REP-2026-00060',@cl20,@e10,@t15,@cm,NULL,'Soldadura de componentes','Chip de WiFi desprendido','Dispositivo en buen estado general, sin daños visibles',900.00,'En reparación','2025-11-17 14:45:00');
INSERT INTO reparaciones(folio,id_cliente,id_equipo,id_empleado,id_color,imei_serie,motivo,falla,observaciones,precio,estatus,fecha_registro)VALUES('REP-2026-00061',@cl01,@e11,@t01,@cn,'350123456789061','Cambio de pantalla','Cristal táctil roto sin daño interno','Equipo llega con rayones menores en la carcasa',1800.00,'Entregado','2025-11-20 09:00:00');
INSERT INTO reparaciones(folio,id_cliente,id_equipo,id_empleado,id_color,imei_serie,motivo,falla,observaciones,precio,estatus,fecha_registro)VALUES('REP-2026-00062',@cl02,@e12,@t02,@cb,'350123456789062','Cambio de batería','Batería deja de cargar al 80%','Sin evidencia de golpes externos, falla interna',650.00,'Entregado','2025-11-23 11:30:00');
INSERT INTO reparaciones(folio,id_cliente,id_equipo,id_empleado,id_color,imei_serie,motivo,falla,observaciones,precio,estatus,fecha_registro)VALUES('REP-2026-00063',@cl03,@e13,@t03,@cg,'350123456789063','Reparación de placa base','No hay imagen en la pantalla, placa dañada','Pantalla con manchas de líquido, posible daño por humedad',2500.00,'Entregado','2025-11-26 13:00:00');
INSERT INTO reparaciones(folio,id_cliente,id_equipo,id_empleado,id_color,imei_serie,motivo,falla,observaciones,precio,estatus,fecha_registro)VALUES('REP-2026-00064',@cl04,@e14,@t04,@cp,NULL,'Cambio de puerto de carga','Puerto de carga quemado por mal voltaje','Estado físico bueno, solo falla funcional',450.00,'Entregado','2025-10-01 10:30:00');
INSERT INTO reparaciones(folio,id_cliente,id_equipo,id_empleado,id_color,imei_serie,motivo,falla,observaciones,precio,estatus,fecha_registro)VALUES('REP-2026-00065',@cl05,@e15,@t05,@cd,'350123456789065','Limpieza interna','Pasta térmica seca, CPU al 100%','Dispositivo en buen estado general, sin daños visibles',350.00,'Concluido','2025-10-04 14:00:00');
INSERT INTO reparaciones(folio,id_cliente,id_equipo,id_empleado,id_color,imei_serie,motivo,falla,observaciones,precio,estatus,fecha_registro)VALUES('REP-2026-00066',@cl06,@e16,@t06,@ca,'350123456789066','Cambio de cámara trasera','Sensor de cámara dañado por humedad','Equipo llega con rayones menores en la carcasa',1200.00,'Concluido','2025-10-07 09:15:00');
INSERT INTO reparaciones(folio,id_cliente,id_equipo,id_empleado,id_color,imei_serie,motivo,falla,observaciones,precio,estatus,fecha_registro)VALUES('REP-2026-00067',@cl07,@e17,@t07,@cr,'350123456789067','Actualización de software','App del sistema no responde, se congela','Sin evidencia de golpes externos, falla interna',300.00,'Concluido','2025-10-10 11:45:00');
INSERT INTO reparaciones(folio,id_cliente,id_equipo,id_empleado,id_color,imei_serie,motivo,falla,observaciones,precio,estatus,fecha_registro)VALUES('REP-2026-00068',@cl08,@e18,@t08,@cv,NULL,'Recuperación de datos','Backup corrompido, necesita recuperación','Pantalla con manchas de líquido, posible daño por humedad',800.00,'En reparación','2025-10-13 13:00:00');
INSERT INTO reparaciones(folio,id_cliente,id_equipo,id_empleado,id_color,imei_serie,motivo,falla,observaciones,precio,estatus,fecha_registro)VALUES('REP-2026-00069',@cl09,@e19,@t09,@crs,'350123456789069','Cambio de micrófono','Micrófono capta ruido constante de fondo','Estado físico bueno, solo falla funcional',550.00,'En reparación','2025-10-16 10:30:00');
INSERT INTO reparaciones(folio,id_cliente,id_equipo,id_empleado,id_color,imei_serie,motivo,falla,observaciones,precio,estatus,fecha_registro)VALUES('REP-2026-00070',@cl10,@e20,@t10,@cm,'350123456789070','Cambio de altavoz','Altavoz con volumen muy bajo al máximo','Dispositivo en buen estado general, sin daños visibles',500.00,'En reparación','2025-10-19 14:15:00');
INSERT INTO reparaciones(folio,id_cliente,id_equipo,id_empleado,id_color,imei_serie,motivo,falla,observaciones,precio,estatus,fecha_registro)VALUES('REP-2026-00071',@cl11,@e21,@t11,@cn,'350123456789071','Reparación de botones','Trackpad sin clic físico','Equipo llega con rayones menores en la carcasa',400.00,'Entregado','2025-10-22 09:00:00');
INSERT INTO reparaciones(folio,id_cliente,id_equipo,id_empleado,id_color,imei_serie,motivo,falla,observaciones,precio,estatus,fecha_registro)VALUES('REP-2026-00072',@cl12,@e22,@t12,@cb,NULL,'Cambio de carcasa','Bisagra de laptop rota, pantalla suelta','Sin evidencia de golpes externos, falla interna',750.00,'Entregado','2025-10-25 11:00:00');
INSERT INTO reparaciones(folio,id_cliente,id_equipo,id_empleado,id_color,imei_serie,motivo,falla,observaciones,precio,estatus,fecha_registro)VALUES('REP-2026-00073',@cl13,@e23,@t13,@cg,'350123456789073','Eliminación de virus','Adware instalado sin consentimiento','Pantalla con manchas de líquido, posible daño por humedad',250.00,'Entregado','2025-09-01 10:45:00');
INSERT INTO reparaciones(folio,id_cliente,id_equipo,id_empleado,id_color,imei_serie,motivo,falla,observaciones,precio,estatus,fecha_registro)VALUES('REP-2026-00074',@cl14,@e24,@t14,@cp,'350123456789074','Formateo y configuración','Windows corrompido por actualización fallida','Estado físico bueno, solo falla funcional',200.00,'Entregado','2025-09-04 14:30:00');
INSERT INTO reparaciones(folio,id_cliente,id_equipo,id_empleado,id_color,imei_serie,motivo,falla,observaciones,precio,estatus,fecha_registro)VALUES('REP-2026-00075',@cl15,@e25,@t15,@cd,'350123456789075','Soldadura de componentes','Puerto HDMI con pines doblados','Dispositivo en buen estado general, sin daños visibles',900.00,'Concluido','2025-09-07 09:15:00');
INSERT INTO reparaciones(folio,id_cliente,id_equipo,id_empleado,id_color,imei_serie,motivo,falla,observaciones,precio,estatus,fecha_registro)VALUES('REP-2026-00076',@cl16,@e01,@t01,@ca,NULL,'Cambio de pantalla','Pantalla con manchas permanentes','Equipo llega con rayones menores en la carcasa',1800.00,'Concluido','2025-09-10 11:30:00');
INSERT INTO reparaciones(folio,id_cliente,id_equipo,id_empleado,id_color,imei_serie,motivo,falla,observaciones,precio,estatus,fecha_registro)VALUES('REP-2026-00077',@cl17,@e02,@t02,@cr,'350123456789077','Cambio de batería','Batería inflamada, riesgo de seguridad','Sin evidencia de golpes externos, falla interna',650.00,'Concluido','2025-09-13 13:00:00');
INSERT INTO reparaciones(folio,id_cliente,id_equipo,id_empleado,id_color,imei_serie,motivo,falla,observaciones,precio,estatus,fecha_registro)VALUES('REP-2026-00078',@cl18,@e03,@t03,@cv,'350123456789078','Reparación de placa base','Error de bus de datos en placa','Pantalla con manchas de líquido, posible daño por humedad',2500.00,'En reparación','2025-09-16 10:00:00');
INSERT INTO reparaciones(folio,id_cliente,id_equipo,id_empleado,id_color,imei_serie,motivo,falla,observaciones,precio,estatus,fecha_registro)VALUES('REP-2026-00079',@cl19,@e04,@t04,@crs,'350123456789079','Cambio de puerto de carga','Lightning roto por dentro','Estado físico bueno, solo falla funcional',450.00,'En reparación','2025-09-19 14:45:00');
INSERT INTO reparaciones(folio,id_cliente,id_equipo,id_empleado,id_color,imei_serie,motivo,falla,observaciones,precio,estatus,fecha_registro)VALUES('REP-2026-00080',@cl20,@e05,@t05,@cm,NULL,'Limpieza interna','Equipo con olor a quemado leve','Dispositivo en buen estado general, sin daños visibles',350.00,'En reparación','2025-09-22 09:30:00');
INSERT INTO reparaciones(folio,id_cliente,id_equipo,id_empleado,id_color,imei_serie,motivo,falla,observaciones,precio,estatus,fecha_registro)VALUES('REP-2026-00081',@cl01,@e06,@t06,@cn,'350123456789081','Cambio de cámara trasera','Cámara ultra gran angular sin imagen','Equipo llega con rayones menores en la carcasa',1200.00,'Entregado','2025-09-25 11:15:00');
INSERT INTO reparaciones(folio,id_cliente,id_equipo,id_empleado,id_color,imei_serie,motivo,falla,observaciones,precio,estatus,fecha_registro)VALUES('REP-2026-00082',@cl02,@e07,@t07,@cb,'350123456789082','Actualización de software','Error 53 tras actualización de iOS','Sin evidencia de golpes externos, falla interna',300.00,'Entregado','2025-08-01 10:00:00');
INSERT INTO reparaciones(folio,id_cliente,id_equipo,id_empleado,id_color,imei_serie,motivo,falla,observaciones,precio,estatus,fecha_registro)VALUES('REP-2026-00083',@cl03,@e08,@t08,@cg,'350123456789083','Recuperación de datos','SD card dañada, fotos perdidas','Pantalla con manchas de líquido, posible daño por humedad',800.00,'Entregado','2025-08-04 14:30:00');
INSERT INTO reparaciones(folio,id_cliente,id_equipo,id_empleado,id_color,imei_serie,motivo,falla,observaciones,precio,estatus,fecha_registro)VALUES('REP-2026-00084',@cl04,@e09,@t09,@cp,NULL,'Cambio de micrófono','Micrófonos duales sin respuesta','Estado físico bueno, solo falla funcional',550.00,'Entregado','2025-08-07 09:45:00');
INSERT INTO reparaciones(folio,id_cliente,id_equipo,id_empleado,id_color,imei_serie,motivo,falla,observaciones,precio,estatus,fecha_registro)VALUES('REP-2026-00085',@cl05,@e10,@t10,@cd,'350123456789085','Cambio de altavoz','Altavoz trasero roto por agua','Dispositivo en buen estado general, sin daños visibles',500.00,'Concluido','2025-08-10 11:00:00');
INSERT INTO reparaciones(folio,id_cliente,id_equipo,id_empleado,id_color,imei_serie,motivo,falla,observaciones,precio,estatus,fecha_registro)VALUES('REP-2026-00086',@cl06,@e11,@t11,@ca,'350123456789086','Reparación de botones','Switch de silencio roto','Equipo llega con rayones menores en la carcasa',400.00,'Concluido','2025-08-13 13:30:00');
INSERT INTO reparaciones(folio,id_cliente,id_equipo,id_empleado,id_color,imei_serie,motivo,falla,observaciones,precio,estatus,fecha_registro)VALUES('REP-2026-00087',@cl07,@e12,@t12,@cr,'350123456789087','Cambio de carcasa','Teclado con teclas sin respuesta por daño físico','Sin evidencia de golpes externos, falla interna',750.00,'Concluido','2025-08-16 10:15:00');
INSERT INTO reparaciones(folio,id_cliente,id_equipo,id_empleado,id_color,imei_serie,motivo,falla,observaciones,precio,estatus,fecha_registro)VALUES('REP-2026-00088',@cl08,@e13,@t13,@cv,NULL,'Eliminación de virus','Minero de criptomonedas en el sistema','Pantalla con manchas de líquido, posible daño por humedad',250.00,'En reparación','2025-08-19 14:00:00');
INSERT INTO reparaciones(folio,id_cliente,id_equipo,id_empleado,id_color,imei_serie,motivo,falla,observaciones,precio,estatus,fecha_registro)VALUES('REP-2026-00089',@cl09,@e14,@t14,@crs,'350123456789089','Formateo y configuración','Restauración de fábrica requerida','Estado físico bueno, solo falla funcional',200.00,'En reparación','2025-08-22 09:00:00');
INSERT INTO reparaciones(folio,id_cliente,id_equipo,id_empleado,id_color,imei_serie,motivo,falla,observaciones,precio,estatus,fecha_registro)VALUES('REP-2026-00090',@cl10,@e15,@t15,@cm,'350123456789090','Soldadura de componentes','Resistencia SMD fuera de lugar','Dispositivo en buen estado general, sin daños visibles',900.00,'En reparación','2025-08-25 11:30:00');
INSERT INTO reparaciones(folio,id_cliente,id_equipo,id_empleado,id_color,imei_serie,motivo,falla,observaciones,precio,estatus,fecha_registro)VALUES('REP-2026-00091',@cl11,@e16,@t01,@cn,'350123456789091','Cambio de pantalla','Display AMOLED con quemado permanente','Equipo llega con rayones menores en la carcasa',1800.00,'Entregado','2025-07-01 10:30:00');
INSERT INTO reparaciones(folio,id_cliente,id_equipo,id_empleado,id_color,imei_serie,motivo,falla,observaciones,precio,estatus,fecha_registro)VALUES('REP-2026-00092',@cl12,@e17,@t02,@cb,NULL,'Cambio de batería','Celular se apaga al 30% de batería','Sin evidencia de golpes externos, falla interna',650.00,'Entregado','2025-07-04 14:00:00');
INSERT INTO reparaciones(folio,id_cliente,id_equipo,id_empleado,id_color,imei_serie,motivo,falla,observaciones,precio,estatus,fecha_registro)VALUES('REP-2026-00093',@cl13,@e18,@t03,@cg,'350123456789093','Reparación de placa base','No hay señal de red, antena dañada','Pantalla con manchas de líquido, posible daño por humedad',2500.00,'Entregado','2025-07-07 09:15:00');
INSERT INTO reparaciones(folio,id_cliente,id_equipo,id_empleado,id_color,imei_serie,motivo,falla,observaciones,precio,estatus,fecha_registro)VALUES('REP-2026-00094',@cl14,@e19,@t04,@cp,'350123456789094','Cambio de puerto de carga','Puerto de carga flojo, carga intermitente','Estado físico bueno, solo falla funcional',450.00,'Entregado','2025-07-10 11:00:00');
INSERT INTO reparaciones(folio,id_cliente,id_equipo,id_empleado,id_color,imei_serie,motivo,falla,observaciones,precio,estatus,fecha_registro)VALUES('REP-2026-00095',@cl15,@e20,@t05,@cd,'350123456789095','Limpieza interna','Puerto USB lleno de pelusa y suciedad','Dispositivo en buen estado general, sin daños visibles',350.00,'Concluido','2025-07-13 13:45:00');
INSERT INTO reparaciones(folio,id_cliente,id_equipo,id_empleado,id_color,imei_serie,motivo,falla,observaciones,precio,estatus,fecha_registro)VALUES('REP-2026-00096',@cl16,@e21,@t06,@ca,NULL,'Cambio de cámara trasera','Cámara web no reconocida por el sistema','Equipo llega con rayones menores en la carcasa',1200.00,'Concluido','2025-07-16 10:00:00');
INSERT INTO reparaciones(folio,id_cliente,id_equipo,id_empleado,id_color,imei_serie,motivo,falla,observaciones,precio,estatus,fecha_registro)VALUES('REP-2026-00097',@cl17,@e22,@t07,@cr,'350123456789097','Actualización de software','Driver de GPU desactualizado, pantalla negra','Sin evidencia de golpes externos, falla interna',300.00,'Concluido','2025-07-19 14:30:00');
INSERT INTO reparaciones(folio,id_cliente,id_equipo,id_empleado,id_color,imei_serie,motivo,falla,observaciones,precio,estatus,fecha_registro)VALUES('REP-2026-00098',@cl18,@e23,@t08,@cv,'350123456789098','Recuperación de datos','Disco duro con fallas mecánicas','Pantalla con manchas de líquido, posible daño por humedad',800.00,'En reparación','2025-07-22 09:30:00');
INSERT INTO reparaciones(folio,id_cliente,id_equipo,id_empleado,id_color,imei_serie,motivo,falla,observaciones,precio,estatus,fecha_registro)VALUES('REP-2026-00099',@cl19,@e24,@t09,@crs,'350123456789099','Cambio de micrófono','Micrófono no funciona en reuniones online','Estado físico bueno, solo falla funcional',550.00,'En reparación','2025-07-25 11:15:00');
INSERT INTO reparaciones(folio,id_cliente,id_equipo,id_empleado,id_color,imei_serie,motivo,falla,observaciones,precio,estatus,fecha_registro)VALUES('REP-2026-00100',@cl20,@e25,@t10,@cm,NULL,'Cambio de altavoz','Altavoz de laptop sin sonido','Dispositivo en buen estado general, sin daños visibles',500.00,'En reparación','2025-07-28 13:00:00');

-- Resumen final
SELECT COUNT(*) AS total_reparaciones FROM reparaciones;
SELECT COUNT(*) AS total_empleados_tecnicos FROM empleados;
SELECT COUNT(*) AS total_equipos FROM equipos;

