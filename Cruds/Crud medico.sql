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
        INSERT INTO log_errores VALUES(NULL,'sp_insert_medico','medico',1,'Error al insertar',NOW());
    END;

    INSERT INTO medico VALUES(p_id,p_nombre,p_especialidad,p_facultad);
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
        INSERT INTO log_errores VALUES(NULL,'sp_update_medico','medico',2,'Error al actualizar',NOW());
    END;

    UPDATE medico
    SET nombre=p_nombre,
        especialidad=p_especialidad,
        id_facultad=p_facultad
    WHERE id_medico=p_id;
END$$


CREATE PROCEDURE sp_delete_medico(IN p_id VARCHAR(10))
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        INSERT INTO log_errores VALUES(NULL,'sp_delete_medico','medico',3,'Error al eliminar',NOW());
    END;

    DELETE FROM medico WHERE id_medico=p_id;
END$$


CREATE PROCEDURE sp_get_medico(IN p_id VARCHAR(10))
BEGIN
    SELECT * FROM medico WHERE id_medico=p_id;
END$$

DELIMITER ;