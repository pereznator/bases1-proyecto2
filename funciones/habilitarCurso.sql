-- FUNCION HABILITAR CURSO

CREATE FUNCTION habilitarCurso (
	_codigoCurso INT,
	_ciclo CHAR(2),
	_siifDocente BIGINT,
	_cupoMaximo INT,
	_seccion CHAR(1)
)
RETURNS INT
DETERMINISTIC
BEGIN
	DECLARE mensajeError VARCHAR(250);
	DECLARE cicloMayusculas CHAR(2);
	DECLARE seccionMayuscula CHAR(1);
	DECLARE existeCurso BOOL;
	DECLARE existeDocente BOOL;
	DECLARE existeCursoHabilitado BOOL;
	DECLARE esSeccionValida BOOL;
	DECLARE idCursoHabilitado INT;

	SET cicloMayusculas = UPPER(_ciclo);

	IF cicloMayusculas != "1S" AND cicloMayusculas != "2S" AND cicloMayusculas != "VJ" AND cicloMayusculas != "VD" THEN
		SET mensajeError = "Formato incorrecto para ciclo.";
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = mensajeError;
	END IF;

	IF _cupoMaximo <= 0 THEN
		SET mensajeError = "Cupo maximo debe ser mayor a cero.";
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = mensajeError;
	END IF;

	SET esSeccionValida = _seccion REGEXP '^[A-Za-z]$';
	IF esSeccionValida = FALSE THEN
		SET mensajeError = "La seccion debe ser una letra.";
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = mensajeError;	
	END IF;

	SET seccionMayuscula = UPPER(_seccion);

	SELECT COUNT(*) INTO existeCurso FROM curso WHERE codigo = _codigoCurso;
	IF existeCurso = FALSE THEN
		SET mensajeError = "No se encontro curso con ese codigo.";
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = mensajeError;	
	END IF;

	SELECT COUNT(*) INTO existeDocente FROM docente d WHERE d.siif = _siifDocente;
	IF existeDocente = FALSE THEN
		SET mensajeError = "No se encontro docente con ese codigo siif.";
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = mensajeError;
	END IF;

	SELECT COUNT(*) INTO existeCursoHabilitado FROM cursoHabilitado ch WHERE
	ch.codigoCurso = _codigoCurso
	AND ch.ciclo = cicloMayusculas
	AND ch.seccion = seccionMayuscula
	AND ch.anio = YEAR(NOW());

	IF existeCursoHabilitado THEN
		SET mensajeError = "Ya existe un curso habilitado con esa seccion.";
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = mensajeError;
	END IF;

	INSERT INTO cursoHabilitado (
		codigoCurso,
		ciclo,
		seccion,
		siifDocente,
		cupoMaximo
	) VALUES (
		_codigoCurso,
		cicloMayusculas,
		seccionMayuscula,
		_siifDocente,
		_cupoMaximo
	);

	SET idCursoHabilitado = LAST_INSERT_ID(); 

	RETURN idCursoHabilitado;
END;

SELECT habilitarCurso(
	119,
	"1s",
	1,
	50,
	'a'
);

DROP FUNCTION habilitarCurso;
