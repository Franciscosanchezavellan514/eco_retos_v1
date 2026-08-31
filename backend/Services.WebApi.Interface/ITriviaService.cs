using WebApi.Model;

namespace Services.WebApi.Interface;

public interface ITriviaService
{
    List<CategoriaTriviaInfo> ListarCategorias();
    List<PreguntaInfo> ListarPreguntas(int categoriaId);
    ResultadoRespuestaInfo Responder(int usuarioId, int preguntaId, int opcionId, int categoriaId);
}