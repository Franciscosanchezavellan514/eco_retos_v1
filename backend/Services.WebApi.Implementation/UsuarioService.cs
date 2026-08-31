using Services.WebApi.Interface;
using WebApi.Data;
using WebApi.Model;

namespace Services.WebApi.Implementation;

public class UsuarioService : IUsuarioService
{
    private readonly UsuarioRepository _usuarioRepository;

    public UsuarioService(UsuarioRepository usuarioRepository)
    {
        _usuarioRepository = usuarioRepository;
    }

    public int Registrar(Usuario usuario)
    {
        // Aquí después vamos a meter: generación de UID único,
        // hasheo de contraseña con BCrypt, validaciones, etc.
        return _usuarioRepository.Registrar(usuario);
    }
}