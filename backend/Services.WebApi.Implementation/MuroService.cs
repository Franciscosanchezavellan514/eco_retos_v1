using Services.WebApi.Interface;
using WebApi.Data;
using WebApi.Model;

namespace Services.WebApi.Implementation;

public class MuroService : IMuroService
{
    private readonly MuroRepository _muroRepository;

    public MuroService(MuroRepository muroRepository)
    {
        _muroRepository = muroRepository;
    }

    public int CrearPublicacion(int usuarioId, string contenido, string? imagenUrl)
    {
        return _muroRepository.CrearPublicacion(usuarioId, contenido, imagenUrl);
    }

    public List<PublicacionInfo> ListarMuro()
    {
        return _muroRepository.ListarMuro();
    }

    public int CrearComentario(int publicacionId, int usuarioId, string contenido, int? comentarioPadreId)
    {
        return _muroRepository.CrearComentario(publicacionId, usuarioId, contenido, comentarioPadreId);
    }

    public List<ComentarioInfo> ListarComentarios(int publicacionId)
    {
        return _muroRepository.ListarComentarios(publicacionId);
    }

    public string ToggleReaccion(int publicacionId, int usuarioId)
    {
        return _muroRepository.ToggleReaccion(publicacionId, usuarioId);
    }
}