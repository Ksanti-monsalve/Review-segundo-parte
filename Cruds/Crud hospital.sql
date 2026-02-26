DELIMITER $$

CREATE PROCEDURE sp_insert_hospital(
    IN p_id VARCHAR(10),
    IN p_nombre VARCHAR(100),
    IN p_direccion VARCHAR(150)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        INSERT INTO log_errores VALUES(NULL,'sp_insert_hospital','hospital',1,'Error al insertar',NOW());
    END;

    INSERT INTO hospital VALUES(p_id,p_nombre,p_direccion);
END$$


CREATE PROCEDURE sp_update_hospital(
    IN p_id VARCHAR(10),
    IN p_nombre VARCHAR(100),
    IN p_direccion VARCHAR(150)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        INSERT INTO log_errores VALUES(NULL,'sp_update_hospital','hospital',2,'Error al actualizar',NOW());
    END;

    UPDATE hospital
    SET nombre=p_nombre,
        direccion=p_direccion
    WHERE id_hospital=p_id;
END$$


CREATE PROCEDURE sp_delete_hospital(IN p_id VARCHAR(10))
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        INSERT INTO log_errores VALUES(NULL,'sp_delete_hospital','hospital',3,'Error al eliminar',NOW());
    END;

    DELETE FROM hospital WHERE id_hospital=p_id;
END$$


CREATE PROCEDURE sp_get_hospital(IN p_id VARCHAR(10))
BEGIN
    SELECT * FROM hospital WHERE id_hospital=p_id;
END$$

DELIMITER ;