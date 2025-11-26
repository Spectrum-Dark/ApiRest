<?php

use App\Core\Router;
use App\Middlewares\AuthMiddleware;

/* Controladores */
use App\Controllers\UserController;

$router = new Router();

/* Rutas publicas ============================================================================================== */

$router->get('/', function () {
    echo json_encode(['ok' => true, 'message' => 'API funcionando']);
});

$router->post('/users/login', [UserController::class, 'login']);

/* Fin de rutas publicas ======================================================================================= */


/* Rutas privadas ============================================================================================== */

$router->get('/users/me', [UserController::class, 'me'])->middleware('auth');
$router->post('/users/show/{id}', [UserController::class, 'show'])->middleware('auth');


/* Fin rutas privadas ========================================================================================== */
return $router;
