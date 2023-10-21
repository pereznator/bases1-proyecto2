-- FUNCION CREAR CARRERA
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

select crearCarrera("Ingenieria en Ciencias y Sistemas");


-- ELIMINAR FUNCION
drop function crearCarrera;