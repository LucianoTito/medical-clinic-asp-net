-- =====================================================================
-- SCRIPT DE DATOS PRECARGADOS PARA LA PRUEBA - CLINICA UTN GRUPO 16
-- ORDEN DE EJECUCION PARA RECONSTRUIR LA BASE COMPLETA:
--   1. Script_Clinica.sql                  (tablas + catalogos)
--   2. Script_Pacientes.sql                (pacientes de prueba)
--   3. Script_ProcedimientosAlmacenados.sql
--   4. Script_DatosPrueba.sql              <- ESTE
--   (Script_Usuarios.sql queda obsoleto: su contenido esta incluido
--    aca con las mismas guardas; ejecutarlo igual no rompe nada.)
-- =====================================================================

USE ClinicaMedica;
GO

SET DATEFORMAT ymd;
GO

-- =====================================================================
-- 0) ESPECIALIDADES (deben existir ANTES que cualquier medico: FK)
--    Id_Especialidad es IDENTITY; se usa IDENTITY_INSERT para conservar
--    los IDs originales (1..6) que referencian los datos de prueba.
-- =====================================================================
SET IDENTITY_INSERT Especialidades ON;

INSERT INTO Especialidades (Id_Especialidad, Descripcion_Esp)
SELECT E.Id, E.Descripcion
FROM (VALUES
    (1, 'Cardiología'),
    (2, 'Pediatría'),
    (3, 'Clínica Médica'),
    (4, 'Traumatología'),
    (5, 'Ginecología'),
    (6, 'Dermatología')
) AS E(Id, Descripcion)
WHERE NOT EXISTS (SELECT 1 FROM Especialidades X WHERE X.Id_Especialidad = E.Id);

SET IDENTITY_INSERT Especialidades OFF;
GO

-- =====================================================================
-- 1) USUARIO ADMINISTRADOR
-- =====================================================================
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE NombreUsuario = 'admin')
BEGIN
    INSERT INTO Usuarios (NombreUsuario, Contrasena, TipoUsuario, Legajo_Med, Activo)
    VALUES ('admin', 'admin123', 'Administrador', NULL, 1);
END
GO

-- =====================================================================
-- 2) MEDICO MED0001 (Dr. Juan Perez) + su usuario 'jperez'
--    (traido de Script_Usuarios.sql, sin cambios)
-- =====================================================================
IF NOT EXISTS (SELECT 1 FROM Medicos WHERE Legajo_Med = 'MED0001')
BEGIN
    INSERT INTO Medicos
        (Legajo_Med, Dni_Med, Nombre_Med, Apellido_Med, Sexo_Med, Nacionalidad_Med,
         FechaNacimiento_Med, Direccion_Med, Id_Localidad_Med, CorreoElectronico_Med,
         Telefono_Med, Id_Especialidad_Med, Estado_Med)
    VALUES
        ('MED0001', '30111222', 'Juan', 'Pérez', 'Masculino', 'Argentina',
         '1985-04-12', 'Av. Siempreviva 123',
         (SELECT MIN(Id_Localidad) FROM Localidades),
         'jperez@clinica.com', '1145678901',
         (SELECT MIN(Id_Especialidad) FROM Especialidades),
         1);
END
GO

IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE NombreUsuario = 'jperez')
BEGIN
    INSERT INTO Usuarios (NombreUsuario, Contrasena, TipoUsuario, Legajo_Med, Activo)
    VALUES ('jperez', 'medico123', 'Medico', 'MED0001', 1);
END
GO

