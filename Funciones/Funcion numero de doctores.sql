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