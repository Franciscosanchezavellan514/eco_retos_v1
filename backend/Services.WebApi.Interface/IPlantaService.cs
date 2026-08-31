using WebApi.Model;

namespace Services.WebApi.Interface;

public interface IPlantaService
{
    List<PlantaInfo> ListarTienda();
    int Comprar(int usuarioId, int plantaId);
}