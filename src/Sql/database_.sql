-- Active: 1761759741520@@127.0.0.1@3306@pruebas

-- ========================================================
-- 0. LIMPIAR TODO PRIMERO
-- ========================================================
DROP DATABASE IF EXISTS educacion;

-- ========================================================
-- 1. CREACIÓN DE BASE DE DATOS
-- ========================================================
CREATE DATABASE IF NOT EXISTS educacion;
USE educacion;

-- ========================================================
-- 2. TABLAS DE USUARIOS
-- ========================================================

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

-- ========================================================
-- 3. PROCEDIMIENTOS ALMACENADOS PARA USUARIOS
-- ========================================================

-- Insert User (FALTA ESTE)
DROP PROCEDURE IF EXISTS InsertUser;
DELIMITER //
CREATE PROCEDURE InsertUser(
    IN p_username VARCHAR(100),
    IN p_email VARCHAR(100),
    IN p_role VARCHAR(100),
    IN p_password VARCHAR(255)
)
BEGIN
    INSERT INTO Users (username, email, role, password)
    VALUES (p_username, p_email, p_role, p_password);
END //
DELIMITER ;

-- Get All Users
DROP PROCEDURE IF EXISTS GetAllUsers;
DELIMITER //
CREATE PROCEDURE GetAllUsers()
BEGIN
    SELECT 
        id, 
        username, 
        email, 
        role, 
        createdAt 
    FROM Users;
END //
DELIMITER ;

-- Get User By Id
DROP PROCEDURE IF EXISTS GetUserById;
DELIMITER //
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
END //
DELIMITER ;

-- Get User By Email
DROP PROCEDURE IF EXISTS GetUserByEmail;
DELIMITER //
CREATE PROCEDURE GetUserByEmail(
    IN p_email VARCHAR(100)
)
BEGIN
    SELECT username, email, role, password, id FROM Users WHERE email = p_email;
END //
DELIMITER ;

-- Update User
DROP PROCEDURE IF EXISTS UpdateUser;
DELIMITER //
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
        password = p_password
    WHERE id = p_id;
END //
DELIMITER ;

-- Delete User
DROP PROCEDURE IF EXISTS DeleteUser;
DELIMITER //
CREATE PROCEDURE DeleteUser(
    IN p_id INT
)
BEGIN
    DELETE FROM Users WHERE id = p_id;
END //
DELIMITER ;

-- ========================================================
-- 4. TABLAS DE CATÁLOGO (INDEPENDIENTES)
-- ========================================================

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
);

-- ========================================================
-- 5. TABLA PRINCIPAL DE ALUMNOS
-- ========================================================

