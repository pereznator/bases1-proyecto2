-- PROCEDIMIENTO CONSULTAR APROBACIONES
CREATE PROCEDURE consultarAprobaciones (
	IN _codigoCurso INT,
	IN _ciclo CHAR(2),
	IN _anio INT,
	IN _seccion CHAR(1)
)
BEGIN 
	DECLARE cicloMayusculas CHAR(2);
	DECLARE seccionMayuscula CHAR(1);
	DECLARE esSeccionValida BOOL;
	DECLARE idCursoHabilitado INT;
	DECLARE existeCurso BOOL;
	DECLARE hayEstudiantesConNota BOOL;

	SET cicloMayusculas = UPPER(_ciclo);

	IF cicloMayusculas != "1S" AND cicloMayusculas != "2S" AND cicloMayusculas != "VJ" AND cicloMayusculas != "VD" THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "No se ingreso un ciclo valido.";
	END IF;

	SET esSeccionValida = _seccion REGEXP '^[A-Za-z]$';
	IF esSeccionValida = FALSE THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "Seccion no valida.";	
	END IF;

	SET seccionMayuscula = UPPER(_seccion);

	SELECT COUNT(*) INTO existeCurso FROM curso c WHERE c.codigo = _codigoCurso;
	IF NOT existeCurso THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "No se encontro el curso con ese codigo.";		
	END IF;

	-- Obtener el id del curso habilitado.
	SELECT ch.id INTO idCursoHabilitado FROM cursoHabilitado ch 
	WHERE
	ch.codigoCurso = _codigoCurso 
	AND ch.ciclo = cicloMayusculas 
	AND ch.seccion = seccionMayuscula 
	AND ch.anio = _anio;

	IF idCursoHabilitado IS NULL THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "No se encontro curso habilitado con los parametros ingresados.";	
	END IF;

	SELECT
	COUNT(*)
	INTO hayEstudiantesConNota
	FROM nota n
	JOIN estudiante e on e.carnet = n.carnet 
	WHERE n.idCursoHabilitado = idCursoHabilitado;

	IF NOT hayEstudiantesConNota THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "No se encontraron estudiantes con nota del curso.";	
	END IF;

	SELECT 
	e.carnet,
	CONCAT(e.nombres, " ", e.apellidos) AS "Nombre Completo",
	CASE
        WHEN n.aprobada = 1 THEN 'APROBADO'
        WHEN n.aprobada  = 0 THEN 'REPROBADO'
    END AS "Estado"
	FROM nota n 
	JOIN estudiante e ON e.carnet = n.carnet 
	WHERE n.idCursoHabilitado = idCursoHabilitado;
END


CALL consultarAprobaciones(119, "1s", 2023, "a");

DROP PROCEDURE consultarAprobaciones; 

