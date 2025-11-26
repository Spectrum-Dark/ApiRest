<?php

namespace App\Core;

class Router
{
    private array $routes = [];
    private array $middlewares = [];

    public function add(string $method, string $path, $handler): Middleware
    {
        $method = strtoupper($method);
        $path = $this->normalize($path);

        $route = new Middleware($method, $path, $handler);

        $this->routes[$method][$path] = $route;

        return $route;
    }

    public function get(string $path, $handler): Middleware
    {
        return $this->add('GET', $path, $handler);
    }

    public function post(string $path, $handler): Middleware
    {
        return $this->add('POST', $path, $handler);
    }

    public function put(string $path, $handler): Middleware
    {
        return $this->add('PUT', $path, $handler);
    }

    public function delete(string $path, $handler): Middleware
    {
        return $this->add('DELETE', $path, $handler);
    }

    public function registerMiddleware(string $name, $class)
    {
        $this->middlewares[$name] = $class;
    }

    public function dispatch(string $requestUri, string $requestMethod)
    {
        $requestUri = parse_url($requestUri, PHP_URL_PATH);
        $requestUri = str_replace('/App/public', '', $requestUri);

        $method = strtoupper($requestMethod);
        $path = $this->normalize($requestUri);

        // Coincidencia exacta
        if (isset($this->routes[$method][$path])) {
            return $this->handleRoute($this->routes[$method][$path]);
        }

        // Coincidencia con parámetros
        foreach ($this->routes[$method] as $route) {
            $pattern = preg_replace('#\{[^/]+\}#', '([^/]+)', $route->path);

            if (preg_match('#^' . $pattern . '$#', $path, $matches)) {
                array_shift($matches);
                return $this->handleRoute($route, $matches);
            }
        }

        http_response_code(404);
        echo json_encode(['error' => 'Not Found']);
    }

    private function handleRoute(Middleware $route, array $params = [])
    {
        // Ejecutar middlewares en orden
        foreach ($route->middlewares as $mw) {
            [$name, $args] = $mw;

            if (!isset($this->middlewares[$name])) {
                http_response_code(500);
                echo json_encode(["error" => "Middleware '$name' no registrado"]);
                return;
            }

            $middleware = new $this->middlewares[$name];

            if (!$middleware->handle($args)) {
                return; // middleware detiene la ejecución
            }
        }

        // Ejecutar handler
        $handler = $route->handler;

        if (is_callable($handler)) {
            return call_user_func_array($handler, $params);
        }

        if (is_array($handler)) {
            [$class, $method] = $handler;

            if (!class_exists($class)) {
                http_response_code(500);
                echo json_encode(['error' => 'Controller not found']);
                return;
            }

            $controller = new $class();
            return call_user_func_array([$controller, $method], $params);
        }
    }

    private function normalize(string $path): string
    {
        if ($path !== '/' && str_ends_with($path, '/')) {
            $path = rtrim($path, '/');
        }
        return $path === '' ? '/' : $path;
    }
}
