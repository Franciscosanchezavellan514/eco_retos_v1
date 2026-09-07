using Services.WebApi.Interface;
using WebApi.Data;
using WebApi.Model;

namespace Services.WebApi.Implementation;

public class MaterialService : IMaterialService
{
    private readonly MaterialRepository _materialRepository;

    public MaterialService(MaterialRepository materialRepository)
    {
        _materialRepository = materialRepository;
    }

    public List<MaterialInfo> ListarTienda()
    {
        return _materialRepository.ListarTienda();
    }

    public int Comprar(int usuarioId, int materialId, int cantidad)
    {
        return _materialRepository.Comprar(usuarioId, materialId, cantidad);
    }

    public List<InventarioMaterialInfo> ListarInventario(int usuarioId)
    {
        return _materialRepository.ListarInventario(usuarioId);
    }
}