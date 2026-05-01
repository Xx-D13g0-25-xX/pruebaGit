<?php
/* ================================================================
   HOSPITALITO GLP – registro.php
   Recibe datos del formulario y guarda el nuevo paciente en MySQL
   ================================================================ */

session_start();
require_once 'db.php';

header('Content-Type: application/json');

// ── Solo POST ────────────────────────────────────────────────────
if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    http_response_code(405);
    echo json_encode(['ok' => false, 'msg' => 'Método no permitido.']);
    exit;
}

// ── Leer y sanitizar campos ──────────────────────────────────────
$nombre   = trim($_POST['nombre']           ?? '');
$ap_pat   = trim($_POST['apellido_paterno'] ?? '');
$ap_mat   = trim($_POST['apellido_materno'] ?? '');
$telefono = trim($_POST['telefono']         ?? '');
$email    = trim(strtolower($_POST['email'] ?? ''));
$password = $_POST['password'] ?? '';

// ── Validaciones básicas ─────────────────────────────────────────
$errors = [];

if (empty($nombre))                          $errors[] = 'El nombre es obligatorio.';
if (empty($ap_pat))                          $errors[] = 'El apellido paterno es obligatorio.';
if (!preg_match('/^\d{10}$/', $telefono))    $errors[] = 'El teléfono debe tener exactamente 10 dígitos.';
if (!filter_var($email, FILTER_VALIDATE_EMAIL)) $errors[] = 'El correo no es válido.';
if (strlen($password) < 6)                  $errors[] = 'La contraseña debe tener al menos 6 caracteres.';

if (!empty($errors)) {
    echo json_encode(['ok' => false, 'msg' => implode(' ', $errors)]);
    exit;
}

// ── Verificar email duplicado ────────────────────────────────────
$db   = getDB();
$stmt = $db->prepare('SELECT id FROM pacientes WHERE email = ? LIMIT 1');
$stmt->bind_param('s', $email);
$stmt->execute();
$stmt->store_result();

if ($stmt->num_rows > 0) {
    $stmt->close();
    $db->close();
    echo json_encode(['ok' => false, 'msg' => 'Ese correo ya está registrado.']);
    exit;
}
$stmt->close();

// ── Hash de contraseña ───────────────────────────────────────────
$hash = password_hash($password, PASSWORD_BCRYPT);

// ── Insertar ─────────────────────────────────────────────────────
$stmt = $db->prepare(
    'INSERT INTO pacientes (nombre, apellido_paterno, apellido_materno, telefono, email, password_hash)
     VALUES (?, ?, ?, ?, ?, ?)'
);
$stmt->bind_param('ssssss', $nombre, $ap_pat, $ap_mat, $telefono, $email, $hash);

if ($stmt->execute()) {
    $stmt->close();
    $db->close();
    echo json_encode(['ok' => true, 'msg' => '¡Cuenta creada con éxito! Ahora puedes iniciar sesión.']);
} else {
    $stmt->close();
    $db->close();
    echo json_encode(['ok' => false, 'msg' => 'Error al guardar los datos. Intenta de nuevo.']);
}
