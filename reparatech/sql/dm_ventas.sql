-- ============================================================
-- REPARATECH - DATA MART: 100 VENTAS
-- Sin stored procedures - compatible con phpMyAdmin
-- Ejecutar DESPUÉS de dm_productos.sql
-- ============================================================
USE reparatech;

-- PASO 1: 20 clientes de prueba
INSERT IGNORE INTO usuarios (nombre, telefono, contrasena_hash, tipo_usuario) VALUES
('Carlos Mendoza',   '5511000001','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','cliente'),
('María González',   '5511000002','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','cliente'),
('Luis Ramírez',     '5511000003','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','cliente'),
('Ana Torres',       '5511000004','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','cliente'),
('Pedro Hernández',  '5511000005','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','cliente'),
('Sofía López',      '5511000006','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','cliente'),
('Diego Martínez',   '5511000007','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','cliente'),
('Valentina Cruz',   '5511000008','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','cliente'),
('Andrés Flores',    '5511000009','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','cliente'),
('Gabriela Sánchez', '5511000010','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','cliente'),
('Roberto Jiménez',  '5511000011','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','cliente'),
('Claudia Morales',  '5511000012','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','cliente'),
('Fernando Reyes',   '5511000013','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','cliente'),
('Patricia Vargas',  '5511000014','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','cliente'),
('Javier Castillo',  '5511000015','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','cliente'),
('Mónica Gutiérrez', '5511000016','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','cliente'),
('Héctor Díaz',      '5511000017','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','cliente'),
('Lucía Pérez',      '5511000018','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','cliente'),
('Eduardo Ríos',     '5511000019','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','cliente'),
('Isabel Rojas',     '5511000020','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','cliente');

-- PASO 2: Registrar en tabla clientes
INSERT INTO clientes (id_cliente, correo, direccion)
SELECT u.id_usuario, CONCAT(LOWER(REPLACE(u.nombre,' ','.')), '@email.com'),
       CONCAT('Calle Reforma #', (u.id_usuario * 7), ', Col. Centro, CDMX')
FROM usuarios u
WHERE u.telefono IN ('5511000001','5511000002','5511000003','5511000004','5511000005',
                     '5511000006','5511000007','5511000008','5511000009','5511000010',
                     '5511000011','5511000012','5511000013','5511000014','5511000015',
                     '5511000016','5511000017','5511000018','5511000019','5511000020')
  AND NOT EXISTS (SELECT 1 FROM clientes c WHERE c.id_cliente = u.id_usuario);

-- PASO 3: Variables de IDs de clientes
SET @c01=(SELECT id_usuario FROM usuarios WHERE telefono='5511000001' LIMIT 1);
SET @c02=(SELECT id_usuario FROM usuarios WHERE telefono='5511000002' LIMIT 1);
SET @c03=(SELECT id_usuario FROM usuarios WHERE telefono='5511000003' LIMIT 1);
SET @c04=(SELECT id_usuario FROM usuarios WHERE telefono='5511000004' LIMIT 1);
SET @c05=(SELECT id_usuario FROM usuarios WHERE telefono='5511000005' LIMIT 1);
SET @c06=(SELECT id_usuario FROM usuarios WHERE telefono='5511000006' LIMIT 1);
SET @c07=(SELECT id_usuario FROM usuarios WHERE telefono='5511000007' LIMIT 1);
SET @c08=(SELECT id_usuario FROM usuarios WHERE telefono='5511000008' LIMIT 1);
SET @c09=(SELECT id_usuario FROM usuarios WHERE telefono='5511000009' LIMIT 1);
SET @c10=(SELECT id_usuario FROM usuarios WHERE telefono='5511000010' LIMIT 1);
SET @c11=(SELECT id_usuario FROM usuarios WHERE telefono='5511000011' LIMIT 1);
SET @c12=(SELECT id_usuario FROM usuarios WHERE telefono='5511000012' LIMIT 1);
SET @c13=(SELECT id_usuario FROM usuarios WHERE telefono='5511000013' LIMIT 1);
SET @c14=(SELECT id_usuario FROM usuarios WHERE telefono='5511000014' LIMIT 1);
SET @c15=(SELECT id_usuario FROM usuarios WHERE telefono='5511000015' LIMIT 1);
SET @c16=(SELECT id_usuario FROM usuarios WHERE telefono='5511000016' LIMIT 1);
SET @c17=(SELECT id_usuario FROM usuarios WHERE telefono='5511000017' LIMIT 1);
SET @c18=(SELECT id_usuario FROM usuarios WHERE telefono='5511000018' LIMIT 1);
SET @c19=(SELECT id_usuario FROM usuarios WHERE telefono='5511000019' LIMIT 1);
SET @c20=(SELECT id_usuario FROM usuarios WHERE telefono='5511000020' LIMIT 1);

-- ============================================================
-- PASO 4: 100 VENTAS
-- Patrón: INSERT pedido → SET @p → INSERT detalle → INSERT envio
-- ============================================================

-- Venta 1
INSERT INTO pedidos(id_cliente,fecha,total,estatus)VALUES(@c01,'2026-05-20 10:15:00',27999.00,'Pagado');SET @p=LAST_INSERT_ID();
INSERT INTO detalle_pedido(id_pedido,id_producto,cantidad,subtotal)VALUES(@p,(SELECT id_producto FROM productos WHERE nombre='iPhone 15 Pro Max 256GB' LIMIT 1),1,27999.00);
INSERT INTO envios(id_pedido,nombre_cliente,direccion,telefono,estatus,folio_rastreo,fecha_envio,fecha_entrega)VALUES(@p,'Carlos Mendoza','Av. Insurgentes Sur #7, Col. San Ángel, CDMX','5511000001','Empacado','RT-000001-2026','2026-05-21 09:00:00',NULL);

-- Venta 2
INSERT INTO pedidos(id_cliente,fecha,total,estatus)VALUES(@c02,'2026-05-18 11:30:00',19499.00,'Pagado');SET @p=LAST_INSERT_ID();
INSERT INTO detalle_pedido(id_pedido,id_producto,cantidad,subtotal)VALUES(@p,(SELECT id_producto FROM productos WHERE nombre='iPhone 14 128GB' LIMIT 1),1,19499.00);
INSERT INTO envios(id_pedido,nombre_cliente,direccion,telefono,estatus,folio_rastreo,fecha_envio,fecha_entrega)VALUES(@p,'María González','Calle Juárez #14, Col. Centro, Guadalajara','5511000002','En procesamiento','RT-000002-2026','2026-05-19 10:00:00',NULL);

-- Venta 3
INSERT INTO pedidos(id_cliente,fecha,total,estatus)VALUES(@c03,'2026-05-15 14:00:00',29999.00,'Enviado');SET @p=LAST_INSERT_ID();
INSERT INTO detalle_pedido(id_pedido,id_producto,cantidad,subtotal)VALUES(@p,(SELECT id_producto FROM productos WHERE nombre='Samsung Galaxy S24 Ultra 256GB' LIMIT 1),1,29999.00);
INSERT INTO envios(id_pedido,nombre_cliente,direccion,telefono,estatus,folio_rastreo,fecha_envio,fecha_entrega)VALUES(@p,'Luis Ramírez','Blvd. Hidalgo #21, Col. Obrera, Monterrey','5511000003','Entregado','RT-000003-2026','2026-05-16 09:00:00','2026-05-18 12:00:00');

-- Venta 4
INSERT INTO pedidos(id_cliente,fecha,total,estatus)VALUES(@c04,'2026-05-12 09:30:00',9999.00,'Pagado');SET @p=LAST_INSERT_ID();
INSERT INTO detalle_pedido(id_pedido,id_producto,cantidad,subtotal)VALUES(@p,(SELECT id_producto FROM productos WHERE nombre='Samsung Galaxy A55 128GB' LIMIT 1),1,9999.00);
INSERT INTO envios(id_pedido,nombre_cliente,direccion,telefono,estatus,folio_rastreo,fecha_envio,fecha_entrega)VALUES(@p,'Ana Torres','Calle Morelos #28, Col. Doctores, CDMX','5511000004','En procesamiento','RT-000004-2026','2026-05-13 08:00:00',NULL);

-- Venta 5
INSERT INTO pedidos(id_cliente,fecha,total,estatus)VALUES(@c05,'2026-05-10 16:45:00',18499.00,'Enviado');SET @p=LAST_INSERT_ID();
INSERT INTO detalle_pedido(id_pedido,id_producto,cantidad,subtotal)VALUES(@p,(SELECT id_producto FROM productos WHERE nombre='Xiaomi 14 Pro 256GB' LIMIT 1),1,18499.00);
INSERT INTO envios(id_pedido,nombre_cliente,direccion,telefono,estatus,folio_rastreo,fecha_envio,fecha_entrega)VALUES(@p,'Pedro Hernández','Av. Revolución #35, Col. Mixcoac, CDMX','5511000005','En camino','RT-000005-2026','2026-05-11 10:00:00',NULL);

-- Venta 6
INSERT INTO pedidos(id_cliente,fecha,total,estatus)VALUES(@c06,'2026-05-07 12:20:00',7499.00,'Pagado');SET @p=LAST_INSERT_ID();
INSERT INTO detalle_pedido(id_pedido,id_producto,cantidad,subtotal)VALUES(@p,(SELECT id_producto FROM productos WHERE nombre='Xiaomi Redmi Note 13 Pro 128GB' LIMIT 1),1,7499.00);
INSERT INTO envios(id_pedido,nombre_cliente,direccion,telefono,estatus,folio_rastreo,fecha_envio,fecha_entrega)VALUES(@p,'Sofía López','Calle Madero #42, Col. Chapultepec, Guadalajara','5511000006','Empacado','RT-000006-2026','2026-05-08 09:00:00',NULL);

-- Venta 7
INSERT INTO pedidos(id_cliente,fecha,total,estatus)VALUES(@c07,'2026-05-05 10:00:00',11499.00,'Enviado');SET @p=LAST_INSERT_ID();
INSERT INTO detalle_pedido(id_pedido,id_producto,cantidad,subtotal)VALUES(@p,(SELECT id_producto FROM productos WHERE nombre='Motorola Edge 50 Pro 256GB' LIMIT 1),1,11499.00);
INSERT INTO envios(id_pedido,nombre_cliente,direccion,telefono,estatus,folio_rastreo,fecha_envio,fecha_entrega)VALUES(@p,'Diego Martínez','Blvd. Independencia #49, Col. Las Quintas, Culiacán','5511000007','Entregado','RT-000007-2026','2026-05-06 09:00:00','2026-05-08 14:00:00');

