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

    public int ColocarPlanta(int usuarioId, int numeroSlot, int plantaId)
    {
        return _jardinRepository.ColocarPlanta(usuarioId, numeroSlot, plantaId);
    }

    public List<JardinSlotInfo> VerEstado(int usuarioId)
    {
        return _jardinRepository.VerEstado(usuarioId);
    }
}