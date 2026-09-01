namespace WebApi.Model;

public class InsigniaInfo
{
    public int InsigniaId { get; set; }
    public string Nombre { get; set; } = string.Empty;
    public string? Descripcion { get; set; }
    public string? ImagenUrl { get; set; }
    public DateTime FechaObtenida { get; set; }
}