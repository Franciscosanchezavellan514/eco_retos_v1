using Services.WebApi.Interface;
using WebApi.Data;
using WebApi.Model;

namespace Services.WebApi.Implementation;

public class RetoService : IRetoService
{
    private readonly RetoRepository _retoRepository;
    private readonly InsigniaRepository _insigniaRepository;

    public RetoService(RetoRepository retoRepository, InsigniaRepository insigniaRepository)
    {
        _retoRepository = retoRepository;
        _insigniaRepository = insigniaRepository;
    }

    public List<RetoInfo> ListarActivos()
    {
        return _retoRepository.ListarActivos();
    }

    public List<RetoConMaterialesInfo> ListarActivosConMateriales(int usuarioId)
    {
        return _retoRepository.ListarActivosConMateriales(usuarioId);
    }

    public ResultadoCompletarReto Completar(int usuarioId, int retoId)
    {
        var resultado = _retoRepository.Completar(usuarioId, retoId);

        if (resultado.Resultado == 1)
        {
            _insigniaRepository.EvaluarYOtorgar(usuarioId);
        }

        return resultado;
    }
}