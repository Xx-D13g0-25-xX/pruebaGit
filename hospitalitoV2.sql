-- Script de base de datos V2

drop database if exists hospitalito;
CREATE DATABASE IF NOT EXISTS hospitalito CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE hospitalito;


-- Creacion de tablas
CREATE TABLE `pacientes` (
id 					int unsigned not null,
nombre 				varchar(80) not null,
apellido_paterno 	varchar(80) not null,
apellido_materno 	varchar(80) default '',
telefono 			int(10) unsigned unique not null,
email 				varchar(150) not null,
cp					varchar(5) default '',
direccion			varchar(300) default '',
password_hash 		varchar(255) not null,
created_at 			timestamp not null default current_timestamp
) ;




CREATE TABLE `doctor` (
id 					int unsigned not null,
rfc 				varchar(13) not null unique,
nombre 				varchar(80) not null,
apellido_paterno 	varchar(80) not null,
apellido_materno 	varchar(80),
especialidad 		varchar(120) default '',
tipo				enum('especialista','general') default 'general',
email 				varchar(150) not null,
pasword_hash 		varchar(255) not null,
created_at 			timestamp not null default current_timestamp
);


CREATE TABLE `citas` (
id 					int unsigned not null,
id_paciente 		int unsigned not null,
id_doctor 			int unsigned not null,
fecha 				date not null,
hora 				time not null,
motivo 				varchar(200) not null default '',
estatus         	enum('pendiente','confirmada','cancelada') DEFAULT 'pendiente',
created_at 			timestamp not null default current_timestamp

) ;


CREATE TABLE `historial_med`(
id					int unsigned not null,
id_paciente 		int unsigned not null,
edad				int(3) unsigned not null,
fecha_nacimiento	date not null,
tipo_Sangre			enum("A+","A-","B+","B-","AB+","AB-","O+","O-") not null,
ultima_consulta 	timestamp
);

create table `patologias_diag`(
id int unsigned not null,
id_patologia int unsigned not null,
id_historial int unsigned not null
);

create table `cirugias_real` (
id int unsigned not null,
id_cirugia int unsigned not null,
id_historial int unsigned not null
);

create table `patologias` (
id int unsigned not null,
nombre varchar(100) not null
);

DROP TABLE IF EXISTS `personal_admin`;
CREATE TABLE personal_admin(
id 					int unsigned primary key auto_increment,
rfc 				varchar(13) unique not null,
nombre 				varchar(80) not null,
apellido_paterno 	varchar(80) not null,
apellido_materno 	varchar(80),
rol 				enum('farmacia','recepcion','inventario') default 'recepcion',
email 				varchar(150) not null unique,
pasword_hash 		varchar(255) not null,
created_at 			timestamp not null default current_timestamp
);

DROP TABLE IF EXISTS `administrador`;
CREATE TABLE IF NOT EXISTS administrador(
id 					int unsigned not null,
rfc 				varchar(13) unique not null,
nombre 				varchar(80) not null,
apellido_paterno 	varchar(80) not null,
apellido_materno 	varchar(80),
rol 				enum('dir.Medico','dir.Admin','gerente') default 'dir.Admin',
email 				varchar(150) not null unique,
password_hash 		varchar(255) not null,
created_at 			timestamp not null default current_timestamp

);


-- Creacion de llaves
alter table pacientes add primary key (id), add unique key (email);

alter table doctor add primary key (id), add unique key (email);

alter table citas add primary key (id), add foreign key (id_paciente)
references pacientes (id), add foreign key (id_doctor) references doctor(id);

alter table historial_med add primary key (id), add foreign key (id_paciente)
references pacientes (id);

alter table patologias add primary key (id);

alter table administrador add primary key (id);

alter table patologias_diag add primary key (id), add foreign key (id_historial)
references  historial_med(id), add foreign key (id_patologia) references patologias(id);