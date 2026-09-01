-- ============================================================
-- Eco-Retos - Script 01: Creación de la base de datos
-- Servidor: DESKTOP-426D7G4\SQLEXPRESS
-- Autenticación: Windows Authentication
-- ============================================================

USE master;
GO

IF DB_ID('EcoRetosDB') IS NOT NULL
BEGIN
    PRINT 'La base de datos EcoRetosDB ya existe. No se creará de nuevo.';
END
ELSE
BEGIN
    CREATE DATABASE EcoRetosDB;
    PRINT 'Base de datos EcoRetosDB creada correctamente.';
END
GO

USE EcoRetosDB;
GO

CREATE TABLE Usuarios (
    UsuarioId       INT IDENTITY(1,1) PRIMARY KEY,
    UID             CHAR(9)       NOT NULL UNIQUE,
    NombreUsuario   NVARCHAR(50)  NOT NULL UNIQUE,
    Email           NVARCHAR(150) NOT NULL UNIQUE,
    PasswordHash    NVARCHAR(255) NOT NULL,
    FechaRegistro   DATETIME2     NOT NULL DEFAULT SYSUTCDATETIME(),
    UltimaConexion  DATETIME2     NULL,
    RachaActual     INT           NOT NULL DEFAULT 0,
    Puntos          INT           NOT NULL DEFAULT 0,
    Monedas         INT           NOT NULL DEFAULT 0,
    EsAdmin         BIT           NOT NULL DEFAULT 0,
    Activo          BIT           NOT NULL DEFAULT 1
);
GO

CREATE TABLE RefreshTokens (
    RefreshTokenId   INT IDENTITY(1,1) PRIMARY KEY,
    UsuarioId        INT NOT NULL FOREIGN KEY REFERENCES Usuarios(UsuarioId),
    TokenHash        VARCHAR(255) NOT NULL,
    FechaCreacion    DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    FechaExpiracion  DATETIME2 NOT NULL,
    Revocado         BIT NOT NULL DEFAULT 0
);
GO

CREATE TABLE Amistades (
    AmistadId             INT IDENTITY(1,1) PRIMARY KEY,
    UsuarioSolicitanteId  INT NOT NULL FOREIGN KEY REFERENCES Usuarios(UsuarioId),
    UsuarioReceptorId     INT NOT NULL FOREIGN KEY REFERENCES Usuarios(UsuarioId),
    Estado                VARCHAR(20) NOT NULL DEFAULT 'Pendiente',
    FechaSolicitud        DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    FechaRespuesta        DATETIME2 NULL,
    CONSTRAINT UQ_Amistad UNIQUE (UsuarioSolicitanteId, UsuarioReceptorId),
    CONSTRAINT CK_NoAutoAmistad CHECK (UsuarioSolicitanteId <> UsuarioReceptorId)
);
GO

CREATE TABLE Materiales (
    MaterialId    INT IDENTITY(1,1) PRIMARY KEY,
    Nombre        NVARCHAR(100) NOT NULL UNIQUE,
    Descripcion   NVARCHAR(255) NULL,
    ImagenUrl     NVARCHAR(255) NULL
);
GO

CREATE TABLE Retos (
    RetoId            INT IDENTITY(1,1) PRIMARY KEY,
    Titulo            NVARCHAR(150) NOT NULL,
    Descripcion       NVARCHAR(500) NULL,
    PuntosRecompensa  INT NOT NULL DEFAULT 0,
    Dificultad        VARCHAR(20) NOT NULL DEFAULT 'Facil',
    Activo            BIT NOT NULL DEFAULT 1
);
GO

CREATE TABLE RetoMateriales (
    RetoId             INT NOT NULL FOREIGN KEY REFERENCES Retos(RetoId),
    MaterialId         INT NOT NULL FOREIGN KEY REFERENCES Materiales(MaterialId),
    CantidadRequerida  INT NOT NULL DEFAULT 1,
    PRIMARY KEY (RetoId, MaterialId)
);
GO

CREATE TABLE UsuarioRetos (
    UsuarioId        INT NOT NULL FOREIGN KEY REFERENCES Usuarios(UsuarioId),
    RetoId           INT NOT NULL FOREIGN KEY REFERENCES Retos(RetoId),
    FechaCompletado  DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    PRIMARY KEY (UsuarioId, RetoId)
);
GO

CREATE TABLE Plantas (
    PlantaId       INT IDENTITY(1,1) PRIMARY KEY,
    Nombre         NVARCHAR(100) NOT NULL,
    PrecioMonedas  INT NOT NULL DEFAULT 0,
    ImagenUrl       NVARCHAR(255) NULL
);
GO