-- Tabla: Alumnos
CREATE TABLE alumnos (
    id_alumno INT AUTO_INCREMENT PRIMARY KEY,
    nombre_completo VARCHAR(150) NOT NULL,
    codigo_carnet VARCHAR(50) UNIQUE NOT NULL,
    correo_electronico VARCHAR(100),
    telefono VARCHAR(20),
    estado ENUM('Activo', 'Inactivo') DEFAULT 'Activo',
    fecha_registro DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- ========================================================
-- 6. TABLAS DE RELACIÓN
-- ========================================================

-- Tabla: Inscripciones (Relación Alumno <-> Grupo)
CREATE TABLE inscripciones_grupo (
    id_inscripcion INT AUTO_INCREMENT PRIMARY KEY,
    id_alumno INT NOT NULL,
    id_grupo INT NOT NULL,
    anio_escolar VARCHAR(10),
    FOREIGN KEY (id_alumno) REFERENCES alumnos (id_alumno) ON DELETE CASCADE,
    FOREIGN KEY (id_grupo) REFERENCES grupos (id_grupo) ON DELETE CASCADE
);

-- Tabla: Asignaciones Académicas (Relación Grupo <-> Clase <-> Profesor <-> Modalidad)
CREATE TABLE asignaciones_clases (
    id_asignacion INT AUTO_INCREMENT PRIMARY KEY,
    id_grupo INT NOT NULL,
    id_clase INT NOT NULL,
    id_profesor INT NOT NULL,
    id_modalidad INT NOT NULL,
    horario VARCHAR(100),
    FOREIGN KEY (id_grupo) REFERENCES grupos (id_grupo),
    FOREIGN KEY (id_clase) REFERENCES clases (id_clase),
    FOREIGN KEY (id_profesor) REFERENCES profesores (id_profesor),
    FOREIGN KEY (id_modalidad) REFERENCES modalidades (id_modalidad)
);

-- ========================================================
-- 7. TABLA DE OPERACIÓN
-- ========================================================

-- Tabla: Asistencias
CREATE TABLE asistencias (
    id_asistencia INT AUTO_INCREMENT PRIMARY KEY,
    id_asignacion INT NOT NULL,
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

-- ========================================================
-- 8. PROCEDIMIENTOS ALMACENADOS PARA CATÁLOGOS
-- ========================================================

-- CRUD Modalidad

-- Insertar Modalidad
DROP PROCEDURE IF EXISTS SP_Insertar_Modalidad;
DELIMITER //
CREATE PROCEDURE SP_Insertar_Modalidad (
    IN p_nombre VARCHAR(50),
    IN p_descripcion TEXT
)
BEGIN
    INSERT INTO modalidades (nombre, descripcion) VALUES (p_nombre, p_descripcion);
END //
DELIMITER ;

-- Obtener Modalidades
DROP PROCEDURE IF EXISTS SP_Obtener_Modalidades;
DELIMITER //
CREATE PROCEDURE SP_Obtener_Modalidades ()
BEGIN
    SELECT * FROM modalidades;
END //
DELIMITER ;

-- Actualizar Modalidad
DROP PROCEDURE IF EXISTS SP_Actualizar_Modalidad;
DELIMITER //
CREATE PROCEDURE SP_Actualizar_Modalidad (
    IN p_id_modalidad INT,
    IN p_nombre VARCHAR(50),
    IN p_descripcion TEXT
)
BEGIN
    UPDATE modalidades SET nombre = p_nombre, descripcion = p_descripcion WHERE id_modalidad = p_id_modalidad;
END //
DELIMITER ;

-- Eliminar Modalidad
DROP PROCEDURE IF EXISTS SP_Eliminar_Modalidad;
DELIMITER //
CREATE PROCEDURE SP_Eliminar_Modalidad (
    IN p_id_modalidad INT
)
BEGIN
    DELETE FROM modalidades WHERE id_modalidad = p_id_modalidad;
END //
DELIMITER ;

-- CRUD de Grupos

-- Insertar Grupo
DROP PROCEDURE IF EXISTS SP_Insertar_Grupo;
DELIMITER //
CREATE PROCEDURE SP_Insertar_Grupo (
    IN p_nombre_grupo VARCHAR(50)
)
BEGIN
    INSERT INTO grupos (nombre_grupo) VALUES (p_nombre_grupo);
END //
DELIMITER ;

-- Obtener Grupos
DROP PROCEDURE IF EXISTS SP_Obtener_Grupos;
DELIMITER //
CREATE PROCEDURE SP_Obtener_Grupos ()
BEGIN
    SELECT * FROM grupos;
END //
DELIMITER ;

-- Actualizar Grupo
DROP PROCEDURE IF EXISTS SP_Actualizar_Grupo;
DELIMITER //
CREATE PROCEDURE SP_Actualizar_Grupo (
    IN p_id_grupo INT,
    IN p_nombre_grupo VARCHAR(50)
)
BEGIN
    UPDATE grupos SET nombre_grupo = p_nombre_grupo WHERE id_grupo = p_id_grupo;
END //
DELIMITER ;

-- Eliminar Grupo
DROP PROCEDURE IF EXISTS SP_Eliminar_Grupo;
DELIMITER //
CREATE PROCEDURE SP_Eliminar_Grupo (
    IN p_id_grupo INT
)
BEGIN
    DELETE FROM grupos WHERE id_grupo = p_id_grupo;
END //
DELIMITER ;

-- CRUD de Profesores

-- Insertar Profesor
DROP PROCEDURE IF EXISTS SP_Insertar_Profesor;
DELIMITER //
CREATE PROCEDURE SP_Insertar_Profesor (
    IN p_nombre_completo VARCHAR(150),
    IN p_email VARCHAR(100),
    IN p_telefono VARCHAR(20)
)
BEGIN
    INSERT INTO profesores (nombre_completo, email, telefono) VALUES (p_nombre_completo, p_email, p_telefono);
END //
DELIMITER ;

-- Obtener Profesores
DROP PROCEDURE IF EXISTS SP_Obtener_Profesores;
DELIMITER //
CREATE PROCEDURE SP_Obtener_Profesores ()
BEGIN
    SELECT * FROM profesores;
END //
DELIMITER ;

-- Actualizar Profesor
DROP PROCEDURE IF EXISTS SP_Actualizar_Profesor;
DELIMITER //
CREATE PROCEDURE SP_Actualizar_Profesor (
    IN p_id_profesor INT,
    IN p_nombre_completo VARCHAR(150),
    IN p_email VARCHAR(100),
    IN p_telefono VARCHAR(20)
)
BEGIN
    UPDATE profesores SET nombre_completo = p_nombre_completo, email = p_email, telefono = p_telefono WHERE id_profesor = p_id_profesor;
END //
DELIMITER ;

-- Eliminar Profesor
DROP PROCEDURE IF EXISTS SP_Eliminar_Profesor;
DELIMITER //
CREATE PROCEDURE SP_Eliminar_Profesor (
    IN p_id_profesor INT
)
BEGIN
    DELETE FROM profesores WHERE id_profesor = p_id_profesor;
END //
DELIMITER ;

-- CRUD de Clases

-- Insertar Clase
DROP PROCEDURE IF EXISTS SP_Insertar_Clase;
DELIMITER //
CREATE PROCEDURE SP_Insertar_Clase (
    IN p_nombre VARCHAR(100),
    IN p_descripcion TEXT
)
BEGIN
    INSERT INTO clases (nombre, descripcion) VALUES (p_nombre, p_descripcion);
END //
DELIMITER ;

-- Obtener Clases
DROP PROCEDURE IF EXISTS SP_Obtener_Clases;
DELIMITER //
CREATE PROCEDURE SP_Obtener_Clases ()
BEGIN
    SELECT * FROM clases;
END //
DELIMITER ;

-- Actualizar Clase
DROP PROCEDURE IF EXISTS SP_Actualizar_Clase;
DELIMITER //
CREATE PROCEDURE SP_Actualizar_Clase (
    IN p_id_clase INT,
    IN p_nombre VARCHAR(100),
    IN p_descripcion TEXT
)
BEGIN
    UPDATE clases SET nombre = p_nombre, descripcion = p_descripcion WHERE id_clase = p_id_clase;
END //
DELIMITER ;

-- Eliminar Clase
DROP PROCEDURE IF EXISTS SP_Eliminar_Clase;
DELIMITER //
CREATE PROCEDURE SP_Eliminar_Clase (
    IN p_id_clase INT
)
BEGIN
    DELETE FROM clases WHERE id_clase = p_id_clase;
END //
DELIMITER ;

-- ========================================================
-- 9. PROCEDIMIENTOS PARA ALUMNOS (CRUD GENERAL)
-- ========================================================

DROP PROCEDURE IF EXISTS SP_ALUMNO_GENERAL;
DELIMITER //
CREATE PROCEDURE SP_ALUMNO_GENERAL(
    IN p_accion VARCHAR(40),
    
    -- DATOS DEL ALUMNO
    IN p_id_alumno INT,
    IN p_nombre VARCHAR(150),
    IN p_carnet VARCHAR(50),
    IN p_correo VARCHAR(100),
    IN p_telefono VARCHAR(20),
    IN p_estado VARCHAR(10),
    
    -- INSCRIPCIÓN AL GRUPO
    IN p_id_grupo INT,
    IN p_anio VARCHAR(10),
    
    -- ASIGNACIÓN DE CLASE AL GRUPO (opcional)
    IN p_id_clase INT,
    IN p_id_profesor INT,
    IN p_id_modalidad INT,
    IN p_horario VARCHAR(50)
)
BEGIN

    /* ==================================
        1) CREAR ALUMNO
    ================================== */
    IF p_accion = 'crear' THEN
        
        -- Insertar alumno
        INSERT INTO alumnos(nombre_completo, codigo_carnet, correo_electronico, telefono, estado)
        VALUES (p_nombre, p_carnet, p_correo, p_telefono, p_estado);
        
        SET @nuevo_alumno = LAST_INSERT_ID();
        
        -- Inscribir al grupo
        INSERT INTO inscripciones_grupo(id_alumno, id_grupo, anio_escolar)
        VALUES (@nuevo_alumno, p_id_grupo, p_anio);
        
        -- Asignar clase al GRUPO (solo si se especifica una clase)
        IF p_id_clase IS NOT NULL AND p_id_clase > 0 THEN
            INSERT INTO asignaciones_clases (id_grupo, id_clase, id_profesor, id_modalidad, horario)
            VALUES (p_id_grupo, p_id_clase, p_id_profesor, p_id_modalidad, p_horario)
            ON DUPLICATE KEY UPDATE
                id_profesor = VALUES(id_profesor),
                id_modalidad = VALUES(id_modalidad),
                horario     = VALUES(horario);
        END IF;
        
    END IF;


    /* ==================================
        2) ACTUALIZAR ALUMNO
    ================================== */
    IF p_accion = 'actualizar' THEN
        
        -- Actualizar datos del alumno
        UPDATE alumnos SET
            nombre_completo     = p_nombre,
            codigo_carnet       = p_carnet,
            correo_electronico  = p_correo,
            telefono            = p_telefono,
            estado              = p_estado
        WHERE id_alumno = p_id_alumno;
        
        -- Actualizar inscripción al grupo
        UPDATE inscripciones_grupo SET
            id_grupo      = p_id_grupo,
            anio_escolar  = p_anio
        WHERE id_alumno = p_id_alumno;
        
        -- Actualizar o crear asignación de clase al grupo
        IF p_id_clase IS NOT NULL AND p_id_clase > 0 THEN
            INSERT INTO asignaciones_clases (id_grupo, id_clase, id_profesor, id_modalidad, horario)
            VALUES (p_id_grupo, p_id_clase, p_id_profesor, p_id_modalidad, p_horario)
            ON DUPLICATE KEY UPDATE
                id_profesor = VALUES(id_profesor),
                id_modalidad = VALUES(id_modalidad),
                horario     = VALUES(horario);
        END IF;
        
    END IF;


    /* ==================================
        3) ELIMINAR ALUMNO (sin tocar las clases del grupo)
    ================================== */
    IF p_accion = 'eliminar' THEN
        DELETE FROM inscripciones_grupo WHERE id_alumno = p_id_alumno;
        DELETE FROM asistencias         WHERE id_alumno = p_id_alumno;
        DELETE FROM alumnos            WHERE id_alumno = p_id_alumno;
    END IF;


    /* ==================================
        4) OBTENER UN ALUMNO
    ================================== */
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
        5) LISTAR TODOS LOS ALUMNOS (una fila por alumno)
    ================================== */
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
            GROUP_CONCAT(
                CONCAT(
                    COALESCE(c.nombre, 'Sin clase'),
                    ' (',
                    COALESCE(p.nombre_completo, 'Sin profesor'),
                    ' · ',
                    COALESCE(ac.horario, 'Sin horario'),
                    ')'
                ) SEPARATOR ' <br> '
            ) AS clases_asignadas
        FROM alumnos a
        LEFT JOIN inscripciones_grupo ig ON ig.id_alumno = a.id_alumno
        LEFT JOIN grupos g ON g.id_grupo = ig.id_grupo
        LEFT JOIN asignaciones_clases ac ON ac.id_grupo = ig.id_grupo
        LEFT JOIN clases c ON c.id_clase = ac.id_clase
        LEFT JOIN profesores p ON p.id_profesor = ac.id_profesor
        WHERE a.estado = 'Activo'
        GROUP BY a.id_alumno
        ORDER BY a.nombre_completo;
    END IF;

END //
DELIMITER ;

-- ========================================================
-- 10. PROCEDIMIENTOS PARA CLASES ASIGNADAS
-- ========================================================

-- Procedimiento definitivo: una fila por alumno por clase asignada
DROP PROCEDURE IF EXISTS SP_OBTENER_CLASES_ASIGNADAS;
DELIMITER //
CREATE PROCEDURE SP_OBTENER_CLASES_ASIGNADAS()
BEGIN
    SELECT 
        ac.id_asignacion,
        g.nombre_grupo,
        c.nombre AS nombre_clase,
        p.nombre_completo AS profesor,
        m.nombre AS modalidad,
        ac.horario,
        
        -- Datos del alumno (una fila por cada uno)
        a.id_alumno,
        a.nombre_completo AS nombre_alumno,
        a.codigo_carnet,
        a.correo_electronico AS correo_alumno

    FROM asignaciones_clases ac
    INNER JOIN grupos g ON ac.id_grupo = g.id_grupo
    INNER JOIN clases c ON ac.id_clase = c.id_clase
    INNER JOIN profesores p ON ac.id_profesor = p.id_profesor
    INNER JOIN modalidades m ON ac.id_modalidad = m.id_modalidad
    
    -- Traemos a los alumnos que pertenecen al grupo de esta asignación
    INNER JOIN inscripciones_grupo ig ON ig.id_grupo = ac.id_grupo
    INNER JOIN alumnos a ON a.id_alumno = ig.id_alumno AND a.estado = 'Activo'

    ORDER BY 
        g.nombre_grupo ASC,
        c.nombre ASC,
        a.nombre_completo ASC;
END //
DELIMITER ;

-- ========================================================
-- 11. PROCEDIMIENTOS PARA ASISTENCIAS
-- ========================================================

-- Obtener estudiantes de esa clase
DROP PROCEDURE IF EXISTS SP_OBTENER_ALUMNOS_POR_ASIGNACION;
DELIMITER //
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
END //
DELIMITER ;

-- Registrar asistencia
DROP PROCEDURE IF EXISTS SP_REGISTRAR_ASISTENCIA;
DELIMITER //
CREATE PROCEDURE SP_REGISTRAR_ASISTENCIA(
    IN pid_asignacion INT,
    IN pid_alumno INT,
    IN pfecha DATE,
    IN pestado VARCHAR(20)
)
BEGIN
    INSERT INTO asistencias(id_asignacion, id_alumno, fecha, estado_asistencia)
    VALUES (pid_asignacion, pid_alumno, pfecha, pestado)
    ON DUPLICATE KEY UPDATE
        estado_asistencia = VALUES(estado_asistencia);
END //
DELIMITER ;


-- Obtener asistencias
DROP PROCEDURE IF EXISTS SP_OBTENER_ASISTENCIAS;
DELIMITER //
CREATE PROCEDURE SP_OBTENER_ASISTENCIAS(
    IN pid_asignacion INT,
    IN pfecha DATE
)
BEGIN
    SELECT
        a.id_asistencia,
        a.id_asignacion,
        al.id_alumno,
        al.nombre_completo AS alumno,
        al.codigo_carnet AS codigo,
        c.nombre AS clase,
        g.nombre_grupo AS grupo,
        p.nombre_completo AS profesor,
        DATE(a.fecha) AS fecha,
        a.estado_asistencia AS estado
    FROM asistencias a
    INNER JOIN asignaciones_clases ac ON a.id_asignacion = ac.id_asignacion
    INNER JOIN grupos g ON ac.id_grupo = g.id_grupo
    INNER JOIN clases c ON ac.id_clase = c.id_clase
    INNER JOIN profesores p ON ac.id_profesor = p.id_profesor
    INNER JOIN alumnos al ON a.id_alumno = al.id_alumno
    WHERE ac.id_asignacion = pid_asignacion
      AND DATE(a.fecha) = pfecha
    ORDER BY al.nombre_completo ASC;
END //
DELIMITER ;

-- Actualizar estado de asistencia
DROP PROCEDURE IF EXISTS SP_ACTUALIZAR_ESTADO_ASISTENCIA;
DELIMITER //
CREATE PROCEDURE SP_ACTUALIZAR_ESTADO_ASISTENCIA(
    IN pid_asistencia INT,
    IN pestado VARCHAR(20)
)
BEGIN
    UPDATE asistencias
    SET estado_asistencia = pestado
    WHERE id_asistencia = pid_asistencia;
END //
DELIMITER ;

-- ========================================================
-- 12. PROCEDIMIENTO PARA DASHBOARD
-- ========================================================

DROP PROCEDURE IF EXISTS SP_DASHBOARD_GENERAL;
DELIMITER //
CREATE PROCEDURE SP_DASHBOARD_GENERAL()
BEGIN
    -- Tabla temporal para guardar todo
    DROP TEMPORARY TABLE IF EXISTS tmp_dashboard;
    CREATE TEMPORARY TABLE tmp_dashboard (
        tipo VARCHAR(50),
        descripcion VARCHAR(255),
        valor VARCHAR(100),
        orden INT
    );

    -- 1. Alumnos activos
    INSERT INTO tmp_dashboard (tipo, descripcion, valor, orden)
    SELECT 'alumnos_activos', 'Alumnos activos', COUNT(*), 1
    FROM alumnos WHERE estado = 'Activo';

    -- 2. Total profesores
    INSERT INTO tmp_dashboard (tipo, descripcion, valor, orden)
    SELECT 'total_profesores', 'Profesores', COUNT(*), 2 FROM profesores;

    -- 3. Total clases
    INSERT INTO tmp_dashboard (tipo, descripcion, valor, orden)
    SELECT 'total_clases', 'Materias', COUNT(*), 3 FROM clases;

    -- 4. Total modalidades
    INSERT INTO tmp_dashboard (tipo, descripcion, valor, orden)
    SELECT 'total_modalidades', 'Modalidades', COUNT(*), 4 FROM modalidades;

    -- 5. Presentes hoy
    INSERT INTO tmp_dashboard (tipo, descripcion, valor, orden)
    SELECT 'presentes_hoy', 'Presentes hoy', 
           COUNT(DISTINCT id_alumno), 5
    FROM asistencias 
    WHERE fecha = CURDATE() AND estado_asistencia = 'Presente';

    -- 6. Actividad reciente (una fila por cada clase que se pasó lista hoy)
    INSERT INTO tmp_dashboard (tipo, descripcion, valor, orden)
    SELECT 
        'actividad',
        CONCAT(p.nombre_completo, ' pasó lista en ', c.nombre, ' - ', g.nombre_grupo),
        CONCAT(
            'hace ', 
            CASE 
                WHEN TIMESTAMPDIFF(MINUTE, MAX(ast.fecha), NOW()) < 60 
                    THEN CONCAT(TIMESTAMPDIFF(MINUTE, MAX(ast.fecha), NOW()), ' min')
                ELSE CONCAT(TIMESTAMPDIFF(HOUR, MAX(ast.fecha), NOW()), ' h')
            END
        ),
        10 + ROW_NUMBER() OVER (ORDER BY MAX(ast.id_asistencia) DESC)
    FROM asistencias ast
    JOIN asignaciones_clases ac ON ast.id_asignacion = ac.id_asignacion
    JOIN profesores p ON ac.id_profesor = p.id_profesor
    JOIN clases c ON ac.id_clase = c.id_clase
    JOIN grupos g ON ac.id_grupo = g.id_grupo
    WHERE DATE(ast.fecha) = CURDATE()
    GROUP BY ac.id_asignacion, p.nombre_completo, c.nombre, g.nombre_grupo
    LIMIT 10;

    -- Devolvemos todo en una sola tabla
    SELECT 
        tipo,
        descripcion,
        valor
    FROM tmp_dashboard
    ORDER BY orden;

    -- Limpiamos
    DROP TEMPORARY TABLE IF EXISTS tmp_dashboard;
END //
DELIMITER ;

CREATE EVENT IF NOT EXISTS ev_reset_asistencias
ON SCHEDULE EVERY 24 HOUR
DO
BEGIN
    DELETE FROM asistencias;
    ALTER TABLE asistencias AUTO_INCREMENT = 1;
END;


-- ========================================================
-- 13. MODIFICACIONES DE TABLAS (ALTER TABLE)
-- ========================================================

-- Comentario: Cambiar tipo de fecha a DATETIME con valores por defecto
ALTER TABLE asistencias 
MODIFY COLUMN fecha DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;

-- Comentario: Asegurar índice único para grupo-clase
ALTER TABLE asignaciones_clases
ADD UNIQUE KEY IF NOT EXISTS unico_grupo_clase (id_grupo, id_clase);