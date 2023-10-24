-- PROCEDIMIENTO CONSULTAR ESTUDIANTE	
CREATE PROCEDURE consultarEstudiante(IN _carnet BIGINT)
BEGIN
	SELECT
	e.carnet,
	CONCAT(e.nombres, " ", e.apellidos) AS "Nombre Completo",
	e.fechaDeNacimiento,
	e.correo,
	e.telefono,
	e.direccion,
	e.dpi,
	c.nombre AS "carrera",
	e.creditos
	FROM estudiante e 
	JOIN carrera c on c.id = e.idCarrera 
	WHERE e.carnet = _carnet;
END

CALL consultarEstudiante(201900810); 

DROP PROCEDURE consultarEstudiante; 





