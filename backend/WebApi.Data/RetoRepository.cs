using Microsoft.Data.SqlClient;
using Microsoft.Extensions.Configuration;
using System.Data;
using WebApi.Model;

namespace WebApi.Data;


public class RetoRepository
{
    private readonly string _connectionString;

    public RetoRepository(IConfiguration configuration)
    {
        _connectionString = configuration.GetConnectionString("EcoRetosDB")
            ?? throw new InvalidOperationException("No se encontró la cadena de conexión 'EcoRetosDB'.");
    }

    public List<RetoInfo> ListarActivos()
    {
        var retos = new List<RetoInfo>();

        using var connection = new SqlConnection(_connectionString);
        using var command = new SqlCommand("sp_Reto_ListarActivos", connection);
        command.CommandType = CommandType.StoredProcedure;

        connection.Open();
        using var reader = command.ExecuteReader();

        while (reader.Read())
        {
            retos.Add(new RetoInfo
            {
                RetoId = reader.GetInt32(reader.GetOrdinal("RetoId")),
                Titulo = reader.GetString(reader.GetOrdinal("Titulo")),
                Descripcion = reader.GetString(reader.GetOrdinal("Descripcion")),
                PuntosRecompensa = reader.GetInt32(reader.GetOrdinal("PuntosRecompensa")),
                Dificultad = reader.GetString(reader.GetOrdinal("Dificultad"))
            });
        }

        return retos;
    }

    public int Completar(int usuarioId, int retoId)
    {
        using var connection = new SqlConnection(_connectionString);
        using var command = new SqlCommand("sp_Reto_Completar", connection);
        command.CommandType = CommandType.StoredProcedure;
        command.Parameters.AddWithValue("@UsuarioId", usuarioId);
        command.Parameters.AddWithValue("@RetoId", retoId);

        connection.Open();
        var resultado = command.ExecuteScalar();

        return Convert.ToInt32(resultado);
        // 1 = éxito, -1 = ya completado, -2 = materiales insuficientes, -3 = reto no existe
    }
}