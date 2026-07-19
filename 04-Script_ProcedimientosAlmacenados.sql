USE ClinicaMedica;
GO

-- SCRIPT DE PROCEDIMIENTOS ALMACENADOS

-- INSERCIÓN DE ESPECIALIDADES
IF NOT EXISTS (SELECT 1 FROM Especialidades WHERE Descripcion_Esp = 'Cardiología')
    INSERT INTO Especialidades (Descripcion_Esp) VALUES ('Cardiología');

IF NOT EXISTS (SELECT 1 FROM Especialidades WHERE Descripcion_Esp = 'Pediatría')
    INSERT INTO Especialidades (Descripcion_Esp) VALUES ('Pediatría');

IF NOT EXISTS (SELECT 1 FROM Especialidades WHERE Descripcion_Esp = 'Clínica Médica')
    INSERT INTO Especialidades (Descripcion_Esp) VALUES ('Clínica Médica');

IF NOT EXISTS (SELECT 1 FROM Especialidades WHERE Descripcion_Esp = 'Traumatología')
    INSERT INTO Especialidades (Descripcion_Esp) VALUES ('Traumatología');

IF NOT EXISTS (SELECT 1 FROM Especialidades WHERE Descripcion_Esp = 'Ginecología')
    INSERT INTO Especialidades (Descripcion_Esp) VALUES ('Ginecología');

IF NOT EXISTS (SELECT 1 FROM Especialidades WHERE Descripcion_Esp = 'Dermatología')
    INSERT INTO Especialidades (Descripcion_Esp) VALUES ('Dermatología');
GO

-- BORRADO DE PROCEDIMIENTOS EXISTENTES
IF OBJECT_ID('SP_ListarEspecialidades', 'P') IS NOT NULL
    DROP PROCEDURE SP_ListarEspecialidades;
GO

IF OBJECT_ID('SP_BuscarPacientePorDNI', 'P') IS NOT NULL
    DROP PROCEDURE SP_BuscarPacientePorDNI;
GO

IF OBJECT_ID('SP_ListarMedicosPorEspecialidad', 'P') IS NOT NULL
    DROP PROCEDURE SP_ListarMedicosPorEspecialidad;
GO

IF OBJECT_ID('SP_ListarMedicos', 'P') IS NOT NULL
    DROP PROCEDURE SP_ListarMedicos;
GO

IF OBJECT_ID('SP_BuscarMedicos', 'P') IS NOT NULL
    DROP PROCEDURE SP_BuscarMedicos;
GO

IF OBJECT_ID('SP_Informe_AsistenciaAvanzado', 'P') IS NOT NULL
    DROP PROCEDURE SP_Informe_AsistenciaAvanzado;
GO

IF OBJECT_ID('SP_ValidarUsuario', 'P') IS NOT NULL
    DROP PROCEDURE SP_ValidarUsuario;
GO

-- LISTAR ESPECIALIDADES
IF OBJECT_ID('SP_ListarEspecialidades', 'P') IS NULL
    EXEC('CREATE PROCEDURE SP_ListarEspecialidades AS BEGIN SELECT 1 END');
GO

ALTER PROCEDURE SP_ListarEspecialidades
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        Id_Especialidad, 
        Descripcion_Esp 
    FROM Especialidades
    ORDER BY Descripcion_Esp;
END;
GO

-- BUSCAR PACIENTE POR DNI
IF OBJECT_ID('SP_BuscarPacientePorDNI', 'P') IS NULL
    EXEC('CREATE PROCEDURE SP_BuscarPacientePorDNI AS BEGIN SELECT 1 END');
GO
ALTER PROCEDURE SP_BuscarPacientePorDNI
    @DNI VARCHAR(20)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        Dni_Pac, 
        Nombre_Pac, 
        Apellido_Pac, 
        Estado_Pac
    FROM Pacientes
    WHERE Dni_Pac = @DNI 
      AND Estado_Pac = 1;
END;
GO

-- LISTAR MÉDICOS POR ESPECIALIDAD
IF OBJECT_ID('SP_ListarMedicosPorEspecialidad', 'P') IS NULL
    EXEC('CREATE PROCEDURE SP_ListarMedicosPorEspecialidad AS BEGIN SELECT 1 END');
GO
ALTER PROCEDURE SP_ListarMedicosPorEspecialidad
    @IdEspecialidad INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        Legajo_Med,
        Nombre_Med,
        Apellido_Med,
        Dni_Med,
        Estado_Med,        
        Apellido_Med + ', ' + Nombre_Med AS NombreCompleto 
    FROM Medicos 
    WHERE Id_Especialidad_Med = @IdEspecialidad 
      AND Estado_Med = 1
    ORDER BY Apellido_Med ASC;
END;
GO

-- LISTAR TODOS LOS MÉDICOS
CREATE OR ALTER PROCEDURE SP_ListarMedicos
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        M.Legajo_Med AS Legajo,
        M.Dni_Med AS DNI,
        M.Apellido_Med AS Apellido,
        M.Nombre_Med AS Nombre,
        E.Descripcion_Esp AS Especialidad,
        M.CorreoElectronico_Med AS Correo,
        M.Telefono_Med AS Telefono,
        CASE 
            WHEN M.Estado_Med = 1 THEN 'Activo'
            ELSE 'Inactivo'
        END AS Estado
    FROM Medicos M
    INNER JOIN Especialidades E 
        ON M.Id_Especialidad_Med = E.Id_Especialidad
    ORDER BY M.Apellido_Med, M.Nombre_Med;
END;
GO

