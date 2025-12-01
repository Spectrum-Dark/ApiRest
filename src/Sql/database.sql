-- Active: 1764224686802@@127.0.0.1@3306@educacion
-- 1. Crear la Base de Datos
CREATE DATABASE IF NOT EXISTS educacion;

USE educacion;

-- Tabla: Usuarios

CREATE TABLE Users (
    id INT(11) NOT NULL AUTO_INCREMENT,
    username VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL,
    role VARCHAR(100) NOT NULL,
    password VARCHAR(255) NOT NULL,
    createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE KEY (username),
    UNIQUE KEY (email)
);

-- Stored Procedures
-- Get All Users
DROP PROCEDURE IF EXISTS GetAllUsers;

DELIMITER /
/

CREATE PROCEDURE GetAllUsers()
BEGIN
    SELECT 
        id, 
        username, 
        email, 
        role, 
        createdAt 
    FROM Users;
END
/
/

DELIMITER;

-- Get User By Id
DROP PROCEDURE IF EXISTS GetUserById;

DELIMITER /
/

CREATE PROCEDURE GetUserById(
    IN p_id INT
)
BEGIN
    SELECT 
        id, 
        username, 
        email, 
        role, 
        createdAt 
    FROM Users 
    WHERE id = p_id;
END
/
/

DELIMITER;

-- Get User By Email
DROP PROCEDURE IF EXISTS GetUserByEmail;

DELIMITER /
/

CREATE PROCEDURE GetUserByEmail(
    IN p_email VARCHAR(100)
)
BEGIN
    -- Incluir el password aquí es común, ya que este SP se usa a menudo para la autenticación (login)
    SELECT username, email, role, password, id FROM Users WHERE email = p_email;
END
/
/

DELIMITER;

-- Update User
DROP PROCEDURE IF EXISTS UpdateUser;

DELIMITER /
/

CREATE PROCEDURE UpdateUser(
    IN p_id INT,
    IN p_username VARCHAR(100),
    IN p_email VARCHAR(100),
    IN p_role VARCHAR(100),
    IN p_password VARCHAR(255)
)
BEGIN
    UPDATE Users
    SET 
        username = p_username, 
        email = p_email,
        role = p_role,
        password = p_password -- ASUMIENDO que el hash de la contraseña se pasa aquí
    WHERE id = p_id;
END
/
/

DELIMITER;

-- Delete User
DROP PROCEDURE IF EXISTS DeleteUser;

DELIMITER /
/

CREATE PROCEDURE DeleteUser(
    IN p_id INT
)
BEGIN
    DELETE FROM Users WHERE id = p_id;
END
/
/

DELIMITER;

-- --------------------------------------------------------
-- 3. Tablas de Catálogo (Independientes)
-- --------------------------------------------------------

-- Tabla: Modalidades
CREATE TABLE modalidades (
    id_modalidad INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    descripcion TEXT
);

-- Tabla: Clases (Solo información básica de la materia)
CREATE TABLE clases (
    id_clase INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    descripcion TEXT
);

-- Tabla: Profesores (Sin asignar clase aquí, para mayor flexibilidad)
CREATE TABLE profesores (
    id_profesor INT AUTO_INCREMENT PRIMARY KEY,
    nombre_completo VARCHAR(150) NOT NULL,
    email VARCHAR(100) UNIQUE,
    telefono VARCHAR(20)
);

-- Tabla: Grupos (Ej: 1A, 2B)
CREATE TABLE grupos (
    id_grupo INT AUTO_INCREMENT PRIMARY KEY,
    nombre_grupo VARCHAR(50) NOT NULL
    -- Nota: La "Cantidad de alumnos" se calcula con un COUNT, no se guarda fijo.
);

-- --------------------------------------------------------
-- 3. Tabla Principal de Alumnos
-- --------------------------------------------------------

