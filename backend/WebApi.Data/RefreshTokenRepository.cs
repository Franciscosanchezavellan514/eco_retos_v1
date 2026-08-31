using Microsoft.Data.SqlClient;
using Microsoft.Extensions.Configuration;
using System.Data;

namespace WebApi.Data;

public class RefreshTokenInfo
{
    public int RefreshTokenId { get; set; }
    public int UsuarioId { get; set; }
    public string TokenHash { get; set; } = string.Empty;
    public DateTime FechaCreacion { get; set; }
    public DateTime FechaExpiracion { get; set; }
    public bool Revocado { get; set; }
}

public class RefreshTokenRepository
{
    private readonly string _connectionString;

    public RefreshTokenRepository(IConfiguration configuration)
    {
        _connectionString = configuration.GetConnectionString("EcoRetosDB")
            ?? throw new InvalidOperationException("No se encontró la cadena de conexión 'EcoRetosDB'.");
    }

    public void Crear(int usuarioId, string tokenHash, DateTime fechaExpiracion)
    {
        using var connection = new SqlConnection(_connectionString);
        using var command = new SqlCommand("sp_RefreshToken_Crear", connection);
        command.CommandType = CommandType.StoredProcedure;

        command.Parameters.AddWithValue("@UsuarioId", usuarioId);
        command.Parameters.AddWithValue("@TokenHash", tokenHash);
        command.Parameters.AddWithValue("@FechaExpiracion", fechaExpiracion);

        connection.Open();
        command.ExecuteNonQuery();
    }

    public RefreshTokenInfo? ObtenerValido(string tokenHash)
    {
        using var connection = new SqlConnection(_connectionString);
        using var command = new SqlCommand("sp_RefreshToken_ObtenerValido", connection);
        command.CommandType = CommandType.StoredProcedure;
        command.Parameters.AddWithValue("@TokenHash", tokenHash);

        connection.Open();
        using var reader = command.ExecuteReader();

        if (!reader.Read())
        {
            return null;
        }

        return new RefreshTokenInfo
        {
            RefreshTokenId = reader.GetInt32(reader.GetOrdinal("RefreshTokenId")),
            UsuarioId = reader.GetInt32(reader.GetOrdinal("UsuarioId")),
            TokenHash = reader.GetString(reader.GetOrdinal("TokenHash")),
            FechaCreacion = reader.GetDateTime(reader.GetOrdinal("FechaCreacion")),
            FechaExpiracion = reader.GetDateTime(reader.GetOrdinal("FechaExpiracion")),
            Revocado = reader.GetBoolean(reader.GetOrdinal("Revocado"))
        };
    }

    public void Revocar(string tokenHash)
    {
        using var connection = new SqlConnection(_connectionString);
        using var command = new SqlCommand("sp_RefreshToken_Revocar", connection);
        command.CommandType = CommandType.StoredProcedure;
        command.Parameters.AddWithValue("@TokenHash", tokenHash);

        connection.Open();
        command.ExecuteNonQuery();
    }
}