<?php

namespace App\Middlewares;

use Firebase\JWT\JWT;
use Firebase\JWT\Key;
use App\Helpers\ResponseHelper;

class AuthMiddleware
{
    public function handle($arg = null)
    {
        // Obtener el header Authorization
        $authHeader = $_SERVER['HTTP_AUTHORIZATION']
            ?? ($_SERVER['Authorization'] ?? null);

        if (!$authHeader) {
            ResponseHelper::error('Token requerido', null, 401);
        }

        // Aceptar con o sin "Bearer "
        $token = str_ireplace('Bearer ', '', trim($authHeader));

        if (!$token) {
            ResponseHelper::error('Token requerido', null, 401);
        }

        // Obtener secreto
        $secret = $_ENV['JWT_SECRET'] ?? null;
        if (!$secret) {
            ResponseHelper::error('JWT_SECRET no configurado', null, 500);
        }

        // Decodificar token
        try {
            $decoded = JWT::decode($token, new Key($secret, 'HS256'));
            $GLOBALS['user'] = (array) $decoded;
            return true;
        } catch (\Throwable $e) {
            ResponseHelper::error('Token inválido', $e->getMessage(), 401);
        }
    }
}
