--- Script para base de datos 

# TABLA CURSO
CREATE TABLE curso (
    id INT NOT NULL AUTO_INCREMENT,
    nombre VARCHAR(250) NOT NULL,
    PRIMARY KEY (id)
);


# TABLA ESTUDIANTE
CREATE TABLE estudiante (
	carnet VARCHAR(9) NOT NULL,
	nombres VARCHAR(250) NOT NULL,
	apellidos VARCHAR(250) NOT NULL,
	fechaDeNacimiento DATE NOT NULL,
	correo VARCHAR(250) NOT NULL,
	telefono VARCHAR(8) NOT NULL
);

201900810