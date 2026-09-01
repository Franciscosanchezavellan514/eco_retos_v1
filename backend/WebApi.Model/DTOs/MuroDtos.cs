namespace WebApi.Model.DTOs;

public class CrearPublicacionDto
{
    public string Contenido { get; set; } = string.Empty;
    public string? ImagenUrl { get; set; }
}

public class CrearComentarioDto
{
    public string Contenido { get; set; } = string.Empty;
    public int? ComentarioPadreId { get; set; }
}