CREATE TABLE JardinSlots (
    JardinSlotId      INT IDENTITY(1,1) PRIMARY KEY,
    UsuarioId         INT NOT NULL FOREIGN KEY REFERENCES Usuarios(UsuarioId),
    NumeroSlot        INT NOT NULL,
    PlantaId          INT NULL FOREIGN KEY REFERENCES Plantas(PlantaId),
    FechaColocacion   DATETIME2 NULL,
    CONSTRAINT UQ_UsuarioSlot UNIQUE (UsuarioId, NumeroSlot)
);
GO

CREATE TABLE UsuarioMateriales (
    UsuarioId   INT NOT NULL FOREIGN KEY REFERENCES Usuarios(UsuarioId),
    MaterialId  INT NOT NULL FOREIGN KEY REFERENCES Materiales(MaterialId),
    Cantidad    INT NOT NULL DEFAULT 0,
    PRIMARY KEY (UsuarioId, MaterialId)
);
GO

CREATE TABLE UsuarioPlantas (
    UsuarioId    INT NOT NULL FOREIGN KEY REFERENCES Usuarios(UsuarioId),
    PlantaId     INT NOT NULL FOREIGN KEY REFERENCES Plantas(PlantaId),
    FechaCompra  DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    PRIMARY KEY (UsuarioId, PlantaId)
);
GO

CREATE TABLE CategoriasTrivia (
    CategoriaId  INT IDENTITY(1,1) PRIMARY KEY,
    Nombre       NVARCHAR(100) NOT NULL,
    Grupo        CHAR(1) NOT NULL,
    Dificultad   VARCHAR(20) NOT NULL DEFAULT 'Facil'
);
GO

CREATE TABLE Preguntas (
    PreguntaId   INT IDENTITY(1,1) PRIMARY KEY,
    CategoriaId  INT NOT NULL FOREIGN KEY REFERENCES CategoriasTrivia(CategoriaId),
    Enunciado    NVARCHAR(500) NOT NULL,
    Activo       BIT NOT NULL DEFAULT 1
);
GO

CREATE TABLE OpcionesPregunta (
    OpcionId     INT IDENTITY(1,1) PRIMARY KEY,
    PreguntaId   INT NOT NULL FOREIGN KEY REFERENCES Preguntas(PreguntaId),
    Texto        NVARCHAR(255) NOT NULL,
    EsCorrecta   BIT NOT NULL DEFAULT 0
);
GO

CREATE UNIQUE INDEX UQ_UnaCorrectaPorPregunta
    ON OpcionesPregunta(PreguntaId)
    WHERE EsCorrecta = 1;
GO

CREATE TABLE TriviaAttempts (
    AttemptId              INT IDENTITY(1,1) PRIMARY KEY,
    UsuarioId              INT NOT NULL FOREIGN KEY REFERENCES Usuarios(UsuarioId),
    PreguntaId             INT NOT NULL FOREIGN KEY REFERENCES Preguntas(PreguntaId),
    OpcionSeleccionadaId   INT NOT NULL FOREIGN KEY REFERENCES OpcionesPregunta(OpcionId),
    EsCorrecta             BIT NOT NULL,
    RewardGranted          BIT NOT NULL DEFAULT 0,
    RewardedAt             DATETIME2 NULL,
    FechaIntento           DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME()
);
GO

CREATE TABLE ResultadosTrivia (
    UsuarioId     INT NOT NULL FOREIGN KEY REFERENCES Usuarios(UsuarioId),
    CategoriaId   INT NOT NULL FOREIGN KEY REFERENCES CategoriasTrivia(CategoriaId),
    MejorPuntaje  INT NOT NULL DEFAULT 0,
    Visibilidad   VARCHAR(20) NOT NULL DEFAULT 'Amigos',
    PRIMARY KEY (UsuarioId, CategoriaId)
);
GO

CREATE TABLE Publicaciones (
    PublicacionId     INT IDENTITY(1,1) PRIMARY KEY,
    UsuarioId         INT NOT NULL FOREIGN KEY REFERENCES Usuarios(UsuarioId),
    Contenido         NVARCHAR(1000) NOT NULL,
    ImagenUrl         NVARCHAR(255) NULL,
    FechaPublicacion  DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME()
);
GO

CREATE TABLE Comentarios (
    ComentarioId       INT IDENTITY(1,1) PRIMARY KEY,
    PublicacionId      INT NOT NULL FOREIGN KEY REFERENCES Publicaciones(PublicacionId),
    UsuarioId          INT NOT NULL FOREIGN KEY REFERENCES Usuarios(UsuarioId),
    ComentarioPadreId  INT NULL FOREIGN KEY REFERENCES Comentarios(ComentarioId),
    Contenido           NVARCHAR(500) NOT NULL,
    FechaComentario     DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME()
);
GO

