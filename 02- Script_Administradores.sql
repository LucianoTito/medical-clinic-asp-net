-- =====================================================================
-- ADMINISTRADORES + SUS USUARIOS - CLINICA UTN GRUPO 16
-- Requiere: Script_Clinica.sql (tablas + Localidades)
-- Re-ejecutable: usa guardas IF NOT EXISTS / WHERE NOT EXISTS
-- =====================================================================
USE ClinicaMedica;
GO

SET DATEFORMAT ymd;
GO

-- =====================================================================
-- PASO 1) Vincular Usuarios con Administradores
--    Usuarios ya tiene Legajo_Med (FK a Medicos). Le agregamos su
--    espejo Legajo_Adm (FK a Administradores) para poder saber QUE
--    persona es el admin logueado. Cada usuario apunta a UNO de los dos.
-- =====================================================================
IF NOT EXISTS (SELECT 1 FROM sys.columns
               WHERE Name = N'Legajo_Adm'
                 AND Object_ID = Object_ID(N'dbo.Usuarios'))
BEGIN
    ALTER TABLE Usuarios ADD Legajo_Adm CHAR(7) NULL;
END
GO   -- GO obligatorio: la columna no existe para el parser hasta cerrar el lote

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys
               WHERE name = N'FK_Usuarios_Administradores')
BEGIN
    ALTER TABLE Usuarios ADD CONSTRAINT FK_Usuarios_Administradores
        FOREIGN KEY (Legajo_Adm) REFERENCES Administradores(Legajo_Adm);
END
GO

-- =====================================================================
-- PASO 2) ADMINISTRADORES (15) - precargados, solo lectura (enunciado)
-- =====================================================================
IF NOT EXISTS (SELECT 1 FROM Administradores WHERE Legajo_Adm = 'ADM0001')
BEGIN
    INSERT INTO Administradores
        (Legajo_Adm, Dni_Adm, Nombre_Adm, Apellido_Adm, Sexo_Adm, Nacionalidad_Adm,
         FechaNacimiento_Adm, Direccion_Adm, Id_Localidad_Adm, CorreoElectronico_Adm,
         Telefono_Adm, Estado_Adm)
    VALUES
    ('ADM0001', '28456101', 'Sebastián', 'Ravenna',    'Masculino', 'Argentina', '1985-03-14', 'Av. Hipólito Yrigoyen 1250',
        (SELECT TOP 1 Id_Localidad FROM Localidades WHERE Descripcion_Loc = 'Gral. Pacheco' AND Id_Provincia_Loc = 1),
        'sravenna@clinica.com',   '1145101001', 1),
    ('ADM0002', '27890202', 'Gabriel',   'Manattini',  'Masculino', 'Argentina', '1983-07-22', 'Calle 50 nro 820',
        (SELECT TOP 1 Id_Localidad FROM Localidades WHERE Descripcion_Loc = 'La Plata' AND Id_Provincia_Loc = 1),
        'gmanattini@clinica.com', '1145102002', 1),
    ('ADM0003', '30567303', 'Julieta',   'Rodríguez',  'Femenino',  'Argentina', '1988-11-05', 'Av. Colón 2340',
        (SELECT TOP 1 Id_Localidad FROM Localidades WHERE Descripcion_Loc = 'Mar del Plata' AND Id_Provincia_Loc = 1),
        'jrodriguez@clinica.com', '1145103003', 1),
    ('ADM0004', '29123404', 'Luciano',   'Cedrón',     'Masculino', 'Argentina', '1986-01-30', 'Rodríguez Peña 455',
        (SELECT TOP 1 Id_Localidad FROM Localidades WHERE Descripcion_Loc = 'Tandil' AND Id_Provincia_Loc = 1),
        'lcedron@clinica.com',    '1145104004', 1),
    ('ADM0005', '24678505', 'Norberto',  'Sampietro',  'Masculino', 'Argentina', '1976-09-18', 'Ruta 8 km 60',
        (SELECT TOP 1 Id_Localidad FROM Localidades WHERE Descripcion_Loc = 'Pilar' AND Id_Provincia_Loc = 1),
        'nsampietro@clinica.com', '1145105005', 1),
    ('ADM0006', '26345606', 'Claudio',   'Fernández',  'Masculino', 'Argentina', '1979-04-27', 'Belgrano 733',
        (SELECT TOP 1 Id_Localidad FROM Localidades WHERE Descripcion_Loc = 'Zárate' AND Id_Provincia_Loc = 1),
        'cfernandez@clinica.com', '1145106006', 1),
    ('ADM0007', '31789707', 'Ariel',     'Tapia',      'Masculino', 'Argentina', '1990-06-12', 'Mitre 190',
        (SELECT TOP 1 Id_Localidad FROM Localidades WHERE Descripcion_Loc = 'Campana' AND Id_Provincia_Loc = 1),
        'atapia@clinica.com',     '1145107007', 1),
    ('ADM0008', '33012808', 'Tamara',    'Herrera',    'Femenino',  'Argentina', '1992-02-08', 'Asborno 640',
        (SELECT TOP 1 Id_Localidad FROM Localidades WHERE Descripcion_Loc = 'Escobar' AND Id_Provincia_Loc = 1),
        'therrera@clinica.com',   '1145108008', 1),
    ('ADM0009', '32456909', 'Mariana',   'Quiroga',    'Femenino',  'Argentina', '1991-08-19', 'San Martín 1120',
        (SELECT TOP 1 Id_Localidad FROM Localidades WHERE Descripcion_Loc = 'Luján' AND Id_Provincia_Loc = 1),
        'mquiroga@clinica.com',   '1145109009', 1),
    ('ADM0010', '29901010', 'Federico',  'Ibáñez',     'Masculino', 'Argentina', '1987-12-03', 'Av. Savio 285',
        (SELECT TOP 1 Id_Localidad FROM Localidades WHERE Descripcion_Loc = 'San Nicolás' AND Id_Provincia_Loc = 1),
        'fibanez@clinica.com',    '1145110010', 1),
    ('ADM0011', '27334111', 'Silvina',   'Márquez',    'Femenino',  'Argentina', '1982-05-25', 'Thames 1580',
        (SELECT TOP 1 Id_Localidad FROM Localidades WHERE Descripcion_Loc = 'Palermo' AND Id_Provincia_Loc = 2),
        'smarquez@clinica.com',   '1145111011', 1),
    ('ADM0012', '34667212', 'Rodrigo',   'Benítez',    'Masculino', 'Argentina', '1993-10-16', 'Cabildo 2400',
        (SELECT TOP 1 Id_Localidad FROM Localidades WHERE Descripcion_Loc = 'Belgrano' AND Id_Provincia_Loc = 2),
        'rbenitez@clinica.com',   '1145112012', 1),
    ('ADM0013', '30778313', 'Paula',     'Zabala',     'Femenino',  'Argentina', '1989-03-09', 'Rivadavia 5100',
        (SELECT TOP 1 Id_Localidad FROM Localidades WHERE Descripcion_Loc = 'Caballito' AND Id_Provincia_Loc = 2),
        'pzabala@clinica.com',    '1145113013', 1),
    ('ADM0014', '25889414', 'Hernán',    'Costa',      'Masculino', 'Argentina', '1977-07-01', 'Av. Pellegrini 980',
        (SELECT TOP 1 Id_Localidad FROM Localidades WHERE Descripcion_Loc = 'Rosario' AND Id_Provincia_Loc = 21),
        'hcosta@clinica.com',     '1145114014', 1),
    ('ADM0015', '31220515', 'Verónica',  'Lagos',      'Femenino',  'Argentina', '1990-09-21', 'Bv. San Juan 1450',
        (SELECT TOP 1 Id_Localidad FROM Localidades WHERE Descripcion_Loc = 'Córdoba' AND Id_Provincia_Loc = 6),
        'vlagos@clinica.com',     '1145115015', 1);
