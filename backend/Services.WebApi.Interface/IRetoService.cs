using WebApi.Model;

namespace Services.WebApi.Interface;

public interface IRetoService
{
    List<RetoInfo> ListarActivos();
    int Completar(int usuarioId, int retoId);
}