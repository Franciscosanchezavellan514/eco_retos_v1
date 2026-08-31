using System.Security.Cryptography;
using Services.WebApi.Interface;
using WebApi.Data;
using WebApi.Model;
using WebApi.Model.DTOs;

namespace Services.WebApi.Implementation;

public class UsuarioService : IUsuarioService
{
    private readonly UsuarioRepository _usuarioRepository;
    private readonly RefreshTokenRepository _refreshTokenRepository;
    private readonly JwtService _jwtService;
    private static readonly Random _random = new();

    public UsuarioService(
        UsuarioRepository usuarioRepository,
        RefreshTokenRepository refreshTokenRepository,
        JwtService jwtService)
    {
        _usuarioRepository = usuarioRepository;
        _refreshTokenRepository = refreshTokenRepository;
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
            return null;
        }

        bool passwordValido = BCrypt.Net.BCrypt.Verify(dto.Password, usuario.PasswordHash);

        if (!passwordValido)
        {
            return null;
        }

        var token = _jwtService.GenerarToken(usuario);
        var refreshTokenPlano = GenerarRefreshTokenPlano();
        var refreshTokenHash = HashearToken(refreshTokenPlano);

        _refreshTokenRepository.Crear(usuario.UsuarioId, refreshTokenHash, DateTime.UtcNow.AddDays(7));

        return new LoginResponseDto
        {
            UsuarioId = usuario.UsuarioId,
            UID = usuario.UID,
            NombreUsuario = usuario.NombreUsuario,
            Token = token,
            RefreshToken = refreshTokenPlano
        };
    }

    public LoginResponseDto? RenovarToken(string refreshTokenPlano)
    {
        var hash = HashearToken(refreshTokenPlano);
        var tokenInfo = _refreshTokenRepository.ObtenerValido(hash);

        if (tokenInfo == null)
        {
            return null; // token inválido, expirado o ya revocado
        }

        var usuario = _usuarioRepository.ObtenerPorId(tokenInfo.UsuarioId);

        if (usuario == null || !usuario.Activo)
        {
            return null;
        }

        // Revoca el token viejo (rotation) y genera uno nuevo
        _refreshTokenRepository.Revocar(hash);

        var nuevoToken = _jwtService.GenerarToken(usuario!);
        var nuevoRefreshPlano = GenerarRefreshTokenPlano();
        var nuevoRefreshHash = HashearToken(nuevoRefreshPlano);

        _refreshTokenRepository.Crear(usuario!.UsuarioId, nuevoRefreshHash, DateTime.UtcNow.AddDays(7));

        return new LoginResponseDto
        {
            UsuarioId = usuario.UsuarioId,
            UID = usuario.UID,
            NombreUsuario = usuario.NombreUsuario,
            Token = nuevoToken,
            RefreshToken = nuevoRefreshPlano
        };
    }

    public void Logout(string refreshTokenPlano)
    {
        var hash = HashearToken(refreshTokenPlano);
        _refreshTokenRepository.Revocar(hash);
    }

    private string GenerarUidUnico()
    {
        return _random.Next(100_000_000, 999_999_999).ToString();
    }

    private string GenerarRefreshTokenPlano()
    {
        var randomBytes = RandomNumberGenerator.GetBytes(64);
        return Convert.ToBase64String(randomBytes);
    }

    private string HashearToken(string tokenPlano)
    {
        var bytes = System.Text.Encoding.UTF8.GetBytes(tokenPlano);
        var hash = SHA256.HashData(bytes);
        return Convert.ToBase64String(hash);
    }
}