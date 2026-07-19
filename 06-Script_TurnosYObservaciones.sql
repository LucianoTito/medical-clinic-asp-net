use clinicaMedica
go
-- Correccion: el turno del 14/07/2026 ya es pasado -> no puede seguir Pendiente
UPDATE Turnos
SET Asistencia = 'Presente',
    Observaciones = 'Paciente asistió al control. Se solicitan estudios de laboratorio.'
WHERE Leg_Medico = 'MED0009' AND Fecha_Tur = '2026-07-14' AND Hora_Tur = '14:00';
GO

INSERT INTO Turnos (Leg_Medico, Dni_Paciente, Fecha_Tur, Hora_Tur, Asistencia, Observaciones, Estado_Tur)
SELECT v.Leg_Medico, v.Dni_Paciente, v.Fecha_Tur, v.Hora_Tur, v.Asistencia, v.Observaciones, v.Estado_Tur
FROM (VALUES
-- ===================== B) 8 PASADOS (Presente/Ausente) =====================
('MED0016', '30000026', '2024-07-06', '10:00', 'Ausente',  CAST(NULL AS VARCHAR(500)), 1),
('MED0008', '30000011', '2026-07-08', '13:00', 'Presente', 'Chequeo general normal. Se solicitan análisis de rutina.', 1),
('MED0001', '30000018', '2026-07-06', '08:00', 'Presente', 'Control de presión arterial estable. Se renueva medicación antihipertensiva.', 1),
('MED0004', '30000024', '2026-07-06', '10:00', 'Presente', 'Control de crecimiento acorde a la edad. Vacunas al día.', 1),
('MED0007', '30000001', '2026-07-14', '13:00', 'Ausente',  NULL, 1),
('MED0011', '30000007', '2026-07-14', '16:00', 'Presente', 'Rehabilitación de rodilla en buena evolución. Continúa kinesiología.', 1),
('MED0010', '30000021', '2026-07-16', '15:00', 'Presente', 'Radiografía de control sin fracturas. Se indica reposo.', 1),
('MED0013', '30000022', '2026-07-16', '11:00', 'Ausente',  NULL, 1),
-- ===================== A) 7 EN EL 17/07/2026 (viernes, futuro) =====================
('MED0001', '30000004', '2026-07-17', '10:00', 'Pendiente', NULL, 1),
('MED0003', '30000038', '2026-07-17', '09:00', 'Pendiente', NULL, 1),
('MED0005', '30000015', '2026-07-17', '10:00', 'Pendiente', NULL, 1),
('MED0012', '30000044', '2026-07-17', '09:00', 'Pendiente', NULL, 1),
('MED0012', '30000037', '2026-07-17', '11:00', 'Pendiente', NULL, 1),
('MED0009', '30000043', '2026-07-17', '15:00', 'Pendiente', NULL, 1),
('MED0016', '30000032', '2026-07-17', '16:00', 'Pendiente', NULL, 1),
-- ===================== C) 15 FUTUROS POSTERIORES AL 17/07 =====================
('MED0002', '30000002', '2026-07-21', '08:00', 'Pendiente', NULL, 1),
('MED0003', '30000005', '2026-07-21', '09:00', 'Pendiente', NULL, 1),
('MED0004', '30000010', '2026-07-28', '10:00', 'Pendiente', NULL, 1),
('MED0005', '30000012', '2026-07-28', '11:00', 'Pendiente', NULL, 1),
('MED0007', '30000013', '2026-08-04', '14:00', 'Pendiente', NULL, 1),
('MED0008', '30000014', '2026-08-05', '12:00', 'Pendiente', NULL, 1),
('MED0009', '30000016', '2026-08-18', '15:00', 'Pendiente', NULL, 1),
('MED0011', '30000017', '2026-08-25', '15:00', 'Pendiente', NULL, 1),
('MED0013', '30000025', '2026-09-01', '10:00', 'Pendiente', NULL, 1),
('MED0012', '30000023', '2026-09-04', '10:00', 'Pendiente', NULL, 1),
('MED0014', '30000030', '2026-10-06', '16:00', 'Pendiente', NULL, 1),
('MED0015', '30000031', '2026-10-07', '14:00', 'Pendiente', NULL, 1),
('MED0001', '30000034', '2026-11-02', '08:00', 'Pendiente', NULL, 1),
('MED0010', '30000035', '2026-11-03', '14:00', 'Pendiente', NULL, 1),
('MED0006', '30000039', '2026-12-03', '14:00', 'Pendiente', NULL, 1)
) AS v(Leg_Medico, Dni_Paciente, Fecha_Tur, Hora_Tur, Asistencia, Observaciones, Estado_Tur)
WHERE NOT EXISTS (
    SELECT 1 FROM Turnos t
    WHERE t.Leg_Medico = v.Leg_Medico
      AND t.Fecha_Tur  = v.Fecha_Tur
      AND t.Hora_Tur   = v.Hora_Tur
);
GO
-- =====================================================================
-- 1) OBSERVACIONES para los 19 turnos 'Presente' existentes
-- =====================================================================
UPDATE T
SET T.Observaciones = v.Obs
FROM Turnos T
INNER JOIN (VALUES
    ('MED0001', '2024-01-15', '09:00', 'Presión arterial dentro de valores normales. Se mantiene tratamiento.'),
    ('MED0001', '2025-03-11', '09:00', 'Electrocardiograma sin alteraciones. Control anual sin novedades.'),
    ('MED0001', '2026-01-13', '09:00', 'Paciente refiere palpitaciones ocasionales. Se solicita Holter de 24 horas.'),
    ('MED0002', '2024-01-18', '09:00', 'Control post tratamiento. Buena respuesta a la medicación.'),
    ('MED0002', '2025-11-04', '09:00', 'Ergometría normal. Se autoriza actividad física moderada.'),
    ('MED0003', '2024-05-10', '09:00', 'Se ajusta dosis de antihipertensivo. Control en tres meses.'),
    ('MED0003', '2026-06-23', '09:00', 'Ecocardiograma sin hallazgos. Continúa con tratamiento actual.'),
    ('MED0004', '2024-02-05', '11:00', 'Control de niño sano. Peso y talla acordes a la edad.'),
    ('MED0004', '2026-02-10', '11:00', 'Calendario de vacunación completo. Próximo control en seis meses.'),
    ('MED0005', '2024-06-14', '11:00', 'Cuadro respiratorio leve. Se indica nebulización y reposo.'),
    ('MED0005', '2026-05-19', '11:00', 'Buena evolución del cuadro previo. Se suspende medicación.'),
    ('MED0007', '2024-02-20', '14:00', 'Chequeo general. Se solicitan análisis de sangre y orina.'),
    ('MED0007', '2025-11-18', '13:00', 'Resultados de laboratorio dentro de parámetros normales.'),
    ('MED0009', '2025-05-20', '14:00', 'Paciente con cuadro gripal. Se indica reposo e hidratación.'),
    ('MED0010', '2024-02-08', '15:00', 'Esguince de tobillo grado I. Se indica inmovilización y kinesiología.'),
    ('MED0011', '2025-07-08', '15:00', 'Control post yeso. Fractura consolidada correctamente.'),
    ('MED0014', '2024-09-03', '16:00', 'Dermatitis de contacto. Se indica crema con corticoides.'),
    ('MED0015', '2025-10-22', '16:00', 'Control de lunares sin cambios. Se recomienda protector solar.'),
    ('MED0012', '2026-04-21', '10:00', 'Control ginecológico anual. Se solicita PAP y mamografía.')
) AS v(Leg, Fecha, Hora, Obs)
    ON  T.Leg_Medico = v.Leg AND T.Fecha_Tur = v.Fecha AND T.Hora_Tur = v.Hora
WHERE T.Asistencia = 'Presente';
GO

-- =====================================================================
-- 2) Id 75: turno del 16/07 (pasado) que quedo Pendiente -> Presente + obs
-- =====================================================================
UPDATE Turnos
SET Asistencia   = 'Presente',
    Observaciones = 'Consulta dermatológica de control. Sin lesiones nuevas.'
WHERE Leg_Medico = 'MED0014' AND Fecha_Tur = '2026-07-16' AND Hora_Tur = '15:00';
GO