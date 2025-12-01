<?php

namespace App\Controllers;

use App\Models\AttendanceModel;
use App\Helpers\ResponseHelper;

class AttendanceController
{
    private $model;

    public function __construct()
    {
        $this->model = new AttendanceModel();
    }

    /* Insertamos modalidad */
    public function insert_Mode()
    {
        /* Capturamos los datos de entrada */
        $Data = json_decode(file_get_contents("php://input"), true);

        if (!isset($Data['name']) || !isset($Data['description'])) {
            return ResponseHelper::error(400, 'Faltan datos obligatorios');
        }

        $result = $this->model->insertMode($Data);
        return $result ? ResponseHelper::success(200, 'Modalidad insertada correctamente') : ResponseHelper::error(500, 'Error al insertar la modalidad');
    }

    /* Obtenemos modalidades */
    public function get_Modes()
    {
        $result = $this->model->getAllModes();
        if (empty($result)) {
            return ResponseHelper::success(200, 'Aun no hay modalidades registradas');
        }
        return $result ? ResponseHelper::success(200, $result) : ResponseHelper::error(500, 'Error al obtener las modalidades');
    }

    /* Actualizamos modalidades */
    public function update_Mode()
    {
        $Data = json_decode(file_get_contents("php://input"), true);

        if (!isset($Data['id']) || !isset($Data['name']) || !isset($Data['description'])) {
            return ResponseHelper::error(400, 'Faltan datos obligatorios');
        }

        $result = $this->model->updateMode($Data);
        return $result ? ResponseHelper::success(200, 'Modalidad actualizada correctamente') : ResponseHelper::error(500, 'Error al actualizar la modalidad');
    }

    /* Eliminamos modalidades */
    public function delete_Mode()
    {
        $Data = json_decode(file_get_contents("php://input"), true);

        if (!isset($Data['id'])) {
            return ResponseHelper::error(400, 'Faltan datos obligatorios');
        }

        $result = $this->model->deleteMode($Data);
        return $result ? ResponseHelper::success(200, 'Modalidad eliminada correctamente') : ResponseHelper::error(500, 'Error al eliminar la modalidad');
    }

    //? ===========================================================================================================================================

    /* Insertamos grupos */
    public function insert_Group()
    {
        $Data = json_decode(file_get_contents("php://input"), true);

        if (!isset($Data['name'])) {
            return ResponseHelper::error(400, 'Faltan datos obligatorios');
        }

        $result = $this->model->insertGroup($Data);
        return $result ? ResponseHelper::success(200, 'Grupo insertado correctamente') : ResponseHelper::error(500, 'Error al insertar el grupo');
    }

    /* Obtenemos grupos */
    public function get_Groups()
    {
        $result = $this->model->getAllGroups();
        /* validamos si los datos estan vacios */
        if (empty($result)) {
            return ResponseHelper::success(200, 'Aun no hay grupos registrados');
        }
        return $result ? ResponseHelper::success(200, $result) : ResponseHelper::error(500, 'Error al obtener los grupos');
    }

    /* Actualizamos grupos */
    public function update_Group()
    {
        $Data = json_decode(file_get_contents("php://input"), true);

        if (!isset($Data['id']) || !isset($Data['name'])) {
            return ResponseHelper::error(400, 'Faltan datos obligatorios');
        }

        $result = $this->model->updateGroup($Data);
        return $result ? ResponseHelper::success(200, 'Grupo actualizado correctamente') : ResponseHelper::error(500, 'Error al actualizar el grupo');
    }

    /* Eliminamos grupos */
    public function delete_Group()
    {
        $Data = json_decode(file_get_contents("php://input"), true);

        if (!isset($Data['id'])) {
            return ResponseHelper::error(400, 'Faltan datos obligatorios');
        }

        $result = $this->model->deleteGroup($Data);
        return $result ? ResponseHelper::success(200, 'Grupo eliminado correctamente') : ResponseHelper::error(500, 'Error al eliminar el grupo');
    }

    //? ===========================================================================================================================================

    /* Insertamos profesores */
    public function insert_Teacher()
    {
        $Data = json_decode(file_get_contents("php://input"), true);

        if (!isset($Data['name']) || !isset($Data['email']) || !isset($Data['phone'])) {
            return ResponseHelper::error(400, 'Faltan datos obligatorios');
        }

        $result = $this->model->insertTeacher($Data);
        return $result ? ResponseHelper::success(200, 'Profesor insertado correctamente') : ResponseHelper::error(500, 'Error al insertar el profesor');
    }

    /* Obtenemos profesores */
    public function get_Teachers()
    {
        $result = $this->model->getAllTeachers();
        if (empty($result)) {
            return ResponseHelper::success(200, 'Aun no hay profesores registrados');
        }
        return $result ? ResponseHelper::success(200, $result) : ResponseHelper::error(500, 'Error al obtener los profesores');
    }

