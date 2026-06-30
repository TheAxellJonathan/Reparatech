-- Base de datos Reparatech
-- Archivo SQL para crear la base de datos, tablas normalizadas y datos de ejemplo
-- Todos los comentarios y nombres en español

-- Crear base de datos
CREATE DATABASE IF NOT EXISTS reparatech DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_spanish_ci;
USE reparatech;

-- Tabla usuarios
-- Guarda información básica de cualquier usuario (cliente o empleado)
CREATE TABLE IF NOT EXISTS usuarios (
  id_usuario INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL,
  telefono VARCHAR(20) NOT NULL UNIQUE,
  contrasena_hash VARCHAR(255) NOT NULL,
  tipo_usuario ENUM('cliente','empleado') NOT NULL,
  fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla clientes (extiende usuarios)
CREATE TABLE IF NOT EXISTS clientes (
  id_cliente INT PRIMARY KEY,
  correo VARCHAR(150),
  direccion TEXT,
  FOREIGN KEY (id_cliente) REFERENCES usuarios(id_usuario) ON DELETE CASCADE
);

-- Tabla empleados (extiende usuarios)
CREATE TABLE IF NOT EXISTS empleados (
  id_empleado INT PRIMARY KEY,
  puesto VARCHAR(100),
  fecha_ingreso DATE,
  FOREIGN KEY (id_empleado) REFERENCES usuarios(id_usuario) ON DELETE CASCADE
);

-- Tabla marcas
CREATE TABLE IF NOT EXISTS marcas (
  id_marca INT AUTO_INCREMENT PRIMARY KEY,
  nombre_marca VARCHAR(100) NOT NULL
);

-- Tabla tipos_equipo
CREATE TABLE IF NOT EXISTS tipos_equipo (
  id_tipo INT AUTO_INCREMENT PRIMARY KEY,
  nombre_tipo VARCHAR(50) NOT NULL
);

-- Tabla equipos (modelos de dispositivos)
CREATE TABLE IF NOT EXISTS equipos (
  id_equipo INT AUTO_INCREMENT PRIMARY KEY,
  id_marca INT NOT NULL,
  id_tipo INT NOT NULL,
  modelo VARCHAR(150) NOT NULL,
  FOREIGN KEY (id_marca) REFERENCES marcas(id_marca) ON DELETE RESTRICT,
  FOREIGN KEY (id_tipo) REFERENCES tipos_equipo(id_tipo) ON DELETE RESTRICT
);

-- Tabla reparaciones
CREATE TABLE IF NOT EXISTS reparaciones (
  id_reparacion INT AUTO_INCREMENT PRIMARY KEY,
  folio VARCHAR(50) NOT NULL UNIQUE,
  id_cliente INT NOT NULL,
  id_equipo INT NOT NULL,
  id_empleado INT DEFAULT NULL,
  motivo VARCHAR(255),
  falla TEXT,
  observaciones TEXT,
  precio DECIMAL(10,2) DEFAULT 0.00,
  estatus ENUM('En reparación','Concluido','Entregado') DEFAULT 'En reparación',
  fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (id_cliente) REFERENCES usuarios(id_usuario) ON DELETE CASCADE,
  FOREIGN KEY (id_equipo) REFERENCES equipos(id_equipo) ON DELETE RESTRICT,
  FOREIGN KEY (id_empleado) REFERENCES empleados(id_empleado) ON DELETE SET NULL
);

-- Tabla imagenes_reparacion
CREATE TABLE IF NOT EXISTS imagenes_reparacion (
  id_imagen INT AUTO_INCREMENT PRIMARY KEY,
  id_reparacion INT NOT NULL,
  ruta_imagen VARCHAR(255) NOT NULL,
  FOREIGN KEY (id_reparacion) REFERENCES reparaciones(id_reparacion) ON DELETE CASCADE
);

-- Tabla comprobantes (rutas a PDFs)
CREATE TABLE IF NOT EXISTS comprobantes (
  id_comprobante INT AUTO_INCREMENT PRIMARY KEY,
  id_reparacion INT NOT NULL,
  ruta_pdf_cliente VARCHAR(255),
  ruta_pdf_negocio VARCHAR(255),
  FOREIGN KEY (id_reparacion) REFERENCES reparaciones(id_reparacion) ON DELETE CASCADE
);

-- Tabla productos (tienda)
CREATE TABLE IF NOT EXISTS productos (
  id_producto INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(150) NOT NULL,
  descripcion TEXT,
  categoria VARCHAR(50),
  precio DECIMAL(10,2) NOT NULL DEFAULT 0.00,
  stock INT DEFAULT 0,
  imagen VARCHAR(255)
);

-- Tabla pedidos
CREATE TABLE IF NOT EXISTS pedidos (
  id_pedido INT AUTO_INCREMENT PRIMARY KEY,
  id_cliente INT NOT NULL,
  fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  total DECIMAL(10,2) DEFAULT 0.00,
  estatus ENUM('Pendiente','Pagado','Enviado','Cancelado') DEFAULT 'Pendiente',
  FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente) ON DELETE CASCADE
);

