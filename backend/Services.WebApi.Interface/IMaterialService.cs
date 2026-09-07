using WebApi.Model;

namespace Services.WebApi.Interface;

public interface IMaterialService
{
    List<MaterialInfo> ListarTienda();
    int Comprar(int usuarioId, int materialId, int cantidad);
    List<InventarioMaterialInfo> ListarInventario(int usuarioId);
}