CREATE TABLE Reacciones (
    ReaccionId       INT IDENTITY(1,1) PRIMARY KEY,
    PublicacionId    INT NOT NULL FOREIGN KEY REFERENCES Publicaciones(PublicacionId),
    UsuarioId        INT NOT NULL FOREIGN KEY REFERENCES Usuarios(UsuarioId),
    Tipo             VARCHAR(20) NOT NULL DEFAULT 'Like',
    FechaReaccion    DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    CONSTRAINT UQ_ReaccionUsuarioPublicacion UNIQUE (PublicacionId, UsuarioId)
);
GO

CREATE TABLE Insignias (
    InsigniaId   INT IDENTITY(1,1) PRIMARY KEY,
    Nombre       NVARCHAR(100) NOT NULL,
    Descripcion  NVARCHAR(255) NULL,
    ImagenUrl    NVARCHAR(255) NULL
);
GO

CREATE TABLE UsuarioInsignias (
    UsuarioId       INT NOT NULL FOREIGN KEY REFERENCES Usuarios(UsuarioId),
    InsigniaId      INT NOT NULL FOREIGN KEY REFERENCES Insignias(InsigniaId),
    FechaObtenida   DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    PRIMARY KEY (UsuarioId, InsigniaId)
);
GO




--procedimientos

CREATE OR ALTER PROCEDURE sp_Usuario_Registrar
    @UID            CHAR(9),
    @NombreUsuario  NVARCHAR(50),
    @Email          NVARCHAR(150),
    @PasswordHash   NVARCHAR(255)
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO Usuarios (UID, NombreUsuario, Email, PasswordHash)
    VALUES (@UID, @NombreUsuario, @Email, @PasswordHash);

    SELECT SCOPE_IDENTITY() AS UsuarioId;
END
GO


--Procedimiento almacenado para buscar por email
USE EcoRetosDB;
GO

CREATE PROCEDURE sp_Usuario_ObtenerPorEmail
    @Email NVARCHAR(150)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT UsuarioId, UID, NombreUsuario, Email, PasswordHash,
           FechaRegistro, UltimaConexion, RachaActual, Puntos, Monedas,
           EsAdmin, Activo
    FROM Usuarios
    WHERE Email = @Email;
END
GO


--Procedimiento almacenado para crear refresh token
USE EcoRetosDB;
GO

CREATE OR ALTER PROCEDURE sp_RefreshToken_Crear
    @UsuarioId       INT,
    @TokenHash       VARCHAR(255),
    @FechaExpiracion DATETIME2
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO RefreshTokens (UsuarioId, TokenHash, FechaExpiracion)
    VALUES (@UsuarioId, @TokenHash, @FechaExpiracion);
END
GO


USE EcoRetosDB;
GO

CREATE OR ALTER PROCEDURE sp_RefreshToken_ObtenerValido
    @TokenHash VARCHAR(255)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT RefreshTokenId, UsuarioId, TokenHash, FechaCreacion, FechaExpiracion, Revocado
    FROM RefreshTokens
    WHERE TokenHash = @TokenHash
      AND Revocado = 0
      AND FechaExpiracion > SYSUTCDATETIME();
END
GO

USE EcoRetosDB;
GO

CREATE OR ALTER PROCEDURE sp_RefreshToken_Revocar
    @TokenHash VARCHAR(255)
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE RefreshTokens
    SET Revocado = 1
    WHERE TokenHash = @TokenHash;
END
GO



--Procedimiento para obtener un refresh token válido (no revocado, no expirado)
USE EcoRetosDB;
GO

CREATE OR ALTER PROCEDURE sp_RefreshToken_ObtenerValido
    @TokenHash VARCHAR(255)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT RefreshTokenId, UsuarioId, TokenHash, FechaCreacion, FechaExpiracion, Revocado
    FROM RefreshTokens
    WHERE TokenHash = @TokenHash
      AND Revocado = 0
      AND FechaExpiracion > SYSUTCDATETIME();
END
GO

--Procedimiento para revocar un refresh token (usado en logout y en rotation)
USE EcoRetosDB;
GO

CREATE OR ALTER PROCEDURE sp_RefreshToken_Revocar
    @TokenHash VARCHAR(255)
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE RefreshTokens
    SET Revocado = 1
    WHERE TokenHash = @TokenHash;
END
GO


--Stored procedure para buscar por ID
USE EcoRetosDB;
GO

CREATE OR ALTER PROCEDURE sp_Usuario_ObtenerPorId
    @UsuarioId INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT UsuarioId, UID, NombreUsuario, Email, PasswordHash,
           FechaRegistro, UltimaConexion, RachaActual, Puntos, Monedas,
           EsAdmin, Activo
    FROM Usuarios
    WHERE UsuarioId = @UsuarioId;
