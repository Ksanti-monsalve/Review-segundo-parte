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
        INSERT INTO log_errores VALUES(NULL,'sp_insert_cita','cita',1,'Error al insertar',NOW());
    END;

    INSERT INTO cita VALUES(p_id,p_fecha,p_diag,p_paciente,p_medico,p_hospital);
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
        INSERT INTO log_errores VALUES(NULL,'sp_update_cita','cita',2,'Error al actualizar',NOW());
    END;

    UPDATE cita
    SET fecha=p_fecha,
        diagnostico=p_diag,
        id_paciente=p_paciente,
        id_medico=p_medico,
        id_hospital=p_hospital
    WHERE id_cita=p_id;
END$$


CREATE PROCEDURE sp_delete_cita(IN p_id VARCHAR(10))
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        INSERT INTO log_errores VALUES(NULL,'sp_delete_cita','cita',3,'Error al eliminar',NOW());
    END;

    DELETE FROM cita WHERE id_cita=p_id;
END$$


CREATE PROCEDURE sp_get_cita(IN p_id VARCHAR(10))
BEGIN
    SELECT * FROM cita WHERE id_cita=p_id;
END$$

DELIMITER ;