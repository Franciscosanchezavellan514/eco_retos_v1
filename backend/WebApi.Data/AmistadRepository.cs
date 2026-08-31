using Microsoft.Data.SqlClient;
using Microsoft.Extensions.Configuration;
using System.Data;
using WebApi.Model;

namespace WebApi.Data;

public class AmistadRepository
{
    private readonly string _connectionString;

    public AmistadRepository(IConfiguration configuration)
    {
        _connectionString = configuration.GetConnectionString("EcoRetosDB")
            ?? throw new InvalidOperationException("No se encontró la cadena de conexión 'EcoRetosDB'.");
    }

    public UsuarioBusquedaDto? BuscarPorUID(string uid)
    {
        using var connection = new SqlConnection(_connectionString);
        using var command = new SqlCommand("sp_Usuario_ObtenerPorUID", connection);
        command.CommandType = CommandType.StoredProcedure;
        command.Parameters.AddWithValue("@UID", uid);

        connection.Open();
        using var reader = command.ExecuteReader();

        if (!reader.Read())
        {
            return null;
        }

        return new UsuarioBusquedaDto
        {
            UsuarioId = reader.GetInt32(reader.GetOrdinal("UsuarioId")),
            UID = reader.GetString(reader.GetOrdinal("UID")),
            NombreUsuario = reader.GetString(reader.GetOrdinal("NombreUsuario")),
            Activo = reader.GetBoolean(reader.GetOrdinal("Activo"))
        };
    }

    public int CrearSolicitud(int usuarioSolicitanteId, int usuarioReceptorId)
    {
        using var connection = new SqlConnection(_connectionString);
        using var command = new SqlCommand("sp_Amistad_CrearSolicitud", connection);
        command.CommandType = CommandType.StoredProcedure;
        command.Parameters.AddWithValue("@UsuarioSolicitanteId", usuarioSolicitanteId);
        command.Parameters.AddWithValue("@UsuarioReceptorId", usuarioReceptorId);

        connection.Open();
        var resultado = command.ExecuteScalar();

        return Convert.ToInt32(resultado); // -1 si ya existía la relación
    }

    public int Responder(int amistadId, int usuarioReceptorId, string nuevoEstado)
    {
        using var connection = new SqlConnection(_connectionString);
        using var command = new SqlCommand("sp_Amistad_Responder", connection);
        command.CommandType = CommandType.StoredProcedure;
        command.Parameters.AddWithValue("@AmistadId", amistadId);
        command.Parameters.AddWithValue("@UsuarioReceptorId", usuarioReceptorId);
        command.Parameters.AddWithValue("@NuevoEstado", nuevoEstado);

        connection.Open();
        var resultado = command.ExecuteScalar();

        return Convert.ToInt32(resultado); // filas afectadas: 1 = ok, 0 = no encontrado/no autorizado
    }

    public List<AmigoDto> ListarAmigos(int usuarioId)
    {
        var amigos = new List<AmigoDto>();

        using var connection = new SqlConnection(_connectionString);
        using var command = new SqlCommand("sp_Amistad_ListarAmigos", connection);
        command.CommandType = CommandType.StoredProcedure;
        command.Parameters.AddWithValue("@UsuarioId", usuarioId);

        connection.Open();
        using var reader = command.ExecuteReader();

        while (reader.Read())
        {
            amigos.Add(new AmigoDto
            {
                UsuarioId = reader.GetInt32(reader.GetOrdinal("UsuarioId")),
                UID = reader.GetString(reader.GetOrdinal("UID")),
                NombreUsuario = reader.GetString(reader.GetOrdinal("NombreUsuario")),
                FechaDesdeQueSonAmigos = reader.GetDateTime(reader.GetOrdinal("FechaDesdeQueSonAmigos"))
            });
        }

        return amigos;
    }
}