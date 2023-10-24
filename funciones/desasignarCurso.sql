-- FUNCION DESASIGNAR CURSO
CREATE FUNCTION desasignarCurso(
	_codigoCurso INT,
	_ciclo CHAR(2),
	_seccion CHAR(1),
	_carnet BIGINT
)
RETURNS INT
DETERMINISTIC
BEGIN
	DECLARE mensajeError VARCHAR(250);
	DECLARE cicloMayusculas CHAR(2);
	DECLARE seccionMayuscula CHAR(1);
	DECLARE esSeccionValida BOOL;
	DECLARE existeCurso BOOL;
	DECLARE existeEstudiante BOOL;
	DECLARE _idCursoHabilitado BOOL;
	DECLARE existeAsignacion BOOL;
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

	-- Validar que el estudiante exista
	SELECT COUNT(*) INTO existeEstudiante FROM estudiante e WHERE e.carnet = _carnet;
	IF NOT existeEstudiante THEN
		SET mensajeError = "No se encontro estudiante con ese carnet.";
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = mensajeError;
	END IF;

	-- Obtener el id del curso habilitado si existe
	SELECT ch.id INTO _idCursoHabilitado FROM cursoHabilitado ch WHERE 
	ch.codigoCurso = _codigoCurso
	AND ch.ciclo = cicloMayusculas
	AND	ch.seccion = seccionMayuscula
	AND ch.anio = YEAR(NOW());

	-- Validar que el curso habilitado exsite
	IF _idCursoHabilitado IS NULL THEN
		SET mensajeError = "No se encontro curso habilitado con los parametros ingresados.";
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = mensajeError;
	END IF;

	-- Validar que el estuidante este asignado al curso habilitado
	SELECT COUNT(*) INTO existeAsignacion FROM asignacion a WHERE 
	a.carnet = _carnet
	AND a.idCursoHabilitado = _idCursoHabilitado;
	IF NOT existeAsignacion THEN
		SET mensajeError = "El estudiante no esta asignado al curso habilitado.";
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = mensajeError;
	END IF;
	
	DELETE FROM asignacion WHERE carnet = _carnet and idCursoHabilitado = _idCursoHabilitado;

	RETURN _idCursoHabilitado;
	
END;


-- TRIGGER PARA DISMINUIR LA CANTIDAD DE ESTUDIANTES ASIGNADOS A CURSO HABILITADO
CREATE TRIGGER disminuirEstudiantesAsignados
AFTER DELETE ON asignacion
FOR EACH ROW
BEGIN
    -- Decrementa el valor de estudiantesAsignados en la tabla Curso
    UPDATE cursoHabilitado
    SET estudiantesAsignados = estudiantesAsignados - 1
    WHERE id = OLD.idCursoHabilitado;
   
   INSERT INTO desasignacion (idCursoHabilitado, carnet) VALUES (OLD.idCursoHabilitado, OLD.carnet);
END;


SELECT desasignarCurso(119, "1s", "a", 201900810);


DROP FUNCTION desasignarCurso;


DROP TRIGGER disminuirEstudiantesAsignados;