-- Tabla: Alumnos
-- Se cambió 'matricula' por 'codigo_carnet'.
-- Se eliminó 'grupo' y 'clase' directa (se hace por relación).
CREATE TABLE alumnos (
    id_alumno INT AUTO_INCREMENT PRIMARY KEY,
    nombre_completo VARCHAR(150) NOT NULL,
    codigo_carnet VARCHAR(50) UNIQUE NOT NULL,
    correo_electronico VARCHAR(100),
    telefono VARCHAR(20),
    estado ENUM('Activo', 'Inactivo') DEFAULT 'Activo',
    fecha_registro DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- --------------------------------------------------------
-- 4. Tablas de Relación (Donde ocurre la magia)
-- --------------------------------------------------------

-- Tabla: Inscripciones (Relación Alumno <-> Grupo)
-- Define a qué grupo pertenece cada alumno.
CREATE TABLE inscripciones_grupo (
    id_inscripcion INT AUTO_INCREMENT PRIMARY KEY,
    id_alumno INT NOT NULL,
    id_grupo INT NOT NULL,
    anio_escolar VARCHAR(10), -- Ej: "2023-2024"
    FOREIGN KEY (id_alumno) REFERENCES alumnos (id_alumno) ON DELETE CASCADE,
    FOREIGN KEY (id_grupo) REFERENCES grupos (id_grupo) ON DELETE CASCADE
);

-- Tabla: Asignaciones Académicas (Relación Grupo <-> Clase <-> Profesor <-> Modalidad)
-- Esta es la tabla que une todo para definir el horario y quién da qué clase.
CREATE TABLE asignaciones_clases (
    id_asignacion INT AUTO_INCREMENT PRIMARY KEY,
    id_grupo INT NOT NULL,
    id_clase INT NOT NULL,
    id_profesor INT NOT NULL,
    id_modalidad INT NOT NULL,
    horario VARCHAR(100), -- Ej: "08:00 - 10:00"
    FOREIGN KEY (id_grupo) REFERENCES grupos (id_grupo),
    FOREIGN KEY (id_clase) REFERENCES clases (id_clase),
    FOREIGN KEY (id_profesor) REFERENCES profesores (id_profesor),
    FOREIGN KEY (id_modalidad) REFERENCES modalidades (id_modalidad)
);

-- --------------------------------------------------------
-- 5. Tabla de Operación
-- --------------------------------------------------------

-- Tabla: Asistencias
-- Registra si el alumno fue o no a una clase específica en una fecha.
CREATE TABLE asistencias (
    id_asistencia INT AUTO_INCREMENT PRIMARY KEY,
    id_asignacion INT NOT NULL, -- Vincula con la clase/grupo/profe específico
    id_alumno INT NOT NULL,
    fecha DATE NOT NULL,
    estado_asistencia ENUM(
        'Presente',
        'Ausente',
        'Tardanza',
        'Justificado'
    ) NOT NULL,
    FOREIGN KEY (id_asignacion) REFERENCES asignaciones_clases (id_asignacion),
    FOREIGN KEY (id_alumno) REFERENCES alumnos (id_alumno)
);

-- Creacion de Procedimientos Almacenados ===========================================================

--Crud Modalidad

-- Insertar Modalidad
DELIMITER /
/

CREATE PROCEDURE SP_Insertar_Modalidad (
    IN p_nombre VARCHAR(50),
    IN p_descripcion TEXT
)
BEGIN
    INSERT INTO modalidades (nombre, descripcion) VALUES (p_nombre, p_descripcion);
END
/
/

-- Obtener Modalidades

CREATE PROCEDURE SP_Obtener_Modalidades ()
BEGIN
    SELECT * FROM modalidades;
END
/
/

DELIMITER;

-- Actualizar Modalidad

DELIMITER /
/

CREATE PROCEDURE SP_Actualizar_Modalidad (
    IN p_id_modalidad INT,
    IN p_nombre VARCHAR(50),
    IN p_descripcion TEXT
)
BEGIN
    UPDATE modalidades SET nombre = p_nombre, descripcion = p_descripcion WHERE id_modalidad = p_id_modalidad;
END
/
/

DELIMITER;
-- Eliminar Modalidad

DELIMITER /
/
CREATE PROCEDURE SP_Eliminar_Modalidad (
    IN p_id_modalidad INT
)
BEGIN
    DELETE FROM modalidades WHERE id_modalidad = p_id_modalidad;
END
/
/

DelIMITER;

/* Crud de grupos */

-- Insertar Grupo
DELIMITER /
/

CREATE PROCEDURE SP_Insertar_Grupo (
    IN p_nombre_grupo VARCHAR(50)
)
BEGIN
    INSERT INTO grupos (nombre_grupo) VALUES (p_nombre_grupo);
END
/
/

DELIMITER;

-- Obtener Grupos

DELIMITER /
/

CREATE PROCEDURE SP_Obtener_Grupos ()
BEGIN
    SELECT * FROM grupos;
END
/
/

DELIMITER;

-- Editar Grupo

DELIMITER /
/
CREATE PROCEDURE SP_Editar_Grupo (
    IN p_id_grupo INT,
    IN p_nombre_grupo VARCHAR(50)
)
BEGIN
    UPDATE grupos SET nombre_grupo = p_nombre_grupo WHERE id_grupo = p_id_grupo;
END
/
/

DelIMITER;

-- Actualizar Grupo

DELIMITER /
/
CREATE PROCEDURE SP_Actualizar_Grupo (
    IN p_id_grupo INT,
    IN p_nombre_grupo VARCHAR(50)
)
BEGIN
    UPDATE grupos SET nombre_grupo = p_nombre_grupo WHERE id_grupo = p_id_grupo;
END
/
/

DelIMITER;

--Eliminar Grupo

DELIMITER /
/
CREATE PROCEDURE SP_Eliminar_Grupo (
    IN p_id_grupo INT
)
BEGIN
    DELETE FROM grupos WHERE id_grupo = p_id_grupo;
END
/
/

Delimiter;

-- Crud de profesores

-- Insertar Profesor
DELIMITER /
/

CREATE PROCEDURE SP_Insertar_Profesor (
    IN p_nombre_completo VARCHAR(150),
    IN p_email VARCHAR(100),
    IN p_telefono VARCHAR(20)
)
BEGIN
    INSERT INTO profesores (nombre_completo, email, telefono) VALUES (p_nombre_completo, p_email, p_telefono);
END
/
/

DELIMITER;

--Obtener Profesores

DELIMITER /
/
CREATE PROCEDURE SP_Obtener_Profesores ()
BEGIN
    SELECT * FROM profesores;
END
/
/

DelIMITER;

-- Actualizar Profesor

DELIMITER /
/
CREATE PROCEDURE SP_Actualizar_Profesor (
    IN p_id_profesor INT,
    IN p_nombre_completo VARCHAR(150),
    IN p_email VARCHAR(100),
    IN p_telefono VARCHAR(20)
)
BEGIN
    UPDATE profesores SET nombre_completo = p_nombre_completo, email = p_email, telefono = p_telefono WHERE id_profesor = p_id_profesor;
END
/
/

DelIMITER;

-- Eliminar Profesor

DELIMITER /
/
CREATE PROCEDURE SP_Eliminar_Profesor (
    IN p_id_profesor INT
)
BEGIN
    DELETE FROM profesores WHERE id_profesor = p_id_profesor;
END
/
/

DelIMITER;

-- Crud de clases

-- Insertar Clase
DELIMITER /
/

CREATE PROCEDURE SP_Insertar_Clase (
    IN p_nombre VARCHAR(100),
    IN p_descripcion TEXT
)
BEGIN
    INSERT INTO clases (nombre, descripcion) VALUES (p_nombre, p_descripcion);
END
/
/

DELIMITER;

-- Obtener Clases

DELIMITER /
/
CREATE PROCEDURE SP_Obtener_Clases ()
BEGIN
    SELECT * FROM clases;
END
/

DelIMITER;

-- Actualizar Clase

DELIMITER /
/
CREATE PROCEDURE SP_Actualizar_Clase (
    IN p_id_clase INT,
    IN p_nombre VARCHAR(100),
    IN p_descripcion TEXT
)
BEGIN
    UPDATE clases SET nombre = p_nombre, descripcion = p_descripcion WHERE id_clase = p_id_clase;
END
/

DelIMITER;

-- eliminar Clase

DELIMITER /
/
CREATE PROCEDURE SP_Eliminar_Clase (
    IN p_id_clase INT
)
BEGIN
    DELETE FROM clases WHERE id_clase = p_id_clase;
END
/

DelIMITER;

-- Crud de Alumnos

DELIMITER $$

CREATE PROCEDURE SP_ALUMNO_GENERAL(
    IN p_accion VARCHAR(40),

    -- DATOS DEL ALUMNO
    IN p_id_alumno INT,
    IN p_nombre VARCHAR(150),
    IN p_carnet VARCHAR(50),
    IN p_correo VARCHAR(100),
    IN p_telefono VARCHAR(20),
    IN p_estado VARCHAR(10),

    -- INSCRIPCIÓN
    IN p_id_grupo INT,
    IN p_anio VARCHAR(10),

    -- ASIGNACIÓN DE CLASES
    IN p_id_clase INT,
    IN p_id_profesor INT,
    IN p_id_modalidad INT,
    IN p_horario VARCHAR(50)
)
BEGIN

    /* ==================================
        1) CREAR ALUMNO COMPLETO
    =================================== */
    IF p_accion = 'crear' THEN

        INSERT INTO alumnos(nombre_completo, codigo_carnet, correo_electronico, telefono, estado)
        VALUES(p_nombre, p_carnet, p_correo, p_telefono, p_estado);

        SET @alumno = LAST_INSERT_ID();

        INSERT INTO inscripciones_grupo(id_alumno, id_grupo, anio_escolar)
        VALUES(@alumno, p_id_grupo, p_anio);

        -- Asignación (opcional)
        IF p_id_clase IS NOT NULL THEN
            INSERT INTO asignaciones_clases(id_grupo, id_clase, id_profesor, id_modalidad, horario)
            VALUES (p_id_grupo, p_id_clase, p_id_profesor, p_id_modalidad, p_horario);
        END IF;

    END IF;



    /* ==================================
        2) ACTUALIZAR ALUMNO
    =================================== */
    IF p_accion = 'actualizar' THEN

        UPDATE alumnos
        SET nombre_completo = p_nombre,
            codigo_carnet = p_carnet,
            correo_electronico = p_correo,
            telefono = p_telefono,
            estado = p_estado
        WHERE id_alumno = p_id_alumno;

        UPDATE inscripciones_grupo
        SET id_grupo = p_id_grupo,
            anio_escolar = p_anio
        WHERE id_alumno = p_id_alumno;

        IF p_id_clase IS NOT NULL THEN

            -- si ya existe asignación → actualizar
            IF EXISTS (SELECT 1 FROM asignaciones_clases WHERE id_grupo = p_id_grupo) THEN
                UPDATE asignaciones_clases
                SET id_clase = p_id_clase,
                    id_profesor = p_id_profesor,
                    id_modalidad = p_id_modalidad,
                    horario = p_horario
                WHERE id_grupo = p_id_grupo;
            ELSE
                -- si no existe → insertar
                INSERT INTO asignaciones_clases (id_grupo, id_clase, id_profesor, id_modalidad, horario)
                VALUES (p_id_grupo, p_id_clase, p_id_profesor, p_id_modalidad, p_horario);
            END IF;

        END IF;

    END IF;



    /* ==================================
        3) ELIMINAR ALUMNO
    =================================== */
    IF p_accion = 'eliminar' THEN
        
        DELETE FROM asignaciones_clases 
        WHERE id_grupo IN (SELECT id_grupo FROM inscripciones_grupo WHERE id_alumno = p_id_alumno);

        DELETE FROM inscripciones_grupo WHERE id_alumno = p_id_alumno;

        DELETE FROM alumnos WHERE id_alumno = p_id_alumno;

    END IF;



    /* ==================================
        4) OBTENER UN ALUMNO (CON NOMBRES)
    =================================== */
    IF p_accion = 'obtener' THEN
        
        SELECT 
            a.id_alumno,
            a.nombre_completo,
            a.codigo_carnet,
            a.correo_electronico,
            a.telefono,
            a.estado,

            ig.id_grupo,
            g.nombre_grupo,
            ig.anio_escolar,

            ac.id_clase,
            c.nombre AS nombre_clase,

            ac.id_profesor,
            p.nombre_completo AS nombre_profesor,

            ac.id_modalidad,
            m.nombre AS nombre_modalidad,

            ac.horario

        FROM alumnos a
        LEFT JOIN inscripciones_grupo ig ON ig.id_alumno = a.id_alumno
        LEFT JOIN grupos g ON g.id_grupo = ig.id_grupo
        LEFT JOIN asignaciones_clases ac ON ac.id_grupo = ig.id_grupo
        LEFT JOIN clases c ON c.id_clase = ac.id_clase
        LEFT JOIN profesores p ON p.id_profesor = ac.id_profesor
        LEFT JOIN modalidades m ON m.id_modalidad = ac.id_modalidad
        WHERE a.id_alumno = p_id_alumno;

    END IF;



    /* ==================================
        5) LISTAR TODOS LOS ALUMNOS (CON NOMBRES)
    =================================== */
    IF p_accion = 'listar' THEN
        
        SELECT 
            a.id_alumno,
            a.nombre_completo,
            a.codigo_carnet,
            a.correo_electronico,
            a.telefono,
            a.estado,

            ig.id_grupo,
            g.nombre_grupo,
            ig.anio_escolar,

            ac.id_clase,
            c.nombre AS nombre_clase,

            ac.id_profesor,
            p.nombre_completo AS nombre_profesor,

            ac.id_modalidad,
            m.nombre AS nombre_modalidad,

            ac.horario

        FROM alumnos a
        LEFT JOIN inscripciones_grupo ig ON ig.id_alumno = a.id_alumno
        LEFT JOIN grupos g ON g.id_grupo = ig.id_grupo
        LEFT JOIN asignaciones_clases ac ON ac.id_grupo = ig.id_grupo
        LEFT JOIN clases c ON c.id_clase = ac.id_clase
        LEFT JOIN profesores p ON p.id_profesor = ac.id_profesor
        LEFT JOIN modalidades m ON m.id_modalidad = ac.id_modalidad;

    END IF;

END $$

DELIMITER;

-- Obtener el grupo profesor y clases  ===============================================================>

CREATE PROCEDURE SP_OBTENER_CLASES_ASIGNADAS()
BEGIN
    SELECT 
        ac.id_asignacion,
        g.nombre_grupo,
        c.nombre AS nombre_clase,
        p.nombre_completo AS profesor,
        m.nombre AS modalidad,
        ac.horario
    FROM asignaciones_clases ac
    INNER JOIN grupos g ON ac.id_grupo = g.id_grupo
    INNER JOIN clases c ON ac.id_clase = c.id_clase
    INNER JOIN profesores p ON ac.id_profesor = p.id_profesor
    INNER JOIN modalidades m ON ac.id_modalidad = m.id_modalidad
    ORDER BY g.nombre_grupo ASC;
END;

DELIMITER;

-- Obtener estudiantes de esa clase
CREATE PROCEDURE SP_OBTENER_ALUMNOS_POR_ASIGNACION(IN pid_asignacion INT)
BEGIN
    SELECT
        a.id_alumno,
        a.nombre_completo,
        a.codigo_carnet,
        'Pendiente' AS estado_asistencia   -- Estado inicial
    FROM asignaciones_clases ac
    INNER JOIN inscripciones_grupo ig ON ac.id_grupo = ig.id_grupo
    INNER JOIN alumnos a ON ig.id_alumno = a.id_alumno
    WHERE ac.id_asignacion = pid_asignacion
    ORDER BY a.nombre_completo ASC;
END;
DELIMITER;

-- Registrar asistencia

CREATE PROCEDURE SP_REGISTRAR_ASISTENCIA(
    IN pid_asignacion INT,
    IN pid_alumno INT,
    IN pfecha DATE,
    IN pestado VARCHAR(20)
)
BEGIN
    INSERT INTO asistencias(id_asignacion, id_alumno, fecha, estado_asistencia)
    VALUES (pid_asignacion, pid_alumno, pfecha, pestado);
END;
DELIMITER;

-- Obtener asistencias
Drop procedure if exists SP_OBTENER_ASISTENCIAS;

DELIMITER $$

CREATE PROCEDURE SP_OBTENER_ASISTENCIAS(
    IN pid_asignacion INT,
    IN pfecha DATE
)
BEGIN
    SELECT 
        -- IDs
        a.id_asistencia,
        ac.id_asignacion,
        al.id_alumno,
        c.id_clase,
        p.id_profesor,

        -- Datos de relaciones
        al.nombre_completo AS alumno,
        al.codigo_carnet AS codigo,
        c.nombre AS clase,
        g.nombre_grupo AS grupo,
        p.nombre_completo AS profesor,

        -- Datos propios
        a.fecha,
        a.estado_asistencia AS estado

    FROM asistencias a
    INNER JOIN asignaciones_clases ac ON ac.id_asignacion = a.id_asignacion
    INNER JOIN grupos g ON g.id_grupo = ac.id_grupo
    INNER JOIN clases c ON c.id_clase = ac.id_clase
    INNER JOIN profesores p ON p.id_profesor = ac.id_profesor
    INNER JOIN alumnos al ON al.id_alumno = a.id_alumno

    WHERE 
        (pid_asignacion = 0 OR ac.id_asignacion = pid_asignacion)
        AND (pfecha IS NULL OR a.fecha = pfecha)

    ORDER BY a.fecha DESC;
END $$

DELIMITER ;

-- Actualizar estado de asistencia
CREATE PROCEDURE SP_ACTUALIZAR_ESTADO_ASISTENCIA(
    IN pid_asistencia INT,
    IN pestado VARCHAR(20)
)
BEGIN
    UPDATE asistencias
    SET estado_asistencia = pestado
    WHERE id_asistencia = pid_asistencia;
END $$
DELIMITER ;