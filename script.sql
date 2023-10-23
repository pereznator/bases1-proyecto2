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
	PRIMARY KEY (carnet),
	FOREIGN KEY (idCarrera) REFERENCES carrera (id)
);
   
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
	carrera INT,
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
	estudiantesAsignados INT NOT NULL DEFAULT 0,
	PRIMARY KEY (id),
	FOREIGN KEY (dpiDocente) REFERENCES docente (dpi)
);


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
	aprobada BOOL NOT NULL,
	PRIMARY KEY (carnet, idCursoHabilitado),
	FOREIGN KEY (carnet) REFERENCES estudiante(carnet),
	FOREIGN KEY (idCursoHabilitado) REFERENCES cursoHabilitado(id)
);

CREATE TABLE acta (
	idCursoHabilitado INT NOT NULL,
	ciclo CHAR(2) NOT NULL,
	seccion CHAR(1) NOT NULL,
	anio YEAR NOT NULL,
	generadaEn TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	PRIMARY KEY(idCursoHabilitado, ciclo, seccion, anio),
	FOREIGN KEY (idCursoHabilitado) REFERENCES cursoHabilitado(id)
);

CREATE TRIGGER acta_anio
BEFORE INSERT ON acta
    FOR EACH ROW SET NEW.anio = YEAR(NOW());

# ELIMINAR TABLAS
drop table asignacion;
drop table acta;
drop table nota;
drop table estudiante;
drop table carrera;
drop table horario;
drop table cursoHabilitado;
drop table docente;
drop table curso;

-- ELIMINAR FUNCIONES
drop function crearCarrera;
drop function registrarEstudiante;
DROP FUNCTION registrarDocente;
DROP FUNCTION crearCurso;
DROP FUNCTION habilitarCurso;
DROP FUNCTION agregarHorario;
DROP FUNCTION asignarCurso;
DROP FUNCTION desasignarCurso;
DROP FUNCTION ingresarNota;
DROP FUNCTION generarActa;

-- Listar Funciones
SELECT ROUTINE_NAME, ROUTINE_TYPE
FROM information_schema.ROUTINES
WHERE ROUTINE_SCHEMA = 'cursos' AND ROUTINE_TYPE = 'FUNCTION';



-- 1. CREAR CARRERA
-- SELECT crearCarrera(NOMBRE)
SELECT crearCarrera("Ingenieria Industrial");

-- 2. REGISTRAR ESTUDIANTE
-- SELECT registrarEstudiante(CARNET, NOMBRES, APELLIDOS, FECHA NACIMIENTO, CORREO, TELEFONO, DIRECCION, DPI, ID CARRERA);
SELECT registrarEstudiante(202000001, "Juan", "Perez", "2000-01-01", "email@gmail.com", 12345678, "direccion", 1234567890123, 2);

-- 3. REGISTRAR DOCENTE
-- SELECT registrarDocente(NOMBRES, APELLIDOS, FECHA NAC, CORREO, TELEFONO, DIRECCION, DPI, SIF);
SELECT registrarDocente("Luis Fernando", "Espino", "1979-01-01", "luis.esp@gmail.com", 12345678, "guatemala", 1234567890987, 1);

-- 4. CREAR CURSO
-- SELECT crearCurso(CODIGO, NOMBRE, CREDITOS NECESARIOS, CREDITOS OTORGADOS, ID CARRERA, OBLIGATORIO);
SELECT crearCurso(996, "Organizacion Computacional", 0, 5, 2, true);

-- 5. HBILITAR CURSO
-- SELECT habilitarCurso(CODIGO CURSO, CICLO, DOCENTE, CUPO, SECCION);
SELECT habilitarCurso(996, "1S", 3004272120101, 60, "A");

-- 6. AGREGAR HORARIO
SELECT agregarHorario(ID CURSO HABILITADO, DIA, HORARIO);
SELECT agregarHorario(2, 1, "10:40-12:20");

-- 7. ASIGNACION DE CURSO
-- SELECT asignarCurso(CODIGO DE CURSO, CICLO, SECCION, CARNET);
SELECT asignarCurso(996, "1s", "a", 202000001);

-- 8. DESASIGNACION DE CURSO
-- SELECT desasignarCurso(CODIGO DE CURSO, CICLO, SECCION, CARNET);
SELECT desasignarCurso(996, "1s", "a", 202000001);


-- 9. INGRESAR NOTAS
-- SELECT ingresarNota(CODIGO CURSO, CICLO, SECCION, CARNET, NOTA);
SELECT ingresarNota(996, "1s", "a", 202000001, 89);


-- 10. GENERAR ACTA
-- SELECT generarActa(CODIGO CURSO, CICLO, SECCION);
SELECT generarActa(996, "1s", "a");


