-- Active: 1761759741520@@127.0.0.1@3306@inventrack
CREATE DATABASE inventrack;

USE inventrack;

CREATE TABLE users(
    id INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    correo VARCHAR(100) NOT NULL UNIQUE,
    usuario VARCHAR(100) NOT NULL,
    acceso VARCHAR(100) NULL NULL
);

/* Creamos Crud de usuarios */

SELECT * FROM users WHERE correo = '' AND acceso = '' LIMIT 1;

INSERT INTO users (correo, usuario, acceso) VALUES("adminexample@gmail.com", "admin", "241299");

UPDATE users SET (correo, usuario, acceso) WHERE id = "";

DELETE FROM users WHERE id = "";

/* Fin Crud de usuarios */