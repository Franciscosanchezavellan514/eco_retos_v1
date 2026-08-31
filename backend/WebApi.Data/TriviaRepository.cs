using Microsoft.Data.SqlClient;
using Microsoft.Extensions.Configuration;
using System.Data;
using WebApi.Model;

namespace WebApi.Data;

public class TriviaRepository
{
    private readonly string _connectionString;

    public TriviaRepository(IConfiguration configuration)
    {
        _connectionString = configuration.GetConnectionString("EcoRetosDB")
            ?? throw new InvalidOperationException("No se encontró la cadena de conexión 'EcoRetosDB'.");
    }

    public List<CategoriaTriviaInfo> ListarCategorias()
    {
        var categorias = new List<CategoriaTriviaInfo>();

        using var connection = new SqlConnection(_connectionString);
        using var command = new SqlCommand("sp_Trivia_ListarCategorias", connection);
        command.CommandType = CommandType.StoredProcedure;

        connection.Open();
        using var reader = command.ExecuteReader();

        while (reader.Read())
        {
            categorias.Add(new CategoriaTriviaInfo
            {
                CategoriaId = reader.GetInt32(reader.GetOrdinal("CategoriaId")),
                Nombre = reader.GetString(reader.GetOrdinal("Nombre")),
                Grupo = reader.GetString(reader.GetOrdinal("Grupo")),
                Dificultad = reader.GetString(reader.GetOrdinal("Dificultad"))
            });
        }

        return categorias;
    }

    public List<PreguntaInfo> ListarPreguntas(int categoriaId)
    {
        var preguntasDict = new Dictionary<int, PreguntaInfo>();

        using var connection = new SqlConnection(_connectionString);
        using var command = new SqlCommand("sp_Trivia_ListarPreguntas", connection);
        command.CommandType = CommandType.StoredProcedure;
        command.Parameters.AddWithValue("@CategoriaId", categoriaId);

        connection.Open();
        using var reader = command.ExecuteReader();

        while (reader.Read())
        {
            var preguntaId = reader.GetInt32(reader.GetOrdinal("PreguntaId"));

            if (!preguntasDict.TryGetValue(preguntaId, out var pregunta))
            {
                pregunta = new PreguntaInfo
                {
                    PreguntaId = preguntaId,
                    Enunciado = reader.GetString(reader.GetOrdinal("Enunciado"))
                };
                preguntasDict[preguntaId] = pregunta;
            }

            pregunta.Opciones.Add(new OpcionPreguntaInfo
            {
                OpcionId = reader.GetInt32(reader.GetOrdinal("OpcionId")),
                Texto = reader.GetString(reader.GetOrdinal("Texto"))
            });
        }

        return preguntasDict.Values.ToList();
    }

    public ResultadoRespuestaInfo Responder(int usuarioId, int preguntaId, int opcionId)
    {
        using var connection = new SqlConnection(_connectionString);
        using var command = new SqlCommand("sp_Trivia_Responder", connection);
        command.CommandType = CommandType.StoredProcedure;
        command.Parameters.AddWithValue("@UsuarioId", usuarioId);
        command.Parameters.AddWithValue("@PreguntaId", preguntaId);
        command.Parameters.AddWithValue("@OpcionSeleccionadaId", opcionId);

        connection.Open();
        using var reader = command.ExecuteReader();
        reader.Read();

        return new ResultadoRespuestaInfo
        {
            EsCorrecta = reader.GetBoolean(reader.GetOrdinal("EsCorrecta")),
            PuntosOtorgados = reader.GetInt32(reader.GetOrdinal("PuntosOtorgados"))
        };
    }

    public void ActualizarMejorPuntaje(int usuarioId, int categoriaId)
    {
        using var connection = new SqlConnection(_connectionString);
        using var command = new SqlCommand("sp_Trivia_ActualizarMejorPuntaje", connection);
        command.CommandType = CommandType.StoredProcedure;
        command.Parameters.AddWithValue("@UsuarioId", usuarioId);
        command.Parameters.AddWithValue("@CategoriaId", categoriaId);

        connection.Open();
        command.ExecuteNonQuery();
    }
}