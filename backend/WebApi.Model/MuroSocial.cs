namespace WebApi.Model;

public class PublicacionInfo
{
    public int PublicacionId { get; set; }
    public int UsuarioId { get; set; }
    public string NombreUsuario { get; set; } = string.Empty;
    public string Contenido { get; set; } = string.Empty;
    public string? ImagenUrl { get; set; }
    public DateTime FechaPublicacion { get; set; }
    public int TotalReacciones { get; set; }
    public int TotalComentarios { get; set; }
}

public class ComentarioInfo
{
    public int ComentarioId { get; set; }
    public int UsuarioId { get; set; }
    public string NombreUsuario { get; set; } = string.Empty;
    public int? ComentarioPadreId { get; set; }
    public string Contenido { get; set; } = string.Empty;
    public DateTime FechaComentario { get; set; }
}