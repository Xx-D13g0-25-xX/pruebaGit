<?php
/* ================================================================
   HOSPITALITO GLP – logout.php
   Destruye la sesión y redirige al login
   ================================================================ */

session_start();
session_destroy();
header('Location: /hospitalito/index.html');
exit;