-- Venta 8
INSERT INTO pedidos(id_cliente,fecha,total,estatus)VALUES(@c08,'2026-05-03 15:30:00',20999.00,'Pagado');SET @p=LAST_INSERT_ID();
INSERT INTO detalle_pedido(id_pedido,id_producto,cantidad,subtotal)VALUES(@p,(SELECT id_producto FROM productos WHERE nombre='Google Pixel 8 Pro 128GB' LIMIT 1),1,20999.00);
INSERT INTO envios(id_pedido,nombre_cliente,direccion,telefono,estatus,folio_rastreo,fecha_envio,fecha_entrega)VALUES(@p,'Valentina Cruz','Av. Universidad #56, Col. Copilco, CDMX','5511000008','En procesamiento','RT-000008-2026','2026-05-04 09:00:00',NULL);

-- Venta 9
INSERT INTO pedidos(id_cliente,fecha,total,estatus)VALUES(@c09,'2026-05-01 11:00:00',17499.00,'Pagado');SET @p=LAST_INSERT_ID();
INSERT INTO detalle_pedido(id_pedido,id_producto,cantidad,subtotal)VALUES(@p,(SELECT id_producto FROM productos WHERE nombre='OnePlus 12 256GB' LIMIT 1),1,17499.00);
INSERT INTO envios(id_pedido,nombre_cliente,direccion,telefono,estatus,folio_rastreo,fecha_envio,fecha_entrega)VALUES(@p,'Andrés Flores','Calle Allende #63, Col. Guerrero, CDMX','5511000009','Empacado','RT-000009-2026','2026-05-02 10:00:00',NULL);

-- Venta 10
INSERT INTO pedidos(id_cliente,fecha,total,estatus)VALUES(@c10,'2026-04-28 13:15:00',8999.00,'Enviado');SET @p=LAST_INSERT_ID();
INSERT INTO detalle_pedido(id_pedido,id_producto,cantidad,subtotal)VALUES(@p,(SELECT id_producto FROM productos WHERE nombre='Huawei Nova 12 SE 256GB' LIMIT 1),1,8999.00);
INSERT INTO envios(id_pedido,nombre_cliente,direccion,telefono,estatus,folio_rastreo,fecha_envio,fecha_entrega)VALUES(@p,'Gabriela Sánchez','Av. Chapultepec #70, Col. Roma, CDMX','5511000010','Entregado','RT-000010-2026','2026-04-29 09:00:00','2026-05-01 11:00:00');

-- Venta 11
INSERT INTO pedidos(id_cliente,fecha,total,estatus)VALUES(@c11,'2026-04-25 10:00:00',32999.00,'Pagado');SET @p=LAST_INSERT_ID();
INSERT INTO detalle_pedido(id_pedido,id_producto,cantidad,subtotal)VALUES(@p,(SELECT id_producto FROM productos WHERE nombre='iPad Pro 12.9" M2 256GB Wi-Fi' LIMIT 1),1,32999.00);
INSERT INTO envios(id_pedido,nombre_cliente,direccion,telefono,estatus,folio_rastreo,fecha_envio,fecha_entrega)VALUES(@p,'Roberto Jiménez','Calle Guerrero #77, Col. Tlatilco, CDMX','5511000011','En procesamiento','RT-000011-2026','2026-04-26 09:00:00',NULL);

-- Venta 12
INSERT INTO pedidos(id_cliente,fecha,total,estatus)VALUES(@c12,'2026-04-22 14:30:00',15999.00,'Enviado');SET @p=LAST_INSERT_ID();
INSERT INTO detalle_pedido(id_pedido,id_producto,cantidad,subtotal)VALUES(@p,(SELECT id_producto FROM productos WHERE nombre='iPad Air 10.9" 64GB' LIMIT 1),1,15999.00);
INSERT INTO envios(id_pedido,nombre_cliente,direccion,telefono,estatus,folio_rastreo,fecha_envio,fecha_entrega)VALUES(@p,'Claudia Morales','Av. Reforma #84, Col. Polanco, CDMX','5511000012','Entregado','RT-000012-2026','2026-04-23 09:00:00','2026-04-25 12:00:00');

-- Venta 13
INSERT INTO pedidos(id_cliente,fecha,total,estatus)VALUES(@c13,'2026-04-20 09:00:00',11999.00,'Pagado');SET @p=LAST_INSERT_ID();
INSERT INTO detalle_pedido(id_pedido,id_producto,cantidad,subtotal)VALUES(@p,(SELECT id_producto FROM productos WHERE nombre='Samsung Galaxy Tab S9 FE 256GB' LIMIT 1),1,11999.00);
INSERT INTO envios(id_pedido,nombre_cliente,direccion,telefono,estatus,folio_rastreo,fecha_envio,fecha_entrega)VALUES(@p,'Fernando Reyes','Calle Zaragoza #91, Col. Narvarte, CDMX','5511000013','Empacado','RT-000013-2026','2026-04-21 09:00:00',NULL);

-- Venta 14
INSERT INTO pedidos(id_cliente,fecha,total,estatus)VALUES(@c14,'2026-04-17 11:20:00',10499.00,'Pagado');SET @p=LAST_INSERT_ID();
INSERT INTO detalle_pedido(id_pedido,id_producto,cantidad,subtotal)VALUES(@p,(SELECT id_producto FROM productos WHERE nombre='Xiaomi Pad 6 Pro 256GB' LIMIT 1),1,10499.00);
INSERT INTO envios(id_pedido,nombre_cliente,direccion,telefono,estatus,folio_rastreo,fecha_envio,fecha_entrega)VALUES(@p,'Patricia Vargas','Blvd. Díaz Mirón #98, Col. Formando Hogar, Veracruz','5511000014','En procesamiento','RT-000014-2026','2026-04-18 09:00:00',NULL);

-- Venta 15
INSERT INTO pedidos(id_cliente,fecha,total,estatus)VALUES(@c15,'2026-04-15 16:00:00',28999.00,'Enviado');SET @p=LAST_INSERT_ID();
INSERT INTO detalle_pedido(id_pedido,id_producto,cantidad,subtotal)VALUES(@p,(SELECT id_producto FROM productos WHERE nombre='MacBook Air 13" M2 8GB/256GB' LIMIT 1),1,28999.00);
INSERT INTO envios(id_pedido,nombre_cliente,direccion,telefono,estatus,folio_rastreo,fecha_envio,fecha_entrega)VALUES(@p,'Javier Castillo','Av. 20 de Noviembre #105, Col. Centro, Puebla','5511000015','Entregado','RT-000015-2026','2026-04-16 09:00:00','2026-04-18 14:00:00');

-- Venta 16
INSERT INTO pedidos(id_cliente,fecha,total,estatus)VALUES(@c16,'2026-04-12 10:30:00',49999.00,'Pagado');SET @p=LAST_INSERT_ID();
INSERT INTO detalle_pedido(id_pedido,id_producto,cantidad,subtotal)VALUES(@p,(SELECT id_producto FROM productos WHERE nombre='MacBook Pro 14" M3 Pro 18GB/512GB' LIMIT 1),1,49999.00);
INSERT INTO envios(id_pedido,nombre_cliente,direccion,telefono,estatus,folio_rastreo,fecha_envio,fecha_entrega)VALUES(@p,'Mónica Gutiérrez','Calle Ocampo #112, Col. Centenario, León','5511000016','Empacado','RT-000016-2026','2026-04-13 09:00:00',NULL);

-- Venta 17
INSERT INTO pedidos(id_cliente,fecha,total,estatus)VALUES(@c17,'2026-04-10 13:45:00',24999.00,'Enviado');SET @p=LAST_INSERT_ID();
INSERT INTO detalle_pedido(id_pedido,id_producto,cantidad,subtotal)VALUES(@p,(SELECT id_producto FROM productos WHERE nombre='Dell XPS 13 Core i7 16GB/512GB' LIMIT 1),1,24999.00);
INSERT INTO envios(id_pedido,nombre_cliente,direccion,telefono,estatus,folio_rastreo,fecha_envio,fecha_entrega)VALUES(@p,'Héctor Díaz','Av. Lázaro Cárdenas #119, Col. del Valle, CDMX','5511000017','En camino','RT-000017-2026','2026-04-11 09:00:00',NULL);

-- Venta 18
INSERT INTO pedidos(id_cliente,fecha,total,estatus)VALUES(@c18,'2026-04-07 09:15:00',13999.00,'Pagado');SET @p=LAST_INSERT_ID();
INSERT INTO detalle_pedido(id_pedido,id_producto,cantidad,subtotal)VALUES(@p,(SELECT id_producto FROM productos WHERE nombre='HP Pavilion 15 Core i5 8GB/512GB' LIMIT 1),1,13999.00);
INSERT INTO envios(id_pedido,nombre_cliente,direccion,telefono,estatus,folio_rastreo,fecha_envio,fecha_entrega)VALUES(@p,'Lucía Pérez','Calle Victoria #126, Col. Estrella, CDMX','5511000018','En procesamiento','RT-000018-2026','2026-04-08 09:00:00',NULL);

-- Venta 19
INSERT INTO pedidos(id_cliente,fecha,total,estatus)VALUES(@c19,'2026-04-05 15:00:00',35999.00,'Enviado');SET @p=LAST_INSERT_ID();
INSERT INTO detalle_pedido(id_pedido,id_producto,cantidad,subtotal)VALUES(@p,(SELECT id_producto FROM productos WHERE nombre='Lenovo ThinkPad X1 Carbon i7 16GB' LIMIT 1),1,35999.00);
INSERT INTO envios(id_pedido,nombre_cliente,direccion,telefono,estatus,folio_rastreo,fecha_envio,fecha_entrega)VALUES(@p,'Eduardo Ríos','Blvd. Torres Quintero #133, Col. Esperanza, Culiacán','5511000019','Entregado','RT-000019-2026','2026-04-06 09:00:00','2026-04-08 12:00:00');

-- Venta 20
INSERT INTO pedidos(id_cliente,fecha,total,estatus)VALUES(@c20,'2026-04-02 11:00:00',19499.00,'Pagado');SET @p=LAST_INSERT_ID();
INSERT INTO detalle_pedido(id_pedido,id_producto,cantidad,subtotal)VALUES(@p,(SELECT id_producto FROM productos WHERE nombre='Asus ZenBook 14 OLED Ryzen 7 16GB' LIMIT 1),1,19499.00);
INSERT INTO envios(id_pedido,nombre_cliente,direccion,telefono,estatus,folio_rastreo,fecha_envio,fecha_entrega)VALUES(@p,'Isabel Rojas','Av. Niños Héroes #140, Col. Americana, Guadalajara','5511000020','Empacado','RT-000020-2026','2026-04-03 09:00:00',NULL);

-- Venta 21
INSERT INTO pedidos(id_cliente,fecha,total,estatus)VALUES(@c01,'2026-03-28 10:00:00',399.00,'Pagado');SET @p=LAST_INSERT_ID();
INSERT INTO detalle_pedido(id_pedido,id_producto,cantidad,subtotal)VALUES(@p,(SELECT id_producto FROM productos WHERE nombre='Batería iPhone 14/15 Premium 3279mAh' LIMIT 1),1,399.00);
INSERT INTO envios(id_pedido,nombre_cliente,direccion,telefono,estatus,folio_rastreo,fecha_envio,fecha_entrega)VALUES(@p,'Carlos Mendoza','Av. Insurgentes Sur #7, Col. San Ángel, CDMX','5511000001','En procesamiento','RT-000021-2026','2026-03-29 09:00:00',NULL);

