USE ClinicaMedica;
GO

SET DATEFORMAT dmy;
GO

-- 1. Creamos una tabla temporal con la misma estructura
CREATE TABLE #TempPacientes (
    Dni_Pac VARCHAR(20),
    Nombre_Pac VARCHAR(100),
    Apellido_Pac VARCHAR(100),
    Sexo_Pac VARCHAR(20),
    Nacionalidad_Pac VARCHAR(100),
    FechaNacimiento_Pac DATE,
    Direccion_Pac VARCHAR(150),
    Id_Localidad_Pac INT,
    CorreoElectronico_Pac VARCHAR(100),
    Telefono_Pac VARCHAR(50),
    Estado_Pac BIT
);

-- 2. Insertamos todos los datos en la tabla temporal 
INSERT INTO #TempPacientes VALUES
('30000023', 'Emiliano', 'Martínez', 'Masculino', 'Argentina', '02/09/1992', 'Calle Mar de Ajó 23', (SELECT TOP 1 Id_Localidad FROM Localidades WHERE Id_Provincia_Loc = 1 AND Descripcion_Loc = 'Mar del Plata'), 'dibu.martinez@mail.com', '2234111111', 1),
('30000012', 'Gerónimo', 'Rulli', 'Masculino', 'Argentina', '20/05/1992', 'Calle 7 nro 123', (SELECT TOP 1 Id_Localidad FROM Localidades WHERE Id_Provincia_Loc = 1 AND Descripcion_Loc = 'La Plata'), 'gero.rulli@mail.com', '2214532211', 1),
('30000001', 'Juan', 'Musso', 'Masculino', 'Argentina', '06/05/1994', 'Av. San Martín 45', (SELECT TOP 1 Id_Localidad FROM Localidades WHERE Id_Provincia_Loc = 1 AND Descripcion_Loc = 'San Nicolás'), 'juan.musso@mail.com', '3364121212', 0),
('30000026', 'Nahuel', 'Molina', 'Masculino', 'Argentina', '06/04/1998', 'Av. Central 14', (SELECT TOP 1 Id_Localidad FROM Localidades WHERE Id_Provincia_Loc = 6 AND Descripcion_Loc = 'Río Tercero'), 'nahuel.molina@mail.com', '3571141414', 1),
('30000004', 'Gonzalo', 'Montiel', 'Masculino', 'Argentina', '01/01/1997', 'Calle California 88', (SELECT TOP 1 Id_Localidad FROM Localidades WHERE Id_Provincia_Loc = 1 AND Descripcion_Loc = '3 de febrero'), 'gonza.montiel@mail.com', '1115151515', 1),
('30000013', 'Cristian', 'Romero', 'Masculino', 'Argentina', '27/04/1998', 'Calle Duarte Quirós 1313', (SELECT TOP 1 Id_Localidad FROM Localidades WHERE Id_Provincia_Loc = 6 AND Descripcion_Loc = 'Córdoba'), 'cuti.romero@mail.com', '3514313131', 1),
('30000019', 'Nicolás', 'Otamendi', 'Masculino', 'Argentina', '12/02/1988', 'Ruta 202 nro 1919', (SELECT TOP 1 Id_Localidad FROM Localidades WHERE Id_Provincia_Loc = 1 AND Descripcion_Loc = 'Don Torcuato'), 'general.ota@mail.com', '1121919191', 0), 
('30000025', 'Lisandro', 'Martínez', 'Masculino', 'Argentina', '18/01/1998', 'Calle Urquiza 432', (SELECT TOP 1 Id_Localidad FROM Localidades WHERE Id_Provincia_Loc = 8 AND Descripcion_Loc = 'Gualeguay'), 'licha.m@mail.com', '3444191919', 1),
('30000002', 'Leonardo', 'Balerdi', 'Masculino', 'Argentina', '26/01/1999', 'Av. Mitre 77', (SELECT TOP 1 Id_Localidad FROM Localidades WHERE Id_Provincia_Loc = 19 AND Descripcion_Loc = 'Villa Mercedes'), 'leo.balerdi@mail.com', '2657181818', 1),
('30000014', 'Facundo', 'Medina', 'Masculino', 'Argentina', '28/05/1999', 'Av. Santa Fe 900', (SELECT TOP 1 Id_Localidad FROM Localidades WHERE Id_Provincia_Loc = 2 AND Descripcion_Loc = 'Palermo'), 'facu.medina@mail.com', '1119191919', 1),
('30000003', 'Nicolás', 'Tagliafico', 'Masculino', 'Argentina', '31/08/1992', 'Av. San Martín 12', (SELECT TOP 1 Id_Localidad FROM Localidades WHERE Id_Provincia_Loc = 1 AND Descripcion_Loc = '3 de febrero'), 'nico.taglia@mail.com', '1121212121', 0),
('30000007', 'Rodrigo', 'De Paul', 'Masculino', 'Argentina', '24/05/1994', 'Pasaje Motorcito 7', (SELECT TOP 1 Id_Localidad FROM Localidades WHERE Id_Provincia_Loc = 1 AND Descripcion_Loc = '3 de febrero'), 'rodri.depaul@mail.com', '1123232323', 1),
('30000005', 'Leandro', 'Paredes', 'Masculino', 'Argentina', '29/06/1994', 'Calle 25 de Mayo 44', (SELECT TOP 1 Id_Localidad FROM Localidades WHERE Id_Provincia_Loc = 21 AND Descripcion_Loc = 'San Justo'), 'leo.paredes@mail.com', '3498242424', 1),
('30000020', 'Alexis', 'Mac Allister', 'Masculino', 'Argentina', '24/12/1998', 'Av. Perón 321', (SELECT TOP 1 Id_Localidad FROM Localidades WHERE Id_Provincia_Loc = 11 AND Descripcion_Loc = 'Santa Rosa'), 'ale.mac@mail.com', '2954252525', 0), 
('30000024', 'Enzo', 'Fernández', 'Masculino', 'Argentina', '17/01/2001', 'Av. General Paz 123', (SELECT TOP 1 Id_Localidad FROM Localidades WHERE Id_Provincia_Loc = 1 AND Descripcion_Loc = '3 de febrero'), 'enzo.f@mail.com', '1128282828', 1),
('30000016', 'Giovani', 'Lo Celso', 'Masculino', 'Argentina', '09/04/1996', 'Bv. Oroño 400', (SELECT TOP 1 Id_Localidad FROM Localidades WHERE Id_Provincia_Loc = 21 AND Descripcion_Loc = 'Rosario'), 'gio.locelso@mail.com', '3412525252', 1),
('30000015', 'Exequiel', 'Palacios', 'Masculino', 'Argentina', '05/10/1998', 'Calle Tucumán 55', (SELECT TOP 1 Id_Localidad FROM Localidades WHERE Id_Provincia_Loc = 24 AND Descripcion_Loc = 'Famaillá'), 'exe.palacios@mail.com', '3816262626', 1),
('30000006', 'Valentín', 'Barco', 'Masculino', 'Argentina', '23/07/2004', 'Calle Costanera 12', (SELECT TOP 1 Id_Localidad FROM Localidades WHERE Id_Provincia_Loc = 1 AND Descripcion_Loc = '25 de Mayo'), 'colo.barco@mail.com', '2342272727', 0), 
('30000017', 'Nicolás', 'González', 'Masculino', 'Argentina', '06/04/1998', 'Calle Belgrano 430', (SELECT TOP 1 Id_Localidad FROM Localidades WHERE Id_Provincia_Loc = 1 AND Descripcion_Loc = 'Escobar'), 'nico.gonzalez@mail.com', '3484282828', 1),
('30000021', 'Giuliano', 'Simeone', 'Masculino', 'Argentina', '18/12/2002', 'Av. del Libertador 1500', (SELECT TOP 1 Id_Localidad FROM Localidades WHERE Id_Provincia_Loc = 2 AND Descripcion_Loc = 'Palermo'), 'giuli.simeone@mail.com', '1129292929', 1),
('30000010', 'Lionel', 'Messi', 'Masculino', 'Argentina', '24/06/1987', 'Av. del Rosario 1010', (SELECT TOP 1 Id_Localidad FROM Localidades WHERE Id_Provincia_Loc = 21 AND Descripcion_Loc = 'Rosario'), 'leo.messi@mail.com', '3413010101', 1),
('30000009', 'Julián', 'Álvarez', 'Masculino', 'Argentina', '31/01/2000', 'Calle Araña 912', (SELECT TOP 1 Id_Localidad FROM Localidades WHERE Id_Provincia_Loc = 6 AND Descripcion_Loc = 'Calchín'), 'arana.alvarez@mail.com', '3531313131', 0),
('30000022', 'Lautaro', 'Martínez', 'Masculino', 'Argentina', '22/08/1997', 'Calle Toro 45', (SELECT TOP 1 Id_Localidad FROM Localidades WHERE Id_Provincia_Loc = 1 AND Descripcion_Loc = 'Bahía Blanca'), 'toro.martinez@mail.com', '2913030303', 1),
('30000011', 'Thiago', 'Almada', 'Masculino', 'Argentina', '26/04/2001', 'Av. Rivadavia 10000', (SELECT TOP 1 Id_Localidad FROM Localidades WHERE Id_Provincia_Loc = 2 AND Descripcion_Loc = 'Liniers'), 'thiago.almada@mail.com', '1134343434', 1),
('30000018', 'José Manuel', 'López', 'Masculino', 'Argentina', '06/12/2000', 'Calle Corrientes 123', (SELECT TOP 1 Id_Localidad FROM Localidades WHERE Id_Provincia_Loc = 7 AND Descripcion_Loc = 'Curuzú Cuatiá'), 'flaco.lopez@mail.com', '3774343434', 1),
('30000008', 'Nicolás', 'Paz', 'Masculino', 'Argentina', '08/09/2004', 'Av. Corrientes 500', (SELECT TOP 1 Id_Localidad FROM Localidades WHERE Id_Provincia_Loc = 2 AND Descripcion_Loc = 'San Nicolás'), 'nico.paz@mail.com', '1135353535', 0),
('30000030', 'Antonella', 'Roccuzzo', 'Femenino', 'Argentina', '26/02/1988', 'Av. del Rosario 1020', (SELECT TOP 1 Id_Localidad FROM Localidades WHERE Id_Provincia_Loc = 21 AND Descripcion_Loc = 'Rosario'), 'anto.roccuzzo@mail.com', '3412303030', 1),
('30000031', 'Jorgelina', 'Cardoso', 'Femenino', 'Argentina', '12/07/1982', 'Bv. Oroño 650', (SELECT TOP 1 Id_Localidad FROM Localidades WHERE Id_Provincia_Loc = 21 AND Descripcion_Loc = 'Rosario'), 'jorgi.cardoso@mail.com', '3412313131', 1),
('30000032', 'Camila', 'Galante', 'Femenino', 'Argentina', '14/06/1992', 'Calle 25 de Mayo 102', (SELECT TOP 1 Id_Localidad FROM Localidades WHERE Id_Provincia_Loc = 21 AND Descripcion_Loc = 'San Justo'), 'cami.galante@mail.com', '3498323232', 1),
('30000033', 'Mandinha', 'Martínez', 'Femenino', 'Otros', '18/01/1992', 'Calle Mar de Ajó 25', (SELECT TOP 1 Id_Localidad FROM Localidades WHERE Id_Provincia_Loc = 1 AND Descripcion_Loc = 'Mar del Plata'), 'mandinha.m@mail.com', '2234333333', 0), 
('30000034', 'Oriana', 'Sabatini', 'Femenino', 'Argentina', '19/04/1996', 'Av. Santa Fe 1200', (SELECT TOP 1 Id_Localidad FROM Localidades WHERE Id_Provincia_Loc = 2 AND Descripcion_Loc = 'Palermo'), 'ori.sabatini@mail.com', '1119343434', 1),
('30000035', 'Agustina', 'Gandolfo', 'Femenino', 'Argentina', '06/11/1995', 'Calle Toro 48', (SELECT TOP 1 Id_Localidad FROM Localidades WHERE Id_Provincia_Loc = 1 AND Descripcion_Loc = 'Bahía Blanca'), 'agus.gandolfo@mail.com', '2913535353', 1),
('30000036', 'Caro', 'Calvagni', 'Femenino', 'Argentina', '10/08/1994', 'Av. San Martín 15', (SELECT TOP 1 Id_Localidad FROM Localidades WHERE Id_Provincia_Loc = 1 AND Descripcion_Loc = '3 de febrero'), 'caro.calvagni@mail.com', '1121363636', 0),
('30000037', 'Muri', 'López', 'Femenino', 'Argentina', '19/07/1998', 'Calle California 90', (SELECT TOP 1 Id_Localidad FROM Localidades WHERE Id_Provincia_Loc = 1 AND Descripcion_Loc = '3 de febrero'), 'muri.lopez@mail.com', '1115373737', 1),
('30000038', 'Chiara', 'Casiraghi', 'Femenino', 'Otros', '04/03/2001', 'Av. Central 18', (SELECT TOP 1 Id_Localidad FROM Localidades WHERE Id_Provincia_Loc = 6 AND Descripcion_Loc = 'Río Tercero'), 'chiara.c@mail.com', '3571383838', 1),
('30000039', 'Valentina', 'Cervantes', 'Femenino', 'Argentina', '04/02/2000', 'Av. General Paz 125', (SELECT TOP 1 Id_Localidad FROM Localidades WHERE Id_Provincia_Loc = 1 AND Descripcion_Loc = '3 de febrero'), 'valu.cervantes@mail.com', '1128393939', 1),
('30000040', 'Bárbara', 'Occhiuzzi', 'Femenino', 'Argentina', '10/03/1996', 'Av. Perón 325', (SELECT TOP 1 Id_Localidad FROM Localidades WHERE Id_Provincia_Loc = 11 AND Descripcion_Loc = 'Santa Rosa'), 'barbi.o@mail.com', '2954404040', 0),
('30000041', 'Guadalupe', 'Wada', 'Femenino', 'Argentina', '25/05/2002', 'Calle Duarte Quirós 1400', (SELECT TOP 1 Id_Localidad FROM Localidades WHERE Id_Provincia_Loc = 6 AND Descripcion_Loc = 'Córdoba'), 'guada.wada@mail.com', '3514414141', 1),
('30000042', 'María', 'Emilia', 'Femenino', 'Argentina', '14/11/1997', 'Calle Araña 915', (SELECT TOP 1 Id_Localidad FROM Localidades WHERE Id_Provincia_Loc = 6 AND Descripcion_Loc = 'Calchín'), 'emilia.fer@mail.com', '3531424242', 1),
('30000043', 'Rocío', 'Espósito', 'Femenino', 'Argentina', '03/11/1989', 'Ruta 202 nro 1925', (SELECT TOP 1 Id_Localidad FROM Localidades WHERE Id_Provincia_Loc = 1 AND Descripcion_Loc = 'Don Torcuato'), 'rocio.esposito@mail.com', '1121434343', 1),
('30000044', 'Magalí', 'Aravena', 'Femenino', 'Argentina', '20/09/1989', 'Calle 7 nro 128', (SELECT TOP 1 Id_Localidad FROM Localidades WHERE Id_Provincia_Loc = 1 AND Descripcion_Loc = 'La Plata'), 'maga.aravena@mail.com', '2214444444', 1);

-- 3. Volcamos a la tabla final SOLO los que no existen 
INSERT INTO Pacientes (
    Dni_Pac, Nombre_Pac, Apellido_Pac, Sexo_Pac, Nacionalidad_Pac,
    FechaNacimiento_Pac, Direccion_Pac, Id_Localidad_Pac,
    CorreoElectronico_Pac, Telefono_Pac, Estado_Pac
)
SELECT 
    Dni_Pac, Nombre_Pac, Apellido_Pac, Sexo_Pac, Nacionalidad_Pac,
    FechaNacimiento_Pac, Direccion_Pac, Id_Localidad_Pac,
    CorreoElectronico_Pac, Telefono_Pac, Estado_Pac
FROM #TempPacientes T
WHERE NOT EXISTS (
    SELECT 1 FROM Pacientes P WHERE P.Dni_Pac = T.Dni_Pac
);

-- 4. Borramos la temporal
DROP TABLE #TempPacientes;
GO