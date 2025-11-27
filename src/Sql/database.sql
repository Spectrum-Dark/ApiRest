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

DELIMITER / /

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

DELIMITER;

-- Get User By Id
DROP PROCEDURE IF EXISTS GetUserById;

DELIMITER / /

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

DELIMITER;

-- Get User By Email
DROP PROCEDURE IF EXISTS GetUserByEmail;

DELIMITER / /

CREATE PROCEDURE GetUserByEmail(
    IN p_email VARCHAR(100)
)
BEGIN
    -- Incluir el password aquí es común, ya que este SP se usa a menudo para la autenticación (login)
    SELECT username, email, role, password, id FROM Users WHERE email = p_email;
END //

DELIMITER;

-- Update User
DROP PROCEDURE IF EXISTS UpdateUser;

DELIMITER / /

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
END //

DELIMITER;

-- Delete User
DROP PROCEDURE IF EXISTS DeleteUser;

DELIMITER / /

CREATE PROCEDURE DeleteUser(
    IN p_id INT
)
BEGIN
    DELETE FROM Users WHERE id = p_id;
END //

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
-- 3. Tabla Principal de Usuarios
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

-- Insertar Modalidad
DELIMITER / /

CREATE PROCEDURE SP_Insertar_Modalidad (
    IN p_nombre VARCHAR(50),
    IN p_descripcion TEXT
)
BEGIN
    INSERT INTO modalidades (nombre, descripcion) VALUES (p_nombre, p_descripcion);
END //

DELIMITER;

-- Insertar Grupo
DELIMITER / /

CREATE PROCEDURE SP_Insertar_Grupo (
    IN p_nombre_grupo VARCHAR(50)
)
BEGIN
    INSERT INTO grupos (nombre_grupo) VALUES (p_nombre_grupo);
END //

DELIMITER;

-- Insertar Profesor
DELIMITER / /

CREATE PROCEDURE SP_Insertar_Profesor (
    IN p_nombre_completo VARCHAR(150),
    IN p_email VARCHAR(100),
    IN p_telefono VARCHAR(20)
)
BEGIN
    INSERT INTO profesores (nombre_completo, email, telefono) VALUES (p_nombre_completo, p_email, p_telefono);
END //

DELIMITER;

-- Insertar Clase
DELIMITER / /

CREATE PROCEDURE SP_Insertar_Clase (
    IN p_nombre VARCHAR(100),
    IN p_descripcion TEXT
)
BEGIN
    INSERT INTO clases (nombre, descripcion) VALUES (p_nombre, p_descripcion);
END //

DELIMITER;

-- Insertar Alumno
DELIMITER / /

CREATE PROCEDURE SP_Inscribir_Alumno_a_Grupo (
    IN p_nombre_completo VARCHAR(150),
    IN p_codigo_carnet VARCHAR(50),
    IN p_correo_electronico VARCHAR(100),
    IN p_telefono VARCHAR(20),
    IN p_estado ENUM('Activo', 'Inactivo'),
    IN p_id_grupo INT,
    IN p_anio_escolar VARCHAR(10)
)
BEGIN
    DECLARE v_id_alumno INT;
    
    -- 1. Insertar el Alumno en la tabla principal
    INSERT INTO alumnos (nombre_completo, codigo_carnet, correo_electronico, telefono, estado) 
    VALUES (p_nombre_completo, p_codigo_carnet, p_correo_electronico, p_telefono, p_estado);
    
    -- Obtener el ID generado
    SET v_id_alumno = LAST_INSERT_ID();
    
    -- 2. Inscribir al alumno en el grupo
    INSERT INTO inscripciones_grupo (id_alumno, id_grupo, anio_escolar) 
    VALUES (v_id_alumno, p_id_grupo, p_anio_escolar);

END //

DELIMITER;

-- Crear Asignacion de Clase
DELIMITER / /

CREATE PROCEDURE SP_Crear_Asignacion_Clase (
    IN p_id_grupo INT,
    IN p_id_clase INT,
    IN p_id_profesor INT,
    IN p_id_modalidad INT,
    IN p_horario VARCHAR(100)
)
BEGIN
    INSERT INTO asignaciones_clases (id_grupo, id_clase, id_profesor, id_modalidad, horario) 
    VALUES (p_id_grupo, p_id_clase, p_id_profesor, p_id_modalidad, p_horario);
END //

DELIMITER;

-- Registrar Asistencia
DELIMITER / /

CREATE PROCEDURE SP_Registrar_Asistencia (
    IN p_id_asignacion INT,
    IN p_id_alumno INT,
    IN p_fecha DATE,
    IN p_estado_asistencia ENUM('Presente', 'Ausente', 'Tardanza', 'Justificado')
)
BEGIN
    INSERT INTO asistencias (id_asignacion, id_alumno, fecha, estado_asistencia) 
    VALUES (p_id_asignacion, p_id_alumno, p_fecha, p_estado_asistencia);
END //

DELIMITER;

-- Crear Vista para las Ultimas Asistencias
CREATE OR REPLACE VIEW V_Ultimas_Asistencias AS
SELECT
    asist.fecha AS Fecha,
    c.nombre AS Clase,
    SUM(
        CASE
            WHEN asist.estado_asistencia = 'Presente' THEN 1
            ELSE 0
        END
    ) AS Total_Presentes,
    SUM(
        CASE
            WHEN asist.estado_asistencia = 'Ausente' THEN 1
            ELSE 0
        END
    ) AS Total_Ausentes
FROM
    asistencias asist
    INNER JOIN asignaciones_clases ac ON asist.id_asignacion = ac.id_asignacion
    INNER JOIN clases c ON ac.id_clase = c.id_clase
GROUP BY
    asist.fecha,
    c.nombre
ORDER BY asist.fecha DESC;