<?php

namespace App\Models;

use App\Config\Database;

class ProductsModel
{
    private $Mysql;

    public function __construct()
    {
        /* Usamos singleton */
        $this->Mysql = Database::getInstance();
    }

    public function GetProducts()
    {
        $Sql = "SELECT * FROM productos;";
        $Result = $this->Mysql->query($Sql);
        return $Result->fetch_all(MYSQLI_ASSOC);
    }

    public function InsertProduct(array $Data)
    {
        $Sql = "INSERT INTO productos (nombre, precio, cantidad, categoria, descripcion) VALUES(?, ?, ?, ?, ?);";
        $Params = [$Data['nombre'], $Data['precio'], $Data['cantidad'], $Data['categoria'], $Data['descripcion']];
        $Result = $this->Mysql->query($Sql, $Params);
        return $Result;
    }

    public function UpdateProduct(array $Data)
    {
        $Sql = "UPDATE productos SET nombre = ?, precio = ?, cantidad = ?, categoria = ?, descripcion = ? WHERE id = ?;";
        $Params = [$Data['nombre'], $Data['precio'], $Data['cantidad'], $Data['categoria'], $Data['descripcion'], $Data['id']];
        $Result = $this->Mysql->query($Sql, $Params);
        return $Result;
    }

    public function DeleteProduct(array $Data)
    {
        $Sql = "DELETE FROM productos WHERE id = ?;";
        $Params = [$Data['id']];
        $Result = $this->Mysql->query($Sql, $Params);
        return $Result;
    }
}
