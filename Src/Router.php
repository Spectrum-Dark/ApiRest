<?php
namespace App;

class Router {
    private $routes = [];

    private function addRoute($method, $path, $callback) {
        $this->routes[$method][$path] = $callback;
    }

    public function get($path, $callback)    { $this->addRoute('GET', $path, $callback); }
    public function post($path, $callback)   { $this->addRoute('POST', $path, $callback); }
    public function put($path, $callback)    { $this->addRoute('PUT', $path, $callback); }
    public function delete($path, $callback) { $this->addRoute('DELETE', $path, $callback); }

    public function run() {
        $method = $_SERVER['REQUEST_METHOD'];
        $uri = parse_url($_SERVER['REQUEST_URI'], PHP_URL_PATH);
        
        // Ajuste para tu carpeta específica
        $uri = str_replace('/ApiRest/Public', '', $uri);

        if (isset($this->routes[$method][$uri])) {
            $callback = $this->routes[$method][$uri];
            
            $controllerName = $callback[0];
            $methodName = $callback[1];
            
            $controller = new $controllerName();
            echo $controller->$methodName();
        } else {
            http_response_code(404);
            echo json_encode(["error" => "Ruta no encontrada", "path" => $uri]);
        }
    }
}