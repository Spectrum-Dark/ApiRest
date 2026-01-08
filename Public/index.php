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
use App\Controllers\ProductsController;

$router = new Router();

// Definimos las rutas aquí
$router->post('/App/Login', [UserController::class, 'login']);
$router->post('/App/Register', [UserController::class, 'register']);

$router->get('/App/Products/All', [ProductsController::class, 'getproducts']);
$router->post('/App/Products/Insert', [ProductsController::class, 'insertproduct']);
$router->put('/App/Products/Update', [ProductsController::class, 'updateproduct']);
$router->delete('/App/Products/Delete', [ProductsController::class, 'deleteproduct']);

// Ejecutamos el router
$router->run();
