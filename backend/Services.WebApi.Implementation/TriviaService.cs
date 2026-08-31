using Services.WebApi.Interface;
using WebApi.Data;
using WebApi.Model;

namespace Services.WebApi.Implementation;

public class TriviaService : ITriviaService
{
    private readonly TriviaRepository _triviaRepository;

    public TriviaService(TriviaRepository triviaRepository)
    {
        _triviaRepository = triviaRepository;
    }

    public List<CategoriaTriviaInfo> ListarCategorias()
    {
        return _triviaRepository.ListarCategorias();
    }

    public List<PreguntaInfo> ListarPreguntas(int categoriaId)
    {
        return _triviaRepository.ListarPreguntas(categoriaId);
    }

    public ResultadoRespuestaInfo Responder(int usuarioId, int preguntaId, int opcionId, int categoriaId)
    {
        var resultado = _triviaRepository.Responder(usuarioId, preguntaId, opcionId);

        // Después de cada respuesta, actualizamos el resumen de mejor puntaje
        _triviaRepository.ActualizarMejorPuntaje(usuarioId, categoriaId);

        return resultado;
    }
}