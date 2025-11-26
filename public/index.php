<?php

/* CORS Headers para permitir peticiones cross-origin */
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type, Authorization');
header('Content-Type: application/json; charset=utf-8');

/* Autoload de Composer para cargar automáticamente las clases */
require __DIR__ . '/../vendor/autoload.php';

use App\Core\App;
use Dotenv\Dotenv;

/* Cargar .env */
$dotenv = Dotenv::createImmutable(__DIR__ . "/../");
$dotenv->load();

/* Instanciación de la aplicación */
$app = new App();
$app->run();