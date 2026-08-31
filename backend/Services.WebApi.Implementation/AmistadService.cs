using Services.WebApi.Interface;
using WebApi.Data;
using WebApi.Model;

namespace Services.WebApi.Implementation;

public class AmistadService : IAmistadService
{
    private readonly AmistadRepository _amistadRepository;

    public AmistadService(AmistadRepository amistadRepository)
    {
        _amistadRepository = amistadRepository;
    }

    public int EnviarSolicitud(int usuarioSolicitanteId, string uidReceptor)
    {
        var receptor = _amistadRepository.BuscarPorUID(uidReceptor);

        if (receptor == null || !receptor.Activo)
        {
            return -2; // código especial: UID no existe o usuario inactivo
        }

        if (receptor.UsuarioId == usuarioSolicitanteId)
        {
            return -3; // código especial: no puedes agregarte a ti mismo
        }

        return _amistadRepository.CrearSolicitud(usuarioSolicitanteId, receptor.UsuarioId);
        // -1 = ya existe una relación (viene del stored procedure)
    }

    public bool Responder(int amistadId, int usuarioReceptorId, bool aceptar)
    {
        var nuevoEstado = aceptar ? "Aceptada" : "Rechazada";
        var filasAfectadas = _amistadRepository.Responder(amistadId, usuarioReceptorId, nuevoEstado);
        return filasAfectadas > 0;
    }

    public List<AmigoDto> ListarAmigos(int usuarioId)
    {
        return _amistadRepository.ListarAmigos(usuarioId);
    }
}