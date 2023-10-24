-- PROCEDIMIENTO Y TRIGGER PARA LLEVAR LA CUENTA DE LAS TRANSACCIONES
CREATE PROCEDURE registrarTransaccion(IN nombreTabla VARCHAR(255), IN tipoAccion ENUM('INSERT', 'UPDATE', 'DELETE'))
BEGIN
    DECLARE descripcionMensaje VARCHAR(255);

    SET descripcionMensaje = CONCAT('Accion ejecutada en tabla ', nombreTabla);

    INSERT INTO transaccion (descripcion, tipo) VALUES (descripcionMensaje, tipoAccion);
END


DROP PROCEDURE registrarTransaccion;

CREATE TRIGGER dispararTransaccion
AFTER INSERT
ON DATABASE cursos
FOR EACH ROW
BEGIN
    DECLARE nombreTabla VARCHAR(255);
    DECLARE accionTipo ENUM('INSERT', 'UPDATE', 'DELETE');
    SET nombreTabla = TABLE_NAME;
    
    IF nombreTabla = 'carrera' THEN
        IF NEW.id IS NOT NULL THEN
            SET accionTipo = 'INSERT';
        ELSEIF OLD.id IS NOT NULL THEN
            SET accionTipo = 'UPDATE';
        ELSE
            SET accionTipo = 'DELETE';
        END IF;    
    ELSEIF nombreTabla = 'estudiante' THEN
        IF NEW.carnet IS NOT NULL THEN
            SET accionTipo = 'INSERT';
        ELSEIF OLD.carnet IS NOT NULL THEN
            SET accionTipo = 'UPDATE';
        ELSE
            SET accionTipo = 'DELETE';
        END IF;
    ELSEIF nombreTabla = 'docente' THEN
        IF NEW.siif IS NOT NULL THEN
            SET accionTipo = 'INSERT';
        ELSEIF OLD.siif IS NOT NULL THEN
            SET accionTipo = 'UPDATE';
        ELSE
            SET accionTipo = 'DELETE';
        END IF;
    ELSEIF nombreTabla = 'curso' THEN
        IF NEW.codigo IS NOT NULL THEN
            SET accionTipo = 'INSERT';
        ELSEIF OLD.codigo IS NOT NULL THEN
            SET accionTipo = 'UPDATE';
        ELSE
            SET accionTipo = 'DELETE';
        END IF;
    ELSEIF nombreTabla = 'cursoHabilitado' THEN
        IF NEW.id IS NOT NULL THEN
            SET accionTipo = 'INSERT';
        ELSEIF OLD.id IS NOT NULL THEN
            SET accionTipo = 'UPDATE';
        ELSE
            SET accionTipo = 'DELETE';
        END IF;
    ELSEIF nombreTabla = 'horario' THEN
        IF NEW.idCursoHabilitado IS NOT NULL AND NEW.dia IS NOT NULL THEN
            SET accionTipo = 'INSERT';
        ELSEIF OLD.idCursoHabilitado IS NOT NULL AND OLD.dia IS NOT NULL THEN
            SET accionTipo = 'UPDATE';
        ELSE
            SET accionTipo = 'DELETE';
        END IF;
    ELSEIF nombreTabla = 'asignacion' THEN
        IF NEW.carnet IS NOT NULL AND NEW.idCursoHabilitado IS NOT NULL THEN
            SET accionTipo = 'INSERT';
        ELSEIF OLD.carnet IS NOT NULL AND OLD.idCursoHabilitado IS NOT NULL THEN
            SET accionTipo = 'UPDATE';
        ELSE
            SET accionTipo = 'DELETE';
        END IF;
    ELSEIF nombreTabla = 'nota' THEN
        IF NEW.carnet IS NOT NULL AND NEW.idCursoHabilitado IS NOT NULL THEN
            SET accionTipo = 'INSERT';
        ELSEIF OLD.carnet IS NOT NULL AND OLD.idCursoHabilitado IS NOT NULL THEN
            SET accionTipo = 'UPDATE';
        ELSE
            SET accionTipo = 'DELETE';
        END IF;
    ELSEIF nombreTabla = 'acta' THEN
        IF NEW.idCursoHabilitado IS NOT NULL THEN
            SET accionTipo = 'INSERT';
        ELSEIF OLD.idCursoHabilitado IS NOT NULL THEN
            SET accionTipo = 'UPDATE';
        ELSE
            SET accionTipo = 'DELETE';
        END IF;
    ELSEIF nombreTabla = 'desasignacion' THEN
        IF NEW.id IS NOT NULL THEN
            SET accionTipo = 'INSERT';
        ELSEIF OLD.id IS NOT NULL THEN
            SET accionTipo = 'UPDATE';
        ELSE
            SET accionTipo = 'DELETE';
        END IF;
    END IF;
	IF accionTipo IS NOT NULL THEN
	    CALL RegistrarTransaccion(nombreTabla, accionTipo);
	END IF;
END;