-- =====================================================================
-- 3) MEDICOS (15 nuevos: MED0002 a MED0016)
-- =====================================================================
IF NOT EXISTS (SELECT 1 FROM Medicos WHERE Legajo_Med = 'MED0002')
BEGIN
    INSERT INTO Medicos
        (Legajo_Med, Dni_Med, Nombre_Med, Apellido_Med, Sexo_Med, Nacionalidad_Med,
         FechaNacimiento_Med, Direccion_Med, Id_Localidad_Med, CorreoElectronico_Med,
         Telefono_Med, Id_Especialidad_Med, Estado_Med)
    VALUES
    -- CARDIOLOGIA
    ('MED0002', '40000002', 'Laura',     'Giménez',   'Femenino',  'Argentina', '1982-05-12', 'Calle 7 nro 540',
        (SELECT TOP 1 Id_Localidad FROM Localidades WHERE Descripcion_Loc = 'La Plata' AND Id_Provincia_Loc = 1),
        'lgimenez@clinica.com', '2211000002',
        (SELECT Id_Especialidad FROM Especialidades WHERE Descripcion_Esp = 'Cardiología'), 1),
    ('MED0003', '40000003', 'Martín',    'Sosa',      'Masculino', 'Argentina', '1978-11-03', 'Av. Luro 1230',
        (SELECT TOP 1 Id_Localidad FROM Localidades WHERE Descripcion_Loc = 'Mar del Plata' AND Id_Provincia_Loc = 1),
        'msosa@clinica.com', '2231000003',
        (SELECT Id_Especialidad FROM Especialidades WHERE Descripcion_Esp = 'Cardiología'), 1),
    -- PEDIATRIA
    ('MED0004', '40000004', 'Carla',     'Ferreyra',  'Femenino',  'Argentina', '1985-02-20', 'Bv. San Juan 800',
        (SELECT TOP 1 Id_Localidad FROM Localidades WHERE Descripcion_Loc = 'Córdoba' AND Id_Provincia_Loc = 6),
        'cferreyra@clinica.com', '3510000004',
        (SELECT Id_Especialidad FROM Especialidades WHERE Descripcion_Esp = 'Pediatría'), 1),
    ('MED0005', '40000005', 'Diego',     'Núñez',     'Masculino', 'Argentina', '1980-07-09', 'Bv. Oroño 1500',
        (SELECT TOP 1 Id_Localidad FROM Localidades WHERE Descripcion_Loc = 'Rosario' AND Id_Provincia_Loc = 21),
        'dnunez@clinica.com', '3410000005',
        (SELECT Id_Especialidad FROM Especialidades WHERE Descripcion_Esp = 'Pediatría'), 1),
    ('MED0006', '40000006', 'Sofía',     'Acosta',    'Femenino',  'Argentina', '1988-09-25', 'Calle Caseros 145',
        (SELECT TOP 1 Id_Localidad FROM Localidades WHERE Descripcion_Loc = 'Salta' AND Id_Provincia_Loc = 17),
        'sacosta@clinica.com', '3870000006',
        (SELECT Id_Especialidad FROM Especialidades WHERE Descripcion_Esp = 'Pediatría'), 1),
    -- CLINICA MEDICA
    ('MED0007', '40000007', 'Pablo',     'Herrera',   'Masculino', 'Argentina', '1976-04-14', 'Av. Santa Fe 2100',
        (SELECT TOP 1 Id_Localidad FROM Localidades WHERE Descripcion_Loc = 'Palermo' AND Id_Provincia_Loc = 2),
        'pherrera@clinica.com', '1140000007',
        (SELECT Id_Especialidad FROM Especialidades WHERE Descripcion_Esp = 'Clínica Médica'), 1),
    ('MED0008', '40000008', 'Valeria',   'Ríos',      'Femenino',  'Argentina', '1983-12-01', 'Calle 24 de Septiembre 90',
        (SELECT TOP 1 Id_Localidad FROM Localidades WHERE Descripcion_Loc = 'San Miguel de Tucumán' AND Id_Provincia_Loc = 24),
        'vrios@clinica.com', '3810000008',
        (SELECT Id_Especialidad FROM Especialidades WHERE Descripcion_Esp = 'Clínica Médica'), 1),
    ('MED0009', '40000009', 'Fernando',  'Cabrera',   'Masculino', 'Argentina', '1979-06-30', 'Av. San Martín 1340',
        (SELECT TOP 1 Id_Localidad FROM Localidades WHERE Descripcion_Loc = 'Mendoza' AND Id_Provincia_Loc = 13),
        'fcabrera@clinica.com', '2610000009',
        (SELECT Id_Especialidad FROM Especialidades WHERE Descripcion_Esp = 'Clínica Médica'), 1),
    -- TRAUMATOLOGIA
    ('MED0010', '40000010', 'Andrés',    'Vega',      'Masculino', 'Argentina', '1981-03-17', 'Av. Colón 670',
        (SELECT TOP 1 Id_Localidad FROM Localidades WHERE Descripcion_Loc = 'Bahía Blanca' AND Id_Provincia_Loc = 1),
        'avega@clinica.com', '2910000010',
        (SELECT Id_Especialidad FROM Especialidades WHERE Descripcion_Esp = 'Traumatología'), 1),
    ('MED0011', '40000011', 'Romina',    'Ledesma',   'Femenino',  'Argentina', '1986-08-08', 'Calle Bolívar 215',
        (SELECT TOP 1 Id_Localidad FROM Localidades WHERE Descripcion_Loc = 'Posadas' AND Id_Provincia_Loc = 14),
        'rledesma@clinica.com', '3760000011',
        (SELECT Id_Especialidad FROM Especialidades WHERE Descripcion_Esp = 'Traumatología'), 1),
    -- GINECOLOGIA
    ('MED0012', '40000012', 'Natalia',   'Bravo',     'Femenino',  'Argentina', '1984-10-22', 'Av. Argentina 455',
        (SELECT TOP 1 Id_Localidad FROM Localidades WHERE Descripcion_Loc = 'Neuquén' AND Id_Provincia_Loc = 15),
        'nbravo@clinica.com', '2990000012',
        (SELECT Id_Especialidad FROM Especialidades WHERE Descripcion_Esp = 'Ginecología'), 1),
    ('MED0013', '40000013', 'Cecilia',   'Domínguez', 'Femenino',  'Argentina', '1977-01-19', 'Calle San Martín 980',
        (SELECT TOP 1 Id_Localidad FROM Localidades WHERE Descripcion_Loc = 'Santa Fe' AND Id_Provincia_Loc = 21),
        'cdominguez@clinica.com', '3420000013',
        (SELECT Id_Especialidad FROM Especialidades WHERE Descripcion_Esp = 'Ginecología'), 1),
    -- DERMATOLOGIA
    ('MED0014', '40000014', 'Florencia', 'Aguirre',   'Femenino',  'Argentina', '1989-05-05', 'Calle Urquiza 320',
        (SELECT TOP 1 Id_Localidad FROM Localidades WHERE Descripcion_Loc = 'Paraná' AND Id_Provincia_Loc = 8),
        'faguirre@clinica.com', '3430000014',
        (SELECT Id_Especialidad FROM Especialidades WHERE Descripcion_Esp = 'Dermatología'), 1),
    ('MED0015', '40000015', 'Sebastián', 'Molina',    'Masculino', 'Argentina', '1982-09-11', 'Av. Sarmiento 1010',
        (SELECT TOP 1 Id_Localidad FROM Localidades WHERE Descripcion_Loc = 'Resistencia' AND Id_Provincia_Loc = 4),
        'smolina@clinica.com', '3620000015',
        (SELECT Id_Especialidad FROM Especialidades WHERE Descripcion_Esp = 'Dermatología'), 1),
    -- TRAUMATOLOGIA (tercero, para balancear el ranking)
    ('MED0016', '40000016', 'Gustavo',   'Peralta',   'Masculino', 'Argentina', '1975-12-28', 'Calle Belgrano 77',
        (SELECT TOP 1 Id_Localidad FROM Localidades WHERE Descripcion_Loc = 'San Salvador de Jujuy' AND Id_Provincia_Loc = 10),
        'gperalta@clinica.com', '3880000016',
        (SELECT Id_Especialidad FROM Especialidades WHERE Descripcion_Esp = 'Traumatología'), 1);
