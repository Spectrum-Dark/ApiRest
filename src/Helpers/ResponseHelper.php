<?php

namespace App\Helpers;

class ResponseHelper
{
    /* Devolver respuesta con éxito */
    public static function success(string $message = '', $data = null, int $status = 200): void
    {
        http_response_code($status);
        echo json_encode([
            'success' => true,
            'message' => $message,
            'data'    => $data
        ], JSON_PRETTY_PRINT | JSON_UNESCAPED_UNICODE);
        exit;
    }

    /* Devolver respuesta con error */
    public static function error(string $message = '', $data = null, int $status = 400): void
    {
        http_response_code($status);
        echo json_encode([
            'success' => false,
            'message' => $message,
            'error'   => $data,
        ], JSON_PRETTY_PRINT | JSON_UNESCAPED_UNICODE);
        exit;
    }

    /* Devolver respuesta JSON personalizada */
    public static function json(array $body, int $status = 200): void
    {
        http_response_code($status);
        echo json_encode($body, JSON_PRETTY_PRINT | JSON_UNESCAPED_UNICODE);
        exit;
    }
}
