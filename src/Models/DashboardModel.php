<?php

namespace App\Models;

use App\Core\Database;

class DashboardModel
{
    private $MySQl;

    public function __construct()
    {
        $this->MySQl = Database::getInstance();
    }

    public function getDashboardData()
    {
        $SQL = "CALL SP_DASHBOARD_GENERAL()";
        $result = $this->MySQl->query($SQL);

        // Forzamos que lea TODOS los rows del primer result set
        $data = [];
        while ($row = $result->fetch_assoc()) {
            $data[] = $row;
        }

        // LIMPIAMOS TODO lo que queda (esto es clave)
        $this->MySQl->consumeAllResults();

        // Liberamos el result set actual
        $result->free();

        return $data;
    }
}