-- Venta 22
INSERT INTO pedidos(id_cliente,fecha,total,estatus)VALUES(@c02,'2026-03-25 14:00:00',349.00,'Pagado');SET @p=LAST_INSERT_ID();
INSERT INTO detalle_pedido(id_pedido,id_producto,cantidad,subtotal)VALUES(@p,(SELECT id_producto FROM productos WHERE nombre='Batería Samsung Galaxy S23 3900mAh' LIMIT 1),1,349.00);
INSERT INTO envios(id_pedido,nombre_cliente,direccion,telefono,estatus,folio_rastreo,fecha_envio,fecha_entrega)VALUES(@p,'María González','Calle Juárez #14, Col. Centro, Guadalajara','5511000002','Empacado','RT-000022-2026','2026-03-26 09:00:00',NULL);

-- Venta 23
INSERT INTO pedidos(id_cliente,fecha,total,estatus)VALUES(@c03,'2026-03-22 12:30:00',299.00,'Enviado');SET @p=LAST_INSERT_ID();
INSERT INTO detalle_pedido(id_pedido,id_producto,cantidad,subtotal)VALUES(@p,(SELECT id_producto FROM productos WHERE nombre='Batería Xiaomi Redmi Note 11 5000mAh' LIMIT 1),1,299.00);
INSERT INTO envios(id_pedido,nombre_cliente,direccion,telefono,estatus,folio_rastreo,fecha_envio,fecha_entrega)VALUES(@p,'Luis Ramírez','Blvd. Hidalgo #21, Col. Obrera, Monterrey','5511000003','Entregado','RT-000023-2026','2026-03-23 09:00:00','2026-03-25 11:00:00');

-- Venta 24
INSERT INTO pedidos(id_cliente,fecha,total,estatus)VALUES(@c04,'2026-03-20 10:45:00',649.00,'Pagado');SET @p=LAST_INSERT_ID();
INSERT INTO detalle_pedido(id_pedido,id_producto,cantidad,subtotal)VALUES(@p,(SELECT id_producto FROM productos WHERE nombre='Cargador USB-C 65W GaN Anker' LIMIT 1),1,649.00);
INSERT INTO envios(id_pedido,nombre_cliente,direccion,telefono,estatus,folio_rastreo,fecha_envio,fecha_entrega)VALUES(@p,'Ana Torres','Calle Morelos #28, Col. Doctores, CDMX','5511000004','En procesamiento','RT-000024-2026','2026-03-21 09:00:00',NULL);

-- Venta 25
INSERT INTO pedidos(id_cliente,fecha,total,estatus)VALUES(@c05,'2026-03-17 16:15:00',899.00,'Enviado');SET @p=LAST_INSERT_ID();
INSERT INTO detalle_pedido(id_pedido,id_producto,cantidad,subtotal)VALUES(@p,(SELECT id_producto FROM productos WHERE nombre='Cargador MagSafe 15W iPhone Original' LIMIT 1),1,899.00);
INSERT INTO envios(id_pedido,nombre_cliente,direccion,telefono,estatus,folio_rastreo,fecha_envio,fecha_entrega)VALUES(@p,'Pedro Hernández','Av. Revolución #35, Col. Mixcoac, CDMX','5511000005','En camino','RT-000025-2026','2026-03-18 09:00:00',NULL);

-- Venta 26
INSERT INTO pedidos(id_cliente,fecha,total,estatus)VALUES(@c06,'2026-03-15 09:30:00',549.00,'Pagado');SET @p=LAST_INSERT_ID();
INSERT INTO detalle_pedido(id_pedido,id_producto,cantidad,subtotal)VALUES(@p,(SELECT id_producto FROM productos WHERE nombre='Cargador Inalámbrico 15W Qi2' LIMIT 1),1,549.00);
INSERT INTO envios(id_pedido,nombre_cliente,direccion,telefono,estatus,folio_rastreo,fecha_envio,fecha_entrega)VALUES(@p,'Sofía López','Calle Madero #42, Col. Chapultepec, Guadalajara','5511000006','Empacado','RT-000026-2026','2026-03-16 09:00:00',NULL);

-- Venta 27
INSERT INTO pedidos(id_cliente,fecha,total,estatus)VALUES(@c07,'2026-03-12 11:00:00',1899.00,'Enviado');SET @p=LAST_INSERT_ID();
INSERT INTO detalle_pedido(id_pedido,id_producto,cantidad,subtotal)VALUES(@p,(SELECT id_producto FROM productos WHERE nombre='Pantalla iPhone 13 OLED Premium' LIMIT 1),1,1899.00);
INSERT INTO envios(id_pedido,nombre_cliente,direccion,telefono,estatus,folio_rastreo,fecha_envio,fecha_entrega)VALUES(@p,'Diego Martínez','Blvd. Independencia #49, Col. Las Quintas, Culiacán','5511000007','Entregado','RT-000027-2026','2026-03-13 09:00:00','2026-03-15 13:00:00');

-- Venta 28
INSERT INTO pedidos(id_cliente,fecha,total,estatus)VALUES(@c08,'2026-03-10 14:00:00',1599.00,'Pagado');SET @p=LAST_INSERT_ID();
INSERT INTO detalle_pedido(id_pedido,id_producto,cantidad,subtotal)VALUES(@p,(SELECT id_producto FROM productos WHERE nombre='Pantalla iPhone 12 OLED' LIMIT 1),1,1599.00);
INSERT INTO envios(id_pedido,nombre_cliente,direccion,telefono,estatus,folio_rastreo,fecha_envio,fecha_entrega)VALUES(@p,'Valentina Cruz','Av. Universidad #56, Col. Copilco, CDMX','5511000008','En procesamiento','RT-000028-2026','2026-03-11 09:00:00',NULL);

-- Venta 29
INSERT INTO pedidos(id_cliente,fecha,total,estatus)VALUES(@c09,'2026-03-07 10:30:00',2199.00,'Pagado');SET @p=LAST_INSERT_ID();
INSERT INTO detalle_pedido(id_pedido,id_producto,cantidad,subtotal)VALUES(@p,(SELECT id_producto FROM productos WHERE nombre='Pantalla Samsung Galaxy S21 Dynamic AMOLED' LIMIT 1),1,2199.00);
INSERT INTO envios(id_pedido,nombre_cliente,direccion,telefono,estatus,folio_rastreo,fecha_envio,fecha_entrega)VALUES(@p,'Andrés Flores','Calle Allende #63, Col. Guerrero, CDMX','5511000009','Empacado','RT-000029-2026','2026-03-08 09:00:00',NULL);

-- Venta 30
INSERT INTO pedidos(id_cliente,fecha,total,estatus)VALUES(@c10,'2026-03-05 15:45:00',1299.00,'Enviado');SET @p=LAST_INSERT_ID();
INSERT INTO detalle_pedido(id_pedido,id_producto,cantidad,subtotal)VALUES(@p,(SELECT id_producto FROM productos WHERE nombre='Pantalla Samsung Galaxy A52 AMOLED' LIMIT 1),1,1299.00);
INSERT INTO envios(id_pedido,nombre_cliente,direccion,telefono,estatus,folio_rastreo,fecha_envio,fecha_entrega)VALUES(@p,'Gabriela Sánchez','Av. Chapultepec #70, Col. Roma, CDMX','5511000010','Entregado','RT-000030-2026','2026-03-06 09:00:00','2026-03-08 12:00:00');

-- Venta 31
INSERT INTO pedidos(id_cliente,fecha,total,estatus)VALUES(@c11,'2026-02-28 09:00:00',999.00,'Pagado');SET @p=LAST_INSERT_ID();
INSERT INTO detalle_pedido(id_pedido,id_producto,cantidad,subtotal)VALUES(@p,(SELECT id_producto FROM productos WHERE nombre='Pantalla Xiaomi Redmi Note 12 AMOLED' LIMIT 1),1,999.00);
INSERT INTO envios(id_pedido,nombre_cliente,direccion,telefono,estatus,folio_rastreo,fecha_envio,fecha_entrega)VALUES(@p,'Roberto Jiménez','Calle Guerrero #77, Col. Tlatilco, CDMX','5511000011','En procesamiento','RT-000031-2026','2026-03-01 09:00:00',NULL);

-- Venta 32
INSERT INTO pedidos(id_cliente,fecha,total,estatus)VALUES(@c12,'2026-02-25 13:00:00',5499.00,'Enviado');SET @p=LAST_INSERT_ID();
INSERT INTO detalle_pedido(id_pedido,id_producto,cantidad,subtotal)VALUES(@p,(SELECT id_producto FROM productos WHERE nombre='AirPods Pro 2da Generación' LIMIT 1),1,5499.00);
INSERT INTO envios(id_pedido,nombre_cliente,direccion,telefono,estatus,folio_rastreo,fecha_envio,fecha_entrega)VALUES(@p,'Claudia Morales','Av. Reforma #84, Col. Polanco, CDMX','5511000012','Entregado','RT-000032-2026','2026-02-26 09:00:00','2026-02-28 14:00:00');

-- Venta 33
INSERT INTO pedidos(id_cliente,fecha,total,estatus)VALUES(@c13,'2026-02-22 10:15:00',3499.00,'Pagado');SET @p=LAST_INSERT_ID();
INSERT INTO detalle_pedido(id_pedido,id_producto,cantidad,subtotal)VALUES(@p,(SELECT id_producto FROM productos WHERE nombre='Samsung Galaxy Buds2 Pro' LIMIT 1),1,3499.00);
INSERT INTO envios(id_pedido,nombre_cliente,direccion,telefono,estatus,folio_rastreo,fecha_envio,fecha_entrega)VALUES(@p,'Fernando Reyes','Calle Zaragoza #91, Col. Narvarte, CDMX','5511000013','Empacado','RT-000033-2026','2026-02-23 09:00:00',NULL);

-- Venta 34
INSERT INTO pedidos(id_cliente,fecha,total,estatus)VALUES(@c14,'2026-02-20 14:30:00',1999.00,'Pagado');SET @p=LAST_INSERT_ID();
INSERT INTO detalle_pedido(id_pedido,id_producto,cantidad,subtotal)VALUES(@p,(SELECT id_producto FROM productos WHERE nombre='JBL Tune 770NC Inalámbricos' LIMIT 1),1,1999.00);
INSERT INTO envios(id_pedido,nombre_cliente,direccion,telefono,estatus,folio_rastreo,fecha_envio,fecha_entrega)VALUES(@p,'Patricia Vargas','Blvd. Díaz Mirón #98, Col. Formando Hogar, Veracruz','5511000014','En procesamiento','RT-000034-2026','2026-02-21 09:00:00',NULL);