-- BUSCAR MÉDICOS POR LEGAJO, DNI, NOMBRE O APELLIDO
IF OBJECT_ID('SP_BuscarMedicos', 'P') IS NOT NULL
    DROP PROCEDURE SP_BuscarMedicos;
GO

CREATE OR ALTER PROCEDURE SP_BuscarMedicos
    @Texto VARCHAR(100),
    @IdEspecialidad INT,
    @Estado INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        M.Legajo_Med AS Legajo,
        M.Dni_Med AS DNI,
        M.Apellido_Med AS Apellido,
        M.Nombre_Med AS Nombre,
        E.Descripcion_Esp AS Especialidad,
        M.CorreoElectronico_Med AS Correo,
        M.Telefono_Med AS Telefono,
        CASE 
            WHEN M.Estado_Med = 1 THEN 'Activo'
            ELSE 'Inactivo'
        END AS Estado
    FROM Medicos M
    INNER JOIN Especialidades E 
        ON M.Id_Especialidad_Med = E.Id_Especialidad
    WHERE
        (
            @Texto = ''
            OR M.Legajo_Med LIKE '%' + @Texto + '%'
            OR M.Dni_Med LIKE '%' + @Texto + '%'
            OR M.Nombre_Med LIKE '%' + @Texto + '%'
            OR M.Apellido_Med LIKE '%' + @Texto + '%'
        )
        AND (@IdEspecialidad = 0 OR M.Id_Especialidad_Med = @IdEspecialidad)
        AND (@Estado = -1 OR M.Estado_Med = @Estado)
    ORDER BY M.Apellido_Med, M.Nombre_Med;
END;
GO
-- VALIDAR MÉDICO REPETIDO POR LEGAJO O DNI
IF OBJECT_ID('SP_ExisteMedicoPorLegajoODni', 'P') IS NOT NULL
    DROP PROCEDURE SP_ExisteMedicoPorLegajoODni;
GO

CREATE OR ALTER PROCEDURE SP_ExisteMedicoPorLegajoODni
    @Legajo_Med CHAR(7),
    @Dni_Med VARCHAR(20)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT COUNT(*) AS Cantidad
    FROM Medicos
    WHERE Legajo_Med = @Legajo_Med
       OR Dni_Med = @Dni_Med;
END;
GO

-- INFORME AVANZADO DE ASISTENCIAS
IF OBJECT_ID('SP_Informe_AsistenciaAvanzado', 'P') IS NULL
    EXEC('CREATE PROCEDURE SP_Informe_AsistenciaAvanzado AS BEGIN SELECT 1 END');
GO
ALTER PROCEDURE SP_Informe_AsistenciaAvanzado
    @FechaDesde DATE,
    @FechaHasta DATE,
    @IdEspecialidad INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        M.Apellido_Med + ', ' + M.Nombre_Med AS Medico,
        E.Descripcion_Esp AS Especialidad,
        COUNT(T.Id_Turno) AS Turnos_Asignados,
        SUM(CASE WHEN T.Asistencia = 'Presente'  THEN 1 ELSE 0 END) AS Presentes,
        SUM(CASE WHEN T.Asistencia = 'Ausente'   THEN 1 ELSE 0 END) AS Ausentes,
        SUM(CASE WHEN T.Asistencia = 'Pendiente' THEN 1 ELSE 0 END) AS Pendientes,
        CASE
            WHEN SUM(CASE WHEN T.Asistencia IN ('Presente','Ausente') THEN 1 ELSE 0 END) > 0
            THEN CAST(
                    SUM(CASE WHEN T.Asistencia = 'Presente' THEN 1.0 ELSE 0.0 END)
                    / SUM(CASE WHEN T.Asistencia IN ('Presente','Ausente') THEN 1.0 ELSE 0.0 END)
                    * 100 AS DECIMAL(5,2)
                 )
            ELSE 0
        END AS Porcentaje_Presentes,
        CASE
            WHEN SUM(CASE WHEN T.Asistencia IN ('Presente','Ausente') THEN 1 ELSE 0 END) > 0
            THEN CAST(
                    SUM(CASE WHEN T.Asistencia = 'Ausente' THEN 1.0 ELSE 0.0 END)
                    / SUM(CASE WHEN T.Asistencia IN ('Presente','Ausente') THEN 1.0 ELSE 0.0 END)
                    * 100 AS DECIMAL(5,2)
                 )
            ELSE 0
        END AS Porcentaje_Ausentes
    FROM Turnos T
    INNER JOIN Medicos M       ON T.Leg_Medico = M.Legajo_Med
    INNER JOIN Especialidades E ON M.Id_Especialidad_Med = E.Id_Especialidad
    WHERE
        T.Estado_Tur = 1
        AND (@FechaDesde IS NULL OR T.Fecha_Tur >= @FechaDesde)
        AND (@FechaHasta IS NULL OR T.Fecha_Tur <= @FechaHasta)
        AND (@IdEspecialidad = 0 OR E.Id_Especialidad = @IdEspecialidad)
    GROUP BY
        M.Apellido_Med, M.Nombre_Med, E.Descripcion_Esp
    ORDER BY
        E.Descripcion_Esp ASC, M.Apellido_Med ASC;
END;
GO

