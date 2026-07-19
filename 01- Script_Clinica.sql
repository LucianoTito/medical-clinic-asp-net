-- =======================================================
-- SCRIPT CLÍNICA UTN - GRUPO 16 
-- =======================================================

USE master;
GO

IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = N'ClinicaMedica')
BEGIN
    CREATE DATABASE ClinicaMedica;
END
GO

USE ClinicaMedica;
GO

-- =======================================================
-- CREACIÓN DE TABLAS MAESTRAS 
-- =======================================================

CREATE TABLE Especialidades (
    Id_Especialidad INT IDENTITY(1,1) NOT NULL,
    Descripcion_Esp VARCHAR(100) NOT NULL,
    CONSTRAINT PK_Especialidades PRIMARY KEY (Id_Especialidad)
);
GO

CREATE TABLE Provincias (
    Id_Provincia INT IDENTITY(1,1) NOT NULL,
    Descripcion_Prov VARCHAR(100) NOT NULL,
    CONSTRAINT PK_Provincias PRIMARY KEY (Id_Provincia)
);
GO

CREATE TABLE Localidades (
    Id_Localidad INT IDENTITY(1,1) NOT NULL,
    Descripcion_Loc VARCHAR(100) NOT NULL,
    Id_Provincia_Loc INT NOT NULL,
    CONSTRAINT PK_Localidades PRIMARY KEY (Id_Localidad),
    CONSTRAINT FK_Localidades_Provincias FOREIGN KEY (Id_Provincia_Loc) REFERENCES Provincias(Id_Provincia)
);
GO

CREATE TABLE DiasSemana (
    Id_Dia INT NOT NULL,
    Descripcion_Dia VARCHAR(20) NOT NULL,
    CONSTRAINT PK_DiasSemana PRIMARY KEY (Id_Dia)
);
GO

CREATE TABLE HorariosAtencion (
    Id_Horario CHAR(5) NOT NULL,
    HoraInicio INT NOT NULL,
    HoraFin INT NOT NULL,
    CONSTRAINT PK_HorariosAtencion PRIMARY KEY (Id_Horario)
);
GO

-- =======================================================
-- CREACIÓN DE TABLAS OPERATIVAS Y ENTIDADES MAESTRAS
-- =======================================================

CREATE TABLE Pacientes (
    Dni_Pac VARCHAR(20) NOT NULL,
    Nombre_Pac VARCHAR(100) NOT NULL,
    Apellido_Pac VARCHAR(100) NOT NULL,
    Sexo_Pac VARCHAR(20) NOT NULL,
    Nacionalidad_Pac VARCHAR(100) NOT NULL,
    FechaNacimiento_Pac DATE NOT NULL,
    Direccion_Pac VARCHAR(150) NOT NULL,
    Id_Localidad_Pac INT NOT NULL, -- La provincia se deduce a través de la localidad 
    CorreoElectronico_Pac VARCHAR(100) NOT NULL,
    Telefono_Pac VARCHAR(50) NOT NULL,
    Estado_Pac BIT NOT NULL DEFAULT 1,
    CONSTRAINT PK_Pacientes PRIMARY KEY (Dni_Pac),
    CONSTRAINT FK_Pacientes_Localidades FOREIGN KEY (Id_Localidad_Pac) REFERENCES Localidades(Id_Localidad)
);
GO

CREATE TABLE Medicos (
    Legajo_Med CHAR(7) NOT NULL,
    Dni_Med VARCHAR(20) NOT NULL UNIQUE,
    Nombre_Med VARCHAR(100) NOT NULL,
    Apellido_Med VARCHAR(100) NOT NULL,
    Sexo_Med VARCHAR(20) NOT NULL,
    Nacionalidad_Med VARCHAR(100) NOT NULL,
    FechaNacimiento_Med DATE NOT NULL,
    Direccion_Med VARCHAR(150) NOT NULL,
    Id_Localidad_Med INT NOT NULL, -- La provincia se deduce a través de la localidad 
    CorreoElectronico_Med VARCHAR(100) NOT NULL,
    Telefono_Med VARCHAR(50) NOT NULL,
    Id_Especialidad_Med INT NOT NULL,
    Estado_Med BIT NOT NULL DEFAULT 1,
    CONSTRAINT PK_Medicos PRIMARY KEY (Legajo_Med),
    CONSTRAINT FK_Medicos_Localidades FOREIGN KEY (Id_Localidad_Med) REFERENCES Localidades(Id_Localidad),
    CONSTRAINT FK_Medicos_Especialidades FOREIGN KEY (Id_Especialidad_Med) REFERENCES Especialidades(Id_Especialidad)
);
GO


