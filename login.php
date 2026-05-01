<?php
/* ================================================================
   HOSPITALITO GLP – login.php
   Autentica paciente o doctor y guarda la sesión
   ================================================================ */

session_start();
require_once 'db.php';

header('Content-Type: application/json');

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    http_response_code(405);
    echo json_encode(['ok' => false, 'msg' => 'Método no permitido.']);
    exit;
}

$rol      = trim($_POST['rol']      ?? 'usuario');   // 'usuario' | 'doctor'
$email    = trim(strtolower($_POST['email']    ?? ''));
$password = $_POST['password'] ?? '';

if (!filter_var($email, FILTER_VALIDATE_EMAIL) || empty($password)) {
    echo json_encode(['ok' => false, 'msg' => 'Correo o contraseña inválidos.']);
    exit;
}

$db = getDB();

if ($rol === 'doctor') {
    // ── Buscar doctor ────────────────────────────────────────────
    $stmt = $db->prepare(
        'SELECT id, nombre, apellido_paterno, password_hash FROM doctores WHERE email = ? LIMIT 1'
    );
    $stmt->bind_param('s', $email);
    $stmt->execute();
    $stmt->bind_result($id, $nombre, $ap_pat, $hash);
    $found = $stmt->fetch();
    $stmt->close();

    if (!$found || !password_verify($password, $hash)) {
        $db->close();
        echo json_encode(['ok' => false, 'msg' => 'Credenciales incorrectas.']);
        exit;
    }

    $_SESSION['user_id']   = $id;
    $_SESSION['user_name'] = $nombre;
    $_SESSION['user_ap']   = $ap_pat;
    $_SESSION['user_rol']  = 'doctor';
    $db->close();
    echo json_encode(['ok' => true, 'redirect' => '/hospitalito/doctor.html']);

} else {
    // ── Buscar paciente ──────────────────────────────────────────
    $stmt = $db->prepare(
        'SELECT id, nombre, apellido_paterno, password_hash FROM pacientes WHERE email = ? LIMIT 1'
    );
    $stmt->bind_param('s', $email);
    $stmt->execute();
    $stmt->bind_result($id, $nombre, $ap_pat, $hash);
    $found = $stmt->fetch();
    $stmt->close();

    if (!$found || !password_verify($password, $hash)) {
        $db->close();
        echo json_encode(['ok' => false, 'msg' => 'Credenciales incorrectas.']);
        exit;
    }

    $_SESSION['user_id']   = $id;
    $_SESSION['user_name'] = $nombre;
    $_SESSION['user_ap']   = $ap_pat;
    $_SESSION['user_rol']  = 'paciente';
    $db->close();
    echo json_encode(['ok' => true, 'redirect' => '/hospitalito/paciente.html']);
}