--INFORME AVANZADO DE PACIENTES
CREATE OR ALTER PROCEDURE SP_Informe_PacientesPorAsistencia
    @FechaDesde DATE,
    @FechaHasta DATE
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        P.Dni_Pac AS DNI,
        P.Apellido_Pac + ', ' + P.Nombre_Pac AS Paciente,
        SUM(CASE WHEN T.Asistencia = 'Presente' THEN 1 ELSE 0 END) AS Veces_Presente,
        SUM(CASE WHEN T.Asistencia = 'Ausente'  THEN 1 ELSE 0 END) AS Veces_Ausente,
        COUNT(T.Id_Turno) AS Turnos_Cerrados,
        CAST(
            SUM(CASE WHEN T.Asistencia = 'Presente' THEN 1.0 ELSE 0.0 END)
            / COUNT(T.Id_Turno) * 100 AS DECIMAL(5,2)
        ) AS Porcentaje_Asistencia
    FROM Turnos T
    INNER JOIN Pacientes P ON T.Dni_Paciente = P.Dni_Pac
    WHERE
        T.Estado_Tur = 1
        AND T.Asistencia IN ('Presente','Ausente')   -- solo turnos cerrados
        AND (@FechaDesde IS NULL OR T.Fecha_Tur >= @FechaDesde)
        AND (@FechaHasta IS NULL OR T.Fecha_Tur <= @FechaHasta)
    GROUP BY P.Dni_Pac, P.Apellido_Pac, P.Nombre_Pac
    ORDER BY Porcentaje_Asistencia DESC, Paciente ASC;
END;
GO


-- INFORME DE ESPECIALIDADES MAS SOLICITADAS

CREATE OR ALTER PROCEDURE SP_Informe_EspecialidadesMasSolicitadas
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        E.Descripcion_Esp AS Especialidad,
        COUNT(T.Id_Turno) AS Total_Turnos,
        COUNT(DISTINCT M.Legajo_Med) AS Medicos_Activos
    FROM Especialidades E
    LEFT JOIN Medicos M
        ON M.Id_Especialidad_Med = E.Id_Especialidad
        AND M.Estado_Med = 1
    LEFT JOIN Turnos T
        ON T.Leg_Medico = M.Legajo_Med
        AND T.Estado_Tur = 1
    GROUP BY E.Descripcion_Esp
    ORDER BY Total_Turnos DESC, Especialidad ASC;
END;
GO

IF OBJECT_ID('SP_AgregarMedico', 'P') IS NOT NULL
    DROP PROCEDURE SP_AgregarMedico;
GO

CREATE OR ALTER PROCEDURE SP_AgregarMedico
    @Legajo_Med CHAR(7),
    @Dni_Med VARCHAR(20),
    @Nombre_Med VARCHAR(100),
    @Apellido_Med VARCHAR(100),
    @Sexo_Med VARCHAR(20),
    @Nacionalidad_Med VARCHAR(100),
    @FechaNacimiento_Med DATE,
    @Direccion_Med VARCHAR(150),
    @Id_Localidad_Med INT,
    @CorreoElectronico_Med VARCHAR(100),
    @Telefono_Med VARCHAR(50),
    @Id_Especialidad_Med INT
AS
BEGIN
   

    INSERT INTO Medicos
    (
        Legajo_Med,
        Dni_Med,
        Nombre_Med,
        Apellido_Med,
        Sexo_Med,
        Nacionalidad_Med,
        FechaNacimiento_Med,
        Direccion_Med,
        Id_Localidad_Med,
        CorreoElectronico_Med,
        Telefono_Med,
        Id_Especialidad_Med,
        Estado_Med
    )
    VALUES
    (
        @Legajo_Med,
        @Dni_Med,
        @Nombre_Med,
        @Apellido_Med,
        @Sexo_Med,
        @Nacionalidad_Med,
        @FechaNacimiento_Med,
        @Direccion_Med,
        @Id_Localidad_Med,
        @CorreoElectronico_Med,
        @Telefono_Med,
        @Id_Especialidad_Med,
        1
    );
END;
GO


-- Listar Pacientes
USE ClinicaMedica;
GO

CREATE OR ALTER PROCEDURE SP_ListarPacientes
AS
BEGIN
    SET NOCOUNT ON;
    SELECT 
        P.Dni_Pac AS DNI, 
        P.Nombre_Pac AS Nombre, 
        P.Apellido_Pac AS Apellido, 
        P.Sexo_Pac AS Sexo, 
        P.Nacionalidad_Pac AS Nacionalidad, 
        CONVERT(VARCHAR, P.FechaNacimiento_Pac, 103) AS [Fecha de Nacimiento], 
        P.Direccion_Pac AS Dirección, 
        Pr.Descripcion_Prov AS Provincia,
        L.Descripcion_Loc AS Localidad,
        P.Id_Localidad_Pac AS IdLocalidad,
        P.CorreoElectronico_Pac AS [Correo Electrónico], 
        P.Telefono_Pac AS Teléfono,
        CASE WHEN P.Estado_Pac = 1 THEN 'Activo' ELSE 'Inactivo' END AS Estado
    FROM Pacientes P
    INNER JOIN Localidades L ON P.Id_Localidad_Pac = L.Id_Localidad
    INNER JOIN Provincias Pr ON L.Id_Provincia_Loc = Pr.Id_Provincia;
END;
GO

-- Filtrar Pacientes (Por DNI,, nombre o apellido)

USE ClinicaMedica;
GO

CREATE OR ALTER PROCEDURE SP_FiltrarPacientes
    @Busqueda VARCHAR(50),
    @Sexo VARCHAR(20) = '',
    @Estado INT = -1
