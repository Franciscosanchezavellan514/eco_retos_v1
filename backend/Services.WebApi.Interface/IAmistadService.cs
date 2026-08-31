using WebApi.Model;

namespace Services.WebApi.Interface;

public interface IAmistadService
{
    int EnviarSolicitud(int usuarioSolicitanteId, string uidReceptor);
    bool Responder(int amistadId, int usuarioReceptorId, bool aceptar);
    List<AmigoDto> ListarAmigos(int usuarioId);
}