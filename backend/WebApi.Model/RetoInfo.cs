namespace WebApi.Model;

public class RetoInfo
{
    public int RetoId { get; set; }
    public string Titulo { get; set; } = string.Empty;
    public string Descripcion { get; set; } = string.Empty;
    public int PuntosRecompensa { get; set; }
    public string Dificultad { get; set; } = string.Empty;
}