AS
BEGIN
    SELECT 
        P.Dni_Pac AS [DNI],
        P.Nombre_Pac AS [Nombre],
        P.Apellido_Pac AS [Apellido],
        P.Sexo_Pac AS [Sexo],
        P.Nacionalidad_Pac AS [Nacionalidad],
        CONVERT(VARCHAR, P.FechaNacimiento_Pac, 103) AS [Fecha de Nacimiento],
        P.Direccion_Pac AS [Dirección],
        PR.Descripcion_Prov AS [Provincia],
        L.Descripcion_Loc AS [Localidad], 
        P.Id_Localidad_Pac AS [IdLocalidad],
        P.CorreoElectronico_Pac AS [Correo Electrónico],
        P.Telefono_Pac AS [Teléfono],
        CASE WHEN P.Estado_Pac = 1 THEN 'Activo' ELSE 'Inactivo' END AS [Estado]
    FROM Pacientes AS P
    INNER JOIN Localidades AS L ON P.Id_Localidad_Pac = L.Id_Localidad
    INNER JOIN Provincias AS PR ON L.Id_Provincia_Loc = PR.Id_Provincia
    WHERE 
        (P.Dni_Pac LIKE '%' + @Busqueda + '%' OR
         P.Nombre_Pac LIKE '%' + @Busqueda + '%' OR
         P.Apellido_Pac LIKE '%' + @Busqueda + '%') 
        AND (@Sexo = '' OR P.Sexo_Pac = @Sexo)
        AND (@Estado = -1 OR P.Estado_Pac = @Estado);
END;
GO

-- Listar Provincias
USE ClinicaMedica;
GO

CREATE OR ALTER PROCEDURE SP_ListarProvincias
AS
BEGIN
    SET NOCOUNT ON;
    SELECT Id_Provincia, Descripcion_Prov
    FROM Provincias
    ORDER BY Descripcion_Prov;
END;
GO


-- Listar localidades
USE ClinicaMedica;
GO

CREATE OR ALTER PROCEDURE SP_ListarLocalidadesPorProvincia
    @Id_Provincia INT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT Id_Localidad, Descripcion_Loc
    FROM Localidades
    WHERE Id_Provincia_Loc = @Id_Provincia
    ORDER BY Descripcion_Loc;
END;
GO

-- Alta Paciente
USE ClinicaMedica;
GO

CREATE OR ALTER PROCEDURE SP_AltaPaciente
    @Dni VARCHAR(20),
    @Nombre VARCHAR(100),
    @Apellido VARCHAR(100),
    @Sexo VARCHAR(20),
    @Nacionalidad VARCHAR(100),
    @FechaNacimiento DATE,
    @Direccion VARCHAR(150),
    @Id_Localidad INT,
    @CorreoElectronico VARCHAR(100),
    @Telefono VARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (SELECT 1 FROM Pacientes WHERE Dni_Pac = @Dni)
    BEGIN
        RAISERROR('Ya existe un paciente registrado con ese DNI.', 16, 1);
        RETURN;
    END

    INSERT INTO Pacientes (
        Dni_Pac, Nombre_Pac, Apellido_Pac, Sexo_Pac, Nacionalidad_Pac,
        FechaNacimiento_Pac, Direccion_Pac, Id_Localidad_Pac,
        CorreoElectronico_Pac, Telefono_Pac, Estado_Pac
    )
    VALUES (
        @Dni, @Nombre, @Apellido, @Sexo, @Nacionalidad,
        @FechaNacimiento, @Direccion, @Id_Localidad,
        @CorreoElectronico, @Telefono, 1
    );
END;
GO

--Modificar Paciente
USE ClinicaMedica;
GO

CREATE OR ALTER PROCEDURE SP_ModificarPaciente
    @Dni VARCHAR(20),
    @Nombre VARCHAR(100),
    @Apellido VARCHAR(100),
    @Sexo VARCHAR(20),
    @Nacionalidad VARCHAR(100),
    @FechaNacimiento DATE,
    @Direccion VARCHAR(150),
    @Id_Localidad INT,
    @CorreoElectronico VARCHAR(100),
    @Telefono VARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE Pacientes
    SET Nombre_Pac = @Nombre,
        Apellido_Pac = @Apellido,
        Sexo_Pac = @Sexo,
        Nacionalidad_Pac = @Nacionalidad,
        FechaNacimiento_Pac = @FechaNacimiento,
        Direccion_Pac = @Direccion,
        Id_Localidad_Pac = @Id_Localidad,
        CorreoElectronico_Pac = @CorreoElectronico,
        Telefono_Pac = @Telefono
    WHERE Dni_Pac = @Dni;
END;
GO

--Baja Logica Paciente
USE ClinicaMedica;
GO

CREATE OR ALTER PROCEDURE SP_BajaPaciente
    @Dni VARCHAR(20)
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE Pacientes
    SET Estado_Pac = 0
    WHERE Dni_Pac = @Dni;
END;
GO

--Reactivar Paciente

USE ClinicaMedica;
GO

CREATE OR ALTER PROCEDURE SP_ReactivarPaciente
    @Dni VARCHAR(20)
AS
BEGIN
    UPDATE Pacientes
    SET Estado_Pac = 1
    WHERE Dni_Pac = @Dni;
END;
GO


--BajaMedico
IF OBJECT_ID('SP_BajaLogicaMedico', 'P') IS NOT NULL
    DROP PROCEDURE SP_BajaLogicaMedico;
GO

CREATE OR ALTER PROCEDURE SP_BajaLogicaMedico
    @Legajo_Med CHAR(7)
AS
BEGIN

    UPDATE Medicos
    SET Estado_Med = 0
    WHERE Legajo_Med = @Legajo_Med;

    UPDATE Usuarios
    SET Activo = 0
    WHERE Legajo_Med = @Legajo_Med;
END;
GO

--Reactivar Medico

USE ClinicaMedica;
GO