-- Venta 35
INSERT INTO pedidos(id_cliente,fecha,total,estatus)VALUES(@c15,'2026-02-17 11:45:00',7499.00,'Enviado');SET @p=LAST_INSERT_ID();
INSERT INTO detalle_pedido(id_pedido,id_producto,cantidad,subtotal)VALUES(@p,(SELECT id_producto FROM productos WHERE nombre='Sony WH-1000XM5 Over-Ear' LIMIT 1),1,7499.00);
INSERT INTO envios(id_pedido,nombre_cliente,direccion,telefono,estatus,folio_rastreo,fecha_envio,fecha_entrega)VALUES(@p,'Javier Castillo','Av. 20 de Noviembre #105, Col. Centro, Puebla','5511000015','Entregado','RT-000035-2026','2026-02-18 09:00:00','2026-02-20 12:00:00');

-- Venta 36
INSERT INTO pedidos(id_cliente,fecha,total,estatus)VALUES(@c16,'2026-02-15 09:30:00',349.00,'Pagado');SET @p=LAST_INSERT_ID();
INSERT INTO detalle_pedido(id_pedido,id_producto,cantidad,subtotal)VALUES(@p,(SELECT id_producto FROM productos WHERE nombre='Funda MagSafe iPhone 15 Pro Spigen' LIMIT 1),1,349.00);
INSERT INTO envios(id_pedido,nombre_cliente,direccion,telefono,estatus,folio_rastreo,fecha_envio,fecha_entrega)VALUES(@p,'Mónica Gutiérrez','Calle Ocampo #112, Col. Centenario, León','5511000016','Empacado','RT-000036-2026','2026-02-16 09:00:00',NULL);

-- Venta 37
INSERT INTO pedidos(id_cliente,fecha,total,estatus)VALUES(@c17,'2026-02-12 16:00:00',299.00,'Enviado');SET @p=LAST_INSERT_ID();
INSERT INTO detalle_pedido(id_pedido,id_producto,cantidad,subtotal)VALUES(@p,(SELECT id_producto FROM productos WHERE nombre='Funda Samsung Galaxy S24 Ultra Armor' LIMIT 1),1,299.00);
INSERT INTO envios(id_pedido,nombre_cliente,direccion,telefono,estatus,folio_rastreo,fecha_envio,fecha_entrega)VALUES(@p,'Héctor Díaz','Av. Lázaro Cárdenas #119, Col. del Valle, CDMX','5511000017','En camino','RT-000037-2026','2026-02-13 09:00:00',NULL);

-- Venta 38
INSERT INTO pedidos(id_cliente,fecha,total,estatus)VALUES(@c18,'2026-02-10 10:00:00',599.00,'Pagado');SET @p=LAST_INSERT_ID();
INSERT INTO detalle_pedido(id_pedido,id_producto,cantidad,subtotal)VALUES(@p,(SELECT id_producto FROM productos WHERE nombre='Funda Folio iPhone 14 Cuero Genuino' LIMIT 1),1,599.00);
INSERT INTO envios(id_pedido,nombre_cliente,direccion,telefono,estatus,folio_rastreo,fecha_envio,fecha_entrega)VALUES(@p,'Lucía Pérez','Calle Victoria #126, Col. Estrella, CDMX','5511000018','En procesamiento','RT-000038-2026','2026-02-11 09:00:00',NULL);

-- Venta 39
INSERT INTO pedidos(id_cliente,fecha,total,estatus)VALUES(@c19,'2026-02-07 13:20:00',99.00,'Pagado');SET @p=LAST_INSERT_ID();
INSERT INTO detalle_pedido(id_pedido,id_producto,cantidad,subtotal)VALUES(@p,(SELECT id_producto FROM productos WHERE nombre='Funda Transparente Xiaomi Redmi Note 12' LIMIT 1),1,99.00);
INSERT INTO envios(id_pedido,nombre_cliente,direccion,telefono,estatus,folio_rastreo,fecha_envio,fecha_entrega)VALUES(@p,'Eduardo Ríos','Blvd. Torres Quintero #133, Col. Esperanza, Culiacán','5511000019','Empacado','RT-000039-2026','2026-02-08 09:00:00',NULL);

-- Venta 40
INSERT INTO pedidos(id_cliente,fecha,total,estatus)VALUES(@c20,'2026-02-05 15:30:00',149.00,'Enviado');SET @p=LAST_INSERT_ID();
INSERT INTO detalle_pedido(id_pedido,id_producto,cantidad,subtotal)VALUES(@p,(SELECT id_producto FROM productos WHERE nombre='Vidrio Templado iPhone 15 / 15 Pro 2-Pack' LIMIT 1),1,149.00);
INSERT INTO envios(id_pedido,nombre_cliente,direccion,telefono,estatus,folio_rastreo,fecha_envio,fecha_entrega)VALUES(@p,'Isabel Rojas','Av. Niños Héroes #140, Col. Americana, Guadalajara','5511000020','Entregado','RT-000040-2026','2026-02-06 09:00:00','2026-02-08 11:00:00');

-- Venta 41
INSERT INTO pedidos(id_cliente,fecha,total,estatus)VALUES(@c01,'2026-01-28 10:00:00',169.00,'Pagado');SET @p=LAST_INSERT_ID();
INSERT INTO detalle_pedido(id_pedido,id_producto,cantidad,subtotal)VALUES(@p,(SELECT id_producto FROM productos WHERE nombre='Vidrio Templado Samsung Galaxy S23 Ultra' LIMIT 1),1,169.00);
INSERT INTO envios(id_pedido,nombre_cliente,direccion,telefono,estatus,folio_rastreo,fecha_envio,fecha_entrega)VALUES(@p,'Carlos Mendoza','Av. Insurgentes Sur #7, Col. San Ángel, CDMX','5511000001','En procesamiento','RT-000041-2026','2026-01-29 09:00:00',NULL);

-- Venta 42
INSERT INTO pedidos(id_cliente,fecha,total,estatus)VALUES(@c02,'2026-01-25 14:15:00',99.00,'Pagado');SET @p=LAST_INSERT_ID();
INSERT INTO detalle_pedido(id_pedido,id_producto,cantidad,subtotal)VALUES(@p,(SELECT id_producto FROM productos WHERE nombre='Vidrio Templado Xiaomi Redmi Note 13 Pro' LIMIT 1),1,99.00);
INSERT INTO envios(id_pedido,nombre_cliente,direccion,telefono,estatus,folio_rastreo,fecha_envio,fecha_entrega)VALUES(@p,'María González','Calle Juárez #14, Col. Centro, Guadalajara','5511000002','Empacado','RT-000042-2026','2026-01-26 09:00:00',NULL);

-- Venta 43
INSERT INTO pedidos(id_cliente,fecha,total,estatus)VALUES(@c03,'2026-01-22 11:30:00',249.00,'Enviado');SET @p=LAST_INSERT_ID();
INSERT INTO detalle_pedido(id_pedido,id_producto,cantidad,subtotal)VALUES(@p,(SELECT id_producto FROM productos WHERE nombre='Cable USB-C a USB-C 2m 100W Anker' LIMIT 1),1,249.00);
INSERT INTO envios(id_pedido,nombre_cliente,direccion,telefono,estatus,folio_rastreo,fecha_envio,fecha_entrega)VALUES(@p,'Luis Ramírez','Blvd. Hidalgo #21, Col. Obrera, Monterrey','5511000003','Entregado','RT-000043-2026','2026-01-23 09:00:00','2026-01-25 12:00:00');

-- Venta 44
INSERT INTO pedidos(id_cliente,fecha,total,estatus)VALUES(@c04,'2026-01-20 09:45:00',299.00,'Pagado');SET @p=LAST_INSERT_ID();
INSERT INTO detalle_pedido(id_pedido,id_producto,cantidad,subtotal)VALUES(@p,(SELECT id_producto FROM productos WHERE nombre='Cable Lightning MFi 1m Belkin' LIMIT 1),1,299.00);
INSERT INTO envios(id_pedido,nombre_cliente,direccion,telefono,estatus,folio_rastreo,fecha_envio,fecha_entrega)VALUES(@p,'Ana Torres','Calle Morelos #28, Col. Doctores, CDMX','5511000004','En procesamiento','RT-000044-2026','2026-01-21 09:00:00',NULL);

-- Venta 45
INSERT INTO pedidos(id_cliente,fecha,total,estatus)VALUES(@c05,'2026-01-17 15:00:00',499.00,'Enviado');SET @p=LAST_INSERT_ID();
INSERT INTO detalle_pedido(id_pedido,id_producto,cantidad,subtotal)VALUES(@p,(SELECT id_producto FROM productos WHERE nombre='Cable USB-C a Lightning 1m Apple Original' LIMIT 1),1,499.00);
INSERT INTO envios(id_pedido,nombre_cliente,direccion,telefono,estatus,folio_rastreo,fecha_envio,fecha_entrega)VALUES(@p,'Pedro Hernández','Av. Revolución #35, Col. Mixcoac, CDMX','5511000005','En camino','RT-000045-2026','2026-01-18 09:00:00',NULL);

-- Venta 46
INSERT INTO pedidos(id_cliente,fecha,total,estatus)VALUES(@c06,'2026-01-15 10:30:00',11999.00,'Pagado');SET @p=LAST_INSERT_ID();
INSERT INTO detalle_pedido(id_pedido,id_producto,cantidad,subtotal)VALUES(@p,(SELECT id_producto FROM productos WHERE nombre='Apple Watch Series 9 41mm GPS' LIMIT 1),1,11999.00);
INSERT INTO envios(id_pedido,nombre_cliente,direccion,telefono,estatus,folio_rastreo,fecha_envio,fecha_entrega)VALUES(@p,'Sofía López','Calle Madero #42, Col. Chapultepec, Guadalajara','5511000006','Empacado','RT-000046-2026','2026-01-16 09:00:00',NULL);

-- Venta 47
INSERT INTO pedidos(id_cliente,fecha,total,estatus)VALUES(@c07,'2026-01-12 13:00:00',7499.00,'Enviado');SET @p=LAST_INSERT_ID();
INSERT INTO detalle_pedido(id_pedido,id_producto,cantidad,subtotal)VALUES(@p,(SELECT id_producto FROM productos WHERE nombre='Samsung Galaxy Watch 6 44mm' LIMIT 1),1,7499.00);
INSERT INTO envios(id_pedido,nombre_cliente,direccion,telefono,estatus,folio_rastreo,fecha_envio,fecha_entrega)VALUES(@p,'Diego Martínez','Blvd. Independencia #49, Col. Las Quintas, Culiacán','5511000007','Entregado','RT-000047-2026','2026-01-13 09:00:00','2026-01-15 14:00:00');