END
GO

-- =====================================================================
-- 4) USUARIOS DE MEDICOS (autogenerados)
--    Crea una cuenta para cada medico que no tenga usuario asociado:
--      NombreUsuario = legajo en minusculas (med0002, med0003, ...)
--      Contrasena    = 'medico123'
-- =====================================================================
INSERT INTO Usuarios (NombreUsuario, Contrasena, TipoUsuario, Legajo_Med, Activo)
SELECT
    LOWER(RTRIM(M.Legajo_Med)),
    'medico123',
    'Medico',
    M.Legajo_Med,
    1
FROM Medicos M
WHERE NOT EXISTS (SELECT 1 FROM Usuarios U WHERE U.Legajo_Med = M.Legajo_Med)
  AND NOT EXISTS (SELECT 1 FROM Usuarios U WHERE U.NombreUsuario = LOWER(RTRIM(M.Legajo_Med)));
GO

-- =====================================================================
-- 5) AGENDAS DE ATENCION (Horarios_Medicos)
--    Agendas VARIADAS por medico (dias y franjas distintas), disenadas
--    para que todo turno de prueba caiga en un dia/hora en que su medico
--    atiende. Se regenera completa para dejar el estado exacto.
--    Referencia: Id_Dia 1=Lunes ... 6=Sabado | H08..H17 = franjas de 1 hora.
-- =====================================================================
DELETE FROM Horarios_Medicos;
GO

