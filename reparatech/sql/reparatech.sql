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
