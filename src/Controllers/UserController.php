<?php

namespace App\Controllers;

use App\Models\UserModel;
use App\Helpers\ResponseHelper;
use Firebase\JWT\JWT;

class UserController
{
    private $model;

    public function __construct()
    {
        $this->model = new UserModel();
    }

    public function register()
    {
        /* Capturamos los datos de entrada */
        $Data = json_decode(file_get_contents("php://input"), true);

        /* Validamos que lleguen los datos obligatorios */
        if (!isset($Data["username"], $Data["email"], $Data["password"], $Data["role"])) {
            return ResponseHelper::error("Por favor, rellene todos los campos", null, 400);
        }

        /* Hasheamos la contraseña */
        $Data["password"] = password_hash($Data["password"], PASSWORD_DEFAULT);

        /* Insertamos el usuario */
        $result = $this->model->insertUser($Data);

        if ($result["success"]) {
            return ResponseHelper::success("Usuario registrado con éxito", null, 201);
        }

        if ($result["error"] === "duplicate") {
            return ResponseHelper::error("Este usuario ya existe", 409);
        }

        return ResponseHelper::error("Error al registrar el usuario", 500);
    }

    public function login()
    {
        /* Capturamos los datos de entrada */
        $Data = json_decode(file_get_contents("php://input"), true);

        /* Validamos que lleguen los datos obligatorios */
        if (!isset($Data["email"], $Data["password"])) {
            ResponseHelper::error("Porfavor rellene todos los campos", null, 400);
        }

        /* Obtenemos el usuario por su correo electrónico */
        $user = $this->model->getUserByEmail($Data);

        /* Validamos que el usuario exista */
        if (!$user) {
            ResponseHelper::error("Usuario no encontrado", null, 404);
        }

        /* Verificamos la contraseña */
        if (!password_verify($Data["password"], $user["password"])) {
            ResponseHelper::error("Credenciales incorrectas", null, 401);
        }

        /* Deshasheamos la contraseña */
        $password = $Data["password"];

        /* Generamos el token */
        $payload = [
            "username" => $user["username"],
            "email" => $user["email"],
            "role"  => $user["role"],
            "password" => $password,
            "iat"   => time(),
            "exp"   => time() + 60 * 60 * 24 // 24h
        ];

        /* Codificamos el payload en un token JWT */
        $token = JWT::encode($payload, $_ENV["JWT_SECRET"], 'HS256');

        ResponseHelper::success("Login correcto", ["token" => $token]);
    }

    public function infomation()
    {
        if (!isset($GLOBALS['user'])) {
            return ResponseHelper::error('Usuario no autenticado', null, 401);
        }

        return ResponseHelper::success('Usuario autenticado', $GLOBALS['user']);
    }

    public function getAll()
    {
        $result = $this->model->getAllUsers();

        if ($result) {
            return ResponseHelper::success("Usuarios obtenidos con exito", $result, 201);
        }

        return ResponseHelper::error("Error al obtener los usuarios", 500);
    }

    public function update()
    {
        $Data = json_decode(file_get_contents("php://input"), true);

        if (!isset($Data["id"], $Data["username"], $Data["email"], $Data["password"], $Data["role"])) {
            return ResponseHelper::error("Por favor, rellene todos los campos", null, 400);
        }

        /* hasheamos la contraseña */
        $Data["password"] = password_hash($Data["password"], PASSWORD_DEFAULT);

        $result = $this->model->updateUser($Data);

        if ($result) {
            return ResponseHelper::success("Usuario actualizado con exito", null, 201);
        }

        return ResponseHelper::error("Error al actualizar el usuario", 500);
    }

    public function delete()
    {
        $Data = json_decode(file_get_contents("php://input"), true);

        if (!isset($Data["id"])) {
            return ResponseHelper::error("Por favor, indique el id del usuario", null, 400);
        }

        $result = $this->model->deleteUser($Data);

        if ($result) {
            return ResponseHelper::success("Usuario eliminado con exito", null, 201);
        }

        return ResponseHelper::error("Error al eliminar el usuario", 500);
    }
}
