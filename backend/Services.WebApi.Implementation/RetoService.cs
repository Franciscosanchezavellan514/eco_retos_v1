using Services.WebApi.Interface;
using WebApi.Data;
using WebApi.Model;

namespace Services.WebApi.Implementation;

public class RetoService : IRetoService
{
    private readonly RetoRepository _retoRepository;

    public RetoService(RetoRepository retoRepository)
    {
        _retoRepository = retoRepository;
    }

    public List<RetoInfo> ListarActivos()
    {
        return _retoRepository.ListarActivos();
    }

    public int Completar(int usuarioId, int retoId)
    {
        return _retoRepository.Completar(usuarioId, retoId);
    }
}