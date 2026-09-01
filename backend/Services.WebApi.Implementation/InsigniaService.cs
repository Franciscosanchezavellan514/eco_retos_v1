using Services.WebApi.Interface;
using WebApi.Data;
using WebApi.Model;

namespace Services.WebApi.Implementation;

public class InsigniaService : IInsigniaService
{
    private readonly InsigniaRepository _insigniaRepository;

    public InsigniaService(InsigniaRepository insigniaRepository)
    {
        _insigniaRepository = insigniaRepository;
    }

    public int Otorgar(int usuarioId, int insigniaId)
    {
        return _insigniaRepository.Otorgar(usuarioId, insigniaId);
    }

    public List<InsigniaInfo> ListarPorUsuario(int usuarioId)
    {
        return _insigniaRepository.ListarPorUsuario(usuarioId);
    }
}