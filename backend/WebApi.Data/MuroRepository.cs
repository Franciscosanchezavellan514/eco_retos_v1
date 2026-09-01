using Microsoft.Data.SqlClient;
using Microsoft.Extensions.Configuration;
using System.Data;
using WebApi.Model;

namespace WebApi.Data;

public class MuroRepository
{
    private readonly string _connectionString;

    public MuroRepository(IConfiguration configuration)
    {
        _connectionString = configuration.GetConnectionString("EcoRetosDB")
            ?? throw new InvalidOperationException("No se encontró la cadena de conexión 'EcoRetosDB'.");
    }

    public int CrearPublicacion(int usuarioId, string contenido, string? imagenUrl)
    {
        using var connection = new SqlConnection(_connectionString);
        using var command = new SqlCommand("sp_Publicacion_Crear", connection);
        command.CommandType = CommandType.StoredProcedure;
        command.Parameters.AddWithValue("@UsuarioId", usuarioId);
        command.Parameters.AddWithValue("@Contenido", contenido);
        command.Parameters.AddWithValue("@ImagenUrl", (object?)imagenUrl ?? DBNull.Value);

        connection.Open();
        var resultado = command.ExecuteScalar();

        return Convert.ToInt32(resultado);
    }

    public List<PublicacionInfo> ListarMuro()
    {
        var publicaciones = new List<PublicacionInfo>();

        using var connection = new SqlConnection(_connectionString);
        using var command = new SqlCommand("sp_Publicacion_ListarMuro", connection);
        command.CommandType = CommandType.StoredProcedure;

        connection.Open();
        using var reader = command.ExecuteReader();

        while (reader.Read())
        {
            publicaciones.Add(new PublicacionInfo
            {
                PublicacionId = reader.GetInt32(reader.GetOrdinal("PublicacionId")),
                UsuarioId = reader.GetInt32(reader.GetOrdinal("UsuarioId")),
                NombreUsuario = reader.GetString(reader.GetOrdinal("NombreUsuario")),
                Contenido = reader.GetString(reader.GetOrdinal("Contenido")),
                ImagenUrl = reader.IsDBNull(reader.GetOrdinal("ImagenUrl"))
                    ? null : reader.GetString(reader.GetOrdinal("ImagenUrl")),
                FechaPublicacion = reader.GetDateTime(reader.GetOrdinal("FechaPublicacion")),
                TotalReacciones = reader.GetInt32(reader.GetOrdinal("TotalReacciones")),
                TotalComentarios = reader.GetInt32(reader.GetOrdinal("TotalComentarios"))
            });
        }

        return publicaciones;
    }

    public int CrearComentario(int publicacionId, int usuarioId, string contenido, int? comentarioPadreId)
    {
        using var connection = new SqlConnection(_connectionString);
        using var command = new SqlCommand("sp_Comentario_Crear", connection);
        command.CommandType = CommandType.StoredProcedure;
        command.Parameters.AddWithValue("@PublicacionId", publicacionId);
        command.Parameters.AddWithValue("@UsuarioId", usuarioId);
        command.Parameters.AddWithValue("@Contenido", contenido);
        command.Parameters.AddWithValue("@ComentarioPadreId", (object?)comentarioPadreId ?? DBNull.Value);

        connection.Open();
        var resultado = command.ExecuteScalar();

        return Convert.ToInt32(resultado);
        // -1 = publicación no existe, -2 = comentario padre inválido
    }

    public List<ComentarioInfo> ListarComentarios(int publicacionId)
    {
        var comentarios = new List<ComentarioInfo>();

        using var connection = new SqlConnection(_connectionString);
        using var command = new SqlCommand("sp_Comentario_ListarPorPublicacion", connection);
        command.CommandType = CommandType.StoredProcedure;
        command.Parameters.AddWithValue("@PublicacionId", publicacionId);

        connection.Open();
        using var reader = command.ExecuteReader();

        while (reader.Read())
        {
            comentarios.Add(new ComentarioInfo
            {
                ComentarioId = reader.GetInt32(reader.GetOrdinal("ComentarioId")),
                UsuarioId = reader.GetInt32(reader.GetOrdinal("UsuarioId")),
                NombreUsuario = reader.GetString(reader.GetOrdinal("NombreUsuario")),
                ComentarioPadreId = reader.IsDBNull(reader.GetOrdinal("ComentarioPadreId"))
                    ? null : reader.GetInt32(reader.GetOrdinal("ComentarioPadreId")),
                Contenido = reader.GetString(reader.GetOrdinal("Contenido")),
                FechaComentario = reader.GetDateTime(reader.GetOrdinal("FechaComentario"))
            });
        }

        return comentarios;
    }

    public string ToggleReaccion(int publicacionId, int usuarioId)
    {
        using var connection = new SqlConnection(_connectionString);
        using var command = new SqlCommand("sp_Reaccion_Toggle", connection);
        command.CommandType = CommandType.StoredProcedure;
        command.Parameters.AddWithValue("@PublicacionId", publicacionId);
        command.Parameters.AddWithValue("@UsuarioId", usuarioId);

        connection.Open();
        var resultado = command.ExecuteScalar();

        return resultado?.ToString() ?? "";
    }
}