-- Tabla detalle_pedido
CREATE TABLE IF NOT EXISTS detalle_pedido (
  id_detalle INT AUTO_INCREMENT PRIMARY KEY,
  id_pedido INT NOT NULL,
  id_producto INT NOT NULL,
  cantidad INT DEFAULT 1,
  subtotal DECIMAL(10,2) DEFAULT 0.00,
  FOREIGN KEY (id_pedido) REFERENCES pedidos(id_pedido) ON DELETE CASCADE,
  FOREIGN KEY (id_producto) REFERENCES productos(id_producto) ON DELETE RESTRICT
);

-- Tabla envios (para rastrear envíos de pedidos)
CREATE TABLE IF NOT EXISTS envios (
  id_envio INT AUTO_INCREMENT PRIMARY KEY,
  id_pedido INT NOT NULL,
  nombre_cliente VARCHAR(100),
  direccion TEXT,
  telefono VARCHAR(20),
  estatus ENUM('En procesamiento','Empacado','En camino','Entregado','Cancelado') DEFAULT 'En procesamiento',
  folio_rastreo VARCHAR(100),
  fecha_envio TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  fecha_entrega TIMESTAMP NULL,
  FOREIGN KEY (id_pedido) REFERENCES pedidos(id_pedido) ON DELETE CASCADE
);

-- Tabla imagenes_envio (para fotos de comprobante de entrega)
CREATE TABLE IF NOT EXISTS imagenes_envio (
  id_imagen INT AUTO_INCREMENT PRIMARY KEY,
  id_envio INT NOT NULL,
  ruta_imagen VARCHAR(255),
  FOREIGN KEY (id_envio) REFERENCES envios(id_envio) ON DELETE CASCADE
);

-- Tabla logs (para registrar todas las acciones)
CREATE TABLE IF NOT EXISTS logs (
  id_log INT AUTO_INCREMENT PRIMARY KEY,
  id_usuario INT,
  tipo_accion VARCHAR(50),
  descripcion TEXT,
  tabla_afectada VARCHAR(100),
  id_registro INT,
  fecha_log TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  ip_address VARCHAR(45),
  FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario) ON DELETE SET NULL
);

-- Tabla reset_contrasena (para recuperación de contraseña)
CREATE TABLE IF NOT EXISTS reset_contrasena (
  id_reset INT AUTO_INCREMENT PRIMARY KEY,
  id_usuario INT NOT NULL,
  token VARCHAR(255) NOT NULL,
  fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  fecha_expiracion TIMESTAMP,
  utilizado BOOLEAN DEFAULT FALSE,
  FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario) ON DELETE CASCADE
);

-- Datos de ejemplo
-- Usuarios (uno empleado y un cliente)
INSERT INTO usuarios (nombre, telefono, contrasena_hash, tipo_usuario) VALUES
('Admin Empleado','5550001111', '$2y$10$adminhashplaceholderadminhashpl', 'empleado'),
('Cliente Demo','5550002222', '$2y$10$clientehashplaceholderclientehashpl', 'cliente');

-- Insertar clientes y empleados asociados
INSERT INTO clientes (id_cliente, correo, direccion) VALUES
(2, 'cliente@demo.com', 'Calle Falsa 123');

INSERT INTO empleados (id_empleado, puesto, fecha_ingreso) VALUES
(1, 'Técnico Senior', '2023-01-01');