CREATE OR ALTER PROCEDURE SP_ReactivarMedico
    @Legajo_Med CHAR(7)
AS
BEGIN

    UPDATE Medicos
    SET Estado_Med = 1
    WHERE Legajo_Med = @Legajo_Med;

    UPDATE Usuarios
    SET Activo = 1
    WHERE Legajo_Med = @Legajo_Med;
END;
GO

--Modificar Medico
IF OBJECT_ID('SP_ModificarMedico', 'P') IS NOT NULL
    DROP PROCEDURE SP_ModificarMedico;
GO

CREATE OR ALTER PROCEDURE SP_ModificarMedico
    @Legajo_Med CHAR(7),
    @Dni_Med VARCHAR(20),
    @Nombre_Med VARCHAR(100),
    @Apellido_Med VARCHAR(100),
    @Sexo_Med VARCHAR(20),
    @Nacionalidad_Med VARCHAR(100),
    @FechaNacimiento_Med DATE,
    @Direccion_Med VARCHAR(150),
    @Id_Localidad_Med INT,
    @CorreoElectronico_Med VARCHAR(100),
    @Telefono_Med VARCHAR(50),
    @Id_Especialidad_Med INT
AS
BEGIN
   

    UPDATE Medicos
    SET
        Dni_Med = @Dni_Med,
        Nombre_Med = @Nombre_Med,
        Apellido_Med = @Apellido_Med,
        Sexo_Med = @Sexo_Med,
        Nacionalidad_Med = @Nacionalidad_Med,
        FechaNacimiento_Med = @FechaNacimiento_Med,
        Direccion_Med = @Direccion_Med,
        Id_Localidad_Med = @Id_Localidad_Med,
        CorreoElectronico_Med = @CorreoElectronico_Med,
        Telefono_Med = @Telefono_Med,
        Id_Especialidad_Med = @Id_Especialidad_Med
    WHERE Legajo_Med = @Legajo_Med;
END;
GO

--Obtener Medico Por legajo
IF OBJECT_ID('SP_ObtenerMedicoPorLegajo', 'P') IS NOT NULL
    DROP PROCEDURE SP_ObtenerMedicoPorLegajo;
GO

CREATE OR ALTER PROCEDURE SP_ObtenerMedicoPorLegajo
    @Legajo_Med CHAR(7)
AS
BEGIN
   

    SELECT
        M.Legajo_Med,
        M.Dni_Med,
        M.Nombre_Med,
        M.Apellido_Med,
        M.Sexo_Med,
        M.Nacionalidad_Med,
        M.FechaNacimiento_Med,
        M.Direccion_Med,
        M.Id_Localidad_Med,
        L.Id_Provincia_Loc,
        M.CorreoElectronico_Med,
        M.Telefono_Med,
        M.Id_Especialidad_Med,
        M.Estado_Med
    FROM Medicos M
    INNER JOIN Localidades L ON M.Id_Localidad_Med = L.Id_Localidad
    WHERE M.Legajo_Med = @Legajo_Med;
END;
GO

-- =======================================================
-- AGENDA DE MÉDICOS (Días y Horarios de Atención)
-- =======================================================

-- Listar días de la semana
IF OBJECT_ID('SP_ListarDiasSemana', 'P') IS NOT NULL
    DROP PROCEDURE SP_ListarDiasSemana;
GO

CREATE OR ALTER PROCEDURE SP_ListarDiasSemana
AS
BEGIN
    SET NOCOUNT ON;

    SELECT Id_Dia, Descripcion_Dia
    FROM DiasSemana
    ORDER BY Id_Dia;
END;
GO

-- Listar franjas horarias de atención
IF OBJECT_ID('SP_ListarHorariosAtencion', 'P') IS NOT NULL
    DROP PROCEDURE SP_ListarHorariosAtencion;
GO

CREATE OR ALTER PROCEDURE SP_ListarHorariosAtencion
AS
BEGIN
    SET NOCOUNT ON;

SELECT
        Id_Horario,
        RIGHT('0' + CAST(HoraInicio AS VARCHAR(2)), 2) + ':00 - ' +
        RIGHT('0' + CAST(HoraFin AS VARCHAR(2)), 2) + ':00' AS DescripcionHorario
    FROM HorariosAtencion
   
    ORDER BY HoraInicio;
END;
GO

-- Agregar un horario de atención a un médico
IF OBJECT_ID('SP_AgregarHorarioMedico', 'P') IS NOT NULL
    DROP PROCEDURE SP_AgregarHorarioMedico;
GO

CREATE OR ALTER PROCEDURE SP_AgregarHorarioMedico
    @Leg_Medico CHAR(7),
    @Id_Dia INT,
    @Id_Horario CHAR(5)
AS
BEGIN
   

    INSERT INTO Horarios_Medicos (Leg_Medico, Id_Dia, Id_Horario)
    VALUES (@Leg_Medico, @Id_Dia, @Id_Horario);
END;
GO
--Elina horarios de un medico
IF OBJECT_ID('SP_EliminarHorarioMedico', 'P') IS NULL
    EXEC('CREATE PROCEDURE SP_EliminarHorarioMedico AS BEGIN SELECT 1 END');
GO

ALTER PROCEDURE SP_EliminarHorarioMedico
    @Leg_Medico CHAR(7),
    @Id_Dia INT,
    @Id_Horario CHAR(5)
AS
BEGIN
    DELETE FROM Horarios_Medicos
    WHERE Leg_Medico = @Leg_Medico
      AND Id_Dia = @Id_Dia
      AND Id_Horario = @Id_Horario;