-- Venta 48
INSERT INTO pedidos(id_cliente,fecha,total,estatus)VALUES(@c08,'2026-01-10 09:00:00',1499.00,'Pagado');SET @p=LAST_INSERT_ID();
INSERT INTO detalle_pedido(id_pedido,id_producto,cantidad,subtotal)VALUES(@p,(SELECT id_producto FROM productos WHERE nombre='Xiaomi Smart Band 8 Pro' LIMIT 1),1,1499.00);
INSERT INTO envios(id_pedido,nombre_cliente,direccion,telefono,estatus,folio_rastreo,fecha_envio,fecha_entrega)VALUES(@p,'Valentina Cruz','Av. Universidad #56, Col. Copilco, CDMX','5511000008','En procesamiento','RT-000048-2026','2026-01-11 09:00:00',NULL);

-- Venta 49
INSERT INTO pedidos(id_cliente,fecha,total,estatus)VALUES(@c09,'2026-01-07 11:45:00',349.00,'Pagado');SET @p=LAST_INSERT_ID();
INSERT INTO detalle_pedido(id_pedido,id_producto,cantidad,subtotal)VALUES(@p,(SELECT id_producto FROM productos WHERE nombre='Kit Destornilladores Precisión 38 en 1' LIMIT 1),1,349.00);
INSERT INTO envios(id_pedido,nombre_cliente,direccion,telefono,estatus,folio_rastreo,fecha_envio,fecha_entrega)VALUES(@p,'Andrés Flores','Calle Allende #63, Col. Guerrero, CDMX','5511000009','Empacado','RT-000049-2026','2026-01-08 09:00:00',NULL);

-- Venta 50
INSERT INTO pedidos(id_cliente,fecha,total,estatus)VALUES(@c10,'2026-01-05 14:30:00',799.00,'Enviado');SET @p=LAST_INSERT_ID();
INSERT INTO detalle_pedido(id_pedido,id_producto,cantidad,subtotal)VALUES(@p,(SELECT id_producto FROM productos WHERE nombre='Pistola de Calor Digital 110V Profesional' LIMIT 1),1,799.00);
INSERT INTO envios(id_pedido,nombre_cliente,direccion,telefono,estatus,folio_rastreo,fecha_envio,fecha_entrega)VALUES(@p,'Gabriela Sánchez','Av. Chapultepec #70, Col. Roma, CDMX','5511000010','Entregado','RT-000050-2026','2026-01-06 09:00:00','2026-01-08 12:00:00');

-- Venta 51
INSERT INTO pedidos(id_cliente,fecha,total,estatus)VALUES(@c11,'2025-12-28 10:00:00',27999.00,'Enviado');SET @p=LAST_INSERT_ID();
INSERT INTO detalle_pedido(id_pedido,id_producto,cantidad,subtotal)VALUES(@p,(SELECT id_producto FROM productos WHERE nombre='iPhone 15 Pro Max 256GB' LIMIT 1),1,27999.00);
INSERT INTO envios(id_pedido,nombre_cliente,direccion,telefono,estatus,folio_rastreo,fecha_envio,fecha_entrega)VALUES(@p,'Roberto Jiménez','Calle Guerrero #77, Col. Tlatilco, CDMX','5511000011','Entregado','RT-000051-2025','2025-12-29 09:00:00','2025-12-31 14:00:00');

-- Venta 52
INSERT INTO pedidos(id_cliente,fecha,total,estatus)VALUES(@c12,'2025-12-25 12:00:00',29999.00,'Pagado');SET @p=LAST_INSERT_ID();
INSERT INTO detalle_pedido(id_pedido,id_producto,cantidad,subtotal)VALUES(@p,(SELECT id_producto FROM productos WHERE nombre='Samsung Galaxy S24 Ultra 256GB' LIMIT 1),1,29999.00);
INSERT INTO envios(id_pedido,nombre_cliente,direccion,telefono,estatus,folio_rastreo,fecha_envio,fecha_entrega)VALUES(@p,'Claudia Morales','Av. Reforma #84, Col. Polanco, CDMX','5511000012','En procesamiento','RT-000052-2025','2025-12-26 09:00:00',NULL);

-- Venta 53
INSERT INTO pedidos(id_cliente,fecha,total,estatus)VALUES(@c13,'2025-12-22 15:30:00',28999.00,'Enviado');SET @p=LAST_INSERT_ID();
INSERT INTO detalle_pedido(id_pedido,id_producto,cantidad,subtotal)VALUES(@p,(SELECT id_producto FROM productos WHERE nombre='MacBook Air 13" M2 8GB/256GB' LIMIT 1),1,28999.00);
INSERT INTO envios(id_pedido,nombre_cliente,direccion,telefono,estatus,folio_rastreo,fecha_envio,fecha_entrega)VALUES(@p,'Fernando Reyes','Calle Zaragoza #91, Col. Narvarte, CDMX','5511000013','Entregado','RT-000053-2025','2025-12-23 09:00:00','2025-12-25 12:00:00');

-- Venta 54
INSERT INTO pedidos(id_cliente,fecha,total,estatus)VALUES(@c14,'2025-12-20 09:15:00',5499.00,'Pagado');SET @p=LAST_INSERT_ID();
INSERT INTO detalle_pedido(id_pedido,id_producto,cantidad,subtotal)VALUES(@p,(SELECT id_producto FROM productos WHERE nombre='AirPods Pro 2da Generación' LIMIT 1),1,5499.00);
INSERT INTO envios(id_pedido,nombre_cliente,direccion,telefono,estatus,folio_rastreo,fecha_envio,fecha_entrega)VALUES(@p,'Patricia Vargas','Blvd. Díaz Mirón #98, Col. Formando Hogar, Veracruz','5511000014','Empacado','RT-000054-2025','2025-12-21 09:00:00',NULL);

-- Venta 55
INSERT INTO pedidos(id_cliente,fecha,total,estatus)VALUES(@c15,'2025-12-17 14:00:00',11999.00,'Enviado');SET @p=LAST_INSERT_ID();
INSERT INTO detalle_pedido(id_pedido,id_producto,cantidad,subtotal)VALUES(@p,(SELECT id_producto FROM productos WHERE nombre='Apple Watch Series 9 41mm GPS' LIMIT 1),1,11999.00);
INSERT INTO envios(id_pedido,nombre_cliente,direccion,telefono,estatus,folio_rastreo,fecha_envio,fecha_entrega)VALUES(@p,'Javier Castillo','Av. 20 de Noviembre #105, Col. Centro, Puebla','5511000015','En camino','RT-000055-2025','2025-12-18 09:00:00',NULL);

-- Venta 56
INSERT INTO pedidos(id_cliente,fecha,total,estatus)VALUES(@c16,'2025-12-15 10:45:00',32999.00,'Pagado');SET @p=LAST_INSERT_ID();
INSERT INTO detalle_pedido(id_pedido,id_producto,cantidad,subtotal)VALUES(@p,(SELECT id_producto FROM productos WHERE nombre='iPad Pro 12.9" M2 256GB Wi-Fi' LIMIT 1),1,32999.00);
INSERT INTO envios(id_pedido,nombre_cliente,direccion,telefono,estatus,folio_rastreo,fecha_envio,fecha_entrega)VALUES(@p,'Mónica Gutiérrez','Calle Ocampo #112, Col. Centenario, León','5511000016','En procesamiento','RT-000056-2025','2025-12-16 09:00:00',NULL);

-- Venta 57
INSERT INTO pedidos(id_cliente,fecha,total,estatus)VALUES(@c17,'2025-12-12 13:30:00',7499.00,'Enviado');SET @p=LAST_INSERT_ID();
INSERT INTO detalle_pedido(id_pedido,id_producto,cantidad,subtotal)VALUES(@p,(SELECT id_producto FROM productos WHERE nombre='Sony WH-1000XM5 Over-Ear' LIMIT 1),1,7499.00);
INSERT INTO envios(id_pedido,nombre_cliente,direccion,telefono,estatus,folio_rastreo,fecha_envio,fecha_entrega)VALUES(@p,'Héctor Díaz','Av. Lázaro Cárdenas #119, Col. del Valle, CDMX','5511000017','Entregado','RT-000057-2025','2025-12-13 09:00:00','2025-12-15 11:00:00');

-- Venta 58
INSERT INTO pedidos(id_cliente,fecha,total,estatus)VALUES(@c18,'2025-12-10 09:00:00',20999.00,'Pagado');SET @p=LAST_INSERT_ID();
INSERT INTO detalle_pedido(id_pedido,id_producto,cantidad,subtotal)VALUES(@p,(SELECT id_producto FROM productos WHERE nombre='Google Pixel 8 Pro 128GB' LIMIT 1),1,20999.00);
INSERT INTO envios(id_pedido,nombre_cliente,direccion,telefono,estatus,folio_rastreo,fecha_envio,fecha_entrega)VALUES(@p,'Lucía Pérez','Calle Victoria #126, Col. Estrella, CDMX','5511000018','Empacado','RT-000058-2025','2025-12-11 09:00:00',NULL);

-- Venta 59
INSERT INTO pedidos(id_cliente,fecha,total,estatus)VALUES(@c19,'2025-12-07 16:00:00',35999.00,'Enviado');SET @p=LAST_INSERT_ID();
INSERT INTO detalle_pedido(id_pedido,id_producto,cantidad,subtotal)VALUES(@p,(SELECT id_producto FROM productos WHERE nombre='Lenovo ThinkPad X1 Carbon i7 16GB' LIMIT 1),1,35999.00);
INSERT INTO envios(id_pedido,nombre_cliente,direccion,telefono,estatus,folio_rastreo,fecha_envio,fecha_entrega)VALUES(@p,'Eduardo Ríos','Blvd. Torres Quintero #133, Col. Esperanza, Culiacán','5511000019','Entregado','RT-000059-2025','2025-12-08 09:00:00','2025-12-10 13:00:00');

-- Venta 60
INSERT INTO pedidos(id_cliente,fecha,total,estatus)VALUES(@c20,'2025-12-05 11:00:00',24999.00,'Pagado');SET @p=LAST_INSERT_ID();
INSERT INTO detalle_pedido(id_pedido,id_producto,cantidad,subtotal)VALUES(@p,(SELECT id_producto FROM productos WHERE nombre='Dell XPS 13 Core i7 16GB/512GB' LIMIT 1),1,24999.00);
INSERT INTO envios(id_pedido,nombre_cliente,direccion,telefono,estatus,folio_rastreo,fecha_envio,fecha_entrega)VALUES(@p,'Isabel Rojas','Av. Niños Héroes #140, Col. Americana, Guadalajara','5511000020','En procesamiento','RT-000060-2025','2025-12-06 09:00:00',NULL);

