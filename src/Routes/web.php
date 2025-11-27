<?php

use App\Core\Router;

/* Controladores */
use App\Controllers\UserController;

$router = new Router();

/* Rutas publicas ============================================================================================== */

$router->get('/', function () {
    echo json_encode(['ok' => true, 'message' => 'API funcionando']);
});

//* Ruta para el login de usuarios //
$router->post('/users/login', [UserController::class, 'login']);

//* Ruta para el registro de usuarios //
$router->post('/users/register', [UserController::class, 'register']);

/* Fin de rutas publicas ======================================================================================= */


/* Rutas privadas ============================================================================================== */

//* Ruta para obtener la informacion del usuario autenticado //
$router->get('/users/me', [UserController::class, 'me'])->middleware('auth');


/* Fin rutas privadas ========================================================================================== */
return $router;
