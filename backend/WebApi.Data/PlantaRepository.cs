using Microsoft.Data.SqlClient;
using Microsoft.Extensions.Configuration;
using System.Data;
using WebApi.Model;

namespace WebApi.Data;

public class PlantaRepository
{
    private readonly string _connectionString;

    public PlantaRepository(IConfiguration configuration)
    {
        _connectionString = configuration.GetConnectionString("EcoRetosDB")
            ?? throw new InvalidOperationException("No se encontró la cadena de conexión 'EcoRetosDB'.");
    }

    public List<PlantaInfo> ListarTienda()
    {
        var plantas = new List<PlantaInfo>();

        using var connection = new SqlConnection(_connectionString);
        using var command = new SqlCommand("sp_Planta_ListarTienda", connection);
        command.CommandType = CommandType.StoredProcedure;

        connection.Open();
        using var reader = command.ExecuteReader();

        while (reader.Read())
        {
            plantas.Add(new PlantaInfo
            {
                PlantaId = reader.GetInt32(reader.GetOrdinal("PlantaId")),
                Nombre = reader.GetString(reader.GetOrdinal("Nombre")),
                PrecioMonedas = reader.GetInt32(reader.GetOrdinal("PrecioMonedas")),
                ImagenUrl = reader.IsDBNull(reader.GetOrdinal("ImagenUrl"))
                    ? null : reader.GetString(reader.GetOrdinal("ImagenUrl"))
            });
        }

        return plantas;
    }

    public int Comprar(int usuarioId, int plantaId)
    {
        using var connection = new SqlConnection(_connectionString);
        using var command = new SqlCommand("sp_Planta_Comprar", connection);
        command.CommandType = CommandType.StoredProcedure;
        command.Parameters.AddWithValue("@UsuarioId", usuarioId);
        command.Parameters.AddWithValue("@PlantaId", plantaId);

        connection.Open();
        var resultado = command.ExecuteScalar();

        return Convert.ToInt32(resultado);
    }
}