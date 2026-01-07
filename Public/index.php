<?php

// Headers de Seguridad y CORS
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization");
header("Content-Type: application/json; charset=UTF-8");

if ($_SERVER['REQUEST_METHOD'] == 'OPTIONS') {
    http_response_code(200);
    exit();
}

/* ---------------------------------------------------------------------------- */

require_once __DIR__ . '/../autoload.php';

use App\Router;
use App\Controllers\UserController;

$router = new Router();

// Definimos las rutas aquí
$router->post('/App/Login', [UserController::class, 'login']);
$router->post('/App/Register', [UserController::class, 'register']);

// Ejecutamos el router
$router->run();
