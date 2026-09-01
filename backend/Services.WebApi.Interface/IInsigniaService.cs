using WebApi.Model;

namespace Services.WebApi.Interface;

public interface IInsigniaService
{
    int Otorgar(int usuarioId, int insigniaId);
    List<InsigniaInfo> ListarPorUsuario(int usuarioId);
}