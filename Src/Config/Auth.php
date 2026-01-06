<?php

namespace App\Config;

class Auth
{
    private static $secret = "Bryan_MQ";

    public static function generateToken($data)
    {
        // 1. Header (Algoritmo y Tipo)
        $header = json_encode(['typ' => 'JWT', 'alg' => 'HS256']);
        $base64UrlHeader = self::base64UrlEncode($header);

        // 2. Payload (Datos del usuario + Expiración)
        $data['iat'] = time();          // Fecha de creación
        $data['exp'] = time() + 3600;   // Expira en 1 hora
        $payload = json_encode($data);
        $base64UrlPayload = self::base64UrlEncode($payload);

        // 3. Signature (Firma secreta)
        $signature = hash_hmac('sha256', $base64UrlHeader . "." . $base64UrlPayload, self::$secret, true);
        $base64UrlSignature = self::base64UrlEncode($signature);

        // Unir las 3 partes
        return $base64UrlHeader . "." . $base64UrlPayload . "." . $base64UrlSignature;
    }

    // Función auxiliar para Base64 compatible con URLs
    private static function base64UrlEncode($text)
    {
        return str_replace(['+', '/', '='], ['-', '_', ''], base64_encode($text));
    }
}
