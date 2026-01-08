<?php

namespace App\Controllers;

use App\Models\ProductsModel;

class ProductsController
{

    private $ProductsModel;

    public function __construct()
    {
        $this->ProductsModel = new ProductsModel;
    }

    public function getproducts()
    {
        $Response = $this->ProductsModel->GetProducts();
        /* Validamos si el resultado no esta vacio */
        if (!empty($Response)) {
            return json_encode($Response);
        } else {
            return json_encode([
                "message" => "No hay productos"
            ]);
        }
    }

    public function insertproduct()
    {
        $Json = file_get_contents('php://input');
        $Data = json_decode($Json, true);

        /* Validamos los datos de entrada (nombre, precio, cantidad, categoria, descripcion)*/
        if (!isset($Data['nombre']) || !isset($Data['precio']) || !isset($Data['cantidad']) || !isset($Data['categoria']) || !isset($Data['descripcion'])) {
            http_response_code(400);
            return json_encode(["error" => "Datos incompletos", "data" => $Data]);
        }

        $Response = $this->ProductsModel->InsertProduct($Data);

        if ($Response) {
            http_response_code(200);
            return json_encode(["message" => "Producto insertado correctamente"]);
        } else {
            http_response_code(400);
            return json_encode(["error" => "Error al insertar el producto"]);
        }
    }
    
    public function updateproduct()
    {
        $Json = file_get_contents('php://input');
        $Data = json_decode($Json, true);

        /* Validamos los datos de entrada (id, nombre, precio, cantidad, categoria, descripcion)*/
        if (!isset($Data['id']) || !isset($Data['nombre']) || !isset($Data['precio']) || !isset($Data['cantidad']) || !isset($Data['categoria']) || !isset($Data['descripcion'])) {
            http_response_code(400);
            return json_encode(["error" => "Datos incompletos", "data" => $Data]);
        }

        $Response = $this->ProductsModel->UpdateProduct($Data);

        if ($Response) {
            http_response_code(200);
            return json_encode(["message" => "Producto actualizado correctamente"]);
        } else {
            http_response_code(400);
            return json_encode(["error" => "Error al actualizar el producto"]);
        }
    }

    public function deleteproduct()
    {
        $Json = file_get_contents('php://input');
        $Data = json_decode($Json, true);

        /* Validamos los datos de entrada (id)*/
        if (!isset($Data['id'])) {
            http_response_code(400);
            return json_encode(["error" => "Datos incompletos", "data" => $Data]);
        }

        $Response = $this->ProductsModel->DeleteProduct($Data);

        if ($Response) {
            http_response_code(200);
            return json_encode(["message" => "Producto eliminado correctamente"]);
        } else {
            http_response_code(400);
            return json_encode(["error" => "Error al eliminar el producto"]);
        }
    }
}
