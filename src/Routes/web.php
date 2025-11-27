<?php

use App\Core\Router;

/* Controladores */
use App\Controllers\UserController;

$router = new Router();


$router->get('/', function () {
    echo json_encode(['success' => true, 'message' => 'API funcionando']);
});

/* Rutas de usuarios  */
$router->post('/users/login', [UserController::class, 'login']);
$router->post('/users/register', [UserController::class, 'register']);
$router->get('/users/all', [UserController::class, 'getAll'])->middleware('auth');
$router->get('/users/profile', [UserController::class, 'infomation'])->middleware('auth');
$router->put('/users/profile/update/', [UserController::class, 'update'])->middleware('auth');
$router->delete('/users/profile/delete/', [UserController::class, 'delete'])->middleware('auth');


return $router;