-- Cardiología - Dr. Pérez: mañanas Lun/Mar, refuerzo Vie
INSERT INTO Horarios_Medicos (Leg_Medico, Id_Dia, Id_Horario) VALUES
('MED0001', 1, 'H08'),
('MED0001', 1, 'H09'),
('MED0001', 1, 'H10'),
('MED0001', 1, 'H11'),
('MED0001', 2, 'H08'),
('MED0001', 2, 'H09'),
('MED0001', 2, 'H10'),
('MED0001', 5, 'H08'),
('MED0001', 5, 'H09'),
('MED0001', 5, 'H10');

-- Cardiología - Dra. Giménez: mañanas Mar/Jue + Sábado
INSERT INTO Horarios_Medicos (Leg_Medico, Id_Dia, Id_Horario) VALUES
('MED0002', 2, 'H08'),
('MED0002', 2, 'H09'),
('MED0002', 2, 'H10'),
('MED0002', 4, 'H08'),
('MED0002', 4, 'H09'),
('MED0002', 4, 'H10'),
('MED0002', 6, 'H09'),
('MED0002', 6, 'H10');

-- Cardiología - Dr. Sosa: media mañana Mar/Vie
INSERT INTO Horarios_Medicos (Leg_Medico, Id_Dia, Id_Horario) VALUES
('MED0003', 2, 'H09'),
('MED0003', 2, 'H10'),
('MED0003', 2, 'H11'),
('MED0003', 5, 'H08'),
('MED0003', 5, 'H09'),
('MED0003', 5, 'H10');

-- Pediatría - Dra. Ferreyra: mañanas Lun/Mar/Mié
INSERT INTO Horarios_Medicos (Leg_Medico, Id_Dia, Id_Horario) VALUES
('MED0004', 1, 'H09'),
('MED0004', 1, 'H10'),
('MED0004', 1, 'H11'),
('MED0004', 2, 'H10'),
('MED0004', 2, 'H11'),
('MED0004', 2, 'H12'),
('MED0004', 3, 'H09'),
('MED0004', 3, 'H10');

-- Pediatría - Dr. Núñez: mediodía Mar/Vie
INSERT INTO Horarios_Medicos (Leg_Medico, Id_Dia, Id_Horario) VALUES
('MED0005', 2, 'H11'),
('MED0005', 2, 'H12'),
('MED0005', 2, 'H13'),
('MED0005', 5, 'H10'),
('MED0005', 5, 'H11'),
('MED0005', 5, 'H12');

