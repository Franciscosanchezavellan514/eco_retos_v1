using Services.WebApi.Interface;
using WebApi.Data;
using WebApi.Model;

namespace Services.WebApi.Implementation;

public class JardinService : IJardinService
{
    private readonly JardinRepository _jardinRepository;

    public JardinService(JardinRepository jardinRepository)
    {
        _jardinRepository = jardinRepository;
    }

    public int ComprarYColocar(int usuarioId, int plantaId, int numeroSlot)
    {
        return _jardinRepository.ComprarYColocar(usuarioId, plantaId, numeroSlot);
    }

    public List<JardinSlotInfo> VerEstado(int usuarioId)
    {
        return _jardinRepository.VerEstado(usuarioId);
    }
}