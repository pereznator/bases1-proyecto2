--- Script para base de datos 

# TABLA CARRERA
CREATE TABLE carrera (
    id INT NOT NULL AUTO_INCREMENT,
    nombre VARCHAR(250) NOT NULL,
    PRIMARY KEY (id)
);


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
	creditos INT NOT NULL DEFAULT 0,
	idCarrera INT NOT NULL,
	creado TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	PRIMARY KEY (carnet)
);

--- Agregar llave foranea a tabla estudiante
ALTER TABLE estudiante
	ADD CONSTRAINT estudiante_carrera_fk FOREIGN KEY ( idCarrera )
    REFERENCES carrera ( id )
    ON DELETE CASCADE;
   
# TABLA DOCENTE
CREATE TABLE docente (
	dpi BIGINT NOT NULL,
	nombres VARCHAR(250) NOT NULL,
	apellidos VARCHAR(250) NOT NULL,
	fechaNacimiento DATE NOT NULL,
	correo VARCHAR(250) NOT NULL,
	telefono INT NOT NULL,
	direccion VARCHAR(250) NOT NULL,
	registroSif INT NOT NULL,
	creado TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	PRIMARY KEY (dpi)
);

# TABLA CURSO
CREATE TABLE curso (
	codigo INT NOT NULL,
	nombre VARCHAR(250) NOT NULL,
	creditosNecesarios INT NOT NULL,
	creditosOtorgados INT NOT NULL,
	carrera INT NOT NULL,
	obligatorio BOOL NOT NULL,
	PRIMARY KEY (codigo)
);

# TABLA CURSO HABILITADO
CREATE TABLE cursoHabilitado (
	id INT NOT NULL AUTO_INCREMENT,
	codigoCurso INT NOT NULL,
	ciclo CHAR(2) NOT NULL,
	seccion CHAR(1) NOT NULL,
	dpiDocente BIGINT NOT NULL,
	cupoMaximo INT NOT NULL,
	anio YEAR NOT NULL,
	estudiantesAsignatos INT NOT NULL DEFAULT 0,
	PRIMARY KEY (id)
);

ALTER TABLE cursoHabilitado 
	ADD CONSTRAINT cursoHabilitado_docente_fk FOREIGN KEY ( dpiDocente )
    REFERENCES docente ( dpi )
    ON DELETE CASCADE;

# TRIGGER PARA AGREGAR AÑO CADA VEZ QUE SE INSERTE UN REGISTRO EN LA TABLA CURSO HABILITADO
CREATE TRIGGER ins_anio
BEFORE INSERT ON cursoHabilitado
    FOR EACH ROW SET NEW.anio = YEAR(NOW());
   
# TABLA HORARIO CURSO
CREATE TABLE horario (
	idCursoHabilitado INT NOT NULL,
	dia INT NOT NULL,
	horario VARCHAR(11) NOT NULL,
	PRIMARY KEY (idCursoHabilitado, dia),
	FOREIGN KEY (idCursoHabilitado) REFERENCES cursoHabilitado(id)
);

# TABLA ASIGNACION
CREATE TABLE asignacion (
	carnet BIGINT NOT NULL,
	idCursoHabilitado INT NOT NULL,
	PRIMARY KEY (carnet, idCursoHabilitado),
	FOREIGN KEY (carnet) REFERENCES estudiante(carnet),
	FOREIGN KEY (idCursoHabilitado) REFERENCES cursoHabilitado(id)
);

CREATE TABLE nota (
	carnet BIGINT NOT NULL,
	idCursoHabilitado INT NOT NULL,
	nota INT NOT NULL,
	PRIMARY KEY (carnet, idCursoHabilitado),
	FOREIGN KEY (carnet) REFERENCES estudiante(carnet),
	FOREIGN KEY (idCursoHabilitado) REFERENCES cursoHabilitado(id)
);
   
# REGISTRAR ESTUDIANTE
CREATE FUNCTION registrarEstudiante (
	carnet BIGINT,
	nombres VARCHAR(250),
	apellidos VARCHAR(250),
	fechaNacimiento DATE,
	correo VARCHAR(250),
	telefono INT,
	direccion VARCHAR(250),
	dpi BIGINT,
	carrera INT
)
RETURNS INT
BEGIN
    DECLARE nuevoCarnet INT;
    
    INSERT INTO mi_tabla (nombre) VALUES (nuevo_nombre);
    SET nuevoCarnet = LAST_INSERT_ID();

    RETURN nuevoCarnet;
END;


# FUNCION CREAR CARRERA
CREATE FUNCTION crearCarrera (
	nombreNuevaCarrera VARCHAR(250)
)
RETURNS INT
DETERMINISTIC
BEGIN 
	DECLARE nuevaCarreraId INT;

	INSERT INTO carrera (nombre) values (nombreNuevaCarrera);

	SET nuevaCarreraId = LAST_INSERT_ID();

	RETURN nuevaCarreraId;
END;

SELECT crearCarrera('Sistemas de Bases de Datos 1');

DROP FUNCTION IF EXISTS crearCarrera;


# ELIMINAR TABLAS
drop table estudiante 
drop table docente
drop table curso
drop table cursoHabilitado
drop table horario;
drop table asignacion

select YEAR(NOW())

# 3004272120101