-- Venta 61
INSERT INTO pedidos(id_cliente,fecha,total,estatus)VALUES(@c01,'2025-11-28 10:30:00',1899.00,'Enviado');SET @p=LAST_INSERT_ID();
INSERT INTO detalle_pedido(id_pedido,id_producto,cantidad,subtotal)VALUES(@p,(SELECT id_producto FROM productos WHERE nombre='Pantalla iPhone 13 OLED Premium' LIMIT 1),1,1899.00);
INSERT INTO envios(id_pedido,nombre_cliente,direccion,telefono,estatus,folio_rastreo,fecha_envio,fecha_entrega)VALUES(@p,'Carlos Mendoza','Av. Insurgentes Sur #7, Col. San Ángel, CDMX','5511000001','Entregado','RT-000061-2025','2025-11-29 09:00:00','2025-12-01 12:00:00');

-- Venta 62
INSERT INTO pedidos(id_cliente,fecha,total,estatus)VALUES(@c02,'2025-11-25 14:00:00',399.00,'Pagado');SET @p=LAST_INSERT_ID();
INSERT INTO detalle_pedido(id_pedido,id_producto,cantidad,subtotal)VALUES(@p,(SELECT id_producto FROM productos WHERE nombre='Batería iPhone 14/15 Premium 3279mAh' LIMIT 1),1,399.00);
INSERT INTO envios(id_pedido,nombre_cliente,direccion,telefono,estatus,folio_rastreo,fecha_envio,fecha_entrega)VALUES(@p,'María González','Calle Juárez #14, Col. Centro, Guadalajara','5511000002','Empacado','RT-000062-2025','2025-11-26 09:00:00',NULL);

-- Venta 63
INSERT INTO pedidos(id_cliente,fecha,total,estatus)VALUES(@c03,'2025-11-22 09:15:00',899.00,'Pagado');SET @p=LAST_INSERT_ID();
INSERT INTO detalle_pedido(id_pedido,id_producto,cantidad,subtotal)VALUES(@p,(SELECT id_producto FROM productos WHERE nombre='Cargador MagSafe 15W iPhone Original' LIMIT 1),1,899.00);
INSERT INTO envios(id_pedido,nombre_cliente,direccion,telefono,estatus,folio_rastreo,fecha_envio,fecha_entrega)VALUES(@p,'Luis Ramírez','Blvd. Hidalgo #21, Col. Obrera, Monterrey','5511000003','En procesamiento','RT-000063-2025','2025-11-23 09:00:00',NULL);

-- Venta 64
INSERT INTO pedidos(id_cliente,fecha,total,estatus)VALUES(@c04,'2025-11-20 12:45:00',599.00,'Enviado');SET @p=LAST_INSERT_ID();
INSERT INTO detalle_pedido(id_pedido,id_producto,cantidad,subtotal)VALUES(@p,(SELECT id_producto FROM productos WHERE nombre='Funda Folio iPhone 14 Cuero Genuino' LIMIT 1),1,599.00);
INSERT INTO envios(id_pedido,nombre_cliente,direccion,telefono,estatus,folio_rastreo,fecha_envio,fecha_entrega)VALUES(@p,'Ana Torres','Calle Morelos #28, Col. Doctores, CDMX','5511000004','Entregado','RT-000064-2025','2025-11-21 09:00:00','2025-11-23 14:00:00');

-- Venta 65
INSERT INTO pedidos(id_cliente,fecha,total,estatus)VALUES(@c05,'2025-11-17 15:30:00',9999.00,'Pagado');SET @p=LAST_INSERT_ID();
INSERT INTO detalle_pedido(id_pedido,id_producto,cantidad,subtotal)VALUES(@p,(SELECT id_producto FROM productos WHERE nombre='Samsung Galaxy A55 128GB' LIMIT 1),1,9999.00);
INSERT INTO envios(id_pedido,nombre_cliente,direccion,telefono,estatus,folio_rastreo,fecha_envio,fecha_entrega)VALUES(@p,'Pedro Hernández','Av. Revolución #35, Col. Mixcoac, CDMX','5511000005','Empacado','RT-000065-2025','2025-11-18 09:00:00',NULL);

-- Venta 66
INSERT INTO pedidos(id_cliente,fecha,total,estatus)VALUES(@c06,'2025-11-15 10:00:00',7499.00,'Enviado');SET @p=LAST_INSERT_ID();
INSERT INTO detalle_pedido(id_pedido,id_producto,cantidad,subtotal)VALUES(@p,(SELECT id_producto FROM productos WHERE nombre='Xiaomi Redmi Note 13 Pro 128GB' LIMIT 1),1,7499.00);
INSERT INTO envios(id_pedido,nombre_cliente,direccion,telefono,estatus,folio_rastreo,fecha_envio,fecha_entrega)VALUES(@p,'Sofía López','Calle Madero #42, Col. Chapultepec, Guadalajara','5511000006','En camino','RT-000066-2025','2025-11-16 09:00:00',NULL);

-- Venta 67
INSERT INTO pedidos(id_cliente,fecha,total,estatus)VALUES(@c07,'2025-11-12 13:15:00',15999.00,'Pagado');SET @p=LAST_INSERT_ID();
INSERT INTO detalle_pedido(id_pedido,id_producto,cantidad,subtotal)VALUES(@p,(SELECT id_producto FROM productos WHERE nombre='iPad Air 10.9" 64GB' LIMIT 1),1,15999.00);
INSERT INTO envios(id_pedido,nombre_cliente,direccion,telefono,estatus,folio_rastreo,fecha_envio,fecha_entrega)VALUES(@p,'Diego Martínez','Blvd. Independencia #49, Col. Las Quintas, Culiacán','5511000007','En procesamiento','RT-000067-2025','2025-11-13 09:00:00',NULL);

-- Venta 68
INSERT INTO pedidos(id_cliente,fecha,total,estatus)VALUES(@c08,'2025-11-10 11:30:00',13999.00,'Enviado');SET @p=LAST_INSERT_ID();
INSERT INTO detalle_pedido(id_pedido,id_producto,cantidad,subtotal)VALUES(@p,(SELECT id_producto FROM productos WHERE nombre='HP Pavilion 15 Core i5 8GB/512GB' LIMIT 1),1,13999.00);
INSERT INTO envios(id_pedido,nombre_cliente,direccion,telefono,estatus,folio_rastreo,fecha_envio,fecha_entrega)VALUES(@p,'Valentina Cruz','Av. Universidad #56, Col. Copilco, CDMX','5511000008','Entregado','RT-000068-2025','2025-11-11 09:00:00','2025-11-13 12:00:00');

-- Venta 69
INSERT INTO pedidos(id_cliente,fecha,total,estatus)VALUES(@c09,'2025-11-07 09:45:00',3499.00,'Pagado');SET @p=LAST_INSERT_ID();
INSERT INTO detalle_pedido(id_pedido,id_producto,cantidad,subtotal)VALUES(@p,(SELECT id_producto FROM productos WHERE nombre='Samsung Galaxy Buds2 Pro' LIMIT 1),1,3499.00);
INSERT INTO envios(id_pedido,nombre_cliente,direccion,telefono,estatus,folio_rastreo,fecha_envio,fecha_entrega)VALUES(@p,'Andrés Flores','Calle Allende #63, Col. Guerrero, CDMX','5511000009','Empacado','RT-000069-2025','2025-11-08 09:00:00',NULL);

-- Venta 70
INSERT INTO pedidos(id_cliente,fecha,total,estatus)VALUES(@c10,'2025-11-05 14:30:00',1999.00,'Pagado');SET @p=LAST_INSERT_ID();
INSERT INTO detalle_pedido(id_pedido,id_producto,cantidad,subtotal)VALUES(@p,(SELECT id_producto FROM productos WHERE nombre='JBL Tune 770NC Inalámbricos' LIMIT 1),1,1999.00);
INSERT INTO envios(id_pedido,nombre_cliente,direccion,telefono,estatus,folio_rastreo,fecha_envio,fecha_entrega)VALUES(@p,'Gabriela Sánchez','Av. Chapultepec #70, Col. Roma, CDMX','5511000010','En procesamiento','RT-000070-2025','2025-11-06 09:00:00',NULL);

-- Venta 71
INSERT INTO pedidos(id_cliente,fecha,total,estatus)VALUES(@c11,'2025-10-28 10:15:00',18499.00,'Enviado');SET @p=LAST_INSERT_ID();
INSERT INTO detalle_pedido(id_pedido,id_producto,cantidad,subtotal)VALUES(@p,(SELECT id_producto FROM productos WHERE nombre='Xiaomi 14 Pro 256GB' LIMIT 1),1,18499.00);
INSERT INTO envios(id_pedido,nombre_cliente,direccion,telefono,estatus,folio_rastreo,fecha_envio,fecha_entrega)VALUES(@p,'Roberto Jiménez','Calle Guerrero #77, Col. Tlatilco, CDMX','5511000011','Entregado','RT-000071-2025','2025-10-29 09:00:00','2025-10-31 13:00:00');

-- Venta 72
INSERT INTO pedidos(id_cliente,fecha,total,estatus)VALUES(@c12,'2025-10-25 13:00:00',17499.00,'Pagado');SET @p=LAST_INSERT_ID();
INSERT INTO detalle_pedido(id_pedido,id_producto,cantidad,subtotal)VALUES(@p,(SELECT id_producto FROM productos WHERE nombre='OnePlus 12 256GB' LIMIT 1),1,17499.00);
INSERT INTO envios(id_pedido,nombre_cliente,direccion,telefono,estatus,folio_rastreo,fecha_envio,fecha_entrega)VALUES(@p,'Claudia Morales','Av. Reforma #84, Col. Polanco, CDMX','5511000012','Empacado','RT-000072-2025','2025-10-26 09:00:00',NULL);

-- Venta 73
INSERT INTO pedidos(id_cliente,fecha,total,estatus)VALUES(@c13,'2025-10-22 11:30:00',11499.00,'Enviado');SET @p=LAST_INSERT_ID();
INSERT INTO detalle_pedido(id_pedido,id_producto,cantidad,subtotal)VALUES(@p,(SELECT id_producto FROM productos WHERE nombre='Motorola Edge 50 Pro 256GB' LIMIT 1),1,11499.00);
INSERT INTO envios(id_pedido,nombre_cliente,direccion,telefono,estatus,folio_rastreo,fecha_envio,fecha_entrega)VALUES(@p,'Fernando Reyes','Calle Zaragoza #91, Col. Narvarte, CDMX','5511000013','En camino','RT-000073-2025','2025-10-23 09:00:00',NULL);

-- Venta 74
INSERT INTO pedidos(id_cliente,fecha,total,estatus)VALUES(@c14,'2025-10-20 09:30:00',8999.00,'Pagado');SET @p=LAST_INSERT_ID();
INSERT INTO detalle_pedido(id_pedido,id_producto,cantidad,subtotal)VALUES(@p,(SELECT id_producto FROM productos WHERE nombre='Huawei Nova 12 SE 256GB' LIMIT 1),1,8999.00);
INSERT INTO envios(id_pedido,nombre_cliente,direccion,telefono,estatus,folio_rastreo,fecha_envio,fecha_entrega)VALUES(@p,'Patricia Vargas','Blvd. Díaz Mirón #98, Col. Formando Hogar, Veracruz','5511000014','En procesamiento','RT-000074-2025','2025-10-21 09:00:00',NULL);

