<?php

namespace App\Core;

use App\Middlewares\AuthMiddleware;  // ← IMPORTANTE

class App
{
    private Router $router;

    public function __construct()
    {
        // Cargar rutas
        $this->router = require __DIR__ . '/../Routes/web.php';

        // Registrar middlewares
        $this->router->registerMiddleware('auth', AuthMiddleware::class);
    }

    public function run(): void
    {
        $this->router->dispatch(
            $_SERVER['REQUEST_URI'],
            $_SERVER['REQUEST_METHOD']
        );
    }
}
