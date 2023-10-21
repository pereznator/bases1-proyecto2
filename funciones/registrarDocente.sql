-- FUNCION REGISTRAR DOCENTE
CREATE FUNCTION registrarDocente(
	_dpi BIGINT,
	_nombres VARCHAR(250),
	_apelliddos VARCHAR(250),
	_fechaNacimiento DATE,
	_correo VARCHAR(250),
	_telefono INT,
	_direccion VARCHAR(250),
	_registroSif INT
)
RETURNS VARCHAR(250)
DETERMINISTIC
BEGIN
	DECLARE mensajeRespuesta VARCHAR(250);
	DECLARE mensajeError VARCHAR(250);
	DECLARE esFormatoCorreo BOOLEAN;

	SET esFormatoCorreo = FALSE;
	SET esFormatoCorreo = _correo REGEXP '^[A-Za-z0-9._%-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}$';
	
	IF NOT esFormatoCorreo THEN
		SET mensajeError = "ERROR: el correo no tiene el formato correcto.";
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = mensajeError;
	END IF;

	INSERT INTO docente (
		dpi,
		nombres,
		apellidos,
		fechaNacimiento,
		correo,
		telefono,
		direccion,
		registroSif
	) VALUES (
		_dpi,
		_nombres,
		_apelliddos,
		_fechaNacimiento,
		_correo,
		_telefono,
		_direccion,
		_registroSif
	);

	SET mensajeRespuesta = "EXITO: Docente creado exitosamente.";
	RETURN mensajeRespuesta;
END;

SELECT registrarDocente(
	3004272120101,
	"OTTO",
	"ESCOBAR LEIVA",
	"1970-01-01",
	"otto.escobar@gmail.com",
	12345678,
	"Guatemala city",
	1
);

DROP FUNCTION registrarDocente;




