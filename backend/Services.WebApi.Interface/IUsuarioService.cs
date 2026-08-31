using WebApi.Model;

namespace Services.WebApi.Interface;

public interface IUsuarioService
{
    int Registrar(Usuario usuario);
}