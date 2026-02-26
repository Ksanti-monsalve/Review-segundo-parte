DELIMITER $$

CREATE PROCEDURE sp_insert_facultad(
    IN p_id VARCHAR(10),
    IN p_nombre VARCHAR(100),
    IN p_decano VARCHAR(100)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        INSERT INTO log_errores VALUES(NULL,'sp_insert_facultad','facultad',1,'Error al insertar',NOW());
    END;

    INSERT INTO facultad VALUES(p_id,p_nombre,p_decano);
END$$


CREATE PROCEDURE sp_update_facultad(
    IN p_id VARCHAR(10),
    IN p_nombre VARCHAR(100),
    IN p_decano VARCHAR(100)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        INSERT INTO log_errores VALUES(NULL,'sp_update_facultad','facultad',2,'Error al actualizar',NOW());
    END;

    UPDATE facultad
    SET nombre_facultad=p_nombre,
        decano=p_decano
    WHERE id_facultad=p_id;
END$$


CREATE PROCEDURE sp_delete_facultad(IN p_id VARCHAR(10))
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        INSERT INTO log_errores VALUES(NULL,'sp_delete_facultad','facultad',3,'Error al eliminar',NOW());
    END;

    DELETE FROM facultad WHERE id_facultad=p_id;
END$$


CREATE PROCEDURE sp_get_facultad(IN p_id VARCHAR(10))
BEGIN
    SELECT * FROM facultad WHERE id_facultad=p_id;
END$$

DELIMITER ;