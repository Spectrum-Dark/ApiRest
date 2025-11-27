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

    /* Insertamos un usuario */
    public function insertUser(array $Data): array
    {
        try {
            $SQL = "CALL InsertUser(?, ?, ?, ?)";

            $Params = [
                $Data['username'],
                $Data['email'],
                $Data['role'],
                $Data['password']
            ];

            $this->MySql->query($SQL, $Params);

            return [
                "success" => true,
                "error" => null
            ];
        } catch (\mysqli_sql_exception $e) {

            return [
                "success" => false,
                "error" => $e->getCode() === 1062 ? "duplicate" : "db_error"
            ];
        }
    }

    /* Obtenemos todos los usuarios */

    public function getAllUsers()
    {
        $SQL = "CALL GetAllUsers()";

        $Result = $this->MySql->query($SQL);
        return $Result->fetch_all(MYSQLI_ASSOC);
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

    /* Actualizamos un usuario */
    public function updateUser(array $Data)
    {
        $SQL = "CALL UpdateUser(?, ?, ?, ?, ?)";
        $Params = [
            $Data['id'],
            $Data['username'],
            $Data['email'],
            $Data['role'],
            $Data['password']
        ];

        $Result = $this->MySql->query($SQL, $Params);
        return $Result;
    }

    /* Eliminamos un usuario */
    public function deleteUser(array $Data)
    {
        $SQL = "CALL DeleteUser(?)";
        $Params = [
            $Data['id']
        ];

        $Result = $this->MySql->query($SQL, $Params);
        return $Result;
    }
}
