<?php
namespace App\Controllers;

use App\Models\BackupModel;
use Exception;

class BackupController
{
    public function create()
    {
        try {
            $backupModel = new BackupModel();
            $backupFile = $backupModel->createBackup();
            
            echo json_encode([
                'status' => 'success',
                'message' => 'Respaldo creado exitosamente.',
                'file' => $backupFile
            ]);
        } catch (Exception $e) {
            http_response_code(500);
            echo json_encode([
                'status' => 'error',
                'message' => $e->getMessage()
            ]);
        }
    }

    public function restore()
    {
        try {
            $backupModel = new BackupModel();
            $restoredFile = $backupModel->restoreBackup();
            
            echo json_encode([
                'status' => 'success',
                'message' => 'Base de datos restaurada exitosamente desde el archivo.',
                'file' => $restoredFile
            ]);
        } catch (Exception $e) {
            http_response_code(500);
            echo json_encode([
                'status' => 'error',
                'message' => $e->getMessage()
            ]);
        }
    }

    public function restoreFromUpload()
    {
        try {
            $backupModel = new BackupModel();
            $restoredFile = $backupModel->restoreFromFileUpload();
            
            echo json_encode([
                'status' => 'success',
                'message' => 'Base de datos restaurada exitosamente desde el archivo subido.',
                'file' => $restoredFile
            ]);
        } catch (Exception $e) {
            http_response_code(500);
            echo json_encode([
                'status' => 'error',
                'message' => $e->getMessage()
            ]);
        }
    }
}
