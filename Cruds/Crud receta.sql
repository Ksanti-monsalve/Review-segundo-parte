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
        INSERT INTO log_errores VALUES(NULL,'sp_insert_receta','receta',1,'Error al insertar',NOW());
    END;

    INSERT INTO receta VALUES(p_id,p_cita,p_med,p_dosis);
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
        INSERT INTO log_errores VALUES(NULL,'sp_update_receta','receta',2,'Error al actualizar',NOW());
    END;

    UPDATE receta
    SET id_cita=p_cita,
        id_medicamento=p_med,
        dosis=p_dosis
    WHERE id_receta=p_id;
END$$


CREATE PROCEDURE sp_delete_receta(IN p_id VARCHAR(10))
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        INSERT INTO log_errores VALUES(NULL,'sp_delete_receta','receta',3,'Error al eliminar',NOW());
    END;

    DELETE FROM receta WHERE id_receta=p_id;
END$$


CREATE PROCEDURE sp_get_receta(IN p_id VARCHAR(10))
BEGIN
    SELECT * FROM receta WHERE id_receta=p_id;
END$$

DELIMITER ;