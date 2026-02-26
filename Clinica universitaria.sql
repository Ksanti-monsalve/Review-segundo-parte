CREATE DATABASE if not exists  clinica_universitaria1;
USE clinica_universitaria1;

CREATE TABLE if not exists facultad (
    id_facultad VARCHAR(10) PRIMARY KEY,
    nombre_facultad VARCHAR(100) NOT NULL,
    decano VARCHAR(100) NOT NULL
) ENGINE=InnoDB;


CREATE TABLE if not exists paciente (
    id_paciente VARCHAR(10) PRIMARY KEY,
    nombres VARCHAR(100) NOT NULL,
    apellidos VARCHAR(100) NOT NULL,
    telefono VARCHAR(20)
) ENGINE=InnoDB;


CREATE TABLE if not exists medico (
    id_medico VARCHAR(10) PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    especialidad VARCHAR(100) NOT NULL,
    id_facultad VARCHAR(10) NOT NULL,
    
    CONSTRAINT fk_medico_facultad
        FOREIGN KEY (id_facultad)
        REFERENCES facultad(id_facultad)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
) ENGINE=InnoDB;


CREATE TABLE if not exists hospital (
    id_hospital VARCHAR(10) PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    direccion VARCHAR(150) NOT NULL
) ENGINE=InnoDB;


CREATE TABLE if not exists cita (
    id_cita VARCHAR(10) PRIMARY KEY,
    fecha DATE NOT NULL,
    diagnostico VARCHAR(255),
    
    id_paciente VARCHAR(10) NOT NULL,
    id_medico VARCHAR(10) NOT NULL,
    id_hospital VARCHAR(10) NOT NULL,
    
    CONSTRAINT fk_cita_paciente
        FOREIGN KEY (id_paciente)
        REFERENCES paciente(id_paciente)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
        
    CONSTRAINT fk_cita_medico
        FOREIGN KEY (id_medico)
        REFERENCES medico(id_medico)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
        
    CONSTRAINT fk_cita_hospital
        FOREIGN KEY (id_hospital)
        REFERENCES hospital(id_hospital)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
) ENGINE=InnoDB;


CREATE TABLE if not exists medicamento (
    id_medicamento VARCHAR(10) PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL
) ENGINE=InnoDB;


CREATE TABLE if not exists receta (
    id_receta VARCHAR(10) PRIMARY KEY,
    id_cita VARCHAR(10) NOT NULL,
    id_medicamento VARCHAR(10) NOT NULL,
    dosis VARCHAR(50) NOT NULL,
    
    CONSTRAINT fk_receta_cita
        FOREIGN KEY (id_cita)
        REFERENCES cita(id_cita)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
        
    CONSTRAINT fk_receta_medicamento
        FOREIGN KEY (id_medicamento)
        REFERENCES medicamento(id_medicamento)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
) ENGINE=InnoDB;

INSERT INTO facultad VALUES 
('F-01','Medicina','Dr. Wilson'),
('F-02','Ciencias','Dr. Palmer');

INSERT INTO paciente VALUES
('P-501','Juan','Rivas','600-111'),
('P-502','Ana','Soto','600-222'),
('P-503','Luis','Paz','600-333');

INSERT INTO medico VALUES
('M-10','Dr. House','Infectología','F-01'),
('M-22','Dra. Grey','Cardiología','F-01'),
('M-30','Dr. Strange','Neurocirugía','F-02');

INSERT INTO hospital VALUES
('H-01','Centro Médico','Calle 5 #10'),
('H-02','Clínica Norte','Av. Libertador');

INSERT INTO cita VALUES
('C-001','2024-05-10','Gripe Fuerte','P-501','M-10','H-01'),
('C-002','2024-05-11','Infección','P-502','M-10','H-01'),
('C-003','2024-05-12','Arritmia','P-501','M-22','H-02'),
('C-004','2024-05-15','Migraña','P-503','M-30','H-02');

INSERT INTO medicamento VALUES
('MED-01','Paracetamol'),
('MED-02','Ibuprofeno'),
('MED-03','Amoxicilina'),
('MED-04','Aspirina'),
('MED-05','Ergotamina');

