namespace WebApi.Model;

public class Usuario
{
    public int UsuarioId { get; set; }
    public string UID { get; set; } = string.Empty;
    public string NombreUsuario { get; set; } = string.Empty;
    public string Email { get; set; } = string.Empty;
    public string PasswordHash { get; set; } = string.Empty;
    public DateTime FechaRegistro { get; set; }
    public DateTime? UltimaConexion { get; set; }
    public int RachaActual { get; set; }
    public int Puntos { get; set; }
    public int Monedas { get; set; }
    public bool EsAdmin { get; set; }
    public bool Activo { get; set; }
}