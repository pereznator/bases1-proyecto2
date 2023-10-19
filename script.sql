--- Script para base de datos 

# TABLA CARRERA
CREATE TABLE carrera (
    id INT NOT NULL AUTO_INCREMENT,
    nombre VARCHAR(250) NOT NULL,
    PRIMARY KEY (id)
);

CREATE FUNCTION crearCarrera (
    nombreNuevaCarrera VARCHAR(250)
)
RETURNS INT
DETERMINISTIC
BEGIN 
    DECLARE nuevaCarreraId INT;

    INSERT INTO carrera (nombre) VALUES (nombreNuevaCarrera);

    SET nuevaCarreraId = LAST_INSERT_ID();

    RETURN nuevaCarreraId;
END;

select crearCarrera("Sistemas de Bases de Datos 1");

select * from carrera;

drop table curso;



# TABLA ESTUDIANTE
CREATE TABLE estudiante (
	carnet BIGINT NOT NULL,
	nombres VARCHAR(250) NOT NULL,
	apellidos VARCHAR(250) NOT NULL,
	fechaDeNacimiento DATE NOT NULL,
	correo VARCHAR(250) NOT NULL,
	telefono INT NOT NULL,
	direccion VARCHAR(250) NOT NULL,
	dpi BIGINT NOT NULL,
	idCarrera INT NOT NULL,
	creditos INT NOT NULL DEFAULT 0,
	creado TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	PRIMARY KEY (carnet),
	FOREIGN KEY (idCarrera) REFERENCES carrera(id)
);

CREATE FUNCTION crearEstudiante (
	carnet BIGINT,
	nombres VARCHAR(250),
	apellidos VARCHAR(250),
	fechaNacimiento DATE,
	correo VARCHAR(250),
	telefono INT,
	direccion VARCHAR(250),
	dpi BIGINT,
	codigoCarrera INT
)
RETURNS VARCHAR(250)
DETERMINISTIC
BEGIN
	DECLARE mensajeRespuesta VARCHAR(250);
	
	DECLARE esFormatoCorreo BOOLEAN;
	SET esFormatoCorreo = FALSE;
	SET esFormatoCorreo = correo REGEXP '^[A-Za-z0-9._%-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}$';
	
	IF NOT esFormatoCorreo THEN
		SET mensajeRespuesta = "ERROR: el correo no tiene el formato correcto.";
		RETURN mensajeRespuesta;
	END IF;

	DECLARE existe BOOLEAN;
	SELECT COUNT(*) INTO existe FROM carrera WHERE id = codigoCarrera;

	IF existe = FALSE THEN
		SET mensajeRespuesta = "ERROR: No existe carrera con ese codigo."
		RETURN mensajeRespuesta;
	END IF;

	SET mensajeRespuesta = "EXITO: Estudiante creado exitosamente.";
	RETURN mensajeRespuesta;
END;

drop function crearEstudiante;

-- carnet BIGINT,
-- 	nombres VARCHAR(250),
-- 	apellidos VARCHAR(250),
-- 	fechaNacimiento DATE,
-- 	correo VARCHAR(250),
-- 	telefono INT,
-- 	direccion VARCHAR(250),
-- 	dpi BIGINT,
-- 	carrera INT

select crearEstudiante(
	201900810,
	"Jorge Antonio",
	"Perez Ordonez",
	"2000-06-07",
	"hola mundo",
	56347131,
	"direccion",
	3004272120101,
	1
);

drop table estudiante;
