using Microsoft.Data.SqlClient;
using Microsoft.Extensions.Configuration;
using System.Data;
using WebApi.Model;

namespace WebApi.Data;

public class JardinRepository
{
    private readonly string _connectionString;

    public JardinRepository(IConfiguration configuration)
    {
        _connectionString = configuration.GetConnectionString("EcoRetosDB")
            ?? throw new InvalidOperationException("No se encontró la cadena de conexión 'EcoRetosDB'.");
    }

    public int ColocarPlanta(int usuarioId, int numeroSlot, int plantaId)
    {
        using var connection = new SqlConnection(_connectionString);
        using var command = new SqlCommand("sp_Jardin_ColocarPlanta", connection);
        command.CommandType = CommandType.StoredProcedure;
        command.Parameters.AddWithValue("@UsuarioId", usuarioId);
        command.Parameters.AddWithValue("@NumeroSlot", numeroSlot);
        command.Parameters.AddWithValue("@PlantaId", plantaId);

        connection.Open();
        var resultado = command.ExecuteScalar();

        return Convert.ToInt32(resultado);
    }

    public List<JardinSlotInfo> VerEstado(int usuarioId)
    {
        var slots = new List<JardinSlotInfo>();

        using var connection = new SqlConnection(_connectionString);
        using var command = new SqlCommand("sp_Jardin_VerEstado", connection);
        command.CommandType = CommandType.StoredProcedure;
        command.Parameters.AddWithValue("@UsuarioId", usuarioId);

        connection.Open();
        using var reader = command.ExecuteReader();

        while (reader.Read())
        {
            slots.Add(new JardinSlotInfo
            {
                NumeroSlot = reader.GetInt32(reader.GetOrdinal("NumeroSlot")),
                PlantaId = reader.GetInt32(reader.GetOrdinal("PlantaId")),
                NombrePlanta = reader.GetString(reader.GetOrdinal("NombrePlanta")),
                FechaColocacion = reader.GetDateTime(reader.GetOrdinal("FechaColocacion"))
            });
        }

        return slots;
    }
}