INSERT INTO receta VALUES
('R-01','C-001','MED-01','500mg'),
('R-02','C-001','MED-02','400mg'),
('R-03','C-002','MED-03','875mg'),
('R-04','C-003','MED-04','100mg'),
('R-05','C-004','MED-05','1mg');

CREATE TABLE log_errores (
    id_error INT AUTO_INCREMENT PRIMARY KEY,
    objeto VARCHAR(100),
    nombre_tabla VARCHAR(100),
    codigo_error INT,
    mensaje TEXT,
    fecha_hora TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

DELIMITER $$

CREATE PROCEDURE sp_insert_paciente(
    IN p_id VARCHAR(10),
    IN p_nombre VARCHAR(100),
    IN p_apellido VARCHAR(100),
    IN p_telefono VARCHAR(20)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        INSERT INTO log_errores 
        VALUES (NULL,'sp_insert_paciente','paciente',1,'Error al insertar',NOW());
    END;

    SET @sql = 'INSERT INTO paciente VALUES (?,?,?,?)';

    SET @a = p_id;
    SET @b = p_nombre;
    SET @c = p_apellido;
    SET @d = p_telefono;

    PREPARE stmt FROM @sql;
    EXECUTE stmt USING @a,@b,@c,@d;
    DEALLOCATE PREPARE stmt;
END$$


CREATE PROCEDURE sp_update_paciente(
    IN p_id VARCHAR(10),
    IN p_nombre VARCHAR(100),
    IN p_apellido VARCHAR(100),
    IN p_telefono VARCHAR(20)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        INSERT INTO log_errores 
        VALUES (NULL,'sp_update_paciente','paciente',2,'Error al actualizar',NOW());
    END;

    SET @sql = '
        UPDATE paciente
        SET nombres=?,
            apellidos=?,
            telefono=?
        WHERE id_paciente=?';

    SET @a = p_nombre;
    SET @b = p_apellido;
    SET @c = p_telefono;
    SET @d = p_id;

    PREPARE stmt FROM @sql;
    EXECUTE stmt USING @a,@b,@c,@d;
    DEALLOCATE PREPARE stmt;
END$$


CREATE PROCEDURE sp_delete_paciente(IN p_id VARCHAR(10))
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        INSERT INTO log_errores 
        VALUES (NULL,'sp_delete_paciente','paciente',3,'Error al eliminar',NOW());
    END;

    SET @sql = 'DELETE FROM paciente WHERE id_paciente=?';

    SET @a = p_id;

    PREPARE stmt FROM @sql;
    EXECUTE stmt USING @a;
    DEALLOCATE PREPARE stmt;
END$$


CREATE PROCEDURE sp_get_paciente(IN p_id VARCHAR(10))
BEGIN
    SET @sql = 'SELECT * FROM paciente WHERE id_paciente=?';

    SET @a = p_id;

    PREPARE stmt FROM @sql;
    EXECUTE stmt USING @a;
    DEALLOCATE PREPARE stmt;
END$$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE sp_insert_facultad(
    IN p_id VARCHAR(10),
    IN p_nombre VARCHAR(100),
    IN p_decano VARCHAR(100)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        INSERT INTO log_errores 
        VALUES(NULL,'sp_insert_facultad','facultad',1,'Error al insertar',NOW());
    END;

    SET @sql = 'INSERT INTO facultad VALUES (?,?,?)';

    SET @a = p_id;
    SET @b = p_nombre;
    SET @c = p_decano;

    PREPARE stmt FROM @sql;
    EXECUTE stmt USING @a,@b,@c;
    DEALLOCATE PREPARE stmt;
END$$


CREATE PROCEDURE sp_update_facultad(
    IN p_id VARCHAR(10),
    IN p_nombre VARCHAR(100),
    IN p_decano VARCHAR(100)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        INSERT INTO log_errores 
        VALUES(NULL,'sp_update_facultad','facultad',2,'Error al actualizar',NOW());
    END;

    SET @sql = '
        UPDATE facultad
        SET nombre_facultad=?,
            decano=?
        WHERE id_facultad=?';

    SET @a = p_nombre;
    SET @b = p_decano;
    SET @c = p_id;

    PREPARE stmt FROM @sql;
    EXECUTE stmt USING @a,@b,@c;
    DEALLOCATE PREPARE stmt;
END$$


CREATE PROCEDURE sp_delete_facultad(IN p_id VARCHAR(10))
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        INSERT INTO log_errores 
        VALUES(NULL,'sp_delete_facultad','facultad',3,'Error al eliminar',NOW());
    END;

    SET @sql = 'DELETE FROM facultad WHERE id_facultad=?';

    SET @a = p_id;

    PREPARE stmt FROM @sql;
    EXECUTE stmt USING @a;
    DEALLOCATE PREPARE stmt;
END$$


CREATE PROCEDURE sp_get_facultad(IN p_id VARCHAR(10))
BEGIN
    SET @sql = 'SELECT * FROM facultad WHERE id_facultad=?';

    SET @a = p_id;

    PREPARE stmt FROM @sql;
    EXECUTE stmt USING @a;
    DEALLOCATE PREPARE stmt;
END$$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE sp_insert_medico(
    IN p_id VARCHAR(10),
    IN p_nombre VARCHAR(100),
    IN p_especialidad VARCHAR(100),
    IN p_facultad VARCHAR(10)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        INSERT INTO log_errores 
        VALUES(NULL,'sp_insert_medico','medico',1,'Error al insertar',NOW());
    END;

    SET @sql = 'INSERT INTO medico VALUES (?,?,?,?)';

    SET @a = p_id;
    SET @b = p_nombre;
    SET @c = p_especialidad;
    SET @d = p_facultad;

    PREPARE stmt FROM @sql;
    EXECUTE stmt USING @a,@b,@c,@d;
    DEALLOCATE PREPARE stmt;
END$$


CREATE PROCEDURE sp_update_medico(
    IN p_id VARCHAR(10),
    IN p_nombre VARCHAR(100),
    IN p_especialidad VARCHAR(100),
    IN p_facultad VARCHAR(10)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        INSERT INTO log_errores 
        VALUES(NULL,'sp_update_medico','medico',2,'Error al actualizar',NOW());
    END;

    SET @sql = '
        UPDATE medico
        SET nombre=?,
            especialidad=?,
            id_facultad=?
        WHERE id_medico=?';

    SET @a = p_nombre;
    SET @b = p_especialidad;
    SET @c = p_facultad;
    SET @d = p_id;

    PREPARE stmt FROM @sql;
    EXECUTE stmt USING @a,@b,@c,@d;
    DEALLOCATE PREPARE stmt;
END$$


CREATE PROCEDURE sp_delete_medico(IN p_id VARCHAR(10))
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        INSERT INTO log_errores 
        VALUES(NULL,'sp_delete_medico','medico',3,'Error al eliminar',NOW());
    END;

    SET @sql = 'DELETE FROM medico WHERE id_medico=?';

    SET @a = p_id;

    PREPARE stmt FROM @sql;
    EXECUTE stmt USING @a;
    DEALLOCATE PREPARE stmt;
END$$


CREATE PROCEDURE sp_get_medico(IN p_id VARCHAR(10))
BEGIN
    SET @sql = 'SELECT * FROM medico WHERE id_medico=?';

    SET @a = p_id;

    PREPARE stmt FROM @sql;
    EXECUTE stmt USING @a;
    DEALLOCATE PREPARE stmt;
END$$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE sp_insert_hospital(
    IN p_id VARCHAR(10),
    IN p_nombre VARCHAR(100),
    IN p_direccion VARCHAR(150)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        INSERT INTO log_errores 
        VALUES(NULL,'sp_insert_hospital','hospital',1,'Error al insertar',NOW());
    END;

    SET @sql = 'INSERT INTO hospital VALUES (?,?,?)';

    SET @a = p_id;
    SET @b = p_nombre;
    SET @c = p_direccion;

    PREPARE stmt FROM @sql;
    EXECUTE stmt USING @a,@b,@c;
    DEALLOCATE PREPARE stmt;
END$$


CREATE PROCEDURE sp_update_hospital(
    IN p_id VARCHAR(10),
    IN p_nombre VARCHAR(100),
    IN p_direccion VARCHAR(150)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        INSERT INTO log_errores 
        VALUES(NULL,'sp_update_hospital','hospital',2,'Error al actualizar',NOW());
    END;

    SET @sql = '
        UPDATE hospital
        SET nombre=?,
            direccion=?
        WHERE id_hospital=?';

    SET @a = p_nombre;
    SET @b = p_direccion;
    SET @c = p_id;

    PREPARE stmt FROM @sql;
    EXECUTE stmt USING @a,@b,@c;
    DEALLOCATE PREPARE stmt;
END$$


CREATE PROCEDURE sp_delete_hospital(IN p_id VARCHAR(10))
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        INSERT INTO log_errores 
        VALUES(NULL,'sp_delete_hospital','hospital',3,'Error al eliminar',NOW());
    END;

    SET @sql = 'DELETE FROM hospital WHERE id_hospital=?';

    SET @a = p_id;

    PREPARE stmt FROM @sql;
    EXECUTE stmt USING @a;
    DEALLOCATE PREPARE stmt;
END$$


CREATE PROCEDURE sp_get_hospital(IN p_id VARCHAR(10))
BEGIN
    SET @sql = 'SELECT * FROM hospital WHERE id_hospital=?';

    SET @a = p_id;

    PREPARE stmt FROM @sql;
    EXECUTE stmt USING @a;
    DEALLOCATE PREPARE stmt;
END$$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE sp_insert_cita(
    IN p_id VARCHAR(10),
    IN p_fecha DATE,
    IN p_diag VARCHAR(255),
    IN p_paciente VARCHAR(10),
    IN p_medico VARCHAR(10),
    IN p_hospital VARCHAR(10)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        INSERT INTO log_errores 
        VALUES(NULL,'sp_insert_cita','cita',1,'Error al insertar',NOW());
    END;

    SET @sql = '
        INSERT INTO cita 
        (id_cita,fecha,diagnostico,id_paciente,id_medico,id_hospital)
        VALUES (?,?,?,?,?,?)';

    SET @a=p_id;
    SET @b=p_fecha;
    SET @c=p_diag;
    SET @d=p_paciente;
    SET @e=p_medico;
    SET @f=p_hospital;

    PREPARE stmt FROM @sql;
    EXECUTE stmt USING @a,@b,@c,@d,@e,@f;
    DEALLOCATE PREPARE stmt;
END$$


CREATE PROCEDURE sp_update_cita(
    IN p_id VARCHAR(10),
    IN p_fecha DATE,
    IN p_diag VARCHAR(255),
    IN p_paciente VARCHAR(10),
    IN p_medico VARCHAR(10),
    IN p_hospital VARCHAR(10)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        INSERT INTO log_errores 
        VALUES(NULL,'sp_update_cita','cita',2,'Error al actualizar',NOW());
    END;

    SET @sql = '
        UPDATE cita
        SET fecha=?,
            diagnostico=?,
            id_paciente=?,
            id_medico=?,
            id_hospital=?
        WHERE id_cita=?';

    SET @a=p_fecha;
    SET @b=p_diag;
    SET @c=p_paciente;
    SET @d=p_medico;
    SET @e=p_hospital;
    SET @f=p_id;

    PREPARE stmt FROM @sql;
    EXECUTE stmt USING @a,@b,@c,@d,@e,@f;
    DEALLOCATE PREPARE stmt;
END$$


CREATE PROCEDURE sp_delete_cita(IN p_id VARCHAR(10))
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        INSERT INTO log_errores 
        VALUES(NULL,'sp_delete_cita','cita',3,'Error al eliminar',NOW());
    END;

    SET @sql = 'DELETE FROM cita WHERE id_cita=?';

    SET @a=p_id;

    PREPARE stmt FROM @sql;
    EXECUTE stmt USING @a;
    DEALLOCATE PREPARE stmt;
END$$


CREATE PROCEDURE sp_get_cita(IN p_id VARCHAR(10))
BEGIN
    SET @sql = 'SELECT * FROM cita WHERE id_cita=?';

    SET @a=p_id;

    PREPARE stmt FROM @sql;
    EXECUTE stmt USING @a;
    DEALLOCATE PREPARE stmt;
END$$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE sp_insert_medicamento(
    IN p_id VARCHAR(10),
    IN p_nombre VARCHAR(100)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        INSERT INTO log_errores 
        VALUES(NULL,'sp_insert_medicamento','medicamento',1,'Error al insertar',NOW());
    END;

    SET @sql = '
        INSERT INTO medicamento (id_medicamento,nombre)
        VALUES (?,?)';

    SET @a=p_id;
    SET @b=p_nombre;

    PREPARE stmt FROM @sql;
    EXECUTE stmt USING @a,@b;
    DEALLOCATE PREPARE stmt;
END$$


CREATE PROCEDURE sp_update_medicamento(
    IN p_id VARCHAR(10),
    IN p_nombre VARCHAR(100)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        INSERT INTO log_errores 
        VALUES(NULL,'sp_update_medicamento','medicamento',2,'Error al actualizar',NOW());
    END;

    SET @sql = '
        UPDATE medicamento
        SET nombre=?
        WHERE id_medicamento=?';

    SET @a=p_nombre;
    SET @b=p_id;

    PREPARE stmt FROM @sql;
    EXECUTE stmt USING @a,@b;
    DEALLOCATE PREPARE stmt;
END$$


CREATE PROCEDURE sp_delete_medicamento(IN p_id VARCHAR(10))
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        INSERT INTO log_errores 
        VALUES(NULL,'sp_delete_medicamento','medicamento',3,'Error al eliminar',NOW());
    END;

    SET @sql = 'DELETE FROM medicamento WHERE id_medicamento=?';

    SET @a=p_id;

    PREPARE stmt FROM @sql;
    EXECUTE stmt USING @a;
    DEALLOCATE PREPARE stmt;
END$$


CREATE PROCEDURE sp_get_medicamento(IN p_id VARCHAR(10))
BEGIN
    SET @sql = 'SELECT * FROM medicamento WHERE id_medicamento=?';

    SET @a=p_id;

    PREPARE stmt FROM @sql;
    EXECUTE stmt USING @a;
    DEALLOCATE PREPARE stmt;
END$$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE sp_insert_receta(
    IN p_id VARCHAR(10),
    IN p_cita VARCHAR(10),
    IN p_med VARCHAR(10),
    IN p_dosis VARCHAR(50)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        INSERT INTO log_errores 
        VALUES(NULL,'sp_insert_receta','receta',1,'Error al insertar',NOW());
    END;

    SET @sql = '
        INSERT INTO receta 
        (id_receta,id_cita,id_medicamento,dosis)
        VALUES (?,?,?,?)';

    SET @a=p_id;
    SET @b=p_cita;
    SET @c=p_med;
    SET @d=p_dosis;

    PREPARE stmt FROM @sql;
    EXECUTE stmt USING @a,@b,@c,@d;
    DEALLOCATE PREPARE stmt;
END$$


CREATE PROCEDURE sp_update_receta(
    IN p_id VARCHAR(10),
    IN p_cita VARCHAR(10),
    IN p_med VARCHAR(10),
    IN p_dosis VARCHAR(50)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        INSERT INTO log_errores 
        VALUES(NULL,'sp_update_receta','receta',2,'Error al actualizar',NOW());
    END;

    SET @sql = '
        UPDATE receta
        SET id_cita=?,
            id_medicamento=?,
            dosis=?
        WHERE id_receta=?';

    SET @a=p_cita;
    SET @b=p_med;
    SET @c=p_dosis;
    SET @d=p_id;

    PREPARE stmt FROM @sql;
    EXECUTE stmt USING @a,@b,@c,@d;
    DEALLOCATE PREPARE stmt;
END$$


CREATE PROCEDURE sp_delete_receta(IN p_id VARCHAR(10))
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        INSERT INTO log_errores 
        VALUES(NULL,'sp_delete_receta','receta',3,'Error al eliminar',NOW());
    END;

    SET @sql = 'DELETE FROM receta WHERE id_receta=?';

    SET @a=p_id;

    PREPARE stmt FROM @sql;
    EXECUTE stmt USING @a;
    DEALLOCATE PREPARE stmt;
END$$


CREATE PROCEDURE sp_get_receta(IN p_id VARCHAR(10))
BEGIN
    SET @sql = 'SELECT * FROM receta WHERE id_receta=?';

    SET @a=p_id;

    PREPARE stmt FROM @sql;
    EXECUTE stmt USING @a;
    DEALLOCATE PREPARE stmt;
END$$

DELIMITER ;

DELIMITER $$

CREATE FUNCTION fn_doctores_por_especialidad(p_especialidad VARCHAR(100))
RETURNS INT
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE total INT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        INSERT INTO log_errores(objeto,nombre_tabla,codigo_error,mensaje)
        VALUES('fn_doctores_por_especialidad','medico',101,'Error en función');
        RETURN 0;
    END;

    SELECT COUNT(*) INTO total
    FROM medico
    WHERE especialidad = p_especialidad;

    RETURN total;
END $$

DELIMITER ;

SELECT fn_doctores_por_especialidad('Infectología') as Especialidad;

DELIMITER $$

CREATE FUNCTION fn_pacientes_por_medico(p_id_medico VARCHAR(10))
RETURNS INT
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE total INT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        INSERT INTO log_errores(objeto,nombre_tabla,codigo_error,mensaje)
        VALUES('fn_pacientes_por_medico','cita',102,'Error en función');
        RETURN 0;
    END;

    SELECT COUNT(DISTINCT id_paciente)
    INTO total
    FROM cita
    WHERE id_medico = p_id_medico;

    RETURN total;
END $$

DELIMITER ;

SELECT fn_pacientes_por_medico('M-10') as total_medico;

DELIMITER $$

CREATE FUNCTION fn_pacientes_por_sede(p_id_hospital VARCHAR(10))
RETURNS INT
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE total INT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        INSERT INTO log_errores(objeto,nombre_tabla,codigo_error,mensaje)
        VALUES('fn_pacientes_por_sede','cita',103,'Error en función');
        RETURN 0;
    END;

    SELECT COUNT(DISTINCT id_paciente)
    INTO total
    FROM cita
    WHERE id_hospital = p_id_hospital;

    RETURN total;
END $$

DELIMITER ;

SELECT fn_pacientes_por_sede('H-01') as pacientes_sede;

CALL sp_insert_paciente('P-900','Carlos','Lopez','300999');

SELECT fn_doctores_por_especialidad('Cardiología') as especialidad;

SELECT fn_pacientes_por_medico('M-10') as total_pacientes_x_medico;

SELECT fn_pacientes_por_sede('H-02')total_pacientes_x_sede;

CALL sp_insert_paciente('P-501','Juan','Rivas','600-111');

CALL sp_insert_medico('M-99','Dr Error','Oncología','F-99');

CALL sp_insert_cita('C-999','2024-06-01','Prueba','P-999','M-10','H-01');

CALL sp_delete_medico('M-10');

CALL sp_insert_receta('R-999','C-001','MED-999','500mg');

CALL sp_insert_hospital('H-99',NULL,'Direccion prueba');

SELECT * FROM log_errores ORDER BY fecha_hora asc;

create event limpiarLogs
on schedule every 5 minute
do
	delete from logs where fecha <now() - interval 5 minute;
    
    
set global event_scheduler = on;

CREATE ROLE rol_admin;
CREATE ROLE rol_recepcionista;
CREATE ROLE rol_medico;
CREATE ROLE rol_farmacia;
CREATE ROLE rol_paciente;

GRANT ALL PRIVILEGES ON *.* TO rol_admin;

GRANT SELECT, INSERT, UPDATE ON paciente TO rol_recepcionista;
GRANT SELECT, INSERT, UPDATE ON cita TO rol_recepcionista;

GRANT SELECT ON medico TO rol_recepcionista;
GRANT SELECT ON hospital TO rol_recepcionista;

GRANT SELECT ON paciente TO rol_medico;
GRANT SELECT ON cita TO rol_medico;

GRANT INSERT, UPDATE ON receta TO rol_medico;
GRANT SELECT ON medicamento TO rol_medico;

GRANT SELECT ON medicamento TO rol_farmacia;
GRANT SELECT ON receta TO rol_farmacia;

GRANT SELECT ON cita TO rol_paciente;
GRANT SELECT ON receta TO rol_paciente;

CREATE USER 'admin1'@'localhost' IDENTIFIED BY '1234$';
GRANT rol_admin TO 'admin1'@'localhost';
SET DEFAULT ROLE rol_admin TO 'admin1'@'localhost';


CREATE USER 'recepcion1'@'localhost' IDENTIFIED BY '1234$';
GRANT rol_recepcionista TO 'recepcion1'@'localhost';
SET DEFAULT ROLE rol_recepcionista TO 'recepcion1'@'localhost';


CREATE USER 'medico1'@'localhost' IDENTIFIED BY '1234$';
GRANT rol_medico TO 'medico1'@'localhost';
SET DEFAULT ROLE rol_medico TO 'medico1'@'localhost';


CREATE USER 'farmacia1'@'localhost' IDENTIFIED BY '1234$';
GRANT rol_farmacia TO 'farmacia1'@'localhost';
SET DEFAULT ROLE rol_farmacia TO 'farmacia1'@'localhost';


CREATE USER 'paciente1'@'localhost' IDENTIFIED BY '1234$';
GRANT rol_paciente TO 'paciente1'@'localhost';
SET DEFAULT ROLE rol_paciente TO 'paciente1'@'localhost';

DELIMITER $$

CREATE TRIGGER trg_validar_paciente_insert
BEFORE INSERT ON paciente
FOR EACH ROW
BEGIN

    IF NEW.nombres IS NULL OR NEW.nombres = '' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El nombre del paciente es obligatorio';
    END IF;

    IF NEW.telefono IS NULL OR NEW.telefono = '' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El teléfono del paciente es obligatorio';
    END IF;

END$$

DELIMITER ;

DELIMITER $$

CREATE TRIGGER trg_validar_paciente_update
BEFORE UPDATE ON paciente
FOR EACH ROW
BEGIN

    IF NEW.nombres IS NULL OR NEW.nombres = '' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El nombre del paciente es obligatorio';
    END IF;

    IF NEW.telefono IS NULL OR NEW.telefono = '' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El teléfono del paciente es obligatorio';
    END IF;

END$$

DELIMITER ;

DELIMITER $$

CREATE TRIGGER trg_validar_fecha_cita_insert
BEFORE INSERT ON cita
FOR EACH ROW
BEGIN

    IF NEW.fecha > CURDATE() THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'La fecha de la cita no puede ser futura';
    END IF;

END$$

DELIMITER ;

DELIMITER $$

CREATE TRIGGER trg_validar_fecha_cita_update
BEFORE UPDATE ON cita
FOR EACH ROW
BEGIN

    IF NEW.fecha > CURDATE() THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'La fecha de la cita no puede ser futura';
    END IF;

END$$

DELIMITER ;

CREATE TABLE informe_diario_citas (
    id_informe INT AUTO_INCREMENT PRIMARY KEY,
    fecha DATE,
    hospital_id VARCHAR(10),
    nombre_hospital VARCHAR(100),
    medico_id VARCHAR(10),
    nombre_medico VARCHAR(100),
    total_pacientes INT,
    fecha_generacion DATETIME DEFAULT CURRENT_TIMESTAMP
);

DELIMITER $$


CREATE PROCEDURE sp_generar_informe_diario()
BEGIN

    SET SQL_SAFE_UPDATES = 0;

    DELETE FROM informe_diario_citas
    WHERE fecha = CURDATE();

    INSERT INTO informe_diario_citas
    (
        fecha,
        hospital_id,
        nombre_hospital,
        medico_id,
        nombre_medico,
        total_pacientes
    )
    SELECT 
        c.fecha,
        h.id_hospital,
        h.nombre,
        m.id_medico,
        m.nombre,
        COUNT(DISTINCT c.id_paciente)
    FROM cita c
    JOIN hospital h ON c.id_hospital = h.id_hospital
    JOIN medico m ON c.id_medico = m.id_medico
    WHERE c.fecha = CURDATE()
    GROUP BY 
        c.fecha,
        h.id_hospital,
        h.nombre,
        m.id_medico,
        m.nombre;

END$$

DELIMITER ;

DELIMITER ;

SET GLOBAL event_scheduler = ON;

DELIMITER $$

CREATE EVENT ev_informe_diario
ON SCHEDULE EVERY 1 DAY
STARTS CURRENT_DATE + INTERVAL 1 DAY
DO
BEGIN
    CALL sp_generar_informe_diario();
END$$

DELIMITER ;

CALL sp_generar_informe_diario();

SELECT * FROM informe_diario_citas;