    /* Actualizamos profesores */
    public function update_Teacher()
    {
        $Data = json_decode(file_get_contents("php://input"), true);

        if (!isset($Data['id']) || !isset($Data['name']) || !isset($Data['email']) || !isset($Data['phone'])) {
            return ResponseHelper::error(400, 'Faltan datos obligatorios');
        }

        $result = $this->model->updateTeacher($Data);
        return $result ? ResponseHelper::success(200, 'Profesor actualizado correctamente') : ResponseHelper::error(500, 'Error al actualizar el profesor');
    }

    /* Eliminamos profesores */
    public function delete_Teacher()
    {
        $Data = json_decode(file_get_contents("php://input"), true);

        if (!isset($Data['id'])) {
            return ResponseHelper::error(400, 'Faltan datos obligatorios');
        }

        $result = $this->model->deleteTeacher($Data);
        return $result ? ResponseHelper::success(200, 'Profesor eliminado correctamente') : ResponseHelper::error(500, 'Error al eliminar el profesor');
    }

    //? ===========================================================================================================================================

    /* Insertamos clase nombre descripcion */
    public function insert_Class()
    {
        $Data = json_decode(file_get_contents("php://input"), true);

        if (!isset($Data['name']) || !isset($Data['description'])) {
            return ResponseHelper::error(400, 'Faltan datos obligatorios');
        }

        $result = $this->model->insertClass($Data);
        return $result ? ResponseHelper::success(200, 'Clase insertada correctamente') : ResponseHelper::error(500, 'Error al insertar la clase');
    }

    /* Obtenemos clases */
    public function get_Classes()
    {
        $result = $this->model->getAllClasses();
        if (empty($result)) {
            return ResponseHelper::success(200, 'Aun no hay clases registradas');
        }
        return $result ? ResponseHelper::success(200, $result) : ResponseHelper::error(500, 'Error al obtener las clases');
    }

    /* Actualizamos clases */
    public function update_Class()
    {
        $Data = json_decode(file_get_contents("php://input"), true);

        if (!isset($Data['id']) || !isset($Data['name']) || !isset($Data['description'])) {
            return ResponseHelper::error(400, 'Faltan datos obligatorios');
        }

        $result = $this->model->updateClass($Data);
        return $result ? ResponseHelper::success(200, 'Clase actualizada correctamente') : ResponseHelper::error(500, 'Error al actualizar la clase');
    }
    
    /* Eliminamos clases */
    public function delete_Class()
    {
        $Data = json_decode(file_get_contents("php://input"), true);

        if (!isset($Data['id'])) {
            return ResponseHelper::error(400, 'Faltan datos obligatorios');
        }

        $result = $this->model->deleteClass($Data);
        return $result ? ResponseHelper::success(200, 'Clase eliminada correctamente') : ResponseHelper::error(500, 'Error al eliminar la clase');
    }

    //? ===========================================================================================================================================

    /* Listamos las clases asignadas */
    public function getClassesAssigned()
    {
        $result = $this->model->getClassesAssigned();
        return $result ? ResponseHelper::success(200, $result) : ResponseHelper::error(500, 'Error al obtener las clases asignadas');
    }

    public function insert_Attendance()
    {
        $Data = json_decode(file_get_contents("php://input"), true);

        if (!isset($Data['id_assignment']) || !isset($Data['id_student']) || !isset($Data['date']) || !isset($Data['state'])) {
            return ResponseHelper::error(400, 'Faltan datos obligatorios');
        }

        $result = $this->model->insertAttendance($Data);
        return $result ? ResponseHelper::success(200, 'Asistencia insertada correctamente') : ResponseHelper::error(500, 'Error al insertar la asistencia');
    }

    public function show_Attendance()
    {
        $Data = json_decode(file_get_contents("php://input"), true);

        if (!isset($Data['id_assignment']) || !isset($Data['date'])) {
            return ResponseHelper::error(400, 'Faltan datos obligatorios');
        }

        /* Cambiamos el orden de la fecha a año dia mes */
        $Data['date'] = date('Y-d-m', strtotime($Data['date']));

        $result = $this->model->ShowAttendance($Data);
        return $result ? ResponseHelper::success(200, $result) : ResponseHelper::error(500, 'Error al obtener la asistencia');
    }

    public function update_Attendance()
    {
        $Data = json_decode(file_get_contents("php://input"), true);

        if (!isset($Data['id_attendance']) || !isset($Data['state'])) {
            return ResponseHelper::error(400, 'Faltan datos obligatorios');
        }

        $result = $this->model->updateAttendance($Data);
        return $result ? ResponseHelper::success(200, 'Asistencia actualizada correctamente') : ResponseHelper::error(500, 'Error al actualizar la asistencia');
    }
}