-- Marcas de ejemplo
INSERT INTO marcas (nombre_marca) VALUES ('Samsung'),('Apple'),('Xiaomi'),('Huawei');

-- Tipos de equipo
INSERT INTO tipos_equipo (nombre_tipo) VALUES ('Celular'),('Tablet'),('Laptop');

-- Equipos de ejemplo
INSERT INTO equipos (id_marca, id_tipo, modelo) VALUES
(1,1,'Galaxy S21'),
(2,1,'iPhone 12'),
(3,3,'Mi Notebook 14');

-- Productos de ejemplo
INSERT INTO productos (nombre, descripcion, categoria, precio, stock, imagen) VALUES
('Samsung Galaxy S21','Celular Samsung, 128GB, 8GB RAM','Celular',14999.00,10,'img/productos/galaxy_s21.jpg'),
('iPhone 12','iPhone 12 64GB','Celular',19999.00,5,'img/productos/iphone_12.jpg'),
('Mi Notebook 14','Laptop ligera 8GB RAM','Laptop',21999.00,3,'img/productos/mi_notebook.jpg');

-- Pedido de ejemplo
INSERT INTO pedidos (id_cliente, total, estatus) VALUES
(2,14999.00,'Pagado');

INSERT INTO detalle_pedido (id_pedido, id_producto, cantidad, subtotal) VALUES
(1,1,1,14999.00);

-- Comentario: Ajuste las contraseñas de ejemplo re-hasheándolas con password_hash en PHP cuando haga el deploy.
-- =====================================
-- INSTRUCCIONES DE ACTUALIZACIÓN DE BD
-- =====================================
--
-- EJECUTAR ESTOS COMANDOS EN ORDEN:
-- 1. Primero copia este archivo: sql/migracion.sql
-- 2. Luego ejecuta en phpMyAdmin o por terminal MySQL:
--    mysql -u root -p reparatech < sql/migracion.sql
--
-- =====================================

USE reparatech;