END
GO


--Buscar usuario por UID (necesario antes de poder agregar a alguien)
USE EcoRetosDB;
GO

CREATE OR ALTER PROCEDURE sp_Usuario_ObtenerPorUID
    @UID CHAR(9)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT UsuarioId, UID, NombreUsuario, Email, Activo
    FROM Usuarios
    WHERE UID = @UID;
END
GO


--solicitud amistad
USE EcoRetosDB;
GO

CREATE OR ALTER PROCEDURE sp_Amistad_CrearSolicitud
    @UsuarioSolicitanteId INT,
    @UsuarioReceptorId    INT
AS
BEGIN
    SET NOCOUNT ON;

    -- Evita duplicar una solicitud si ya existe en cualquier dirección
    IF EXISTS (
        SELECT 1 FROM Amistades
        WHERE (UsuarioSolicitanteId = @UsuarioSolicitanteId AND UsuarioReceptorId = @UsuarioReceptorId)
           OR (UsuarioSolicitanteId = @UsuarioReceptorId AND UsuarioReceptorId = @UsuarioSolicitanteId)
    )
    BEGIN
        SELECT -1 AS AmistadId; -- código especial: ya existe una relación entre estos usuarios
        RETURN;
    END

    INSERT INTO Amistades (UsuarioSolicitanteId, UsuarioReceptorId, Estado)
    VALUES (@UsuarioSolicitanteId, @UsuarioReceptorId, 'Pendiente');

    SELECT SCOPE_IDENTITY() AS AmistadId;
END
GO



--sp_Amistad_Responder
USE EcoRetosDB;
GO

CREATE OR ALTER PROCEDURE sp_Amistad_Responder
    @AmistadId        INT,
    @UsuarioReceptorId INT,   -- para verificar que quien responde es el receptor real
    @NuevoEstado      VARCHAR(20)  -- 'Aceptada' o 'Rechazada'
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE Amistades
    SET Estado = @NuevoEstado,
        FechaRespuesta = SYSUTCDATETIME()
    WHERE AmistadId = @AmistadId
      AND UsuarioReceptorId = @UsuarioReceptorId
      AND Estado = 'Pendiente';

    SELECT @@ROWCOUNT AS FilasAfectadas;
END
GO



--sp_Amistad_ListarAmigos
USE EcoRetosDB;
GO

CREATE OR ALTER PROCEDURE sp_Amistad_ListarAmigos
    @UsuarioId INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        u.UsuarioId,
        u.UID,
        u.NombreUsuario,
        a.FechaRespuesta AS FechaDesdeQueSonAmigos
    FROM Amistades a
    INNER JOIN Usuarios u
        ON u.UsuarioId = CASE
                            WHEN a.UsuarioSolicitanteId = @UsuarioId THEN a.UsuarioReceptorId
                            ELSE a.UsuarioSolicitanteId
                          END
    WHERE (a.UsuarioSolicitanteId = @UsuarioId OR a.UsuarioReceptorId = @UsuarioId)
      AND a.Estado = 'Aceptada';
END
GO


--sp_Reto_ListarActivos
USE EcoRetosDB;
GO

CREATE OR ALTER PROCEDURE sp_Reto_ListarActivos
AS
BEGIN
    SET NOCOUNT ON;

    SELECT RetoId, Titulo, Descripcion, PuntosRecompensa, Dificultad
    FROM Retos
    WHERE Activo = 1;
END
GO



