DELIMITER $$

CREATE PROCEDURE sp_insert_medicamento(
    IN p_id VARCHAR(10),
    IN p_nombre VARCHAR(100)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        INSERT INTO log_errores VALUES(NULL,'sp_insert_medicamento','medicamento',1,'Error al insertar',NOW());
    END;

    INSERT INTO medicamento VALUES(p_id,p_nombre);
END$$


CREATE PROCEDURE sp_update_medicamento(
    IN p_id VARCHAR(10),
    IN p_nombre VARCHAR(100)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        INSERT INTO log_errores VALUES(NULL,'sp_update_medicamento','medicamento',2,'Error al actualizar',NOW());
    END;

    UPDATE medicamento
    SET nombre=p_nombre
    WHERE id_medicamento=p_id;
END$$


CREATE PROCEDURE sp_delete_medicamento(IN p_id VARCHAR(10))
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        INSERT INTO log_errores VALUES(NULL,'sp_delete_medicamento','medicamento',3,'Error al eliminar',NOW());
    END;

    DELETE FROM medicamento WHERE id_medicamento=p_id;
END$$


CREATE PROCEDURE sp_get_medicamento(IN p_id VARCHAR(10))
BEGIN
    SELECT * FROM medicamento WHERE id_medicamento=p_id;
END$$

DELIMITER ;