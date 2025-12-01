<?php

namespace App\Models;

use App\Core\Database;

class StudentsModel
{
    private $MySQl;

    public function __construct()
    {
        $this->MySQl = Database::getInstance();
    }

    public function Student(string $action, array $Data = [])
    {
        $SQL = "CALL SP_ALUMNO_GENERAL(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        $Params = [
            $action,

            // ALUMNO
            $Data['id_alumno']        ?? null,
            $Data['nombre_completo']  ?? null,
            $Data['codigo_carnet']    ?? null,
            $Data['correo_electronico'] ?? null,
            $Data['telefono']         ?? null,
            $Data['estado']           ?? 'Activo',

            // INSCRIPCIÓN
            $Data['id_grupo']         ?? null,
            $Data['anio_escolar']     ?? date("Y"),

            // ASIGNACIÓN
            $Data['id_clase']         ?? null,
            $Data['id_profesor']      ?? null,
            $Data['id_modalidad']     ?? null,
            $Data['horario']          ?? null,
        ];

        $Result = $this->MySQl->query($SQL, $Params);

        // ============================
        // ACCIONES QUE DEVUELVEN FILAS
        // ============================
        if (in_array($action, ['obtener', 'listar'])) {

            if (!$Result) {
                return false;
            }

            $data = $Result->fetch_all(MYSQLI_ASSOC);

            return ($action === 'obtener')
                ? ($data[0] ?? null)
                : $data;
        }

        // ============================
        // ACCIONES QUE SOLO EJECUTAN
        // ============================
        return $Result ? true : false;
    }

    public function getStudentsByAssignment(int $studentId)
    {
        $SQL = "CALL SP_OBTENER_ALUMNOS_POR_ASIGNACION(?)";
        $Result = $this->MySQl->query($SQL, [$studentId]);

        if (!$Result) {
            return false;
        }

        return $Result->fetch_all(MYSQLI_ASSOC);
    }
}