END;
GO
-- Listar la agenda de un médico
IF OBJECT_ID('SP_ListarHorariosPorMedico', 'P') IS NOT NULL
    DROP PROCEDURE SP_ListarHorariosPorMedico;
GO

CREATE OR ALTER PROCEDURE SP_ListarHorariosPorMedico
    @Leg_Medico CHAR(7)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        HM.Leg_Medico,
        HM.Id_Dia,
        DS.Descripcion_Dia,
        HM.Id_Horario,
        RIGHT('0' + CAST(HA.HoraInicio AS VARCHAR(2)), 2) + ':00 - ' +
        RIGHT('0' + CAST(HA.HoraFin AS VARCHAR(2)), 2) + ':00' AS Horario
    FROM Horarios_Medicos HM
    INNER JOIN DiasSemana DS ON HM.Id_Dia = DS.Id_Dia
    INNER JOIN HorariosAtencion HA ON HM.Id_Horario = HA.Id_Horario
    WHERE HM.Leg_Medico = @Leg_Medico
    ORDER BY HM.Id_Dia, HA.HoraInicio;
END;
GO

-- Verificar si un médico ya tiene asignado un día/horario
IF OBJECT_ID('SP_ExisteHorarioMedico', 'P') IS NOT NULL
    DROP PROCEDURE SP_ExisteHorarioMedico;
GO

CREATE OR ALTER PROCEDURE SP_ExisteHorarioMedico
    @Leg_Medico CHAR(7),
    @Id_Dia INT,
    @Id_Horario CHAR(5)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT COUNT(*) AS Cantidad
    FROM Horarios_Medicos
    WHERE Leg_Medico = @Leg_Medico
      AND Id_Dia = @Id_Dia
      AND Id_Horario = @Id_Horario;
END;
GO


--    V27    --

USE ClinicaMedica
go



CREATE OR ALTER PROCEDURE SP_ObtenerTurnosPorDni
    @Dni_Paciente VARCHAR(20)
AS
BEGIN
    -- Devuelve solo los turnos ACCIONABLES desde la pantalla de gestion:
    -- activos (baja logica), aun Pendientes y con fecha/hora futura.
    -- Los turnos ya atendidos o vencidos se consultan por el medico o informes.
    SELECT 
        T.Id_Turno,
        CONVERT(VARCHAR(10), T.Fecha_Tur, 103) AS Fecha,
        CONVERT(VARCHAR(5), T.Hora_Tur, 108) AS Hora,
        M.Nombre_Med + ' ' + M.Apellido_Med AS Medico,
        E.Descripcion_Esp AS Especialidad
    FROM Turnos T
    INNER JOIN Medicos M ON T.Leg_Medico = M.Legajo_Med
    INNER JOIN Especialidades E ON M.Id_Especialidad_Med = E.Id_Especialidad
    WHERE T.Dni_Paciente = @Dni_Paciente 
      AND T.Estado_Tur = 1 
      AND T.Asistencia = 'Pendiente'
      AND CAST(T.Fecha_Tur AS DATETIME) + CAST(T.Hora_Tur AS DATETIME) >= GETDATE()
END
go


CREATE OR ALTER PROCEDURE SP_CancelarTurno
    @Id_Turno INT
AS
BEGIN
    UPDATE Turnos
    SET Estado_Tur = 0
    WHERE Id_Turno = @Id_Turno
END
GO

CREATE OR ALTER PROCEDURE SP_ObtenerTurnosOcupados
    @Leg_Medico CHAR(7)
AS
BEGIN
    SELECT 
        Fecha_Tur AS Fecha, 
        CONVERT(VARCHAR(5), Hora_Tur, 108) AS Hora
    FROM Turnos
    WHERE Leg_Medico = @Leg_Medico 
      AND Estado_Tur = 1 
END
GO

CREATE OR ALTER PROCEDURE SP_TraerTurnosMedico
    @Leg_Medico CHAR(7)
AS
BEGIN
    
    SELECT Fecha_Tur AS Fecha, CONVERT(VARCHAR(5), Hora_Tur, 108) AS Hora
    FROM Turnos
    WHERE Leg_Medico = @Leg_Medico 
      AND Estado_Tur = 1 
END
GO

CREATE OR ALTER PROCEDURE SP_ReservarTurno
    @Leg_Medico CHAR(7),
    @Dni_Paciente VARCHAR(20),
    @Fecha_Tur DATE,
    @Hora_Tur TIME
AS
BEGIN
   
    UPDATE Turnos 
    SET Dni_Paciente = @Dni_Paciente, 
        Estado_Tur = 1
    WHERE Leg_Medico = @Leg_Medico 
      AND Fecha_Tur = @Fecha_Tur 
      AND Hora_Tur = @Hora_Tur
     
      AND Estado_Tur = 0 

    
    IF @@ROWCOUNT = 0
    BEGIN
        INSERT INTO Turnos (Leg_Medico, Dni_Paciente, Fecha_Tur, Hora_Tur, Estado_Tur)
        VALUES (@Leg_Medico, @Dni_Paciente, @Fecha_Tur, @Hora_Tur, 1)
    END
END
GO

--   V29   --

CREATE OR ALTER PROCEDURE sp_ObtenerTurnosPorMedico
    @LegajoMedico CHAR(7),
    @BusquedaPaciente VARCHAR(100) = NULL, -- Puede ser DNI o nombre
    @FechaDesde DATE = NULL,
    @FechaHasta DATE = NULL
