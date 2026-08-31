namespace WebApi.Model.DTOs;

public class LoginResponseDto
{
    public int UsuarioId { get; set; }
    public string UID { get; set; } = string.Empty;
    public string NombreUsuario { get; set; } = string.Empty;
    public string Token { get; set; } = string.Empty;
    public string RefreshToken { get; set; } = string.Empty;
}