CREATE TABLE Usuarios (
    Id_Usuario INT IDENTITY(1,1) NOT NULL,
    NombreUsuario VARCHAR(50) NOT NULL UNIQUE,
    Contrasena VARCHAR(30) NOT NULL,
    TipoUsuario VARCHAR(20) NOT NULL, -- 'Administrador' o 'Medico'
    Legajo_Med CHAR(7) NULL,          
    Activo BIT NOT NULL DEFAULT 1,
    CONSTRAINT PK_Usuarios PRIMARY KEY (Id_Usuario),
    CONSTRAINT FK_Usuarios_Medicos FOREIGN KEY (Legajo_Med) REFERENCES Medicos(Legajo_Med),
    CONSTRAINT CK_Usuarios_TipoUsuario CHECK (TipoUsuario IN ('Administrador', 'Medico'))
);
GO


CREATE TABLE Administradores (
    Legajo_Adm CHAR(7) NOT NULL,
    Dni_Adm VARCHAR(20) NOT NULL UNIQUE,
    Nombre_Adm VARCHAR(100) NOT NULL,
    Apellido_Adm VARCHAR(100) NOT NULL,
    Sexo_Adm VARCHAR(20) NOT NULL,
    Nacionalidad_Adm VARCHAR(100) NOT NULL,
    FechaNacimiento_Adm DATE NOT NULL,
    Direccion_Adm VARCHAR(150) NOT NULL,
    Id_Localidad_Adm INT NOT NULL, -- La provincia se deduce a través de la localidad 
    CorreoElectronico_Adm VARCHAR(100) NOT NULL,
    Telefono_Adm VARCHAR(50) NOT NULL,
    Estado_Adm BIT NOT NULL DEFAULT 1,
    CONSTRAINT PK_Administradores PRIMARY KEY (Legajo_Adm),
    CONSTRAINT FK_Administradores_Localidades FOREIGN KEY (Id_Localidad_Adm) REFERENCES Localidades(Id_Localidad)
);
GO

-- =======================================================
-- CREACIÓN DE TABLAS DE RELACIÓN (TURNOS Y HORARIOS_MEDICOS)
-- =======================================================

CREATE TABLE Turnos (
    Id_Turno INT IDENTITY(1,1) NOT NULL,
    Leg_Medico CHAR(7) NOT NULL,
    Dni_Paciente VARCHAR(20) NOT NULL,
    Fecha_Tur DATE NOT NULL,
    Hora_Tur TIME NOT NULL,
    Asistencia VARCHAR(15) NOT NULL DEFAULT 'Pendiente', -- 'Pendiente', 'Presente', 'Ausente'
    Observaciones VARCHAR(500) NULL,
    Estado_Tur BIT NOT NULL DEFAULT 1, 
    CONSTRAINT PK_Turnos PRIMARY KEY (Id_Turno),
    CONSTRAINT FK_Turnos_Medicos FOREIGN KEY (Leg_Medico) REFERENCES Medicos(Legajo_Med),
    CONSTRAINT FK_Turnos_Pacientes FOREIGN KEY (Dni_Paciente) REFERENCES Pacientes(Dni_Pac),
    CONSTRAINT UQ_Turno_Unico UNIQUE (Leg_Medico, Fecha_Tur, Hora_Tur)
);
GO

CREATE TABLE Horarios_Medicos (
    Leg_Medico CHAR(7) NOT NULL,
    Id_Dia INT NOT NULL,
    Id_Horario CHAR(5) NOT NULL,
    CONSTRAINT PK_Horarios_Medicos PRIMARY KEY (Leg_Medico, Id_Dia, Id_Horario),
    CONSTRAINT FK_HorariosMed_Medicos FOREIGN KEY (Leg_Medico) REFERENCES Medicos(Legajo_Med),
    CONSTRAINT FK_HorariosMed_Dias FOREIGN KEY (Id_Dia) REFERENCES DiasSemana(Id_Dia),
    CONSTRAINT FK_HorariosMed_Horarios FOREIGN KEY (Id_Horario) REFERENCES HorariosAtencion(Id_Horario)
);
GO


-- =======================================================
-- INSERCIÓN DE DATOS INICIALES MAESTROS
-- =======================================================

