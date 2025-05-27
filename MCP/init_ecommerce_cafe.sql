-- Script de inicialización para la base de datos ecommerce_cafe
-- Creación de usuario y base de datos

-- NOTA IMPORTANTE: Este script requiere que PostgreSQL esté en ejecución
-- Si encuentras errores de conexión, asegúrate de que:
-- 1. PostgreSQL está instalado y en ejecución
-- 2. Tienes permisos de superusuario (postgres)
--
-- Para iniciar PostgreSQL en sistemas basados en Unix:
-- sudo service postgresql start
-- o
-- sudo systemctl start postgresql
--
-- Para Mac con Homebrew:
-- brew services start postgresql
--
-- Para ejecutar este script:
-- psql -h 127.0.0.1 -p 5432 -U postgres -f init_ecommerce_cafe.sql

CREATE USER postgres WITH PASSWORD 'postgres';
CREATE DATABASE ecommerce_cafe;
ALTER DATABASE ecommerce_cafe OWNER TO postgres;

\connect ecommerce_cafe;

-- Creación de tablas

-- Tabla clientes
CREATE TABLE clientes (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    telefono VARCHAR(20),
    fecha_registro DATE NOT NULL DEFAULT CURRENT_DATE
);

-- Tabla ordenes
CREATE TABLE ordenes (
    id SERIAL PRIMARY KEY,
    cliente_id INTEGER NOT NULL REFERENCES clientes(id) ON DELETE CASCADE,
    fecha_orden TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    monto_total NUMERIC(10, 2) NOT NULL CHECK (monto_total > 0),
    estado VARCHAR(20) NOT NULL CHECK (estado IN ('pendiente', 'completada', 'cancelada')),
    canal_compra VARCHAR(50) NOT NULL DEFAULT 'TIENDA'
);

-- Inserción de datos sintéticos

-- Datos para la tabla clientes
INSERT INTO clientes (nombre, email, telefono, fecha_registro) VALUES
('María García', 'maria.garcia@example.com', '612345678', '2023-01-15'),
('Juan Rodríguez', 'juan.rodriguez@example.com', '623456789', '2023-02-20'),
('Ana Martínez', 'ana.martinez@example.com', '634567890', '2023-03-10'),
('Carlos López', 'carlos.lopez@example.com', '645678901', '2023-04-05'),
('Laura Sánchez', 'laura.sanchez@example.com', '656789012', '2023-05-12'),
('Pedro Ramírez', 'pedro.ramirez@example.com', '667890123', '2023-06-18'),
('Sofía Fernández', 'sofia.fernandez@example.com', '678901234', '2023-07-22'),
('Miguel Torres', 'miguel.torres@example.com', '689012345', '2023-08-30'),
('Carmen Ruiz', 'carmen.ruiz@example.com', '690123456', '2023-09-14'),
('David Jiménez', 'david.jimenez@example.com', '601234567', '2023-10-25');

-- Datos para la tabla ordenes
INSERT INTO ordenes (cliente_id, fecha_orden, monto_total, estado, canal_compra) VALUES
(1, '2023-02-10 10:30:00', 125.50, 'completada', 'TIENDA'),
(1, '2023-05-15 14:45:00', 78.25, 'completada', 'TIENDA'),
(1, '2023-11-02 09:15:00', 245.99, 'pendiente', 'TIENDA'),
(2, '2023-03-22 16:20:00', 56.75, 'completada', 'TIENDA'),
(2, '2023-07-30 11:10:00', 112.30, 'completada', 'TIENDA'),
(3, '2023-04-18 13:40:00', 89.99, 'completada', 'TIENDA'),
(3, '2023-09-05 17:25:00', 134.50, 'cancelada', 'TIENDA'),
(4, '2023-05-01 10:00:00', 67.80, 'completada', 'TIENDA'),
(4, '2023-08-12 15:30:00', 178.45, 'completada', 'TIENDA'),
(4, '2023-11-10 12:20:00', 210.75, 'pendiente', 'TIENDA'),
(5, '2023-06-24 09:45:00', 45.60, 'completada', 'TIENDA'),
(5, '2023-10-08 14:15:00', 95.25, 'completada', 'TIENDA'),
(6, '2023-07-13 16:50:00', 156.40, 'completada', 'TIENDA'),
(6, '2023-11-15 11:35:00', 87.99, 'pendiente', 'TIENDA'),
(7, '2023-08-02 13:10:00', 120.75, 'completada', 'TIENDA'),
(7, '2023-10-20 15:45:00', 198.30, 'completada', 'TIENDA'),
(7, '2023-11-25 10:25:00', 65.40, 'pendiente', 'TIENDA'),
(8, '2023-09-17 12:30:00', 145.60, 'completada', 'TIENDA'),
(8, '2023-11-05 16:40:00', 89.99, 'pendiente', 'TIENDA'),
(9, '2023-10-03 11:20:00', 67.25, 'completada', 'TIENDA'),
(9, '2023-11-18 14:50:00', 112.80, 'pendiente', 'TIENDA'),
(10, '2023-11-01 09:30:00', 178.95, 'pendiente', 'TIENDA'),
(10, '2023-11-20 15:15:00', 235.45, 'pendiente', 'TIENDA'),
(3, '2023-11-22 10:10:00', 45.30, 'pendiente', 'TIENDA'),
(5, '2023-11-23 13:25:00', 123.75, 'pendiente', 'TIENDA'),
(7, '2023-11-24 16:35:00', 56.90, 'pendiente', 'TIENDA'),
(9, '2023-11-26 12:45:00', 78.50, 'pendiente', 'TIENDA');

-- Conceder permisos al usuario postgres
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO postgres;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO postgres;

-- Añadir índice para mejorar rendimiento en búsquedas por cliente
CREATE INDEX idx_ordenes_cliente_id ON ordenes(cliente_id); 