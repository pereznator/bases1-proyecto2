-- PROCEDIMIENTO CONSULTAR PENSUM
CREATE PROCEDURE consultarPensum(IN codigoCarrera INT)
BEGIN
	SELECT c.codigo, c.nombre, c.obligatorio, c.creditosNecesarios  FROM curso c WHERE c.carrera = codigoCarrera;
END

CALL consultarPensum(2); 


DROP PROCEDURE consultarPensum; 