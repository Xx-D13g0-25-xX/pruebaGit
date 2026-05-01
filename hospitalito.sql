-- ================================================================
--  HOSPITALITO GLP – Script de Base de Datos
--  Ejecuta este archivo en phpMyAdmin o MySQL Workbench
-- ================================================================

CREATE DATABASE IF NOT EXISTS hospitalito
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_spanish_ci;

USE hospitalito;

-- ── Tabla de pacientes ──────────────────────────────────────────
CREATE TABLE IF NOT EXISTS pacientes (
  id              INT UNSIGNED     AUTO_INCREMENT PRIMARY KEY,
  nombre          VARCHAR(80)      NOT NULL,
  apellido_paterno VARCHAR(80)     NOT NULL,
  apellido_materno VARCHAR(80)     DEFAULT '',
  telefono        CHAR(10)         NOT NULL,
  email           VARCHAR(150)     NOT NULL UNIQUE,
  password_hash   VARCHAR(255)     NOT NULL,
  created_at      TIMESTAMP        DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- ── Tabla de doctores ───────────────────────────────────────────
CREATE TABLE IF NOT EXISTS doctores (
  id              INT UNSIGNED     AUTO_INCREMENT PRIMARY KEY,
  nombre          VARCHAR(80)      NOT NULL,
  apellido_paterno VARCHAR(80)     NOT NULL,
  apellido_materno VARCHAR(80)     DEFAULT '',
  especialidad    VARCHAR(120)     DEFAULT '',
  email           VARCHAR(150)     NOT NULL UNIQUE,
  password_hash   VARCHAR(255)     NOT NULL,
  created_at      TIMESTAMP        DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- ── Tabla de citas ──────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS citas (
  id              INT UNSIGNED     AUTO_INCREMENT PRIMARY KEY,
  paciente_id     INT UNSIGNED     NOT NULL,
  doctor_id       INT UNSIGNED     NOT NULL,
  fecha           DATE             NOT NULL,
  hora            TIME             NOT NULL,
  motivo          VARCHAR(255)     DEFAULT '',
  estatus         ENUM('pendiente','confirmada','cancelada') DEFAULT 'pendiente',
  created_at      TIMESTAMP        DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (paciente_id) REFERENCES pacientes(id) ON DELETE CASCADE,
  FOREIGN KEY (doctor_id)   REFERENCES doctores(id)  ON DELETE CASCADE
) ENGINE=InnoDB;

-- ── Doctor de ejemplo (contraseña: doctor123) ───────────────────
INSERT INTO doctores (nombre, apellido_paterno, apellido_materno, especialidad, email, password_hash)
VALUES ('Carlos','Rodríguez','López','Medicina General','doctor@hospitalito.com',
        '$2y$12$xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx')
ON DUPLICATE KEY UPDATE id = id;
-- Nota: genera el hash real con: password_hash('doctor123', PASSWORD_BCRYPT)
