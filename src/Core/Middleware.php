<?php

namespace App\Core;

class Middleware
{
    public string $method;
    public string $path;
    public $handler;
    public array $middlewares = [];

    public function __construct(string $method, string $path, $handler)
    {
        $this->method = $method;
        $this->path = $path;
        $this->handler = $handler;
    }

    public function middleware(string|array $names): self
    {
        if (is_string($names)) {
            $names = [$names];
        }

        foreach ($names as $mw) {
            $parts = explode(':', $mw);
            $name = $parts[0];
            $args = $parts[1] ?? null;
            $this->middlewares[] = [$name, $args];
        }

        return $this;
    }
}
