using WebApi.Model;

namespace Services.WebApi.Interface;

public interface IJardinService
{
    int ComprarYColocar(int usuarioId, int plantaId, int numeroSlot);
    List<JardinSlotInfo> VerEstado(int usuarioId);
}