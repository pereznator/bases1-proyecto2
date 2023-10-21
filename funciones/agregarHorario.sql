-- FUNCION AGREGAR HORARIO
CREATE FUNCTION agregarHorario (
	_idCursoHabilitado INT,
	_dia INT,
	_horario VARCHAR(11)
)
RETURNS INT
DETERMINISTIC
BEGIN
	DECLARE mensajeError VARCHAR(250);
	DECLARE existeCurso BOOL;
	DECLARE formatoHorario BOOL;

	IF _dia < 1 OR _dia > 7 THEN 
		SET mensajeError = "El dia debe ser un numero entre 1 y 7.";
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = mensajeError;
	END IF;

	SET formatoHorario = _horario REGEXP '^([0-1]?[0-9]|2[0-3]):[0-5][0-9]-([0-1]?[0-9]|2[0-3]):[0-5][0-9]$';
	IF NOT formatoHorario THEN
		SET mensajeError = "Horario no tiene el formato correcto.";
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = mensajeError;
	END IF;

	SELECT COUNT(*) INTO existeCurso FROM cursoHabilitado ch WHERE ch.id = _idCursoHabilitado;
	IF NOT existeCurso THEN 
		SET mensajeError = "No se encontro curso habilitado con ese id.";
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = mensajeError;
	END IF;

	INSERT INTO horario (
		idCursoHabilitado,
		dia,
		horario
	) VALUES (
		_idCursoHabilitado,
		_dia,
		_horario
	);

	RETURN _idCursoHabilitado;

END;


SELECT agregarHorario(1, 2, "10:40-12:20");


DROP FUNCTION agregarHorario;




