namespace WebApi.Model;

public class Amistad
{
    public int AmistadId { get; set; }
    public int UsuarioSolicitanteId { get; set; }
    public int UsuarioReceptorId { get; set; }
    public string Estado { get; set; } = string.Empty;
    public DateTime FechaSolicitud { get; set; }
    public DateTime? FechaRespuesta { get; set; }
}

public class AmigoDto
{
    public int UsuarioId { get; set; }
    public string UID { get; set; } = string.Empty;
    public string NombreUsuario { get; set; } = string.Empty;
    public DateTime FechaDesdeQueSonAmigos { get; set; }
}

public class UsuarioBusquedaDto
{
    public int UsuarioId { get; set; }
    public string UID { get; set; } = string.Empty;
    public string NombreUsuario { get; set; } = string.Empty;
    public bool Activo { get; set; }
}