-- Venta 75
INSERT INTO pedidos(id_cliente,fecha,total,estatus)VALUES(@c15,'2025-10-17 15:00:00',11999.00,'Pagado');SET @p=LAST_INSERT_ID();
INSERT INTO detalle_pedido(id_pedido,id_producto,cantidad,subtotal)VALUES(@p,(SELECT id_producto FROM productos WHERE nombre='Samsung Galaxy Tab S9 FE 256GB' LIMIT 1),1,11999.00);
INSERT INTO envios(id_pedido,nombre_cliente,direccion,telefono,estatus,folio_rastreo,fecha_envio,fecha_entrega)VALUES(@p,'Javier Castillo','Av. 20 de Noviembre #105, Col. Centro, Puebla','5511000015','Empacado','RT-000075-2025','2025-10-18 09:00:00',NULL);

-- Venta 76
INSERT INTO pedidos(id_cliente,fecha,total,estatus)VALUES(@c16,'2025-10-15 10:45:00',10499.00,'Enviado');SET @p=LAST_INSERT_ID();
INSERT INTO detalle_pedido(id_pedido,id_producto,cantidad,subtotal)VALUES(@p,(SELECT id_producto FROM productos WHERE nombre='Xiaomi Pad 6 Pro 256GB' LIMIT 1),1,10499.00);
INSERT INTO envios(id_pedido,nombre_cliente,direccion,telefono,estatus,folio_rastreo,fecha_envio,fecha_entrega)VALUES(@p,'Mónica Gutiérrez','Calle Ocampo #112, Col. Centenario, León','5511000016','Entregado','RT-000076-2025','2025-10-16 09:00:00','2025-10-18 12:00:00');

-- Venta 77
INSERT INTO pedidos(id_cliente,fecha,total,estatus)VALUES(@c17,'2025-10-12 14:15:00',49999.00,'Pagado');SET @p=LAST_INSERT_ID();
INSERT INTO detalle_pedido(id_pedido,id_producto,cantidad,subtotal)VALUES(@p,(SELECT id_producto FROM productos WHERE nombre='MacBook Pro 14" M3 Pro 18GB/512GB' LIMIT 1),1,49999.00);
INSERT INTO envios(id_pedido,nombre_cliente,direccion,telefono,estatus,folio_rastreo,fecha_envio,fecha_entrega)VALUES(@p,'Héctor Díaz','Av. Lázaro Cárdenas #119, Col. del Valle, CDMX','5511000017','En procesamiento','RT-000077-2025','2025-10-13 09:00:00',NULL);

-- Venta 78
INSERT INTO pedidos(id_cliente,fecha,total,estatus)VALUES(@c18,'2025-10-10 09:00:00',19499.00,'Enviado');SET @p=LAST_INSERT_ID();
INSERT INTO detalle_pedido(id_pedido,id_producto,cantidad,subtotal)VALUES(@p,(SELECT id_producto FROM productos WHERE nombre='Asus ZenBook 14 OLED Ryzen 7 16GB' LIMIT 1),1,19499.00);
INSERT INTO envios(id_pedido,nombre_cliente,direccion,telefono,estatus,folio_rastreo,fecha_envio,fecha_entrega)VALUES(@p,'Lucía Pérez','Calle Victoria #126, Col. Estrella, CDMX','5511000018','Entregado','RT-000078-2025','2025-10-11 09:00:00','2025-10-13 14:00:00');

-- Venta 79
INSERT INTO pedidos(id_cliente,fecha,total,estatus)VALUES(@c19,'2025-10-07 12:30:00',649.00,'Pagado');SET @p=LAST_INSERT_ID();
INSERT INTO detalle_pedido(id_pedido,id_producto,cantidad,subtotal)VALUES(@p,(SELECT id_producto FROM productos WHERE nombre='Cargador USB-C 65W GaN Anker' LIMIT 1),1,649.00);
INSERT INTO envios(id_pedido,nombre_cliente,direccion,telefono,estatus,folio_rastreo,fecha_envio,fecha_entrega)VALUES(@p,'Eduardo Ríos','Blvd. Torres Quintero #133, Col. Esperanza, Culiacán','5511000019','Empacado','RT-000079-2025','2025-10-08 09:00:00',NULL);

-- Venta 80
INSERT INTO pedidos(id_cliente,fecha,total,estatus)VALUES(@c20,'2025-10-05 11:00:00',298.00,'Pagado');SET @p=LAST_INSERT_ID();
INSERT INTO detalle_pedido(id_pedido,id_producto,cantidad,subtotal)VALUES(@p,(SELECT id_producto FROM productos WHERE nombre='Vidrio Templado iPhone 15 / 15 Pro 2-Pack' LIMIT 1),2,298.00);
INSERT INTO envios(id_pedido,nombre_cliente,direccion,telefono,estatus,folio_rastreo,fecha_envio,fecha_entrega)VALUES(@p,'Isabel Rojas','Av. Niños Héroes #140, Col. Americana, Guadalajara','5511000020','En procesamiento','RT-000080-2025','2025-10-06 09:00:00',NULL);

-- Venta 81
INSERT INTO pedidos(id_cliente,fecha,total,estatus)VALUES(@c01,'2025-09-28 10:00:00',249.00,'Enviado');SET @p=LAST_INSERT_ID();
INSERT INTO detalle_pedido(id_pedido,id_producto,cantidad,subtotal)VALUES(@p,(SELECT id_producto FROM productos WHERE nombre='Cable USB-C a USB-C 2m 100W Anker' LIMIT 1),1,249.00);
INSERT INTO envios(id_pedido,nombre_cliente,direccion,telefono,estatus,folio_rastreo,fecha_envio,fecha_entrega)VALUES(@p,'Carlos Mendoza','Av. Insurgentes Sur #7, Col. San Ángel, CDMX','5511000001','Entregado','RT-000081-2025','2025-09-29 09:00:00','2025-10-01 12:00:00');

-- Venta 82
INSERT INTO pedidos(id_cliente,fecha,total,estatus)VALUES(@c02,'2025-09-25 14:15:00',349.00,'Pagado');SET @p=LAST_INSERT_ID();
INSERT INTO detalle_pedido(id_pedido,id_producto,cantidad,subtotal)VALUES(@p,(SELECT id_producto FROM productos WHERE nombre='Funda MagSafe iPhone 15 Pro Spigen' LIMIT 1),1,349.00);
INSERT INTO envios(id_pedido,nombre_cliente,direccion,telefono,estatus,folio_rastreo,fecha_envio,fecha_entrega)VALUES(@p,'María González','Calle Juárez #14, Col. Centro, Guadalajara','5511000002','Empacado','RT-000082-2025','2025-09-26 09:00:00',NULL);

-- Venta 83
INSERT INTO pedidos(id_cliente,fecha,total,estatus)VALUES(@c03,'2025-09-22 09:30:00',299.00,'Pagado');SET @p=LAST_INSERT_ID();
INSERT INTO detalle_pedido(id_pedido,id_producto,cantidad,subtotal)VALUES(@p,(SELECT id_producto FROM productos WHERE nombre='Funda Samsung Galaxy S24 Ultra Armor' LIMIT 1),1,299.00);
INSERT INTO envios(id_pedido,nombre_cliente,direccion,telefono,estatus,folio_rastreo,fecha_envio,fecha_entrega)VALUES(@p,'Luis Ramírez','Blvd. Hidalgo #21, Col. Obrera, Monterrey','5511000003','En procesamiento','RT-000083-2025','2025-09-23 09:00:00',NULL);

-- Venta 84
INSERT INTO pedidos(id_cliente,fecha,total,estatus)VALUES(@c04,'2025-09-20 15:00:00',29999.00,'Enviado');SET @p=LAST_INSERT_ID();
INSERT INTO detalle_pedido(id_pedido,id_producto,cantidad,subtotal)VALUES(@p,(SELECT id_producto FROM productos WHERE nombre='Samsung Galaxy S24 Ultra 256GB' LIMIT 1),1,29999.00);
INSERT INTO envios(id_pedido,nombre_cliente,direccion,telefono,estatus,folio_rastreo,fecha_envio,fecha_entrega)VALUES(@p,'Ana Torres','Calle Morelos #28, Col. Doctores, CDMX','5511000004','Entregado','RT-000084-2025','2025-09-21 09:00:00','2025-09-23 13:00:00');

-- Venta 85
INSERT INTO pedidos(id_cliente,fecha,total,estatus)VALUES(@c05,'2025-09-17 10:45:00',19499.00,'Pagado');SET @p=LAST_INSERT_ID();
INSERT INTO detalle_pedido(id_pedido,id_producto,cantidad,subtotal)VALUES(@p,(SELECT id_producto FROM productos WHERE nombre='iPhone 14 128GB' LIMIT 1),1,19499.00);
INSERT INTO envios(id_pedido,nombre_cliente,direccion,telefono,estatus,folio_rastreo,fecha_envio,fecha_entrega)VALUES(@p,'Pedro Hernández','Av. Revolución #35, Col. Mixcoac, CDMX','5511000005','Empacado','RT-000085-2025','2025-09-18 09:00:00',NULL);

-- Venta 86
INSERT INTO pedidos(id_cliente,fecha,total,estatus)VALUES(@c06,'2025-09-15 13:00:00',2199.00,'Enviado');SET @p=LAST_INSERT_ID();
INSERT INTO detalle_pedido(id_pedido,id_producto,cantidad,subtotal)VALUES(@p,(SELECT id_producto FROM productos WHERE nombre='Pantalla Samsung Galaxy S21 Dynamic AMOLED' LIMIT 1),1,2199.00);
INSERT INTO envios(id_pedido,nombre_cliente,direccion,telefono,estatus,folio_rastreo,fecha_envio,fecha_entrega)VALUES(@p,'Sofía López','Calle Madero #42, Col. Chapultepec, Guadalajara','5511000006','En camino','RT-000086-2025','2025-09-16 09:00:00',NULL);

-- Venta 87
INSERT INTO pedidos(id_cliente,fecha,total,estatus)VALUES(@c07,'2025-09-12 09:00:00',1299.00,'Pagado');SET @p=LAST_INSERT_ID();
INSERT INTO detalle_pedido(id_pedido,id_producto,cantidad,subtotal)VALUES(@p,(SELECT id_producto FROM productos WHERE nombre='Pantalla Samsung Galaxy A52 AMOLED' LIMIT 1),1,1299.00);
INSERT INTO envios(id_pedido,nombre_cliente,direccion,telefono,estatus,folio_rastreo,fecha_envio,fecha_entrega)VALUES(@p,'Diego Martínez','Blvd. Independencia #49, Col. Las Quintas, Culiacán','5511000007','En procesamiento','RT-000087-2025','2025-09-13 09:00:00',NULL);

