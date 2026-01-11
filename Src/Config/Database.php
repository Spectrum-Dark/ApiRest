<?php
namespace App\Config;

use mysqli;
use Exception;

class Database
{
    private string $host = 'localhost';
    private string $username = 'root';
    private string $password = '';
    private string $database = 'inventrack';
    private ?mysqli $connection = null;

    // 1. Propiedad estática para guardar la instancia única
    private static ?Database $instance = null;

    // 2. Constructor privado: evita que se use "new Database()" desde fuera
    private function __construct()
    {
        $this->openConnection();
    }

    // 3. Método estático para obtener la conexión
    public static function getInstance(): Database
    {
        if (self::$instance === null) {
            self::$instance = new self();
        }
        return self::$instance;
    }

    public static function getDbConfig(): array
    {
        return [
            'host' => 'localhost',
            'username' => 'root',
            'password' => '',
            'database' => 'inventrack'
        ];
    }

    private function openConnection(): void
    {
        $this->connection = new mysqli($this->host, $this->username, $this->password, $this->database);

        if ($this->connection->connect_error) {
            throw new Exception('Error de conexión: ' . $this->connection->connect_error);
        }

        $this->connection->set_charset('utf8mb4');
    }

    // Proporcionar acceso directo al objeto mysqli si lo necesitas
    public function getConnection(): mysqli
    {
        return $this->connection;
    }

    // Getters para acceder a la configuración de forma segura
    public function getHost(): string { return $this->host; }
    public function getUsername(): string { return $this->username; }
    public function getPassword(): string { return $this->password; }
    public function getDatabase(): string { return $this->database; }

    public function query(string $sql, array $params = []): \mysqli_result|bool
    {
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
        return $stmt->get_result() ?: true;
    }

    // Evitar que se clone la instancia
    private function __clone() { }
}