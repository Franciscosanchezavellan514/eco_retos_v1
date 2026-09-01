using WebApi.Model;

namespace Services.WebApi.Interface;

public interface IMuroService
{
    int CrearPublicacion(int usuarioId, string contenido, string? imagenUrl);
    List<PublicacionInfo> ListarMuro();
    int CrearComentario(int publicacionId, int usuarioId, string contenido, int? comentarioPadreId);
    List<ComentarioInfo> ListarComentarios(int publicacionId);
    string ToggleReaccion(int publicacionId, int usuarioId);
}