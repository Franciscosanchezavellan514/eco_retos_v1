namespace WebApi.Model;

public class CategoriaTriviaInfo
{
    public int CategoriaId { get; set; }
    public string Nombre { get; set; } = string.Empty;
    public string Grupo { get; set; } = string.Empty;
    public string Dificultad { get; set; } = string.Empty;
}

public class OpcionPreguntaInfo
{
    public int OpcionId { get; set; }
    public string Texto { get; set; } = string.Empty;
}

public class PreguntaInfo
{
    public int PreguntaId { get; set; }
    public string Enunciado { get; set; } = string.Empty;
    public List<OpcionPreguntaInfo> Opciones { get; set; } = new();
}

public class ResultadoRespuestaInfo
{
    public bool EsCorrecta { get; set; }
    public int PuntosOtorgados { get; set; }
}