CREATE TABLE log_errores (
    id_error INT AUTO_INCREMENT PRIMARY KEY,
    objeto VARCHAR(100),
    nombre_tabla VARCHAR(100),
    codigo_error INT,
    mensaje TEXT,
    fecha_hora TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);