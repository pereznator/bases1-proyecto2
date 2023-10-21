-- FUNCTION CREAR CURSO
CREATE FUNCTION crearCurso (
	_codigo INT,
	_nombre VARCHAR(250),
	_creditosNecesarios INT,
	_cretidosOtorgados INT,
	_codigoCarrera INT,
	_esObligatorio BOOL
)
RETURNS INT
DETERMINISTIC 
BEGIN
	DECLARE mensajeError VARCHAR(255);
	DECLARE existeCurso BOOL;
	DECLARE existeCarrera BOOL;
	DECLARE codigoDeCursoCreado INT;

	IF _creditosNecesarios < 0 THEN
		SET mensajeError = "ERROR: Creditos necesarios debe ser mayor o igual a cero.";
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = mensajeError;
	END IF;

    IF _cretidosOtorgados <= 0 THEN
        SET mensajeError = "Creditos que otroga debe ser mayor a cero.";
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = mensajeError;
    END IF;
   
   SELECT COUNT(*) INTO existeCarrera FROM carrera WHERE id = _codigoCarrera;
  	IF existeCarrera = FALSE THEN
  		SET mensajeError = "No existe una carrera con ese codigo.";
  		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = mensajeError;
  	END IF;
   
  	SELECT COUNT(*) INTO existeCurso FROM curso WHERE codigo = _codigo;
  	IF existeCurso = TRUE THEN
  		SET mensajeError = "Ya existe un curso con ese codigo.";
  		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = mensajeError;
  	END IF;

  	INSERT INTO curso (
  		codigo,
		nombre,
		creditosNecesarios,
		creditosOtorgados,
		carrera,
		obligatorio
  	) VALUES (
  		_codigo,
		_nombre,
		_creditosNecesarios,
		_cretidosOtorgados,
		_codigoCarrera,
		_esObligatorio
  	);
  
	SET codigoDeCursoCreado = _codigo;
	RETURN codigoDeCursoCreado;
END;


SELECT crearCurso(
	140,
	"Compi 1",
	125,
	5,
	2,
	TRUE
);

DROP FUNCTION crearCurso;

