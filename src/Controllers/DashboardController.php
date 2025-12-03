<?php

namespace App\Controllers;

use App\Models\DashboardModel;

class DashboardController
{
    private $model;

    public function __construct()
    {
        $this->model = new DashboardModel();
    }

    public function index()
    {
        header('Content-Type: application/json; charset=utf-8');
        echo json_encode($this->model->getDashboardData(), JSON_UNESCAPED_UNICODE);
        exit; // importante para que no siga ejecutando nada más
    }
}