-- Pediatría - Dra. Acosta: mañana Mar, tarde Jue
INSERT INTO Horarios_Medicos (Leg_Medico, Id_Dia, Id_Horario) VALUES
('MED0006', 2, 'H08'),
('MED0006', 2, 'H09'),
('MED0006', 2, 'H10'),
('MED0006', 4, 'H14'),
('MED0006', 4, 'H15'),
('MED0006', 4, 'H16');

-- Clínica Médica - Dr. Herrera: tardes Mar/Jue
INSERT INTO Horarios_Medicos (Leg_Medico, Id_Dia, Id_Horario) VALUES
('MED0007', 2, 'H13'),
('MED0007', 2, 'H14'),
('MED0007', 2, 'H15'),
('MED0007', 4, 'H13'),
('MED0007', 4, 'H14'),
('MED0007', 4, 'H15');

-- Clínica Médica - Dra. Ríos: mediodía Mar/Mié
INSERT INTO Horarios_Medicos (Leg_Medico, Id_Dia, Id_Horario) VALUES
('MED0008', 2, 'H12'),
('MED0008', 2, 'H13'),
('MED0008', 2, 'H14'),
('MED0008', 3, 'H12'),
('MED0008', 3, 'H13'),
('MED0008', 3, 'H14');

-- Clínica Médica - Dr. Cabrera: tardes Mar/Vie
INSERT INTO Horarios_Medicos (Leg_Medico, Id_Dia, Id_Horario) VALUES
('MED0009', 2, 'H14'),
('MED0009', 2, 'H15'),
('MED0009', 2, 'H16'),
('MED0009', 5, 'H14'),
('MED0009', 5, 'H15'),
('MED0009', 5, 'H16');

-- Traumatología - Dr. Vega: tardes Mar/Jue + Sáb mañana
INSERT INTO Horarios_Medicos (Leg_Medico, Id_Dia, Id_Horario) VALUES
('MED0010', 2, 'H14'),
('MED0010', 2, 'H15'),
('MED0010', 2, 'H16'),
('MED0010', 4, 'H14'),
('MED0010', 4, 'H15'),
('MED0010', 4, 'H16'),
('MED0010', 6, 'H08'),
('MED0010', 6, 'H09');

-- Traumatología - Dra. Ledesma: última tarde Mar/Mié
INSERT INTO Horarios_Medicos (Leg_Medico, Id_Dia, Id_Horario) VALUES
('MED0011', 2, 'H15'),
('MED0011', 2, 'H16'),
('MED0011', 2, 'H17'),
('MED0011', 3, 'H15'),
('MED0011', 3, 'H16'),
('MED0011', 3, 'H17');

-- Ginecología - Dra. Bravo: mañanas Mar/Vie
INSERT INTO Horarios_Medicos (Leg_Medico, Id_Dia, Id_Horario) VALUES
('MED0012', 2, 'H09'),
('MED0012', 2, 'H10'),
('MED0012', 2, 'H11'),
('MED0012', 5, 'H09'),
('MED0012', 5, 'H10'),
('MED0012', 5, 'H11');

-- Ginecología - Dra. Domínguez: media mañana Mar/Jue
INSERT INTO Horarios_Medicos (Leg_Medico, Id_Dia, Id_Horario) VALUES
('MED0013', 2, 'H10'),
('MED0013', 2, 'H11'),
('MED0013', 2, 'H12'),
('MED0013', 4, 'H10'),
('MED0013', 4, 'H11'),
('MED0013', 4, 'H12');