-- Tabla envios (para rastrear envíos de pedidos)
CREATE TABLE IF NOT EXISTS envios (
  id_envio INT AUTO_INCREMENT PRIMARY KEY,
  id_pedido INT NOT NULL,
  nombre_cliente VARCHAR(100),
  direccion TEXT,
  telefono VARCHAR(20),
  estatus ENUM('En procesamiento','Empacado','En camino','Entregado','Cancelado') DEFAULT 'En procesamiento',
  folio_rastreo VARCHAR(100),
  fecha_envio TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  fecha_entrega TIMESTAMP NULL,
  FOREIGN KEY (id_pedido) REFERENCES pedidos(id_pedido) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

-- Tabla imagenes_envio (para fotos de comprobante de entrega)
CREATE TABLE IF NOT EXISTS imagenes_envio (
  id_imagen INT AUTO_INCREMENT PRIMARY KEY,
  id_envio INT NOT NULL,
  ruta_imagen VARCHAR(255),
  FOREIGN KEY (id_envio) REFERENCES envios(id_envio) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

-- Tabla logs (para registrar todas las acciones)
CREATE TABLE IF NOT EXISTS logs (
  id_log INT AUTO_INCREMENT PRIMARY KEY,
  id_usuario INT,
  tipo_accion VARCHAR(50),
  descripcion TEXT,
  tabla_afectada VARCHAR(100),
  id_registro INT,
  fecha_log TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  ip_address VARCHAR(45),
  FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

-- Tabla reset_contrasena (para recuperación de contraseña)
CREATE TABLE IF NOT EXISTS reset_contrasena (
  id_reset INT AUTO_INCREMENT PRIMARY KEY,
  id_usuario INT NOT NULL,
  token VARCHAR(255) NOT NULL,
  fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  fecha_expiracion TIMESTAMP,
  utilizado BOOLEAN DEFAULT FALSE,
  FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

-- Crear índices para mejorar rendimiento
CREATE INDEX idx_envios_pedido ON envios(id_pedido);
CREATE INDEX idx_logs_usuario ON logs(id_usuario);
CREATE INDEX idx_logs_fecha ON logs(fecha_log);
CREATE INDEX idx_reset_token ON reset_contrasena(token);
CREATE INDEX idx_reset_usuario ON reset_contrasena(id_usuario);

-- Fin de la migración
COMMIT;
-- Actualización de esquema para Reparatech

-- 1. Tabla de Colores
CREATE TABLE IF NOT EXISTS colores (
    id_color INT AUTO_INCREMENT PRIMARY KEY,
    nombre_color VARCHAR(50) NOT NULL UNIQUE,
    hex_code VARCHAR(7) DEFAULT '#000000'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Insertar colores por defecto
INSERT IGNORE INTO colores (nombre_color, hex_code) VALUES 
('Negro', '#000000'),
('Blanco', '#FFFFFF'),
('Gris', '#808080'),
('Plata', '#C0C0C0'),
('Dorado', '#FFD700'),
('Azul', '#0000FF'),
('Rojo', '#FF0000'),
('Verde', '#008000'),
('Rosa', '#FFC0CB'),
('Morado', '#800080');

-- 2. Actualizar tabla reparaciones
-- Agregar columna id_color si no existe
SET @dbname = DATABASE();
SET @tablename = "reparaciones";
SET @columnname = "id_color";
SET @preparedStatement = (SELECT IF(
  (
    SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS
    WHERE
      (table_name = @tablename)
      AND (table_schema = @dbname)
      AND (column_name = @columnname)
  ) > 0,
  "SELECT 1",
  "ALTER TABLE reparaciones ADD COLUMN id_color INT DEFAULT NULL AFTER id_equipo;"
));
PREPARE alterIfNotExists FROM @preparedStatement;
EXECUTE alterIfNotExists;
DEALLOCATE PREPARE alterIfNotExists;

-- Agregar columna imei_serie si no existe
SET @columnname = "imei_serie";
SET @preparedStatement = (SELECT IF(
  (
    SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS
    WHERE
      (table_name = @tablename)
      AND (table_schema = @dbname)
      AND (column_name = @columnname)
  ) > 0,
  "SELECT 1",
  "ALTER TABLE reparaciones ADD COLUMN imei_serie VARCHAR(100) DEFAULT NULL AFTER id_color;"
));
PREPARE alterIfNotExists FROM @preparedStatement;
EXECUTE alterIfNotExists;
DEALLOCATE PREPARE alterIfNotExists;

-- 3. Asegurar datos en marcas y tipos (Insertar si no existen)
INSERT IGNORE INTO marcas (nombre_marca) VALUES 
('Apple'), ('Samsung'), ('Xiaomi'), ('Huawei'), ('Motorola'), ('Oppo'), ('Vivo'), ('Realme'), ('Sony'), ('LG'), ('Google'), ('OnePlus'), ('Dell'), ('HP'), ('Lenovo'), ('Asus'), ('Acer'), ('Microsoft'), ('Nintendo'), ('PlayStation'), ('Xbox');

INSERT IGNORE INTO tipos_equipo (nombre_tipo) VALUES 
('Smartphone'), ('Tablet'), ('Laptop'), ('PC Escritorio'), ('Consola'), ('Smartwatch'), ('Audífonos'), ('Otro');
-- Actualización de esquema para Ventas y Envíos

-- 1. Actualizar tabla pedidos
-- Agregar tipo_entrega y ruta_pdf
SET @dbname = DATABASE();
SET @tablename = "pedidos";
SET @columnname = "tipo_entrega";
SET @preparedStatement = (SELECT IF(
  (
    SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS
    WHERE
      (table_name = @tablename)
      AND (table_schema = @dbname)
      AND (column_name = @columnname)
  ) > 0,
  "SELECT 1",
  "ALTER TABLE pedidos ADD COLUMN tipo_entrega ENUM('tienda', 'domicilio') DEFAULT 'tienda' AFTER estatus;"
));
PREPARE alterIfNotExists FROM @preparedStatement;
EXECUTE alterIfNotExists;
DEALLOCATE PREPARE alterIfNotExists;

SET @columnname = "ruta_pdf";
SET @preparedStatement = (SELECT IF(
  (
    SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS
    WHERE
      (table_name = @tablename)
      AND (table_schema = @dbname)
      AND (column_name = @columnname)
  ) > 0,
  "SELECT 1",
  "ALTER TABLE pedidos ADD COLUMN ruta_pdf VARCHAR(255) DEFAULT NULL AFTER tipo_entrega;"
));
PREPARE alterIfNotExists FROM @preparedStatement;
EXECUTE alterIfNotExists;
DEALLOCATE PREPARE alterIfNotExists;

-- 2. Actualizar tabla envios
-- Agregar campos detallados de dirección
ALTER TABLE envios ADD COLUMN calle VARCHAR(255) DEFAULT NULL AFTER direccion;
ALTER TABLE envios ADD COLUMN colonia VARCHAR(100) DEFAULT NULL AFTER calle;
ALTER TABLE envios ADD COLUMN municipio VARCHAR(100) DEFAULT NULL AFTER colonia;
ALTER TABLE envios ADD COLUMN estado VARCHAR(100) DEFAULT NULL AFTER municipio;
ALTER TABLE envios ADD COLUMN pais VARCHAR(100) DEFAULT 'México' AFTER estado;
ALTER TABLE envios ADD COLUMN nombres_contacto VARCHAR(100) DEFAULT NULL AFTER pais;
ALTER TABLE envios ADD COLUMN apellidos_contacto VARCHAR(100) DEFAULT NULL AFTER nombres_contacto;
ALTER TABLE envios ADD COLUMN telefono_contacto VARCHAR(20) DEFAULT NULL AFTER apellidos_contacto;
ALTER TABLE envios ADD COLUMN codigo_postal VARCHAR(10) DEFAULT NULL AFTER estado;
ALTER TABLE envios ADD COLUMN pais VARCHAR(50) DEFAULT 'México' AFTER estado;
ALTER TABLE envios ADD COLUMN nombres_contacto VARCHAR(100) DEFAULT NULL AFTER telefono_contacto;
ALTER TABLE envios ADD COLUMN apellidos_contacto VARCHAR(100) DEFAULT NULL AFTER nombres_contacto;
-- Script para asegurar que todos los usuarios tipo 'cliente' tengan un registro en la tabla clientes
USE reparatech;

-- Insertar registros faltantes en la tabla clientes para usuarios tipo 'cliente'
INSERT INTO clientes (id_cliente, correo, direccion)
SELECT u.id_usuario, NULL, NULL
FROM usuarios u
WHERE u.tipo_usuario = 'cliente'
AND NOT EXISTS (
    SELECT 1 FROM clientes c WHERE c.id_cliente = u.id_usuario
);

-- Verificar los registros
SELECT 
    u.id_usuario,
    u.nombre,
    u.tipo_usuario,
    c.id_cliente,
    c.correo,
    c.direccion
FROM usuarios u
LEFT JOIN clientes c ON u.id_usuario = c.id_cliente
WHERE u.tipo_usuario = 'cliente';
-- Script para verificar y agregar columnas faltantes en la tabla envios
-- Este script asegura que todas las columnas necesarias existan

USE reparatech;

-- Verificar estructura actual
DESCRIBE envios;

-- Agregar columnas si no existen (safe para ejecutar múltiples veces)

-- Columnas de dirección detallada
ALTER TABLE envios 
ADD COLUMN IF NOT EXISTS calle VARCHAR(255) DEFAULT NULL AFTER direccion,
ADD COLUMN IF NOT EXISTS colonia VARCHAR(100) DEFAULT NULL AFTER calle,
ADD COLUMN IF NOT EXISTS municipio VARCHAR(100) DEFAULT NULL AFTER colonia,
ADD COLUMN IF NOT EXISTS estado VARCHAR(100) DEFAULT NULL AFTER municipio,
ADD COLUMN IF NOT EXISTS pais VARCHAR(50) DEFAULT 'México' AFTER estado,
ADD COLUMN IF NOT EXISTS codigo_postal VARCHAR(10) DEFAULT NULL AFTER pais;

-- Columnas de contacto
ALTER TABLE envios
ADD COLUMN IF NOT EXISTS telefono_contacto VARCHAR(20) DEFAULT NULL AFTER telefono,
ADD COLUMN IF NOT EXISTS nombres_contacto VARCHAR(100) DEFAULT NULL AFTER telefono_contacto,
ADD COLUMN IF NOT EXISTS apellidos_contacto VARCHAR(100) DEFAULT NULL AFTER nombres_contacto;

-- Verificar estructura final
DESCRIBE envios;
