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
}