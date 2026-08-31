using Services.WebApi.Interface;
using WebApi.Data;
using WebApi.Model;
using WebApi.Model.DTOs;

namespace Services.WebApi.Implementation;

public class UsuarioService : IUsuarioService
{
    private readonly UsuarioRepository _usuarioRepository;
    private static readonly Random _random = new();

    public UsuarioService(UsuarioRepository usuarioRepository)
    {
        _usuarioRepository = usuarioRepository;
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

    private string GenerarUidUnico()
    {
        // Genera un número de 9 dígitos (100000000 - 999999999)
        // Nota: la verificación de colisión contra la BD la agregamos
        // cuando construyamos el repositorio de búsqueda por UID.
        return _random.Next(100_000_000, 999_999_999).ToString();
    }
}