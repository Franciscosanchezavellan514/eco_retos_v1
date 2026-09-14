using WebApi.Model;

namespace Services.WebApi.Interface;

public interface IRetoService
{
    List<RetoInfo> ListarActivos();
    List<RetoConMaterialesInfo> ListarActivosConMateriales(int usuarioId);
    ResultadoCompletarReto Completar(int usuarioId, int retoId);
}