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