-- Dermatología - Dra. Aguirre: última tarde Mar/Jue
INSERT INTO Horarios_Medicos (Leg_Medico, Id_Dia, Id_Horario) VALUES
('MED0014', 2, 'H15'),
('MED0014', 2, 'H16'),
('MED0014', 2, 'H17'),
('MED0014', 4, 'H15'),
('MED0014', 4, 'H16'),
('MED0014', 4, 'H17');

-- Dermatología - Dr. Molina: tardes Mié/Vie (no atiende Mar)
INSERT INTO Horarios_Medicos (Leg_Medico, Id_Dia, Id_Horario) VALUES
('MED0015', 3, 'H14'),
('MED0015', 3, 'H15'),
('MED0015', 3, 'H16'),
('MED0015', 5, 'H14'),
('MED0015', 5, 'H15'),
('MED0015', 5, 'H16');

-- Traumatología - Dr. Peralta: tarde corta Mar/Vie + Sáb
INSERT INTO Horarios_Medicos (Leg_Medico, Id_Dia, Id_Horario) VALUES
('MED0016', 2, 'H15'),
('MED0016', 2, 'H16'),
('MED0016', 5, 'H15'),
('MED0016', 5, 'H16'),
('MED0016', 6, 'H10'),
('MED0016', 6, 'H11');
GO

-- =====================================================================
-- 6) TURNOS
-- =====================================================================
DELETE FROM Turnos;
GO

INSERT INTO Turnos (Leg_Medico, Dni_Paciente, Fecha_Tur, Hora_Tur, Asistencia, Estado_Tur)
VALUES
-- ---------- 2024 (pasado -> Presente/Ausente) ----------
('MED0001', '30000030', '2024-01-15', '09:00', 'Presente', 1),
('MED0001', '30000009', '2024-01-22', '10:00', 'Ausente',  1),
('MED0002', '30000023', '2024-01-18', '09:00', 'Presente', 1),
('MED0012', '30000031', '2024-01-30', '10:00', 'Ausente',  1),
('MED0010', '30000014', '2024-02-08', '15:00', 'Presente', 1),
('MED0004', '30000012', '2024-02-05', '11:00', 'Presente', 1),
('MED0004', '30000032', '2024-02-12', '09:00', 'Ausente',  1),
('MED0007', '30000013', '2024-02-20', '14:00', 'Presente', 1),
('MED0003', '30000033', '2024-05-10', '09:00', 'Presente', 1),
('MED0005', '30000025', '2024-06-14', '11:00', 'Presente', 1),
('MED0008', '30000002', '2024-08-21', '13:00', 'Ausente',  1),
('MED0014', '30000034', '2024-09-03', '16:00', 'Presente', 1),

-- ---------- 2025 (pasado -> Presente/Ausente) ----------
('MED0001', '30000003', '2025-03-11', '09:00', 'Presente', 1),
('MED0006', '30000021', '2025-04-15', '10:00', 'Ausente',  1),
('MED0009', '30000035', '2025-05-20', '14:00', 'Presente', 1),
('MED0011', '30000020', '2025-07-08', '15:00', 'Presente', 1),
('MED0013', '30000036', '2025-09-16', '11:00', 'Ausente',  1),
('MED0015', '30000016', '2025-10-22', '16:00', 'Presente', 1),
('MED0002', '30000037', '2025-11-04', '09:00', 'Presente', 1),
('MED0007', '30000006', '2025-11-18', '13:00', 'Presente', 1),
('MED0010', '30000017', '2025-12-02', '15:00', 'Ausente',  1),

-- ---------- 2026 ene-jun (pasado -> Presente/Ausente) ----------
('MED0001', '30000038', '2026-01-13', '09:00', 'Presente', 1),
('MED0004', '30000010', '2026-02-10', '11:00', 'Presente', 1),
('MED0008', '30000039', '2026-03-17', '13:00', 'Ausente',  1),
('MED0012', '30000022', '2026-04-21', '10:00', 'Presente', 1),
('MED0005', '30000011', '2026-05-19', '11:00', 'Presente', 1),
('MED0014', '30000040', '2026-06-09', '16:00', 'Ausente',  1),
('MED0003', '30000008', '2026-06-23', '09:00', 'Presente', 1),

