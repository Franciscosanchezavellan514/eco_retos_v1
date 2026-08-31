using Services.WebApi.Interface;
using WebApi.Data;
using WebApi.Model;

namespace Services.WebApi.Implementation;

public class PlantaService : IPlantaService
{
    private readonly PlantaRepository _plantaRepository;

    public PlantaService(PlantaRepository plantaRepository)
    {
        _plantaRepository = plantaRepository;
    }

    public List<PlantaInfo> ListarTienda()
    {
        return _plantaRepository.ListarTienda();
    }

    public int Comprar(int usuarioId, int plantaId)
    {
        return _plantaRepository.Comprar(usuarioId, plantaId);
    }
}