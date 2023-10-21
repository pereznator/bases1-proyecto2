-- FUNCTION ASIGNAR A CURSO
CREATE FUNCTION asignarCurso (
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
	DECLARE esSeccionValida BOOL;
	DECLARE existeCurso BOOL;
	DECLARE existeEstudiante BOOL;
	DECLARE existeCursoHabilitado BOOL;
	DECLARE yaEstaAsignado BOOL;
	DECLARE seccionMayuscula CHAR(1);
	DECLARE _idCursoHabilitado INT;
	DECLARE creditosNecesarios INT;
	DECLARE creditos INT;
	DECLARE carreraEstudiante INT;
	DECLARE carreraCurso INT;
	DECLARE estudiantesAsignadosEnCurso INT;
	DECLARE cupoParaCurso INT;

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

	SELECT e.creditos, e.idCarrera  INTO creditos, carreraEstudiante FROM estudiante e WHERE e.carnet = _carnet;
	SELECT c.creditosNecesarios, c.carrera  INTO creditosNecesarios, carreraCurso FROM curso c WHERE c.codigo = _codigoCurso;

	-- Validar que el curso sea de la misma carrera que la del estudiante
	IF carreraCurso IS NOT NULL THEN 
		IF carreraCurso != carreraEstudiante THEN
			SET mensajeError = "No se puede asignar un curso de una carrera distinta a la del estudiante.";
			SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = mensajeError;
		END IF;
	END IF;
	
	-- Validar que el estudiante tenga suficientes creditos para llevar el curso
	IF creditosNecesarios > creditos THEN 
		SET mensajeError = "El estudiante no tiene suficientes creditos para llevar el curos.";
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = mensajeError;
	END IF;
	
	-- Validar si el estudiante ya esta asignado
	SELECT COUNT(*) INTO yaEstaAsignado FROM asignacion a WHERE 
	a.carnet = _carnet
	AND a.idCursoHabilitado IN (
		SELECT ch.id FROM cursoHabilitado ch WHERE 
		ch.codigoCurso = _codigoCurso
		AND ch.ciclo = cicloMayusculas
		AND ch.anio = YEAR(NOW())
	);
	IF yaEstaAsignado THEN
		SET mensajeError = "El estudiante ya se encuentra asignado a ese curso este ciclo.";
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = mensajeError;
	END IF;

	
	-- Obtener el id del curso habilitado
	SELECT ch.id, ch.cupoMaximo, ch.estudiantesAsignatos INTO _idCursoHabilitado, cupoParaCurso, estudiantesAsignadosEnCurso FROM cursoHabilitado ch WHERE 
	ch.codigoCurso = _codigoCurso 
	AND ch.ciclo = cicloMayusculas
	AND ch.seccion = seccionMayuscula
	AND ch.anio = YEAR(NOW());
	
	-- Validar que el curso habilitado existe
	IF _idCursoHabilitado IS NULL THEN
		SET mensajeError = "No se encontro curso habilitado con los parametros ingresados.";
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = mensajeError;
	END IF;

	IF cupoParaCurso >= estudiantesAsignadosEnCurso THEN
		SET mensajeError = "Ya no hay cupo en esta seccion.";
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = mensajeError;
	END IF;

	INSERT INTO asignacion (
		carnet,
		idCursoHabilitado
	) VALUES (
		_carnet,
		_idCursoHabilitado
	);
	RETURN _idCursoHabilitado;

END;


-- Trigger para aumetar el numero de estudiantes asignados
CREATE TRIGGER incrementarEstudiantesAsignadosACursoHabilitado
AFTER INSERT ON asignacion
FOR EACH ROW 
BEGIN 
	UPDATE cursoHabilitado 
	SET estudiantesAsignatos = estudiantesAsignatos + 1
	WHERE id = NEW.idCursoHabilitado;
END;


SELECT asignarCurso(119, "2s", "b", 201900810);



DROP FUNCTION asignarCurso;

DROP TRIGGER incrementarEstudiantesAsignadosACursoHabilitado;

