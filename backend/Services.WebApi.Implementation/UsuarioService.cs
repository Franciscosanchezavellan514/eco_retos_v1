using Services.WebApi.Interface;
using WebApi.Data;
using WebApi.Model;
using WebApi.Model.DTOs;

namespace Services.WebApi.Implementation;

public class UsuarioService : IUsuarioService
{
    private readonly UsuarioRepository _usuarioRepository;
    private readonly JwtService _jwtService;
    private static readonly Random _random = new();

    public UsuarioService(UsuarioRepository usuarioRepository, JwtService jwtService)
    {
        _usuarioRepository = usuarioRepository;
        _jwtService = jwtService;
    }

    public int Registrar(RegistroUsuarioDto dto)
    {
        var usuario = new Usuario
        {
            UID = GenerarUidUnico(),
            NombreUsuario = dto.NombreUsuario,
            Email = dto.Email,
            PasswordHash = BCrypt.Net.BCrypt.HashPassword(dto.Password)
        };

        return _usuarioRepository.Registrar(usuario);
    }

    public LoginResponseDto? Login(LoginDto dto)
    {
        var usuario = _usuarioRepository.ObtenerPorEmail(dto.Email);

        if (usuario == null || !usuario.Activo)
        {
            return null; // no revelamos si es el email o el password el incorrecto
        }

        bool passwordValido = BCrypt.Net.BCrypt.Verify(dto.Password, usuario.PasswordHash);

        if (!passwordValido)
        {
            return null;
        }

        var token = _jwtService.GenerarToken(usuario);

        return new LoginResponseDto
        {
            UsuarioId = usuario.UsuarioId,
            UID = usuario.UID,
            NombreUsuario = usuario.NombreUsuario,
            Token = token
        };
    }

    private string GenerarUidUnico()
    {
        return _random.Next(100_000_000, 999_999_999).ToString();
    }
}