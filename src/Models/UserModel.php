<?php

namespace App\Models;

/* Usamos la base de datos */

use App\Core\Database;

class UserModel
{
    private $MySql;

    public function __construct()
    {
        $this->MySql = Database::getInstance();
    }

    /* Obtenemos el usuario por su correo electrónico */

    public function getUserByEmail(array $Data)
    {
        /* Preparamos la consula */
        $SQL = "CALL GetUserByEmail(?)";

        /* Preparamos los parametros */
        $Params = [
            $Data['email']
        ];

        /* Ejecutamos la consulta */
        $Result = $this->MySql->query($SQL, $Params);

        /* Retornamos el resultado */
        return $Result->fetch_assoc();
    }
}
