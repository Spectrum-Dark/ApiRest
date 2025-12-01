<?php

namespace App\Controllers;

use App\Helpers\ResponseHelper;
use App\Models\StudentsModel;

class StudentsController
{
    private $model;

    public function __construct()
    {
        $this->model = new StudentsModel();
    }

    public function createStudent()
    {
        $data = json_decode(file_get_contents("php://input"), true);
        $result = $this->model->Student('crear', $data);
        return $result
            ? ResponseHelper::success(200, 'Alumno insertado correctamente')
            : ResponseHelper::error(500, 'Error al insertar el alumno');
    }

    public function updateStudent()
    {
        $data = json_decode(file_get_contents("php://input"), true);
        $result = $this->model->Student('actualizar', $data);
        return $result
            ? ResponseHelper::success(200, 'Alumno actualizado correctamente')
            : ResponseHelper::error(500, 'Error al actualizar el alumno');
    }

    public function deleteStudent()
    {
        $data = json_decode(file_get_contents("php://input"), true);
        $result = $this->model->Student('eliminar', $data);
        return $result
            ? ResponseHelper::success(200, 'Alumno eliminado correctamente')
            : ResponseHelper::error(500, 'Error al eliminar el alumno');
    }

    public function getStudent($id)
    {
        $result = $this->model->Student('obtener', ['id_alumno' => $id]);
        return $result
            ? ResponseHelper::success(200, $result)
            : ResponseHelper::error(404, 'Alumno no encontrado');
    }

    public function getAllStudents()
    {
        $result = $this->model->Student('listar', []);
        return $result
            ? ResponseHelper::success(200, $result)
            : ResponseHelper::error(404, 'No hay alumnos registrados');
    }

    public function getStudentsByAssignment($id)
    {
        $result = $this->model->getStudentsByAssignment($id);
        return $result
            ? ResponseHelper::success(200, $result)
            : ResponseHelper::error(404, 'No hay alumnos registrados en esta asignación');
    }
}
