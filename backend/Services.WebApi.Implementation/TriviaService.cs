using Services.WebApi.Interface;
using WebApi.Data;
using WebApi.Model;

namespace Services.WebApi.Implementation;

public class TriviaService : ITriviaService
{
    private readonly TriviaRepository _triviaRepository;
    private readonly InsigniaRepository _insigniaRepository;

    public TriviaService(TriviaRepository triviaRepository, InsigniaRepository insigniaRepository)
    {
        _triviaRepository = triviaRepository;
        _insigniaRepository = insigniaRepository;
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

        _triviaRepository.ActualizarMejorPuntaje(usuarioId, categoriaId);

        // Solo evaluamos insignias si realmente otorgó puntos (fue correcta Y primer intento)
        if (resultado.PuntosOtorgados > 0)
        {
            _insigniaRepository.EvaluarYOtorgar(usuarioId);
        }

        return resultado;
    }
}