AS
BEGIN
    SELECT 
        T.Id_Turno,
        T.Fecha_Tur AS Fecha,
        T.Hora_Tur AS Hora,
        P.Nombre_Pac + ' ' + P.Apellido_Pac AS NombreCompletoPaciente,
        T.Asistencia,
        T.Observaciones
    FROM Turnos T
    INNER JOIN Pacientes P ON T.Dni_Paciente = P.Dni_Pac
    WHERE T.Leg_Medico = @LegajoMedico
      AND T.Estado_Tur = 1 -- Solo turnos activos
      -- Filtro dinámico por Paciente (busca por DNI o Nombre/Apellido)
      AND (@BusquedaPaciente IS NULL OR 
           P.Dni_Pac LIKE '%' + @BusquedaPaciente + '%' OR 
           P.Nombre_Pac LIKE '%' + @BusquedaPaciente + '%' OR 
           P.Apellido_Pac LIKE '%' + @BusquedaPaciente + '%')
      -- Filtro dinámico por Fechas
      AND (@FechaDesde IS NULL OR T.Fecha_Tur >= @FechaDesde)
      AND (@FechaHasta IS NULL OR T.Fecha_Tur <= @FechaHasta)
    ORDER BY T.Fecha_Tur, T.Hora_Tur;
END
GO

CREATE OR ALTER PROCEDURE SP_ModificarTurno
    @Id_Turno INT,
    @Asistencia VARCHAR(15),
    @Observaciones VARCHAR(500)
AS
BEGIN
    UPDATE Turnos 
    SET Asistencia = @Asistencia, 
        Observaciones = @Observaciones
    WHERE Id_Turno = @Id_Turno
END
GO


   -- SP FALTANTES TURNOS

USE ClinicaMedica;
GO


CREATE OR ALTER PROCEDURE SP_ReactivarPaciente
    @Dni VARCHAR(20)
AS
BEGIN
    UPDATE Pacientes
    SET Estado_Pac = 1
    WHERE Dni_Pac = @Dni;
END;
GO


CREATE OR ALTER PROCEDURE SP_ReactivarMedico
    @Legajo_Med CHAR(7)
AS
BEGIN

    UPDATE Medicos
    SET Estado_Med = 1
    WHERE Legajo_Med = @Legajo_Med;

    UPDATE Usuarios
    SET Activo = 1
    WHERE Legajo_Med = @Legajo_Med;
END;
GO


CREATE OR ALTER PROCEDURE SP_TraerHorariosMedico
    @Leg_Medico CHAR(7)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        HM.Id_Dia,
        RIGHT('0' + CAST(HA.HoraInicio AS VARCHAR(2)), 2) + ':00' AS Hora
    FROM Horarios_Medicos HM
    INNER JOIN HorariosAtencion HA ON HM.Id_Horario = HA.Id_Horario
    WHERE HM.Leg_Medico = @Leg_Medico
    ORDER BY HM.Id_Dia, HA.HoraInicio;
END;
GO
-- CREAR USUARIO PARA MÉDICO
IF OBJECT_ID('SP_AgregarUsuarioMedico', 'P') IS NULL
    EXEC('CREATE PROCEDURE SP_AgregarUsuarioMedico AS BEGIN SELECT 1 END');
GO

ALTER PROCEDURE SP_AgregarUsuarioMedico
    @NombreUsuario VARCHAR(50),
    @Contrasena VARCHAR(30),
    @Legajo_Med CHAR(7)
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM Usuarios
        WHERE NombreUsuario = @NombreUsuario
    )
    BEGIN
        RETURN;
    END

    INSERT INTO Usuarios
    (
        NombreUsuario,
        Contrasena,
        TipoUsuario,
        Legajo_Med,
        Activo
    )
    VALUES
    (
        @NombreUsuario,
        @Contrasena,
        'Medico',
        @Legajo_Med,
        1
    );
END;
GO


-- VERIFICAR SI UN MÉDICO YA TIENE USUARIO
IF OBJECT_ID('SP_ExisteUsuarioParaMedico', 'P') IS NULL
    EXEC('CREATE PROCEDURE SP_ExisteUsuarioParaMedico AS BEGIN SELECT 1 END');
GO

ALTER PROCEDURE SP_ExisteUsuarioParaMedico
    @Legajo_Med CHAR(7)
AS
BEGIN
    SELECT COUNT(*) AS Cantidad
    FROM Usuarios
    WHERE Legajo_Med = @Legajo_Med
      AND Activo = 1;
END;
GO
-- VERIFICAR SI YA EXISTE UN NOMBRE DE USUARIO
IF OBJECT_ID('SP_ExisteUsuario', 'P') IS NULL
    EXEC('CREATE PROCEDURE SP_ExisteUsuario AS BEGIN SELECT 1 END');
GO

ALTER PROCEDURE SP_ExisteUsuario
    @NombreUsuario VARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT COUNT(*) AS Cantidad
    FROM Usuarios
    WHERE NombreUsuario = @NombreUsuario;
END;
GO

-- VALIDAR USUARIO
IF OBJECT_ID('SP_ValidarUsuario', 'P') IS NULL
    EXEC('CREATE PROCEDURE SP_ValidarUsuario AS BEGIN SELECT 1 END');
GO



