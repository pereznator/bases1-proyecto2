CREATE TABLE candidato (
    id               INTEGER NOT NULL,
    nombres          VARCHAR(225) NOT NULL,
    fecha_nacimiento DATETIME NOT NULL,
    id_partido       INTEGER NOT NULL,
    id_cargo         INTEGER NOT NULL
);

ALTER TABLE candidato ADD CONSTRAINT candidato_pk PRIMARY KEY ( id );

CREATE TABLE cargo (
    id    INTEGER NOT NULL,
    cargo VARCHAR(225) NOT NULL
);

ALTER TABLE cargo ADD CONSTRAINT cargo_pk PRIMARY KEY ( id );

CREATE TABLE ciudadano (
    dpi       VARCHAR(13) NOT NULL,
    nombre    VARCHAR(225) NOT NULL,
    apellido  VARCHAR(225) NOT NULL,
    direccion VARCHAR(225) NOT NULL,
    telefono  VARCHAR(225) NOT NULL,
    edad      INTEGER NOT NULL,
    genero    CHAR(1) NOT NULL
);

ALTER TABLE ciudadano ADD CONSTRAINT ciudadano_pk PRIMARY KEY ( dpi );

CREATE TABLE departamento (
    id           INTEGER NOT NULL,
    departamento VARCHAR(250) NOT NULL
);

ALTER TABLE departamento ADD CONSTRAINT departamento_pk PRIMARY KEY ( id );

CREATE TABLE detalle_voto (
    id           INTEGER NOT NULL,
    id_voto      INTEGER NOT NULL,
    id_candidato INTEGER NOT NULL
);

ALTER TABLE detalle_voto ADD CONSTRAINT detalle_voto_pk PRIMARY KEY ( id );

CREATE TABLE mesa (
    id              INTEGER NOT NULL,
    id_departamento INTEGER NOT NULL
);

ALTER TABLE mesa ADD CONSTRAINT mesa_pk PRIMARY KEY ( id );

CREATE TABLE partido (
    id        INTEGER NOT NULL,
    nombre    VARCHAR(225) NOT NULL,
    siglas    VARCHAR(225) NOT NULL,
    fundacion DATETIME NOT NULL
);

ALTER TABLE partido ADD CONSTRAINT partido_pk PRIMARY KEY ( id );

CREATE TABLE temporal (
    id                         INTEGER NOT NULL,
    tipo                       INTEGER NOT NULL,
    id_departamento            INTEGER,
    departamento               VARCHAR(225),
    id_mesa                    INTEGER,
    id_cargo                   INTEGER,
    cargo                      VARCHAR(225),
    id_partido                 INTEGER,
    nombre_partido             VARCHAR(225),
    siglas_partido             VARCHAR(225),
    fundacion_partido          DATETIME,
    dpi                        VARCHAR(13),
    nombre_ciudadano           VARCHAR(225),
    apellido_ciudadano         VARCHAR(225),
    direccion_ciudadano        VARCHAR(225),
    telefono_ciudadano         VARCHAR(225),
    edad_ciudadano             INTEGER,
    genero_ciudadano           CHAR(1),
    id_candidato               INTEGER,
    nombres_candidato          VARCHAR(225),
    fecha_nacimiento_candidato DATETIME,
    id_voto                    INTEGER,
    fecha_hora_voto            DATETIME
);

ALTER TABLE temporal ADD CONSTRAINT temporal_pk PRIMARY KEY ( id );

CREATE TABLE voto (
    id         INTEGER NOT NULL,
    dpi        VARCHAR(13) NOT NULL,
    id_mesa    INTEGER NOT NULL,
    fecha_hora DATETIME(6) NOT NULL
);

ALTER TABLE voto ADD CONSTRAINT voto_pk PRIMARY KEY ( id );

ALTER TABLE candidato
    ADD CONSTRAINT candidato_cargo_fk FOREIGN KEY ( id_cargo )
        REFERENCES cargo ( id )
            ON DELETE CASCADE;

ALTER TABLE detalle_voto
    ADD CONSTRAINT detalle_voto_candidato_fk FOREIGN KEY ( id_candidato )
        REFERENCES candidato ( id )
            ON DELETE CASCADE;

ALTER TABLE detalle_voto
    ADD CONSTRAINT detalle_voto_voto_fk FOREIGN KEY ( id_voto )
        REFERENCES voto ( id )
            ON DELETE CASCADE;

ALTER TABLE candidato
    ADD CONSTRAINT id_partido FOREIGN KEY ( id_partido )
        REFERENCES partido ( id )
            ON DELETE CASCADE;

ALTER TABLE mesa
    ADD CONSTRAINT mesa_departamento_fk FOREIGN KEY ( id_departamento )
        REFERENCES departamento ( id )
            ON DELETE CASCADE;

ALTER TABLE voto
    ADD CONSTRAINT voto_ciudadano_fk FOREIGN KEY ( dpi )
        REFERENCES ciudadano ( dpi )
            ON DELETE CASCADE;

ALTER TABLE voto
    ADD CONSTRAINT voto_mesa_fk FOREIGN KEY ( id_mesa )
        REFERENCES mesa ( id )
            ON DELETE CASCADE;

ALTER TABLE elecciones.temporal MODIFY COLUMN id int auto_increment NOT NULL;

ALTER TABLE elecciones.detalle_voto MODIFY COLUMN id int auto_increment NOT NULL;