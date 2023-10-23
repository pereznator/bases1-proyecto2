-- FUNCION INGRESAR NOTA
CREATE FUNCTION ingresarNota (
	_codigoCurso INT,
	_ciclo CHAR(2),
	_seccion CHAR(1),
	_carnet BIGINT,
	_nota DECIMAL(10, 2)
)
RETURNS INT
DETERMINISTIC
BEGIN
	DECLARE mensajeError VARCHAR(250);
	DECLARE notaRedondeada INT;
	DECLARE cicloMayusculas CHAR(2);
	DECLARE seccionMayuscula CHAR(1);
	DECLARE esSeccionValida BOOL;
	DECLARE existeCurso BOOL;
	DECLARE existeEstudiante BOOL;
	DECLARE _idCursoHabilitado BOOL;
	DECLARE existeAsignacion BOOL;
	DECLARE cursoAprobado BOOL;
	DECLARE creditos INT;
	SET notaRedondeada = ROUND(_nota);

	IF notaRedondeada < 0 THEN
		SET mensajeError = "Nota debe ser un numero positivo.";
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = mensajeError;
	END IF;

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

	SET cursoAprobado = notaRedondeada >= 61;

	IF cursoAprobado THEN
		SELECT c.creditosOtorgados INTO creditos FROM curso c WHERE c.codigo = _codigoCurso;
		UPDATE estudiante e SET e.creditos = e.creditos + creditos WHERE e.carnet = _carnet; 
	END IF;
	
	INSERT INTO nota (
		carnet,
		idCursoHabilitado,
		nota,
		aprobada
	) VALUES (
		_carnet,
		_idCursoHabilitado,
		notaRedondeada,
		cursoAprobado
	);

	RETURN _idCursoHabilitado;

END;


SELECT ingresarNota(119, "1s", "a", 201900810, 61);


DROP FUNCTION ingresarNota;