ALTER PROCEDURE SP_ValidarUsuario
    @NombreUsuario VARCHAR(50),
    @Contrasena    VARCHAR(30)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        U.Id_Usuario,
        U.NombreUsuario,
        U.Contrasena,
        U.TipoUsuario,
        U.Legajo_Med,
        U.Legajo_Adm,
        U.Activo,
        COALESCE(
            M.Nombre_Med + ' ' + M.Apellido_Med,
            A.Nombre_Adm + ' ' + A.Apellido_Adm,
            U.NombreUsuario
        ) AS NombreCompleto
    FROM Usuarios U
    LEFT JOIN Medicos M ON U.Legajo_Med = M.Legajo_Med
    LEFT JOIN Administradores A ON U.Legajo_Adm = A.Legajo_Adm
    WHERE U.NombreUsuario COLLATE Latin1_General_CS_AS = @NombreUsuario COLLATE Latin1_General_CS_AS
      AND U.Contrasena COLLATE Latin1_General_CS_AS = @Contrasena COLLATE Latin1_General_CS_AS
      AND U.Activo = 1;
END;
GO
-- MODIFICAR USUARIO DE MÉDICO
CREATE OR ALTER PROCEDURE SP_ModificarUsuarioMedico
    @NombreUsuario VARCHAR(50),
    @Contrasena VARCHAR(30),
    @Legajo_Med CHAR(7)
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (
        SELECT 1
        FROM Usuarios
        WHERE NombreUsuario = @NombreUsuario
          AND (Legajo_Med IS NULL OR Legajo_Med <> @Legajo_Med)
          AND Activo = 1
    )
    BEGIN
        SELECT -2 AS Resultado;
        RETURN;
    END

    UPDATE Usuarios
    SET NombreUsuario = @NombreUsuario,
        Contrasena = @Contrasena
    WHERE Legajo_Med = @Legajo_Med
      AND Activo = 1;

    SELECT @@ROWCOUNT AS Resultado;
END;
GO

--obtener usuario por medico
IF OBJECT_ID('SP_ObtenerUsuarioPorMedico', 'P') IS NULL
    EXEC('CREATE PROCEDURE SP_ObtenerUsuarioPorMedico AS BEGIN SELECT 1 END');
GO

ALTER PROCEDURE SP_ObtenerUsuarioPorMedico
    @Legajo_Med CHAR(7)
AS
BEGIN
    SELECT NombreUsuario
    FROM Usuarios
    WHERE Legajo_Med = @Legajo_Med
      AND Activo = 1;
END;
GO
-- =====================================================================
-- AGENDA DE TURNOS (agenda completa del medico por 30 dias)
-- Genera un calendario de 30 dias con CTE recursiva, lo cruza con la
-- agenda del medico y marca cada franja como ocupada si existe un
-- turno ACTIVO en esa fecha/hora. Excluye franjas ya pasadas de hoy.
-- =====================================================================
IF OBJECT_ID('SP_ObtenerAgendaCompleta', 'P') IS NULL
    EXEC('CREATE PROCEDURE SP_ObtenerAgendaCompleta AS BEGIN SELECT 1 END');
GO

ALTER PROCEDURE SP_ObtenerAgendaCompleta
    @Leg_Medico CHAR(7)
AS
BEGIN
    SET NOCOUNT ON;
    SET DATEFIRST 1;

    ;WITH Numeros AS (
        SELECT 0 AS n UNION ALL SELECT n + 1 FROM Numeros WHERE n < 29
    ),
    Calendario AS (
        SELECT DATEADD(day, n, CAST(GETDATE() AS DATE)) AS Fecha
        FROM Numeros
    )
    SELECT 
        DS.Descripcion_Dia AS DiaSemana,
        CONVERT(VARCHAR(10), c.Fecha, 103) AS Fecha, 
        c.Fecha AS FechaFiltro, 
        RIGHT('0' + CAST(HA.HoraInicio AS VARCHAR(2)), 2) + ':00' AS Hora,
        CASE WHEN T.Id_Turno IS NULL THEN 0 ELSE 1 END AS Ocupado
    FROM Calendario c
    INNER JOIN DiasSemana DS ON DATEPART(dw, c.Fecha) = DS.Id_Dia
    INNER JOIN Horarios_Medicos HM ON DS.Id_Dia = HM.Id_Dia
    INNER JOIN HorariosAtencion HA ON HM.Id_Horario = HA.Id_Horario
    LEFT JOIN Turnos T ON T.Fecha_Tur = c.Fecha 
                      AND T.Hora_Tur = CAST(RIGHT('0' + CAST(HA.HoraInicio AS VARCHAR(2)), 2) + ':00:00' AS TIME)
                      AND T.Leg_Medico = HM.Leg_Medico
                      AND T.Estado_Tur = 1
    WHERE HM.Leg_Medico = @Leg_Medico
      AND DS.Descripcion_Dia <> 'Domingo'
     AND DATEADD(HOUR, CAST(HA.HoraInicio AS INT), CAST(c.Fecha AS DATETIME)) >= GETDATE()
    ORDER BY c.Fecha, HA.HoraInicio;
END
GO

CREATE OR ALTER PROCEDURE SP_ObtenerHistorialTurnosPorDni
    @Dni_Paciente VARCHAR(20)
AS
BEGIN
    SELECT 
        T.Id_Turno,
        CONVERT(VARCHAR(10), T.Fecha_Tur, 103) AS Fecha,
        CONVERT(VARCHAR(5), T.Hora_Tur, 108) AS Hora,
        M.Nombre_Med + ' ' + M.Apellido_Med AS Medico,
        E.Descripcion_Esp AS Especialidad
    FROM Turnos T
    INNER JOIN Medicos M ON T.Leg_Medico = M.Legajo_Med
    INNER JOIN Especialidades E ON M.Id_Especialidad_Med = E.Id_Especialidad
    WHERE T.Dni_Paciente = @Dni_Paciente 
      AND T.Estado_Tur = 1          
      AND T.Asistencia = 'Presente'  
    ORDER BY T.Fecha_Tur DESC, T.Hora_Tur DESC;
END
GO
