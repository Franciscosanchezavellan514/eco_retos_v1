using WebApi.Model;

namespace Services.WebApi.Interface;

public interface IJardinService
{
    int ColocarPlanta(int usuarioId, int numeroSlot, int plantaId);
    List<JardinSlotInfo> VerEstado(int usuarioId);
}