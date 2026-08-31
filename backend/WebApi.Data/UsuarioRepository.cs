using Microsoft.Data.SqlClient;
using Microsoft.Extensions.Configuration;
using System.Data;
using WebApi.Model;

namespace WebApi.Data;

public class UsuarioRepository
{
    private readonly string _connectionString;

    public UsuarioRepository(IConfiguration configuration)
    {
        _connectionString = configuration.GetConnectionString("EcoRetosDB")
            ?? throw new InvalidOperationException("No se encontró la cadena de conexión 'EcoRetosDB'.");
    }

    public int Registrar(Usuario usuario)
    {
        using var connection = new SqlConnection(_connectionString);
        using var command = new SqlCommand("sp_Usuario_Registrar", connection);
        command.CommandType = CommandType.StoredProcedure;

        command.Parameters.AddWithValue("@UID", usuario.UID);
        command.Parameters.AddWithValue("@NombreUsuario", usuario.NombreUsuario);
        command.Parameters.AddWithValue("@Email", usuario.Email);
        command.Parameters.AddWithValue("@PasswordHash", usuario.PasswordHash);

        connection.Open();
        var resultado = command.ExecuteScalar();

        return Convert.ToInt32(resultado);
    }

    public Usuario? ObtenerPorEmail(string email)
    {
        using var connection = new SqlConnection(_connectionString);
        using var command = new SqlCommand("sp_Usuario_ObtenerPorEmail", connection);
        command.CommandType = CommandType.StoredProcedure;
        command.Parameters.AddWithValue("@Email", email);

        connection.Open();
        using var reader = command.ExecuteReader();

        if (!reader.Read())
        {
            return null;
        }

        return new Usuario
        {
            UsuarioId = reader.GetInt32(reader.GetOrdinal("UsuarioId")),
            UID = reader.GetString(reader.GetOrdinal("UID")),
            NombreUsuario = reader.GetString(reader.GetOrdinal("NombreUsuario")),
            Email = reader.GetString(reader.GetOrdinal("Email")),
            PasswordHash = reader.GetString(reader.GetOrdinal("PasswordHash")),
            FechaRegistro = reader.GetDateTime(reader.GetOrdinal("FechaRegistro")),
            UltimaConexion = reader.IsDBNull(reader.GetOrdinal("UltimaConexion"))
                ? null : reader.GetDateTime(reader.GetOrdinal("UltimaConexion")),
            RachaActual = reader.GetInt32(reader.GetOrdinal("RachaActual")),
            Puntos = reader.GetInt32(reader.GetOrdinal("Puntos")),
            Monedas = reader.GetInt32(reader.GetOrdinal("Monedas")),
            EsAdmin = reader.GetBoolean(reader.GetOrdinal("EsAdmin")),
            Activo = reader.GetBoolean(reader.GetOrdinal("Activo"))
        };
    }

    public Usuario? ObtenerPorId(int usuarioId)
    {
        using var connection = new SqlConnection(_connectionString);
        using var command = new SqlCommand("sp_Usuario_ObtenerPorId", connection);
        command.CommandType = CommandType.StoredProcedure;
        command.Parameters.AddWithValue("@UsuarioId", usuarioId);

        connection.Open();
        using var reader = command.ExecuteReader();

        if (!reader.Read())
        {
            return null;
        }

        return new Usuario
        {
            UsuarioId = reader.GetInt32(reader.GetOrdinal("UsuarioId")),
            UID = reader.GetString(reader.GetOrdinal("UID")),
            NombreUsuario = reader.GetString(reader.GetOrdinal("NombreUsuario")),
            Email = reader.GetString(reader.GetOrdinal("Email")),
            PasswordHash = reader.GetString(reader.GetOrdinal("PasswordHash")),
            FechaRegistro = reader.GetDateTime(reader.GetOrdinal("FechaRegistro")),
            UltimaConexion = reader.IsDBNull(reader.GetOrdinal("UltimaConexion"))
                ? null : reader.GetDateTime(reader.GetOrdinal("UltimaConexion")),
            RachaActual = reader.GetInt32(reader.GetOrdinal("RachaActual")),
            Puntos = reader.GetInt32(reader.GetOrdinal("Puntos")),
            Monedas = reader.GetInt32(reader.GetOrdinal("Monedas")),
            EsAdmin = reader.GetBoolean(reader.GetOrdinal("EsAdmin")),
            Activo = reader.GetBoolean(reader.GetOrdinal("Activo"))
        };
    }
}