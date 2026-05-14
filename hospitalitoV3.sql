-- Script de base de datos V3

DROP DATABASE IF EXISTS hospitalito;

CREATE DATABASE hospitalito CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE hospitalito;

CREATE TABLE pacientes (
	id int unsigned NOT NULL,
	nombre varchar(80) NOT NULL,
	apellido_paterno varchar(80) NOT NULL,
	apellido_materno varchar(80) DEFAULT '',
    genero enum('H','M','NB') NOT NULL,
	telefono char(10) NOT NULL,
	email varchar(150) NOT NULL,
	password_hash varchar(255) NOT NULL,
	direccion varchar(255) DEFAULT '',
	cp varchar(10) DEFAULT '',
	created_at	 timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE = InnoDB;

CREATE TABLE doctores (
  id int(10) UNSIGNED NOT NULL,
  nombre varchar(80) NOT NULL,
  apellido_paterno varchar(80) NOT NULL,
  apellido_materno varchar(80) DEFAULT '',
  genero enum ('H','M','NB') NOT NULL,
  especialidad_id int UNSIGNED DEFAULT 1,
  consultorio varchar(60) DEFAULT '',
  email varchar(150) NOT NULL,
  password_hash varchar(255) NOT NULL,
  created_at timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB;

CREATE TABLE citas (
  id int(10) UNSIGNED NOT NULL,
  paciente_id int(10) UNSIGNED NOT NULL,
  doctor_id int(10) UNSIGNED NOT NULL,
  fecha date NOT NULL,
  hora time NOT NULL,
  motivo varchar(255) DEFAULT '',
  estatus enum('pendiente','confirmada','cancelada') DEFAULT 'pendiente',
  created_at timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB;

CREATE TABLE administrativos (
  id int(10) UNSIGNED NOT NULL,
  nombre varchar(80) NOT NULL,
  apellido_paterno varchar(80) NOT NULL,
  apellido_materno varchar(80) DEFAULT '',
  email varchar(150) NOT NULL,
  password_hash varchar(255) NOT NULL,
  rol int UNSIGNED DEFAULT 1,
  created_at timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB;

CREATE TABLE agenda_doc (
	id int UNSIGNED NOT NULL,
    doctor_id int(10) UNSIGNED NOT NULL,
    dia date NOT NULL,
    horario enum('7:00-8:00','8:00-9:00','9:00-10:00','10:00-11:00','11:00-12:00',
    '12:00-13:00','13:00-14:00','14:00-15:00','15:00-16:00','16:00-17:00','17:00-18:00'),
    estado enum('libre','apartado','no_disponible')
) ENGINE=InnoDB;

CREATE TABLE historial_med (
id					int unsigned NOT NULL,
paciente_id 		int unsigned NOT NULL,
edad				int(3) unsigned NOT NULL,
peso_kg				int unsigned NOT NULL,
altura_cm			int	unsigned NOT NULL,	
sexo				enum('H','M') NOT NULL,
fecha_nacimiento	date NOT NULL,
tipo_Sangre			enum("A+","A-","B+","B-","AB+","AB-","O+","O-") NOT NULL,
ultima_consulta 	datetime DEFAULT NULL
) ENGINE = InnoDB;

CREATE TABLE padece (
id int UNSIGNED NOT NULL,
historial_id int UNSIGNED NOT NULL,
enfermedad_id int UNSIGNED NOT NULL
) ENGINE = InnoDB;

CREATE TABLE enfermedad (
id int UNSIGNED NOT NULL,
nombre varchar(150) NOT NULL
) ENGINE = InnoDB;

CREATE TABLE especialidad (
	id int UNSIGNED NOT NULL,
    especialidad varchar(120) NOT NULL
)ENGINE = InnoDB;

CREATE TABLE rol (
	id int UNSIGNED NOT NULL,
    rol varchar(120) NOT NULL
);
-- ALTERACION DE TABLAS

-- llaves primarias y unicas

ALTER TABLE administrativos 
	ADD PRIMARY KEY (id),
    ADD UNIQUE KEY email (email);
    
ALTER TABLE pacientes
	ADD PRIMARY KEY (id),
    ADD UNIQUE KEY email (email);
    
ALTER TABLE doctores
	ADD PRIMARY KEY (id),
    ADD UNIQUE KEY email (email);
    
ALTER TABLE citas
	ADD PRIMARY KEY (id);

ALTER TABLE agenda_doc
	ADD PRIMARY KEY (id);
    
ALTER TABLE historial_med
	ADD PRIMARY KEY (id);

ALTER TABLE enfermedad
	ADD PRIMARY KEY (id);
    
ALTER TABLE padece
	ADD PRIMARY KEY (id);

ALTER TABLE especialidad
	ADD PRIMARY KEY (id),
    ADD UNIQUE KEY especialidad(especialidad);

ALTER TABLE rol
	ADD PRIMARY KEY (id),
    ADD UNIQUE KEY rol (rol);
    
    
-- Auto increment

ALTER TABLE pacientes
	MODIFY id int UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT = 6; 
    
ALTER TABLE doctores
	MODIFY id int UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT = 2; 
    
ALTER TABLE administrativos
	MODIFY id int UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT = 3;

ALTER TABLE citas 
	MODIFY id int UNSIGNED NOT NULL AUTO_INCREMENT;
    
ALTER TABLE historial_med 
	MODIFY id int UNSIGNED NOT NULL AUTO_INCREMENT;
    
ALTER TABLE padece 
	MODIFY id int UNSIGNED NOT NULL AUTO_INCREMENT;

ALTER TABLE enfermedad 
	MODIFY id int UNSIGNED NOT NULL AUTO_INCREMENT;
    
ALTER TABLE especialidad
	MODIFY id int UNSIGNED NOT NULL AUTO_INCREMENT;
    
ALTER TABLE rol
	MODIFY id int UNSIGNED NOT NULL AUTO_INCREMENT;
    
    
-- llaves foraneas    

ALTER TABLE doctores
	ADD FOREIGN KEY especialidad_id (especialidad_id) REFERENCES especialidad (id) ON DELETE SET NULL;

ALTER TABLE administrativos
	ADD FOREIGN KEY rol (rol) REFERENCES rol (id) ON UPDATE CASCADE;
    
ALTER TABLE citas
	ADD FOREIGN KEY paciente_id (paciente_id) REFERENCES pacientes (id) ON DELETE CASCADE,
    ADD FOREIGN KEY doctor_id (doctor_id) REFERENCES doctores (id) ON DELETE CASCADE;
    
ALTER TABLE agenda_doc
	ADD FOREIGN KEY doctor_id (doctor_id) REFERENCES doctores(id) ON DELETE CASCADE;
    
ALTER TABLE historial_med
	ADD FOREIGN KEY paciente_id (paciente_id) REFERENCES pacientes(id) ON DELETE CASCADE;
    
ALTER TABLE padece
	ADD FOREIGN KEY historial_id (historial_id) REFERENCES historial_med(id) ON DELETE CASCADE,
    ADD FOREIGN KEY enfermedad_id (enfermedad_id) REFERENCES enfermedad(id) ON DELETE CASCADE;
    
-- Volcado de información

INSERT INTO especialidad (especialidad) VALUES ('Medicina General'), ('Cardiología'),
('Dermatología'), ('Endocrinología'), ('Gastroenterología'), ('Geriatría'),
('Ginecología y Obstetricia'), ('Hematología'), ('Infectología'), ('Medicina Interna'),
('Nefrología'), ('Neumología'), ('Neurología'), ('Oftalmología'), ('Oncología'),
('Ortopedia y Traumatología'), ('Otorrinolaringología'), ('Pediatría'), ('Psiquiatría'),
('Radiología'),('Reumatología'), ('Urología');

INSERT INTO rol (rol) VALUES('recepcionista'), ('director');

select * from especialidad order by 1;

