<?php
namespace App\Models;

use App\Config\Database;
use Exception;

class BackupModel
{
    public function createBackup(): string
    {
        // Para crear, la BD debe existir, así que obtenemos la instancia de forma normal.
        $db = Database::getInstance();

        $backupDir = __DIR__ . '/../../backups';

        if (is_dir($backupDir)) {
            $existing_files = glob($backupDir . '/*.sql');
            foreach ($existing_files as $file) {
                if (is_file($file)) {
                    unlink($file);
                }
            }
        } else {
            if (!mkdir($backupDir, 0777, true) && !is_dir($backupDir)) {
                throw new Exception(sprintf('Directory "%s" was not created', $backupDir));
            }
        }

        $password = $db->getPassword();
        $passwordCmd = !empty($password) ? sprintf('-p"%s"', $password) : '';
        $backupFile = $backupDir . '/backup_' . date('Y-m-d_H-i-s') . '.sql';

        $command = sprintf(
            'c:\\xampp\\mysql\\bin\\mysqldump.exe -h"%s" -u"%s" %s --databases "%s" > "%s"',
            $db->getHost(),
            $db->getUsername(),
            $passwordCmd,
            $db->getDatabase(),
            $backupFile
        );

        exec($command, $output, $return_var);

        if ($return_var !== 0) {
            throw new Exception('Error al ejecutar el comando. Código: ' . $return_var . '. Comando: ' . $command);
        }

        return $backupFile;
    }

    public function restoreBackup(): string
    {
        $backupDir = __DIR__ . '/../../backups';
        $backupFiles = glob($backupDir . '/*.sql');

        if (empty($backupFiles)) {
            throw new Exception('No se encontró ningún archivo de respaldo (.sql) en el directorio de backups.');
        }
        
        $backupFile = $backupFiles[0];
        $this->executeRestoreCommand($backupFile);
        return $backupFile;
    }

    public function restoreFromFileUpload(): string
    {
        if (!isset($_FILES['backup_file']) || $_FILES['backup_file']['error'] !== UPLOAD_ERR_OK) {
            throw new Exception('Error en la subida del archivo o archivo no proporcionado.');
        }

        $tmpPath = $_FILES['backup_file']['tmp_name'];
        $fileName = $_FILES['backup_file']['name'];

        // Verificación simple de extensión
        if (pathinfo($fileName, PATHINFO_EXTENSION) !== 'sql') {
            unlink($tmpPath); // Borrar archivo subido no válido
            throw new Exception('El archivo proporcionado no es un archivo .sql.');
        }

        try {
            $this->executeRestoreCommand($tmpPath);
        } finally {
            // Asegurarse de que el archivo temporal siempre se borre
            if (file_exists($tmpPath)) {
                unlink($tmpPath);
            }
        }
        
        return $fileName;
    }

    private function executeRestoreCommand(string $filePath): void
    {
        // Para restaurar, la BD podría no existir. Usamos la config estática.
        $config = Database::getDbConfig();

        $password = $config['password'];
        $passwordCmd = !empty($password) ? sprintf('-p"%s"', $password) : '';

        $command = sprintf(
            'c:\\xampp\\mysql\\bin\\mysql.exe -h"%s" -u"%s" %s < "%s"',
            $config['host'],
            $config['username'],
            $passwordCmd,
            $filePath
        );

        exec($command, $output, $return_var);

        if ($return_var !== 0) {
            throw new Exception('Error al ejecutar el comando. Código: ' . $return_var . '. Comando: ' . $command);
        }
    }
}
