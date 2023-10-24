-- PROCEDIMIENTO CONSULTAR ACTAS
CREATE PROCEDURE consultarActas(
	IN _codigoCurso INT
)
BEGIN
	DECLARE existeCurso BOOL;
	
	-- Validar si el curso existe
	SELECT COUNT(*) INTO existeCurso FROM curso c WHERE c.codigo = _codigoCurso;
	IF NOT existeCurso THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "No se encontro curso con ese codigo." ;
	END IF;
	
	SELECT 
	ch.codigoCurso AS "Codigo de Curso",
	ch.seccion AS "Seccion",
	CASE
        WHEN ch.ciclo = "1S" THEN "PRIMER SEMESTRE"
        WHEN ch.ciclo = "2S" THEN "SEGUNDO SEMESTRE"
        WHEN ch.ciclo = "VJ" THEN "VACACIONES DE JUNIO"
		WHEN ch.ciclo = "VD" THEN "VACACIONES DE DICIEMBRE"
    END AS "Ciclo",
    ch.anio,
	COUNT(n.carnet) AS "Cantidad de Notas que fueron Ingresadas",
    a.generadaEn
	FROM acta a 
	JOIN cursoHabilitado ch ON ch.id = a.idCursoHabilitado 
	JOIN nota n ON n.idCursoHabilitado = a.idCursoHabilitado  
	WHERE 
	ch.codigoCurso = 119
	GROUP BY ch.codigoCurso, ch.seccion, ch.ciclo, ch.anio, a.generadaEn 
	ORDER BY a.generadaEn ASC;
END


CALL consultarActas(119); 


DROP PROCEDURE consultarActas;