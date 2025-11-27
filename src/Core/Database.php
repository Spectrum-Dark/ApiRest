<?php

namespace App\Core;

use mysqli;
use Exception;
use mysqli_result;

use App\Config\Properties as Props;

class Database
{
    private string $host = Props::DB_HOST;
    private string $username = Props::DB_USERNAME;
    private string $password = Props::DB_PASSWORD;
    private string $database = Props::DB_NAME;
    private ?mysqli $connection = null;

    private static ?Database $instance = null;

    private function __construct(string $database = '')
    {
        if (!empty($database)) {
            $this->database = $database;
        }
        $this->openConnection();
    }

    public static function getInstance(string $database = ''): Database
    {
        if (self::$instance === null) {
            self::$instance = new Database($database);
        }
        return self::$instance;
    }

    private function openConnection(): void
    {
        $this->connection = new mysqli($this->host, $this->username, $this->password, $this->database);

        if ($this->connection->connect_error) {
            throw new Exception('Error de conexión: ' . $this->connection->connect_error);
        }

        $this->connection->set_charset('utf8mb4');
    }

    public function closeConnection(): void
    {
        if ($this->connection) {
            $this->connection->close();
            $this->connection = null;
            self::$instance = null;
        }
    }

    public function query(string $sql, array $params = []): mysqli_result|bool
    {
        // 🔥 Limpiar resultados pendientes de otros CALL
        while ($this->connection->more_results() && $this->connection->next_result()) {
            $extra = $this->connection->use_result();
            if ($extra instanceof \mysqli_result) {
                $extra->free();
            }
        }

        if (empty($params)) {
            $result = $this->connection->query($sql);
            if (!$result) {
                throw new Exception('Error en la consulta: ' . $this->connection->error);
            }
            return $result;
        }

        $stmt = $this->connection->prepare($sql);
        if (!$stmt) {
            throw new Exception('Error al preparar la consulta: ' . $this->connection->error);
        }

        $types = '';
        foreach ($params as $param) {
            $types .= match (gettype($param)) {
                'integer' => 'i',
                'double' => 'd',
                default => 's'
            };
        }

        $stmt->bind_param($types, ...$params);
        $stmt->execute();

        $result = $stmt->get_result();
        return $result ?: true;
    }


    public function escape(string $value): string
    {
        return $this->connection->real_escape_string($value);
    }

    public function __destruct()
    {
        $this->closeConnection();
    }
}
