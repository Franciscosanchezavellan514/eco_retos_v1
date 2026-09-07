using WebApi.Model;

namespace Services.WebApi.Interface;

public interface IRetoService
{
    List<RetoInfo> ListarActivos();
    ResultadoCompletarReto Completar(int usuarioId, int retoId);
}