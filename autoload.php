<?php
// autoload.php
spl_autoload_register(function ($class) {
    // Convierte el nombre de la clase (App\Controllers\User) en una ruta de archivo
    $path = str_replace('App\\', 'Src/', $class);
    $path = __DIR__ . '/' . str_replace('\\', '/', $path) . '.php';

    if (file_exists($path)) {
        require_once $path;
    }
});