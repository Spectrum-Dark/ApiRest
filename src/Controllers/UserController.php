<?php

namespace App\Controllers;

use App\Models\UserModel;
use App\Helpers\ResponseHelper;
use Firebase\JWT\JWT;

class UserController
{
    public function login()
    {
        /* Capturamos los datos de entrada */
        $Data = json_decode(file_get_contents("php://input"), true);

        /* Validamos que lleguen los datos obligatorios */
        if (!isset($Data["email"], $Data["password"])) {
            ResponseHelper::error("Email y password requeridos", null, 400);
        }

        /* Obtenemos el usuario por su correo electrónico */
        $model = new UserModel();
        $user = $model->getUserByEmail($Data);

        /* Validamos que el usuario exista */
        if (!$user) {
            ResponseHelper::error("Usuario no encontrado", null, 404);
        }

        /* Verificamos la contraseña */
        if (!password_verify($Data["password"], $user["password"])) {
            ResponseHelper::error("Credenciales incorrectas", null, 401);
        }

        /* Generamos el token */
        $payload = [
            "email" => $user["email"],
            "role"  => $user["role"],
            "iat"   => time(),
            "exp"   => time() + 60 * 60 * 24 // 24h
        ];

        /* Codificamos el payload en un token JWT */
        $token = JWT::encode($payload, $_ENV["JWT_SECRET"], 'HS256');

        ResponseHelper::success("Login correcto", ["token" => $token]);
    }

    public function me()
    {
        if (!isset($GLOBALS['user'])) {
            return ResponseHelper::error('Usuario no autenticado', null, 401);
        }

        return ResponseHelper::success('Usuario autenticado', $GLOBALS['user']);
    }

    public function show($id)
    {
        ResponseHelper::success(
            "Mostrando usuario con ID: {$id}",
            ["id" => $id]
        );
    }
}
