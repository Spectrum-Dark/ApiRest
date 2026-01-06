<?php

namespace App\Models;

use App\Config\Database;

class UserModel
{
    private $Mysql;

    public function __construct()
    {
        /* Usamos singleton */
        $this->Mysql = Database::getInstance();
    }

    public function GetUser(array $Data)
    {
        /* Obtenemos el usuario */
        $Sql = "SELECT * FROM users WHERE correo = ? AND acceso = ? LIMIT 1;";
        $Params = [$Data['correo'], $Data['acceso']];
        $Result = $this->Mysql->query($Sql, $Params);
        return $Result->fetch_assoc();
    }
}
