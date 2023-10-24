-- PROCEDIMIENTO CONSULTAR DESASIGNACIONES

CREATE PROCEDURE consultarDesasignaciones(
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
	DECLARE cantidadDeEstudiantesAsignados INT;
	DECLARE totalDeEstudiantesDelCurso INT;
	DECLARE cantidadDeEstudiantesDesasignados INT;
	DECLARE porcentajeDesasignaciones DECIMAL(10, 2);

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

	SELECT COUNT(*) INTO cantidadDeEstudiantesAsignados FROM asignacion a WHERE a.idCursoHabilitado = idCursoHabilitado;

	SELECT COUNT(*) INTO cantidadDeEstudiantesDesasignados FROM desasignacion d WHERE d.idCursoHabilitado = idCursoHabilitado;

	SET totalDeEstudiantesDelCurso = cantidadDeEstudiantesAsignados + cantidadDeEstudiantesDesasignados;

	SET porcentajeDesasignaciones = cantidadDeEstudiantesDesasignados / totalDeEstudiantesDelCurso * 100;

	SELECT
	_codigoCurso AS "Codigo de Curso",
	seccionMayuscula AS "Seccion",
	CASE
        WHEN cicloMayusculas = "1S" THEN "PRIMER SEMESTRE"
        WHEN cicloMayusculas = "2S" THEN "SEGUNDO SEMESTRE"
        WHEN cicloMayusculas = "VJ" THEN "VACACIONES DE JUNIO"
		WHEN cicloMayusculas = "VD" THEN "VACACIONES DE DICIEMBRE"
    END AS "Ciclo",
    _anio AS "AÑO",
    totalDeEstudiantesDelCurso AS "Cantidad de Estudiantes que llevaron el curso",
	cantidadDeEstudiantesDesasignados AS "Cantidad de Estudiantes que se desasignaron",
	porcentajeDesasignaciones AS "Porcentaje de desasignacion";
END

CALL consultarDesasignaciones(119, "1s", 2023, "a"); 