SET IDENTITY_INSERT Provincias ON;
INSERT INTO Provincias (Id_Provincia, Descripcion_Prov) VALUES
(1, 'Buenos Aires'), (2, 'Ciudad Autónoma de Buenos Aires'), (3, 'Catamarca'), (4, 'Chaco'), 
(5, 'Chubut'), (6, 'Córdoba'), (7, 'Corrientes'), (8, 'Entre Ríos'), (9, 'Formosa'), 
(10, 'Jujuy'), (11, 'La Pampa'), (12, 'La Rioja'), (13, 'Mendoza'), (14, 'Misiones'), 
(15, 'Neuquén'), (16, 'Río Negro'), (17, 'Salta'), (18, 'San Juan'), (19, 'San Luis'), 
(20, 'Santa Cruz'), (21, 'Santa Fe'), (22, 'Santiago del Estero'), (23, 'Tierra del Fuego'), 
(24, 'Tucumán');
SET IDENTITY_INSERT Provincias OFF;
GO

INSERT INTO Localidades (Id_Provincia_Loc, Descripcion_Loc) VALUES
(1, '25 de Mayo'), (1, '3 de febrero'), (1, 'A. Alsina'), (1, 'A. Gonzáles Cháves'), (1, 'Aguas Verdes'),(1, 'Alberti'), (1, 'Arrecifes'), (1, 'Ayacucho'), (1, 'Azul'), (1, 'Bahía Blanca'), (1, 'Balcarce'),(1, 'Baradero'), (1, 'Benito Juárez'), (1, 'Berisso'), (1, 'Bolívar'), (1, 'Bragado'), (1, 'Brandsen'),(1, 'Campana'), (1, 'Cañuelas'), (1, 'Capilla del Señor'), (1, 'Capitán Sarmiento'), (1, 'Carapachay'),(1, 'Carhue'), (1, 'Cariló'), (1, 'Carlos Casares'), (1, 'Carlos Tejedor'), (1, 'Carmen de Areco'),(1, 'Carmen de Patagones'), (1, 'Castelli'), (1, 'Chacabuco'), (1, 'Chascomús'), (1, 'Chivilcoy'),(1, 'Colón'), (1, 'Coronel Dorrego'), (1, 'Coronel Pringles'), (1, 'Coronel Rosales'), (1, 'Coronel Suarez'),(1, 'Costa Azul'), (1, 'Costa Chica'), (1, 'Costa del Este'), (1, 'Costa Esmeralda'), (1, 'Daireaux'),(1, 'Darregueira'), (1, 'Del Viso'), (1, 'Dolores'), (1, 'Don Torcuato'), (1, 'Ensenada'), (1, 'Escobar'),(1, 'Exaltación de la Cruz'), (1, 'Florentino Ameghino'), (1, 'Garín'), (1, 'Gral. Alvarado'),(1, 'Gral. Alvear'), (1, 'Gral. Arenales'), (1, 'Gral. Belgrano'), (1, 'Gral. Guido'), (1, 'Gral. Lamadrid'),(1, 'Gral. Las Heras'), (1, 'Gral. Lavalle'), (1, 'Gral. Madariaga'), (1, 'Gral. Pacheco'), (1, 'Gral. Paz'),(1, 'Gral. Pinto'), (1, 'Gral. Pueyrredón'), (1, 'Gral. Rodríguez'), (1, 'Gral. Viamonte'), (1, 'Gral. Villegas'),(1, 'Guaminí'), (1, 'Guernica'), (1, 'Hipólito Yrigoyen'), (1, 'Ing. Maschwitz'), (1, 'Junín'), (1, 'La Plata'),(1, 'Laprida'), (1, 'Las Flores'), (1, 'Las Toninas'), (1, 'Leandro N. Alem'), (1, 'Lincoln'), (1, 'Loberia'),(1, 'Lobos'), (1, 'Los Cardales'), (1, 'Los Toldos'), (1, 'Lucila del Mar'), (1, 'Luján'), (1, 'Magdalena'),(1, 'Maipú'), (1, 'Mar Chiquita'), (1, 'Mar de Ajó'), (1, 'Mar de las Pampas'), (1, 'Mar del Plata'),(1, 'Mar del Tuyú'), (1, 'Marcos Paz'), (1, 'Mercedes'), (1, 'Miramar'), (1, 'Monte'), (1, 'Monte Hermoso'),(1, 'Munro'), (1, 'Navarro'), (1, 'Necochea'), (1, 'Olavarría'), (1, 'Partido de la Costa'), (1, 'Pehuajó'),(1, 'Pellegrini'), (1, 'Pergamino'), (1, 'Pigüé'), (1, 'Pila'), (1, 'Pilar'), (1, 'Pinamar'), (1, 'Pinar del Sol'),(1, 'Polvorines'), (1, 'Pte. Perón'), (1, 'Puán'), (1, 'Punta Indio'), (1, 'Ramallo'), (1, 'Rauch'), (1, 'Rivadavia'),(1, 'Rojas'), (1, 'Roque Pérez'), (1, 'Saavedra'), (1, 'Saladillo'), (1, 'Salliqueló'), (1, 'Salto'),(1, 'San Andrés de Giles'), (1, 'San Antonio de Areco'), (1, 'San Antonio de Padua'), (1, 'San Bernardo'),(1, 'San Cayetano'), (1, 'San Clemente del Tuyú'), (1, 'San Nicolás'), (1, 'San Pedro'), (1, 'San Vicente'),(1, 'Santa Teresita'), (1, 'Suipacha'), (1, 'Tandil'), (1, 'Tapalqué'), (1, 'Tordillo'), (1, 'Tornquist'),(1, 'Trenque Lauquen'), (1, 'Tres Lomas'), (1, 'Villa Gesell'), (1, 'Villarino'), (1, 'Zárate'),
(2, 'Almagro'), (2, 'Balvanera'), (2, 'Barracas'), (2, 'Belgrano'), (2, 'Boca'), (2, 'Boedo'), (2, 'Caballito'),(2, 'Chacarita'), (2, 'Coghlan'), (2, 'Colegiales'), (2, 'Constitución'), (2, 'Flores'), (2, 'Floresta'),(2, 'La Paternal'), (2, 'Liniers'), (2, 'Mataderos'), (2, 'Monserrat'), (2, 'Monte Castro'), (2, 'Nueva Pompeya'),(2, 'Núñez'), (2, 'Palermo'), (2, 'Parque Avellaneda'), (2, 'Parque Chacabuco'), (2, 'Parque Chas'),(2, 'Parque Patricios'), (2, 'Puerto Madero'), (2, 'Recoleta'), (2, 'Retiro'), (2, 'Saavedra'),(2, 'San Cristóbal'), (2, 'San Nicolás'), (2, 'San Telmo'), (2, 'Vélez Sársfield'), (2, 'Versalles'),(2, 'Villa Crespo'), (2, 'Villa del Parque'), (2, 'Villa Devoto'), (2, 'Villa Gral. Mitre'), (2, 'Villa Lugano'),(2, 'Villa Luro'), (2, 'Villa Ortúzar'), (2, 'Villa Pueyrredón'), (2, 'Villa Real'), (2, 'Villa Riachuelo'),(2, 'Villa Santa Rita'), (2, 'Villa Soldati'), (2, 'Villa Urquiza'), 
(3,'San Fernando del Valle de Catamarca'),(3,'Andalgalá'),(3,'Belén'),(3,'Santa María'),(3,'Tinogasta'),(3,'Recreo'),(3,'Fiambalá'),(3,'Saujil'),(3,'Pomán'),(3,'Londres'),(3,'Aconquija'),(3,'Icaño'),(3,'Capayán'),
(4,'Resistencia'),(4,'Barranqueras'),(4,'Fontana'),(4,'Presidencia Roque Sáenz Peña'),(4,'Villa Ángela'),(4,'General San Martín'),(4,'Charata'),(4,'Las Breñas'),(4,'Quitilipi'),(4,'Machagai'),(4,'Juan José Castelli'),(4,'Corzuela'),(4,'Tres Isletas'),(4,'Puerto Tirol'),(4,'Margarita Belén'), 
(5,'Rawson'),(5,'Trelew'),(5,'Puerto Madryn'),(5,'Comodoro Rivadavia'),(5,'Esquel'),(5,'Gaiman'),(5,'Dolavon'),(5,'Sarmiento'),(5,'Trevelin'),(5,'Gobernador Costa'),(5,'Río Mayo'),(5,'Rada Tilly'),(5,'El Maitén'),(5,'Lago Puelo'),(5,'Epuyén'), 
(6,'Alta Gracia'),(6,'Arroyito'),(6,'Bell Ville'),(6,'Calchín'),(6,'Córdoba'),(6,'Cosquín'),(6,'Cruz del Eje'),(6,'Jesús María'),(6,'La Falda'),(6,'Laboulaye'),(6,'Las Varillas'),(6,'Marcos Juárez'),(6,'Río Cuarto'),(6,'Río Segundo'),(6,'Río Tercero'),(6,'San Francisco'),(6,'Villa Carlos Paz'),(6,'Villa Dolores'),(6,'Villa María'),
(7,'Corrientes'),(7,'Goya'),(7,'Mercedes'),(7,'Curuzú Cuatiá'),(7,'Paso de los Libres'),(7,'Bella Vista'),(7,'Esquina'),(7,'Santo Tomé'),(7,'Monte Caseros'),(7,'Saladas'),(7,'Ituzaingó'),(7,'Empedrado'),(7,'Gobernador Virasoro'),
(8,'Paraná'),(8,'Concordia'),(8,'Gualeguaychú'),(8,'Concepción del Uruguay'),(8,'Gualeguay'),(8,'Victoria'),(8,'Villaguay'),(8,'La Paz'),(8,'Colón'),(8,'Nogoyá'),(8,'Diamante'),(8,'Chajarí'),(8,'Federación'),(8,'Federal'),(8,'Crespo'),(8,'San Salvador'),
(9,'Formosa'),(9,'Clorinda'),(9,'Pirané'),(9,'El Colorado'),(9,'Las Lomitas'),(9,'Ingeniero Juárez'),(9,'Ibarreta'),(9,'Comandante Fontana'),(9,'Laguna Blanca'),(9,'Palo Santo'),(9,'Estanislao del Campo'), 
(10,'San Salvador de Jujuy'),(10,'San Pedro de Jujuy'),(10,'Libertador General San Martín'),(10,'Palpalá'),(10,'Perico'),(10,'El Carmen'),(10,'La Quiaca'),(10,'Humahuaca'),(10,'Tilcara'),(10,'Monterrico'),(10,'Fraile Pintado'),(10,'Abra Pampa'),(10,'Purmamarca'),(10,'Maimará'), 
(11,'Santa Rosa'),(11,'General Pico'),(11,'Toay'),(11,'Realicó'),(11,'Eduardo Castex'),(11,'General Acha'),(11,'Macachín'),(11,'Victorica'),(11,'Intendente Alvear'),(11,'Quemú Quemú'),(11,'Catriló'),(11,'Guatraché'),(11,'Winifreda'), 
(12,'La Rioja'),(12,'Chilecito'),(12,'Aimogasta'),(12,'Chamical'),(12,'Chepes'),(12,'Villa Unión'),(12,'Famatina'),(12,'Nonogasta'),(12,'Olta'),(12,'Sanagasta'),(12,'Patquía'), 
(13,'Mendoza'),(13,'San Rafael'),(13,'Godoy Cruz'),(13,'Las Heras'),(13,'Maipú'),(13,'Luján de Cuyo'),(13,'Guaymallén'),(13,'San Martín'),(13,'Rivadavia'),(13,'Tunuyán'),(13,'General Alvear'),(13,'Malargüe'),(13,'Tupungato'),(13,'San Carlos'),(13,'Junín'),(13,'La Paz'),(13,'Lavalle'), 
(14,'Posadas'),(14,'Oberá'),(14,'Eldorado'),(14,'Puerto Iguazú'),(14,'Apóstoles'),(14,'Leandro N. Alem'),(14,'Puerto Rico'),(14,'Montecarlo'),(14,'San Vicente'),(14,'Jardín América'),(14,'Aristóbulo del Valle'),(14,'Wanda'),(14,'Candelaria'),(14,'Garupá'),(14,'San Pedro'), 
(15,'Neuquén'),(15,'Cutral Có'),(15,'Plottier'),(15,'Centenario'),(15,'Zapala'),(15,'San Martín de los Andes'),(15,'Villa La Angostura'),(15,'Junín de los Andes'),(15,'Plaza Huincul'),(15,'Chos Malal'),(15,'Rincón de los Sauces'),(15,'Senillosa'),(15,'Aluminé'),(15,'Las Lajas'), 
(16,'Viedma'),(16,'San Carlos de Bariloche'),(16,'General Roca'),(16,'Cipolletti'),(16,'Villa Regina'),(16,'Cinco Saltos'),(16,'Allen'),(16,'Choele Choel'),(16,'Río Colorado'),(16,'El Bolsón'),(16,'Catriel'),(16,'Ingeniero Jacobacci'),(16,'Sierra Grande'),(16,'General Conesa'), 
(17,'Salta'),(17,'San Ramón de la Nueva Orán'),(17,'Tartagal'),(17,'General Güemes'),(17,'Metán'),(17,'Rosario de la Frontera'),(17,'Cafayate'),(17,'Cerrillos'),(17,'Embarcación'),(17,'Joaquín V. González'),(17,'Rosario de Lerma'),(17,'El Carril'),(17,'Cachi'),(17,'San Antonio de los Cobres'), 
(18,'San Juan'),(18,'Chimbas'),(18,'Rivadavia'),(18,'Santa Lucía'),(18,'Pocito'),(18,'Caucete'),(18,'Albardón'),(18,'San José de Jáchal'),(18,'Media Agua'),(18,'Calingasta'),(18,'Iglesia'),(18,'San Agustín del Valle Fértil'),(18,'Angaco'),(18,'Ullum'), 
(19,'San Luis'),(19,'Villa Mercedes'),(19,'Merlo'),(19,'Justo Daract'),(19,'La Punta'),(19,'Juana Koslay'),(19,'Concarán'),(19,'Tilisarao'),(19,'Santa Rosa del Conlara'),(19,'Quines'),(19,'Buena Esperanza'),(19,'La Toma'), 
(20,'Río Gallegos'),(20,'Caleta Olivia'),(20,'Pico Truncado'),(20,'Las Heras'),(20,'Puerto Deseado'),(20,'Puerto San Julián'),(20,'El Calafate'),(20,'Río Turbio'),(20,'Gobernador Gregores'),(20,'Perito Moreno'),(20,'28 de Noviembre'),(20,'Puerto Santa Cruz'),(20,'Los Antiguos'),(20,'El Chaltén'), 
(21,'Santa Fe'),(21,'Rosario'),(21,'Rafaela'),(21,'Venado Tuerto'),(21,'Reconquista'),(21,'Villa Gobernador Gálvez'),(21,'Santo Tomé'),(21,'Esperanza'),(21,'San Lorenzo'),(21,'Casilda'),(21,'Cañada de Gómez'),(21,'Firmat'),(21,'Sunchales'),(21,'Las Rosas'),(21,'San Justo'),(21,'Gálvez'),(21,'Avellaneda'),(21,'Vera'),(21,'Funes'),(21,'Pérez'), 
(22,'Santiago del Estero'),(22,'La Banda'),(22,'Termas de Río Hondo'),(22,'Añatuya'),(22,'Frías'),(22,'Fernández'),(22,'Quimilí'),(22,'Loreto'),(22,'Suncho Corral'),(22,'Monte Quemado'),(22,'Clodomira'),(22,'Bandera'),(22,'Villa Ojo de Agua'), 
(23,'Ushuaia'),(23,'Río Grande'),(23,'Tolhuin'), 
(24,'San Miguel de Tucumán'),(24,'Yerba Buena'),(24,'Tafí Viejo'),(24,'Banda del Río Salí'),(24,'Concepción'),(24,'Aguilares'),(24,'Famaillá'),(24,'Monteros'),(24,'Lules'),(24,'Bella Vista'),(24,'Tafí del Valle'),(24,'Simoca'),(24,'Juan Bautista Alberdi'),(24,'La Cocha'),(24,'Trancas'),(24,'Las Talitas');
GO

-- =======================================================
-- DATOS MAESTROS DE AGENDA (Días y Franjas Horarias)
-- =======================================================

-- Días de atención de la clínica (lunes a sábado)
IF NOT EXISTS (SELECT 1 FROM DiasSemana)
BEGIN
    INSERT INTO DiasSemana (Id_Dia, Descripcion_Dia) VALUES
    (1, 'Lunes'),
    (2, 'Martes'),
    (3, 'Miércoles'),
    (4, 'Jueves'),
    (5, 'Viernes'),
    (6, 'Sábado');
END
GO

-- Franjas horarias de atención (turnos de 1 hora, de 08 a 18)
IF NOT EXISTS (SELECT 1 FROM HorariosAtencion)
BEGIN
    INSERT INTO HorariosAtencion (Id_Horario, HoraInicio, HoraFin) VALUES
    ('H08', 8, 9),
    ('H09', 9, 10),
    ('H10', 10, 11),
    ('H11', 11, 12),
    ('H12', 12, 13),
    ('H13', 13, 14),
    ('H14', 14, 15),
    ('H15', 15, 16),
    ('H16', 16, 17),
    ('H17', 17, 18);
END
GO