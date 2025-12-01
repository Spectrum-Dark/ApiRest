<?php

namespace App\Models;

use App\Core\Database;

class AttendanceModel
{
    private $MySQl;

    public function __construct()
    {
        $this->MySQl = Database::getInstance();
    }

    /* Insertamos modalidades */

    public function insertMode(array $Data)
    {
        $SQL = "CALL SP_Insertar_Modalidad(?, ?)";
        $Params = [$Data['name'], $Data['description']];
        $Result = $this->MySQl->query($SQL, $Params);
        return $Result;
    }

    /* Obtener Modalidades */
    public function getAllModes()
    {
        $SQL = "CALL SP_Obtener_Modalidades()";
        $Result = $this->MySQl->query($SQL)->fetch_all(MYSQLI_ASSOC);
        return $Result;
    }

    /* Editar Modalidad */

    public function updateMode(array $Data)
    {
        $SQL = "CALL SP_Actualizar_Modalidad(?, ?, ?)";
        $Params = [$Data['id'], $Data['name'], $Data['description']];
        $Result = $this->MySQl->query($SQL, $Params);
        return $Result;
    }

    /* Eliminar Modalidad */

    public function deleteMode(array $Data)
    {
        $SQL = "CALL SP_Eliminar_Modalidad(?)";
        $Params = [$Data['id']];
        $Result = $this->MySQl->query($SQL, $Params);
        return $Result;
    }

    //? ===========================================================================================================================================

    /* Insertamos grupos */

    public function insertGroup(array $Data)
    {
        $SQL = "CALL SP_Insertar_Grupo(?)";
        $Params = [$Data['name']];
        $Result = $this->MySQl->query($SQL, $Params);
        return $Result;
    }

    /* Obtener Grupos */

    public function getAllGroups()
    {
        $SQL = "CALL SP_Obtener_Grupos()";
        $Result = $this->MySQl->query($SQL)->fetch_all(MYSQLI_ASSOC);
        return $Result;
    }

    /* Editar Grupo */

    public function updateGroup(array $Data)
    {
        $SQL = "CALL SP_Actualizar_Grupo(?, ?)";
        $Params = [$Data['id'], $Data['name']];
        $Result = $this->MySQl->query($SQL, $Params);
        return $Result;
    }

    /* Eliminar Grupo */

    public function deleteGroup(array $Data)
    {
        $SQL = "CALL SP_Eliminar_Grupo(?)";
        $Params = [$Data['id']];
        $Result = $this->MySQl->query($SQL, $Params);
        return $Result;
    }

    //? ===========================================================================================================================================

    /* Insertamos profesores (name,email,phone) */

    public function insertTeacher(array $Data)
    {
        $SQL = "CALL SP_Insertar_Profesor(?, ?, ?)";
        $Params = [$Data['name'], $Data['email'], $Data['phone']];
        $Result = $this->MySQl->query($SQL, $Params);
        return $Result;
    }

    /* Obtener Profesores */

    public function getAllTeachers()
    {
        $SQL = "CALL SP_Obtener_Profesores()";
        $Result = $this->MySQl->query($SQL)->fetch_all(MYSQLI_ASSOC);
        return $Result;
    }

    /* Editar Profesor */

    public function updateTeacher(array $Data)
    {
        $SQL = "CALL SP_Actualizar_Profesor(?, ?, ?, ?)";
        $Params = [$Data['id'], $Data['name'], $Data['email'], $Data['phone']];
        $Result = $this->MySQl->query($SQL, $Params);
        return $Result;
    }

    /* Eliminar Profesor */

    public function deleteTeacher(array $Data)
    {
        $SQL = "CALL SP_Eliminar_Profesor(?)";
        $Params = [$Data['id']];
        $Result = $this->MySQl->query($SQL, $Params);
        return $Result;
    }

    //? ===========================================================================================================================================

    /* Insertamos clase nombre descripcion */
    public function insertClass(array $Data)
    {
        $SQL = "CALL SP_Insertar_Clase(?, ?)";
        $Params = [$Data['name'], $Data['description']];
        $Result = $this->MySQl->query($SQL, $Params);
        return $Result;
    }

    /* Obtener Clases */
    public function getAllClasses()
    {
        $SQL = "CALL SP_Obtener_Clases()";
        $Result = $this->MySQl->query($SQL)->fetch_all(MYSQLI_ASSOC);
        return $Result;
    }

    /* Editar Clase */
    public function updateClass(array $Data)
    {
        $SQL = "CALL SP_Actualizar_Clase(?, ?, ?)";
        $Params = [$Data['id'], $Data['name'], $Data['description']];
        $Result = $this->MySQl->query($SQL, $Params);
        return $Result;
    }

    /* Eliminar Clase */
    public function deleteClass(array $Data)
    {
        $SQL = "CALL SP_Eliminar_Clase(?)";
        $Params = [$Data['id']];
        $Result = $this->MySQl->query($SQL, $Params);
        return $Result;
    }
    
    //? ===========================================================================================================================================

    /* Listamos las clases asignadas */

    public function getClassesAssigned()
    {
        $SQL = "CALL SP_OBTENER_CLASES_ASIGNADAS()";
        $Result = $this->MySQl->query($SQL);

        if (!$Result) {
            return false;
        }

        return $Result->fetch_all(MYSQLI_ASSOC);
    }

    //? ===========================================================================================================================================

    /* Insertamos asistencia */
    public function insertAttendance(array $Data)
    {
        $SQL = "CALL SP_REGISTRAR_ASISTENCIA(?, ?, ?, ?)";
        $Params = [$Data['id_assignment'], $Data['id_student'], $Data['date'], $Data['state']];
        $Result = $this->MySQl->query($SQL, $Params);
        return $Result;
    }

    public function ShowAttendance(array $Data)
    {
        $SQL = "CALL SP_OBTENER_ASISTENCIAS(?, ?)";
        $Params = [$Data['id_assignment'], $Data['date']];
        $Result = $this->MySQl->query($SQL, $Params);
        return $Result->fetch_all(MYSQLI_ASSOC);
    }

    public function updateAttendance(array $Data)
    {
        $SQL = "CALL SP_ACTUALIZAR_ESTADO_ASISTENCIA(?, ?)";
        $Params = [$Data['id_attendance'], $Data['state']];
        $Result = $this->MySQl->query($SQL, $Params);
        return $Result;
    }
}