-- Venta 88
INSERT INTO pedidos(id_cliente,fecha,total,estatus)VALUES(@c08,'2025-09-10 14:30:00',349.00,'Pagado');SET @p=LAST_INSERT_ID();
INSERT INTO detalle_pedido(id_pedido,id_producto,cantidad,subtotal)VALUES(@p,(SELECT id_producto FROM productos WHERE nombre='Batería Samsung Galaxy S23 3900mAh' LIMIT 1),1,349.00);
INSERT INTO envios(id_pedido,nombre_cliente,direccion,telefono,estatus,folio_rastreo,fecha_envio,fecha_entrega)VALUES(@p,'Valentina Cruz','Av. Universidad #56, Col. Copilco, CDMX','5511000008','Empacado','RT-000088-2025','2025-09-11 09:00:00',NULL);

-- Venta 89
INSERT INTO pedidos(id_cliente,fecha,total,estatus)VALUES(@c09,'2025-09-07 11:15:00',7499.00,'Enviado');SET @p=LAST_INSERT_ID();
INSERT INTO detalle_pedido(id_pedido,id_producto,cantidad,subtotal)VALUES(@p,(SELECT id_producto FROM productos WHERE nombre='Samsung Galaxy Watch 6 44mm' LIMIT 1),1,7499.00);
INSERT INTO envios(id_pedido,nombre_cliente,direccion,telefono,estatus,folio_rastreo,fecha_envio,fecha_entrega)VALUES(@p,'Andrés Flores','Calle Allende #63, Col. Guerrero, CDMX','5511000009','Entregado','RT-000089-2025','2025-09-08 09:00:00','2025-09-10 13:00:00');

-- Venta 90
INSERT INTO pedidos(id_cliente,fecha,total,estatus)VALUES(@c10,'2025-09-05 15:45:00',1499.00,'Pagado');SET @p=LAST_INSERT_ID();
INSERT INTO detalle_pedido(id_pedido,id_producto,cantidad,subtotal)VALUES(@p,(SELECT id_producto FROM productos WHERE nombre='Xiaomi Smart Band 8 Pro' LIMIT 1),1,1499.00);
INSERT INTO envios(id_pedido,nombre_cliente,direccion,telefono,estatus,folio_rastreo,fecha_envio,fecha_entrega)VALUES(@p,'Gabriela Sánchez','Av. Chapultepec #70, Col. Roma, CDMX','5511000010','En procesamiento','RT-000090-2025','2025-09-06 09:00:00',NULL);

-- Venta 91
INSERT INTO pedidos(id_cliente,fecha,total,estatus)VALUES(@c11,'2025-08-28 10:00:00',299.00,'Pagado');SET @p=LAST_INSERT_ID();
INSERT INTO detalle_pedido(id_pedido,id_producto,cantidad,subtotal)VALUES(@p,(SELECT id_producto FROM productos WHERE nombre='Batería Xiaomi Redmi Note 11 5000mAh' LIMIT 1),1,299.00);
INSERT INTO envios(id_pedido,nombre_cliente,direccion,telefono,estatus,folio_rastreo,fecha_envio,fecha_entrega)VALUES(@p,'Roberto Jiménez','Calle Guerrero #77, Col. Tlatilco, CDMX','5511000011','Empacado','RT-000091-2025','2025-08-29 09:00:00',NULL);

-- Venta 92
INSERT INTO pedidos(id_cliente,fecha,total,estatus)VALUES(@c12,'2025-08-25 13:30:00',999.00,'Enviado');SET @p=LAST_INSERT_ID();
INSERT INTO detalle_pedido(id_pedido,id_producto,cantidad,subtotal)VALUES(@p,(SELECT id_producto FROM productos WHERE nombre='Pantalla Xiaomi Redmi Note 12 AMOLED' LIMIT 1),1,999.00);
INSERT INTO envios(id_pedido,nombre_cliente,direccion,telefono,estatus,folio_rastreo,fecha_envio,fecha_entrega)VALUES(@p,'Claudia Morales','Av. Reforma #84, Col. Polanco, CDMX','5511000012','Entregado','RT-000092-2025','2025-08-26 09:00:00','2025-08-28 12:00:00');

-- Venta 93
INSERT INTO pedidos(id_cliente,fecha,total,estatus)VALUES(@c13,'2025-08-22 09:00:00',549.00,'Pagado');SET @p=LAST_INSERT_ID();
INSERT INTO detalle_pedido(id_pedido,id_producto,cantidad,subtotal)VALUES(@p,(SELECT id_producto FROM productos WHERE nombre='Cargador Inalámbrico 15W Qi2' LIMIT 1),1,549.00);
INSERT INTO envios(id_pedido,nombre_cliente,direccion,telefono,estatus,folio_rastreo,fecha_envio,fecha_entrega)VALUES(@p,'Fernando Reyes','Calle Zaragoza #91, Col. Narvarte, CDMX','5511000013','En procesamiento','RT-000093-2025','2025-08-23 09:00:00',NULL);

-- Venta 94
INSERT INTO pedidos(id_cliente,fecha,total,estatus)VALUES(@c14,'2025-08-20 14:00:00',299.00,'Pagado');SET @p=LAST_INSERT_ID();
INSERT INTO detalle_pedido(id_pedido,id_producto,cantidad,subtotal)VALUES(@p,(SELECT id_producto FROM productos WHERE nombre='Cable Lightning MFi 1m Belkin' LIMIT 1),1,299.00);
INSERT INTO envios(id_pedido,nombre_cliente,direccion,telefono,estatus,folio_rastreo,fecha_envio,fecha_entrega)VALUES(@p,'Patricia Vargas','Blvd. Díaz Mirón #98, Col. Formando Hogar, Veracruz','5511000014','Empacado','RT-000094-2025','2025-08-21 09:00:00',NULL);

-- Venta 95
INSERT INTO pedidos(id_cliente,fecha,total,estatus)VALUES(@c15,'2025-08-17 11:45:00',499.00,'Enviado');SET @p=LAST_INSERT_ID();
INSERT INTO detalle_pedido(id_pedido,id_producto,cantidad,subtotal)VALUES(@p,(SELECT id_producto FROM productos WHERE nombre='Cable USB-C a Lightning 1m Apple Original' LIMIT 1),1,499.00);
INSERT INTO envios(id_pedido,nombre_cliente,direccion,telefono,estatus,folio_rastreo,fecha_envio,fecha_entrega)VALUES(@p,'Javier Castillo','Av. 20 de Noviembre #105, Col. Centro, Puebla','5511000015','Entregado','RT-000095-2025','2025-08-18 09:00:00','2025-08-20 13:00:00');

-- Venta 96
INSERT INTO pedidos(id_cliente,fecha,total,estatus)VALUES(@c16,'2025-08-15 10:30:00',169.00,'Pagado');SET @p=LAST_INSERT_ID();
INSERT INTO detalle_pedido(id_pedido,id_producto,cantidad,subtotal)VALUES(@p,(SELECT id_producto FROM productos WHERE nombre='Vidrio Templado Samsung Galaxy S23 Ultra' LIMIT 1),1,169.00);
INSERT INTO envios(id_pedido,nombre_cliente,direccion,telefono,estatus,folio_rastreo,fecha_envio,fecha_entrega)VALUES(@p,'Mónica Gutiérrez','Calle Ocampo #112, Col. Centenario, León','5511000016','En procesamiento','RT-000096-2025','2025-08-16 09:00:00',NULL);

-- Venta 97
INSERT INTO pedidos(id_cliente,fecha,total,estatus)VALUES(@c17,'2025-08-12 14:00:00',99.00,'Pagado');SET @p=LAST_INSERT_ID();
INSERT INTO detalle_pedido(id_pedido,id_producto,cantidad,subtotal)VALUES(@p,(SELECT id_producto FROM productos WHERE nombre='Vidrio Templado Xiaomi Redmi Note 13 Pro' LIMIT 1),1,99.00);
INSERT INTO envios(id_pedido,nombre_cliente,direccion,telefono,estatus,folio_rastreo,fecha_envio,fecha_entrega)VALUES(@p,'Héctor Díaz','Av. Lázaro Cárdenas #119, Col. del Valle, CDMX','5511000017','Empacado','RT-000097-2025','2025-08-13 09:00:00',NULL);

-- Venta 98
INSERT INTO pedidos(id_cliente,fecha,total,estatus)VALUES(@c18,'2025-08-10 09:15:00',349.00,'Enviado');SET @p=LAST_INSERT_ID();
INSERT INTO detalle_pedido(id_pedido,id_producto,cantidad,subtotal)VALUES(@p,(SELECT id_producto FROM productos WHERE nombre='Kit Destornilladores Precisión 38 en 1' LIMIT 1),1,349.00);
INSERT INTO envios(id_pedido,nombre_cliente,direccion,telefono,estatus,folio_rastreo,fecha_envio,fecha_entrega)VALUES(@p,'Lucía Pérez','Calle Victoria #126, Col. Estrella, CDMX','5511000018','Entregado','RT-000098-2025','2025-08-11 09:00:00','2025-08-13 12:00:00');

-- Venta 99
INSERT INTO pedidos(id_cliente,fecha,total,estatus)VALUES(@c19,'2025-08-07 12:00:00',1599.00,'Pagado');SET @p=LAST_INSERT_ID();
INSERT INTO detalle_pedido(id_pedido,id_producto,cantidad,subtotal)VALUES(@p,(SELECT id_producto FROM productos WHERE nombre='Pantalla iPhone 12 OLED' LIMIT 1),1,1599.00);
INSERT INTO envios(id_pedido,nombre_cliente,direccion,telefono,estatus,folio_rastreo,fecha_envio,fecha_entrega)VALUES(@p,'Eduardo Ríos','Blvd. Torres Quintero #133, Col. Esperanza, Culiacán','5511000019','En procesamiento','RT-000099-2025','2025-08-08 09:00:00',NULL);

-- Venta 100
INSERT INTO pedidos(id_cliente,fecha,total,estatus)VALUES(@c20,'2025-08-05 16:30:00',27999.00,'Enviado');SET @p=LAST_INSERT_ID();
INSERT INTO detalle_pedido(id_pedido,id_producto,cantidad,subtotal)VALUES(@p,(SELECT id_producto FROM productos WHERE nombre='iPhone 15 Pro Max 256GB' LIMIT 1),1,27999.00);
INSERT INTO envios(id_pedido,nombre_cliente,direccion,telefono,estatus,folio_rastreo,fecha_envio,fecha_entrega)VALUES(@p,'Isabel Rojas','Av. Niños Héroes #140, Col. Americana, Guadalajara','5511000020','En camino','RT-000100-2025','2025-08-06 09:00:00',NULL);

-- Resumen
SELECT COUNT(*) AS total_pedidos FROM pedidos;
SELECT COUNT(*) AS total_detalles FROM detalle_pedido;
SELECT COUNT(*) AS total_envios FROM envios;
