namespace WebApi.Model.DTOs;

public class PerfilDto
{
    public int UsuarioId { get; set; }
    public string UID { get; set; } = string.Empty;
    public string NombreUsuario { get; set; } = string.Empty;
    public string Email { get; set; } = string.Empty;
    public int Puntos { get; set; }
    public int Monedas { get; set; }
    public int Nivel { get; set; }
    public int RachaActual { get; set; }
    public int MejorRacha { get; set; }
    public int DiasActivos { get; set; }
    public DateTime FechaRegistro { get; set; }
}