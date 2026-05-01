<?php
/* ================================================================
   HOSPITALITO GLP – Configuración de Base de Datos
   ================================================================
   Modifica las constantes según tu entorno (XAMPP/WAMP/servidor)
   ================================================================ */

define('DB_HOST',   'localhost');
define('DB_USER',   'root');        // Tu usuario MySQL
define('DB_PASS',   '');            // Tu contraseña MySQL
define('DB_NAME',   'hospitalito'); // Nombre de la base de datos
define('DB_CHARSET','utf8mb4');

/**
 * Retorna una conexión mysqli o lanza un error.
 */
function getDB(): mysqli {
    $conn = new mysqli(DB_HOST, DB_USER, DB_PASS, DB_NAME);
    if ($conn->connect_error) {
        http_response_code(500);
        die(json_encode(['ok' => false, 'msg' => 'Error de conexión a la base de datos.']));
    }
    $conn->set_charset(DB_CHARSET);
    return $conn;
}
