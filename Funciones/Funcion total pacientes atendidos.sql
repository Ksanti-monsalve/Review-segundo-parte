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