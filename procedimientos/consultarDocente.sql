-- PROCEDIMIENTO CONSULTAR DOCENTE
CREATE PROCEDURE consultarDocente(IN registroSiif BIGINT)
BEGIN
	SELECT
	d.siif AS "Registro SIIF",
	CONCAT(d.nombres, " ", d.apellidos) AS "Nombre Completo",
	d.fechaNacimiento AS "Fecha de Nacimiento",
	d.correo AS "Correo",
	d.telefono AS "Telefono",
	d.direccion AS "Direccion",
	d.dpi AS "DPI"
	FROM docente d WHERE d.siif = registroSiif;
END

CALL consultarDocente(1);


DROP PROCEDURE consultarDocente;