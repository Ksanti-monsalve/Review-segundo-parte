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
        INSERT INTO log_errores VALUES (NULL,'sp_insert_paciente','paciente',1,'Error al insertar',NOW());
    END;

    INSERT INTO paciente VALUES(p_id,p_nombre,p_apellido,p_telefono);
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
        INSERT INTO log_errores VALUES (NULL,'sp_update_paciente','paciente',2,'Error al actualizar',NOW());
    END;

    UPDATE paciente
    SET nombres=p_nombre,
        apellidos=p_apellido,
        telefono=p_telefono
    WHERE id_paciente=p_id;
END$$


CREATE PROCEDURE sp_delete_paciente(IN p_id VARCHAR(10))
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        INSERT INTO log_errores VALUES (NULL,'sp_delete_paciente','paciente',3,'Error al eliminar',NOW());
    END;

    DELETE FROM paciente WHERE id_paciente=p_id;
END$$


CREATE PROCEDURE sp_get_paciente(IN p_id VARCHAR(10))
BEGIN
    SELECT * FROM paciente WHERE id_paciente=p_id;
END$$

DELIMITER ;