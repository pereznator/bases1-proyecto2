# FUNCION REGISTRAR ESTUDIANTE
CREATE FUNCTION registrarEstudiante (
	_carnet BIGINT,
	_nombres VARCHAR(250),
	_apellidos VARCHAR(250),
	_fechaNacimiento DATE,
	_correo VARCHAR(250),
	_telefono INT,
	_direccion VARCHAR(250),
	_dpi BIGINT,
	_codigoCarrera INT
)
RETURNS VARCHAR(250)
DETERMINISTIC
BEGIN
	DECLARE mensajeRespuesta VARCHAR(250);
	DECLARE mensajeError VARCHAR(250);
	DECLARE existeCarrera BOOLEAN;
	DECLARE esFormatoCorreo BOOLEAN;

	SET esFormatoCorreo = FALSE;
	SET esFormatoCorreo = _correo REGEXP '^[A-Za-z0-9._%-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}$';
	
	IF NOT esFormatoCorreo THEN
		SET mensajeError = "ERROR: el correo no tiene el formato correcto.";
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = mensajeError;
	END IF;

	SELECT COUNT(*) INTO existeCarrera FROM carrera WHERE id = _codigoCarrera;

	IF existeCarrera = FALSE THEN
		SET mensajeError = "ERROR: No existe carrera con ese codigo.";
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = mensajeError;
	END IF;

	INSERT INTO estudiante (
		carnet,
		nombres,
		apellidos,
		fechaDeNacimiento,
		correo,
		telefono,
		direccion,
		dpi,
		idCarrera
	) VALUES (
		_carnet,
		_nombres,
		_apellidos,
		_fechaNacimiento,
		_correo,
		_telefono,
		_direccion,
		_dpi,
		_codigoCarrera
	);

	SET mensajeRespuesta = "EXITO: Estudiante creado exitosamente.";
	RETURN mensajeRespuesta;
END;


select registrarEstudiante(
	201900810,
	"Jorge Antonio",
	"Perez Ordonez",
	"2000-06-07",
	"jorgeperezlj@gmail.com",
	56347131,
	"direccion",
	3004272120101,
	1
);


-- ELIMINAR FUNCION
drop function registrarEstudiante;