-- ---------- 2026 jul-dic (futuro -> Pendiente) ----------
('MED0009', '30000041', '2026-07-14', '14:00', 'Pendiente', 1),
('MED0010', '30000012', '2026-08-11', '15:00', 'Pendiente', 1),
('MED0013', '30000042', '2026-09-08', '11:00', 'Pendiente', 1),
('MED0006', '30000013', '2026-10-20', '10:00', 'Pendiente', 1),
('MED0016', '30000043', '2026-11-17', '15:00', 'Pendiente', 1),

-- ---------- NUEVOS TURNOS VIERNES 17/07/2026 ----------
-- MED0001 (jperez) arranca con 3 turnos ese dia: a la hora de la defensa
-- los primeros ya pasaron (para demostrar la carga de asistencia y
-- observaciones) y el de las 10 sigue pendiente a futuro.
('MED0003', '30000023', '2026-07-17', '08:00', 'Pendiente', 1),
('MED0001', '30000004', '2026-07-17', '08:00', 'Pendiente', 1),
('MED0001', '30000030', '2026-07-17', '09:00', 'Pendiente', 1),
('MED0001', '30000026', '2026-07-17', '10:00', 'Pendiente', 1),
('MED0012', '30000010', '2026-07-17', '10:00', 'Pendiente', 1),
('MED0005', '30000034', '2026-07-17', '11:00', 'Pendiente', 1),
('MED0005', '30000007', '2026-07-17', '12:00', 'Pendiente', 1),
('MED0009', '30000035', '2026-07-17', '14:00', 'Pendiente', 1),
('MED0015', '30000024', '2026-07-17', '15:00', 'Pendiente', 1),
('MED0016', '30000044', '2026-07-17', '15:00', 'Pendiente', 1),
('MED0009', '30000013', '2026-07-17', '16:00', 'Pendiente', 1),
('MED0015', '30000039', '2026-07-17', '16:00', 'Pendiente', 1);
GO

-- =====================================================================
-- 7) VERIFICACION
-- =====================================================================
SELECT 'Especialidades' AS Tabla, COUNT(*) AS Cantidad FROM Especialidades
UNION ALL SELECT 'Medicos',          COUNT(*) FROM Medicos
UNION ALL SELECT 'Usuarios',         COUNT(*) FROM Usuarios
UNION ALL SELECT 'Horarios_Medicos', COUNT(*) FROM Horarios_Medicos
UNION ALL SELECT 'Pacientes',        COUNT(*) FROM Pacientes
UNION ALL SELECT 'Turnos',           COUNT(*) FROM Turnos;
GO

-- Coherencia agenda vs turnos: debe devolver 0 filas
-- (ningun turno en dia/hora en que su medico no atiende; DATEFIRST 1 = semana arranca Lunes)
SET DATEFIRST 1;
SELECT T.Leg_Medico, T.Fecha_Tur, T.Hora_Tur
FROM Turnos T
WHERE NOT EXISTS (
    SELECT 1
    FROM Horarios_Medicos H
    INNER JOIN HorariosAtencion HA ON HA.Id_Horario = H.Id_Horario
    WHERE H.Leg_Medico = T.Leg_Medico
      AND H.Id_Dia = DATEPART(WEEKDAY, T.Fecha_Tur)
      AND HA.HoraInicio = DATEPART(HOUR, T.Hora_Tur)
);
GO

-- Prueba rapida de los 3 informes:
EXEC SP_Informe_AsistenciaAvanzado '2024-01-01', '2026-12-31', 0;   -- Informe 1 (todo el periodo)
EXEC SP_Informe_PacientesPorAsistencia '2024-01-01', '2026-12-31';  -- Informe 2
EXEC SP_Informe_EspecialidadesMasSolicitadas;                       -- Informe 3
GO