--Stored procedure para completar un reto (con validación + consumo de materiales
USE EcoRetosDB;
GO

CREATE OR ALTER PROCEDURE sp_Reto_Completar
    @UsuarioId INT,
    @RetoId    INT
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON; -- si algo falla, deshace toda la transacción automáticamente

    -- Código de resultado: 1 = éxito, -1 = ya completado, -2 = materiales insuficientes, -3 = reto no existe/inactivo
    DECLARE @Resultado INT = 1;

    BEGIN TRANSACTION;

    -- 1. Verificar que el reto existe y está activo
    IF NOT EXISTS (SELECT 1 FROM Retos WHERE RetoId = @RetoId AND Activo = 1)
    BEGIN
        SET @Resultado = -3;
        ROLLBACK TRANSACTION;
        SELECT @Resultado AS Resultado;
        RETURN;
    END

    -- 2. Verificar que no lo haya completado antes (no repetible)
    IF EXISTS (SELECT 1 FROM UsuarioRetos WHERE UsuarioId = @UsuarioId AND RetoId = @RetoId)
    BEGIN
        SET @Resultado = -1;
        ROLLBACK TRANSACTION;
        SELECT @Resultado AS Resultado;
        RETURN;
    END

    -- 3. Verificar que tenga TODOS los materiales requeridos en cantidad suficiente
    IF EXISTS (
        SELECT 1
        FROM RetoMateriales rm
        LEFT JOIN UsuarioMateriales um
            ON um.MaterialId = rm.MaterialId AND um.UsuarioId = @UsuarioId
        WHERE rm.RetoId = @RetoId
          AND ISNULL(um.Cantidad, 0) < rm.CantidadRequerida
    )
    BEGIN
        SET @Resultado = -2;
        ROLLBACK TRANSACTION;
        SELECT @Resultado AS Resultado;
        RETURN;
    END

    -- 4. Descontar los materiales usados
    UPDATE um
    SET um.Cantidad = um.Cantidad - rm.CantidadRequerida
    FROM UsuarioMateriales um
    INNER JOIN RetoMateriales rm
        ON rm.MaterialId = um.MaterialId
    WHERE rm.RetoId = @RetoId
      AND um.UsuarioId = @UsuarioId;

    -- 5. Registrar el reto como completado
    INSERT INTO UsuarioRetos (UsuarioId, RetoId)
    VALUES (@UsuarioId, @RetoId);

    -- 6. Otorgar los puntos de recompensa
    UPDATE Usuarios
    SET Puntos = Puntos + (SELECT PuntosRecompensa FROM Retos WHERE RetoId = @RetoId)
    WHERE UsuarioId = @UsuarioId;

    COMMIT TRANSACTION;

    SELECT @Resultado AS Resultado;
END
GO





USE EcoRetosDB;
GO

-- Materiales de ejemplo
INSERT INTO Materiales (Nombre, Descripcion)
VALUES
    ('Botella de plástico', 'Botella PET reciclada'),
    ('Cartón', 'Cartón limpio y seco');
GO

-- Reto de ejemplo
INSERT INTO Retos (Titulo, Descripcion, PuntosRecompensa, Dificultad)
VALUES ('Recicla 3 botellas', 'Junta y entrega 3 botellas de plástico para reciclar', 50, 'Facil');
GO

-- Receta: este reto requiere 3 botellas de plástico
INSERT INTO RetoMateriales (RetoId, MaterialId, CantidadRequerida)
SELECT
    (SELECT RetoId FROM Retos WHERE Titulo = 'Recicla 3 botellas'),
    (SELECT MaterialId FROM Materiales WHERE Nombre = 'Botella de plástico'),
    3;
GO



INSERT INTO Plantas (Nombre, PrecioMonedas)
VALUES
    ('Girasol', 20),
    ('Cactus', 35),
    ('Lanzaguisantes Verde', 50);
GO


--Stored procedure para listar la tienda
USE EcoRetosDB;
GO

CREATE OR ALTER PROCEDURE sp_Planta_ListarTienda
AS
BEGIN
    SET NOCOUNT ON;

    SELECT PlantaId, Nombre, PrecioMonedas, ImagenUrl
    FROM Plantas;
END
GO


--comprar una planta
USE EcoRetosDB;
GO

CREATE OR ALTER PROCEDURE sp_Planta_Comprar
    @UsuarioId INT,
    @PlantaId  INT
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    -- Resultado: 1 = éxito, -1 = ya la tiene, -2 = monedas insuficientes, -3 = planta no existe
    DECLARE @Resultado INT = 1;
    DECLARE @Precio INT;

    BEGIN TRANSACTION;

    SELECT @Precio = PrecioMonedas FROM Plantas WHERE PlantaId = @PlantaId;

    IF @Precio IS NULL
    BEGIN
        SET @Resultado = -3;
        ROLLBACK TRANSACTION;
        SELECT @Resultado AS Resultado;
        RETURN;
    END

    IF EXISTS (SELECT 1 FROM UsuarioPlantas WHERE UsuarioId = @UsuarioId AND PlantaId = @PlantaId)
    BEGIN
        SET @Resultado = -1;
        ROLLBACK TRANSACTION;
        SELECT @Resultado AS Resultado;
        RETURN;
    END

    IF (SELECT Monedas FROM Usuarios WHERE UsuarioId = @UsuarioId) < @Precio
    BEGIN
        SET @Resultado = -2;
        ROLLBACK TRANSACTION;
        SELECT @Resultado AS Resultado;
        RETURN;
    END

    UPDATE Usuarios SET Monedas = Monedas - @Precio WHERE UsuarioId = @UsuarioId;
    INSERT INTO UsuarioPlantas (UsuarioId, PlantaId) VALUES (@UsuarioId, @PlantaId);

    COMMIT TRANSACTION;

    SELECT @Resultado AS Resultado;
END
GO


--colocar una planta en un slot y ver el estado del jardín.
USE EcoRetosDB;
GO

CREATE OR ALTER PROCEDURE sp_Jardin_ColocarPlanta
    @UsuarioId  INT,
    @NumeroSlot INT,
    @PlantaId   INT
AS
BEGIN
    SET NOCOUNT ON;

    -- Resultado: 1 = éxito, -1 = no tienes esa planta desbloqueada, -2 = slot inválido
    DECLARE @Resultado INT = 1;

    -- Verificar que el usuario ya compró esa planta
    IF NOT EXISTS (SELECT 1 FROM UsuarioPlantas WHERE UsuarioId = @UsuarioId AND PlantaId = @PlantaId)
    BEGIN
        SELECT -1 AS Resultado;
        RETURN;
    END

    -- Verificar rango válido de slot (ejemplo: jardín de 12 slots, 1 al 12)
    IF @NumeroSlot < 1 OR @NumeroSlot > 12
    BEGIN
        SELECT -2 AS Resultado;
        RETURN;
    END

    -- Si ya existe una fila para ese slot, la actualiza (reemplaza la planta); si no, la crea
    IF EXISTS (SELECT 1 FROM JardinSlots WHERE UsuarioId = @UsuarioId AND NumeroSlot = @NumeroSlot)
    BEGIN
        UPDATE JardinSlots
        SET PlantaId = @PlantaId,
            FechaColocacion = SYSUTCDATETIME()
        WHERE UsuarioId = @UsuarioId AND NumeroSlot = @NumeroSlot;
    END
    ELSE
    BEGIN
        INSERT INTO JardinSlots (UsuarioId, NumeroSlot, PlantaId, FechaColocacion)
        VALUES (@UsuarioId, @NumeroSlot, @PlantaId, SYSUTCDATETIME());
    END

    SELECT @Resultado AS Resultado;
END
GO



--ver el estado completo del jardín de un usuario
USE EcoRetosDB;
GO

CREATE OR ALTER PROCEDURE sp_Jardin_VerEstado
    @UsuarioId INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        js.NumeroSlot,
        js.PlantaId,
        p.Nombre AS NombrePlanta,
        js.FechaColocacion
    FROM JardinSlots js
    INNER JOIN Plantas p ON p.PlantaId = js.PlantaId
    WHERE js.UsuarioId = @UsuarioId;
END
GO


USE EcoRetosDB;
GO

INSERT INTO CategoriasTrivia (Nombre, Grupo, Dificultad)
VALUES ('Reciclaje Básico', 'A', 'Facil');
GO



USE EcoRetosDB;
GO

DECLARE @CategoriaId INT = (SELECT CategoriaId FROM CategoriasTrivia WHERE Nombre = 'Reciclaje Básico');

-- Pregunta 1
INSERT INTO Preguntas (CategoriaId, Enunciado)
VALUES (@CategoriaId, '¿De qué color es normalmente el contenedor para plástico?');

DECLARE @Pregunta1Id INT = SCOPE_IDENTITY();

INSERT INTO OpcionesPregunta (PreguntaId, Texto, EsCorrecta)
VALUES
    (@Pregunta1Id, 'Amarillo', 1),
    (@Pregunta1Id, 'Verde', 0),
    (@Pregunta1Id, 'Rojo', 0);

-- Pregunta 2
INSERT INTO Preguntas (CategoriaId, Enunciado)
VALUES (@CategoriaId, '¿Cuánto tarda una botella de plástico en degradarse aproximadamente?');

DECLARE @Pregunta2Id INT = SCOPE_IDENTITY();

INSERT INTO OpcionesPregunta (PreguntaId, Texto, EsCorrecta)
VALUES
    (@Pregunta2Id, '1 año', 0),
    (@Pregunta2Id, '450 años', 1),
    (@Pregunta2Id, '10 años', 0);
GO




USE EcoRetosDB;
GO

CREATE OR ALTER PROCEDURE sp_Trivia_ListarCategorias
AS
BEGIN
    SET NOCOUNT ON;

    SELECT CategoriaId, Nombre, Grupo, Dificultad
    FROM CategoriasTrivia;
END
GO



USE EcoRetosDB;
GO

CREATE OR ALTER PROCEDURE sp_Trivia_ListarPreguntas
    @CategoriaId INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        p.PreguntaId,
        p.Enunciado,
        o.OpcionId,
        o.Texto
        -- Nota: a propósito NO incluimos "EsCorrecta" aquí,
        -- el cliente (Flutter) nunca debe recibir cuál es la respuesta correcta
    FROM Preguntas p
    INNER JOIN OpcionesPregunta o ON o.PreguntaId = p.PreguntaId
    WHERE p.CategoriaId = @CategoriaId
      AND p.Activo = 1
    ORDER BY p.PreguntaId, o.OpcionId;
END
GO



USE EcoRetosDB;
GO

CREATE OR ALTER PROCEDURE sp_Trivia_Responder
    @UsuarioId            INT,
    @PreguntaId           INT,
    @OpcionSeleccionadaId INT,
    @PuntosPorAcierto     INT = 10  -- valor fijo por pregunta, ajustable
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    DECLARE @EsCorrecta BIT;
    DECLARE @EsPrimerIntento BIT;
    DECLARE @PuntosOtorgados INT = 0;

    -- Verificar si esta es la primera vez que el usuario responde esta pregunta
    SET @EsPrimerIntento = CASE
        WHEN EXISTS (SELECT 1 FROM TriviaAttempts WHERE UsuarioId = @UsuarioId AND PreguntaId = @PreguntaId)
        THEN 0 ELSE 1
    END;

    -- Verificar si la opción elegida es la correcta
    SELECT @EsCorrecta = EsCorrecta
    FROM OpcionesPregunta
    WHERE OpcionId = @OpcionSeleccionadaId AND PreguntaId = @PreguntaId;

    IF @EsCorrecta IS NULL
    BEGIN
        SELECT -1 AS Resultado, 0 AS PuntosOtorgados; -- la opción no pertenece a esa pregunta
        RETURN;
    END

    BEGIN TRANSACTION;

    -- Solo se otorgan puntos si es correcta Y es el primer intento
    IF @EsCorrecta = 1 AND @EsPrimerIntento = 1
    BEGIN
        SET @PuntosOtorgados = @PuntosPorAcierto;
        UPDATE Usuarios SET Puntos = Puntos + @PuntosOtorgados WHERE UsuarioId = @UsuarioId;
    END

    INSERT INTO TriviaAttempts (UsuarioId, PreguntaId, OpcionSeleccionadaId, EsCorrecta, RewardGranted, RewardedAt)
    VALUES (
        @UsuarioId, @PreguntaId, @OpcionSeleccionadaId, @EsCorrecta,
        CASE WHEN @PuntosOtorgados > 0 THEN 1 ELSE 0 END,
        CASE WHEN @PuntosOtorgados > 0 THEN SYSUTCDATETIME() ELSE NULL END
    );

    COMMIT TRANSACTION;

    SELECT 1 AS Resultado, @EsCorrecta AS EsCorrecta, @PuntosOtorgados AS PuntosOtorgados;
END
GO


USE EcoRetosDB;
GO

CREATE OR ALTER PROCEDURE sp_Trivia_ActualizarMejorPuntaje
    @UsuarioId   INT,
    @CategoriaId INT
AS
BEGIN
    SET NOCOUNT ON;

    -- Cuenta cuántas preguntas de esta categoría ha acertado el usuario
    DECLARE @PuntajeActual INT;

    SELECT @PuntajeActual = COUNT(*)
    FROM TriviaAttempts ta
    INNER JOIN Preguntas p ON p.PreguntaId = ta.PreguntaId
    WHERE ta.UsuarioId = @UsuarioId
      AND p.CategoriaId = @CategoriaId
      AND ta.EsCorrecta = 1;

    IF EXISTS (SELECT 1 FROM ResultadosTrivia WHERE UsuarioId = @UsuarioId AND CategoriaId = @CategoriaId)
    BEGIN
        UPDATE ResultadosTrivia
        SET MejorPuntaje = @PuntajeActual
        WHERE UsuarioId = @UsuarioId AND CategoriaId = @CategoriaId
          AND @PuntajeActual > MejorPuntaje; -- solo actualiza si mejoró
    END
    ELSE
    BEGIN
        INSERT INTO ResultadosTrivia (UsuarioId, CategoriaId, MejorPuntaje)
        VALUES (@UsuarioId, @CategoriaId, @PuntajeActual);
    END
END
GO




USE EcoRetosDB;
GO

CREATE OR ALTER PROCEDURE sp_Trivia_ActualizarMejorPuntaje
    @UsuarioId   INT,
    @CategoriaId INT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @PuntajeActual INT;

    SELECT @PuntajeActual = COUNT(DISTINCT ta.PreguntaId)
    FROM TriviaAttempts ta
    INNER JOIN Preguntas p ON p.PreguntaId = ta.PreguntaId
    WHERE ta.UsuarioId = @UsuarioId
      AND p.CategoriaId = @CategoriaId
      AND ta.EsCorrecta = 1;

    IF EXISTS (SELECT 1 FROM ResultadosTrivia WHERE UsuarioId = @UsuarioId AND CategoriaId = @CategoriaId)
    BEGIN
        UPDATE ResultadosTrivia
        SET MejorPuntaje = @PuntajeActual
        WHERE UsuarioId = @UsuarioId AND CategoriaId = @CategoriaId;
    END
    ELSE
    BEGIN
        INSERT INTO ResultadosTrivia (UsuarioId, CategoriaId, MejorPuntaje)
        VALUES (@UsuarioId, @CategoriaId, @PuntajeActual);
    END
END
GO

EXEC sp_Trivia_ActualizarMejorPuntaje @UsuarioId = 4, @CategoriaId = 1;




--Muro Social: publicaciones, comentarios anidados, y reacciones (likes).
USE EcoRetosDB;
GO

CREATE OR ALTER PROCEDURE sp_Publicacion_Crear
    @UsuarioId INT,
    @Contenido NVARCHAR(1000),
    @ImagenUrl NVARCHAR(255) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO Publicaciones (UsuarioId, Contenido, ImagenUrl)
    VALUES (@UsuarioId, @Contenido, @ImagenUrl);

    SELECT SCOPE_IDENTITY() AS PublicacionId;
END
GO


--Listar el muro (feed general, todas las publicaciones
USE EcoRetosDB;
GO

CREATE OR ALTER PROCEDURE sp_Publicacion_ListarMuro
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        p.PublicacionId,
        p.UsuarioId,
        u.NombreUsuario,
        p.Contenido,
        p.ImagenUrl,
        p.FechaPublicacion,
        (SELECT COUNT(*) FROM Reacciones r WHERE r.PublicacionId = p.PublicacionId) AS TotalReacciones,
        (SELECT COUNT(*) FROM Comentarios c WHERE c.PublicacionId = p.PublicacionId) AS TotalComentarios
    FROM Publicaciones p
    INNER JOIN Usuarios u ON u.UsuarioId = p.UsuarioId
    ORDER BY p.FechaPublicacion DESC;
END
GO


USE EcoRetosDB;
GO

CREATE OR ALTER PROCEDURE sp_Comentario_Crear
    @PublicacionId     INT,
    @UsuarioId         INT,
    @Contenido         NVARCHAR(500),
    @ComentarioPadreId INT = NULL
AS
BEGIN
    SET NOCOUNT ON;

    -- Verifica que la publicación exista
    IF NOT EXISTS (SELECT 1 FROM Publicaciones WHERE PublicacionId = @PublicacionId)
    BEGIN
        SELECT -1 AS ComentarioId;
        RETURN;
    END

    -- Si es respuesta a otro comentario, verifica que ese comentario padre pertenezca a la misma publicación
    IF @ComentarioPadreId IS NOT NULL AND NOT EXISTS (
        SELECT 1 FROM Comentarios WHERE ComentarioId = @ComentarioPadreId AND PublicacionId = @PublicacionId
    )
    BEGIN
        SELECT -2 AS ComentarioId;
        RETURN;
    END

    INSERT INTO Comentarios (PublicacionId, UsuarioId, ComentarioPadreId, Contenido)
    VALUES (@PublicacionId, @UsuarioId, @ComentarioPadreId, @Contenido);

    SELECT SCOPE_IDENTITY() AS ComentarioId;
END
GO


--listar comentarios de una publicación
USE EcoRetosDB;
GO

CREATE OR ALTER PROCEDURE sp_Comentario_ListarPorPublicacion
    @PublicacionId INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        c.ComentarioId,
        c.UsuarioId,
        u.NombreUsuario,
        c.ComentarioPadreId,
        c.Contenido,
        c.FechaComentario
    FROM Comentarios c
    INNER JOIN Usuarios u ON u.UsuarioId = c.UsuarioId
    WHERE c.PublicacionId = @PublicacionId
    ORDER BY c.FechaComentario ASC;
END
GO



--reacciones (like/unlike, con el UNIQUE)
USE EcoRetosDB;
GO

CREATE OR ALTER PROCEDURE sp_Reaccion_Toggle
    @PublicacionId INT,
    @UsuarioId     INT
AS
BEGIN
    SET NOCOUNT ON;

    -- Si ya existe la reacción, la quita (unlike). Si no existe, la agrega (like).
    IF EXISTS (SELECT 1 FROM Reacciones WHERE PublicacionId = @PublicacionId AND UsuarioId = @UsuarioId)
    BEGIN
        DELETE FROM Reacciones WHERE PublicacionId = @PublicacionId AND UsuarioId = @UsuarioId;
        SELECT 'Quitado' AS Accion;
    END
    ELSE
    BEGIN
        INSERT INTO Reacciones (PublicacionId, UsuarioId, Tipo)
        VALUES (@PublicacionId, @UsuarioId, 'Like');
        SELECT 'Agregado' AS Accion;
    END
END
GO