END
GO

-- =====================================================================
-- PASO 3) USUARIOS DE LOS ADMINISTRADORES
--    NombreUsuario = inicial del nombre + apellido (sin tildes)
--    Contrasena    = 'admin123'
-- =====================================================================
INSERT INTO Usuarios (NombreUsuario, Contrasena, TipoUsuario, Legajo_Med, Legajo_Adm, Activo)
SELECT v.usuario, 'admin123', 'Administrador', NULL, v.legajo, 1
FROM (VALUES
    ('sravenna',   'ADM0001'),
    ('gmanattini', 'ADM0002'),
    ('jrodriguez', 'ADM0003'),
    ('lcedron',    'ADM0004'),
    ('nsampietro', 'ADM0005'),
    ('cfernandez', 'ADM0006'),
    ('atapia',     'ADM0007'),
    ('therrera',   'ADM0008'),
    ('mquiroga',   'ADM0009'),
    ('fibanez',    'ADM0010'),
    ('smarquez',   'ADM0011'),
    ('rbenitez',   'ADM0012'),
    ('pzabala',    'ADM0013'),
    ('hcosta',     'ADM0014'),
    ('vlagos',     'ADM0015')
) AS v(usuario, legajo)
WHERE NOT EXISTS (SELECT 1 FROM Usuarios U WHERE U.NombreUsuario = v.usuario);
GO

-- =====================================================================
-- PASO 4) Usuario 'admin' historico: crearlo si falta y vincularlo a ADM0001
--    (no depende de Script_DatosPrueba: este script es auto-suficiente)
-- =====================================================================
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE NombreUsuario = 'admin')
BEGIN
    INSERT INTO Usuarios (NombreUsuario, Contrasena, TipoUsuario, Legajo_Med, Legajo_Adm, Activo)
    VALUES ('admin', 'admin123', 'Administrador', NULL, 'ADM0001', 1);
END
ELSE
BEGIN
    UPDATE Usuarios
    SET Legajo_Adm = 'ADM0001'
    WHERE NombreUsuario = 'admin' AND Legajo_Adm IS NULL;
END
GO

-- =====================================================================
-- PASO 5) VERIFICACION
-- =====================================================================
SELECT 'Administradores' AS Tabla, COUNT(*) AS Cantidad FROM Administradores
UNION ALL
SELECT 'Usuarios', COUNT(*) FROM Usuarios;

SELECT U.NombreUsuario, U.TipoUsuario,
       A.Nombre_Adm + ' ' + A.Apellido_Adm AS Persona
FROM Usuarios U
INNER JOIN Administradores A ON U.Legajo_Adm = A.Legajo_Adm
ORDER BY U.NombreUsuario;
GO