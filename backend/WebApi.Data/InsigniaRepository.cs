using Microsoft.Data.SqlClient;
using Microsoft.Extensions.Configuration;
using System.Data;
using WebApi.Model;

namespace WebApi.Data;

public class InsigniaRepository
{
    private readonly string _connectionString;

    public InsigniaRepository(IConfiguration configuration)
    {
        _connectionString = configuration.GetConnectionString("EcoRetosDB")
            ?? throw new InvalidOperationException("No se encontró la cadena de conexión 'EcoRetosDB'.");
    }

    public int Otorgar(int usuarioId, int insigniaId)
    {
        using var connection = new SqlConnection(_connectionString);
        using var command = new SqlCommand("sp_Insignia_Otorgar", connection);
        command.CommandType = CommandType.StoredProcedure;
        command.Parameters.AddWithValue("@UsuarioId", usuarioId);
        command.Parameters.AddWithValue("@InsigniaId", insigniaId);

        connection.Open();
        var resultado = command.ExecuteScalar();

        return Convert.ToInt32(resultado);
    }

    public List<InsigniaInfo> ListarPorUsuario(int usuarioId)
    {
        var insignias = new List<InsigniaInfo>();

        using var connection = new SqlConnection(_connectionString);
        using var command = new SqlCommand("sp_Insignia_ListarPorUsuario", connection);
        command.CommandType = CommandType.StoredProcedure;
        command.Parameters.AddWithValue("@UsuarioId", usuarioId);

        connection.Open();
        using var reader = command.ExecuteReader();

        while (reader.Read())
        {
            insignias.Add(new InsigniaInfo
            {
                InsigniaId = reader.GetInt32(reader.GetOrdinal("InsigniaId")),
                Nombre = reader.GetString(reader.GetOrdinal("Nombre")),
                Descripcion = reader.IsDBNull(reader.GetOrdinal("Descripcion"))
                    ? null : reader.GetString(reader.GetOrdinal("Descripcion")),
                ImagenUrl = reader.IsDBNull(reader.GetOrdinal("ImagenUrl"))
                    ? null : reader.GetString(reader.GetOrdinal("ImagenUrl")),
                FechaObtenida = reader.GetDateTime(reader.GetOrdinal("FechaObtenida"))
            });
        }

        return insignias;
    }
}