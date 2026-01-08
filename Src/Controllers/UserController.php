<?php

namespace App\Controllers;

use App\Models\UserModel;
use App\Config\Auth;

class UserController
{
    private $UserModel;

    public function __construct()
    {
        /* Instanciamos */
        $this->UserModel = new UserModel;
    }

    public function login()
    {
        /* Obtenemos la informacion de la peticion */
        $Json = file_get_contents('php://input');
        $Data = json_decode($Json, true);

        /* Validamos si existen los datos */
        if (!isset($Data['correo']) || !isset($Data['acceso'])) {
            http_response_code(400);
            return json_encode(["error" => "Datos incompletos"]);
        }

        /* Mandamos los parametros */
        $Response = $this->UserModel->Login($Data);

        /* Validamos el login */
        if ($Response['correo'] == $Data['correo'] && $Response['acceso'] == $Data['acceso']) {
            /* Generamos el token de acceso */
            $Token = Auth::generateToken($Data);
            return json_encode([
                "message" => "Autenticado",
                "user" => $Response['usuario'],
                "token" => $Token
            ]);
        }
    }

    public function register()
    {
        /* Obtenemos la informacion de la peticion */
        $Json = file_get_contents('php://input');
        $Data = json_decode($Json, true);

        if (!isset($Data['correo']) || !isset($Data['usuario']) || !isset($Data['acceso'])) {
            http_response_code(400);
            return json_encode([
                "error " => "Datos incompletos",
                "data" => $Data
            ]);
        }

        $Response = $this->UserModel->Register($Data);

        if ($Response) {
            return json_encode([
                "message" => "Usuario registrado"
            ]);
        } else {
            return json_encode([
                "error" => "Usuario no registrado"
            ]);
        }
    }
}
