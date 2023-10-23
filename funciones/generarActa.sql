-- FUNCION GENERAR ACTA
CREATE FUNCTION generarActa(
	_codigoCurso INT,
	_ciclo CHAR(2),
	_seccion CHAR(1)
)
RETURNS INT
DETERMINISTIC
BEGIN
	DECLARE mensajeError VARCHAR(250);
	DECLARE cicloMayusculas CHAR(2);
	DECLARE seccionMayuscula CHAR(1);
	DECLARE esSeccionValida BOOL;
	DECLARE existeCurso BOOL;
	DECLARE _idCursoHabilitado BOOL;
	DECLARE estudiantesAsignados INT;
	DECLARE cantidadEstudiantesConNota INT;
	SET cicloMayusculas = UPPER(_ciclo);

	-- Validar que el ciclo tenga formato correcto
	IF cicloMayusculas != "1S" AND cicloMayusculas != "2S" AND cicloMayusculas != "VJ" AND cicloMayusculas != "VD" THEN
		SET mensajeError = "Formato incorrecto para ciclo.";
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = mensajeError;
	END IF;

	-- Validar que la seccion sea una letra
	SET esSeccionValida = _seccion REGEXP '^[A-Za-z]$';
	IF esSeccionValida = FALSE THEN
		SET mensajeError = "La seccion debe ser una letra.";
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = mensajeError;	
	END IF;

	SET seccionMayuscula = UPPER(_seccion);

	-- Validar que el curso exista
	SELECT COUNT(*) INTO existeCurso FROM curso WHERE codigo = _codigoCurso;
	IF existeCurso = FALSE THEN
		SET mensajeError = "No se encontro curso con ese codigo.";
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = mensajeError;	
	END IF;

	-- Obtener el id del curso habilitado si existe
	SELECT ch.id, ch.estudiantesAsignados INTO _idCursoHabilitado, estudiantesAsignados FROM cursoHabilitado ch WHERE 
	ch.codigoCurso = _codigoCurso
	AND ch.ciclo = cicloMayusculas
	AND	ch.seccion = seccionMayuscula
	AND ch.anio = YEAR(NOW());

	-- Validar que el curso habilitado exsite
	IF _idCursoHabilitado IS NULL THEN
		SET mensajeError = "No se encontro curso habilitado con los parametros ingresados.";
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = mensajeError;
	END IF;

	-- Validar que todos los estudiantes tengan su nota
	SELECT COUNT(*) INTO cantidadEstudiantesConNota FROM nota n WHERE n.idCursoHabilitado = _idCursoHabilitado
	AND n.carnet IN (
		SELECT a.carnet FROM asignacion a WHERE a.idCursoHabilitado = _idCursoHabilitado
	);

	IF cantidadEstudiantesConNota < estudiantesAsignados THEN
		SET mensajeError = "No todos los estudiantes asignados tienen nota.";
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = mensajeError;
	END IF;

	INSERT INTO acta (
		idCursoHabilitado,
		ciclo,
		seccion
	) VALUES (
		_idCursoHabilitado,
		cicloMayusculas,
		seccionMayuscula
	);

	RETURN _idCursoHabilitado;
END;


SELECT generarActa(119, "1s", "a");

DROP FUNCTION generarActa;




