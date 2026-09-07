using Microsoft.Data.SqlClient;
using Microsoft.Extensions.Configuration;
using System.Data;
using WebApi.Model;

namespace WebApi.Data;

public class MaterialRepository
{
    private readonly string _connectionString;

    public MaterialRepository(IConfiguration configuration)
    {
        _connectionString = configuration.GetConnectionString("EcoRetosDB")
            ?? throw new InvalidOperationException("No se encontró la cadena de conexión 'EcoRetosDB'.");
    }

    public List<MaterialInfo> ListarTienda()
    {
        var materiales = new List<MaterialInfo>();

        using var connection = new SqlConnection(_connectionString);
        using var command = new SqlCommand("sp_Material_ListarTienda", connection);
        command.CommandType = CommandType.StoredProcedure;

        connection.Open();
        using var reader = command.ExecuteReader();

        while (reader.Read())
        {
            materiales.Add(new MaterialInfo
            {
                MaterialId = reader.GetInt32(reader.GetOrdinal("MaterialId")),
                Nombre = reader.GetString(reader.GetOrdinal("Nombre")),
                Descripcion = reader.IsDBNull(reader.GetOrdinal("Descripcion"))
                    ? null : reader.GetString(reader.GetOrdinal("Descripcion")),
                PrecioPuntos = reader.GetInt32(reader.GetOrdinal("PrecioPuntos")),
                ImagenUrl = reader.IsDBNull(reader.GetOrdinal("ImagenUrl"))
                    ? null : reader.GetString(reader.GetOrdinal("ImagenUrl"))
            });
        }

        return materiales;
    }

    public int Comprar(int usuarioId, int materialId, int cantidad)
    {
        using var connection = new SqlConnection(_connectionString);
        using var command = new SqlCommand("sp_Material_Comprar", connection);
        command.CommandType = CommandType.StoredProcedure;
        command.Parameters.AddWithValue("@UsuarioId", usuarioId);
        command.Parameters.AddWithValue("@MaterialId", materialId);
        command.Parameters.AddWithValue("@Cantidad", cantidad);

        connection.Open();
        var resultado = command.ExecuteScalar();

        return Convert.ToInt32(resultado);
    }

    public List<InventarioMaterialInfo> ListarInventario(int usuarioId)
    {
        var inventario = new List<InventarioMaterialInfo>();

        using var connection = new SqlConnection(_connectionString);
        using var command = new SqlCommand("sp_Material_ListarInventario", connection);
        command.CommandType = CommandType.StoredProcedure;
        command.Parameters.AddWithValue("@UsuarioId", usuarioId);

        connection.Open();
        using var reader = command.ExecuteReader();

        while (reader.Read())
        {
            inventario.Add(new InventarioMaterialInfo
            {
                MaterialId = reader.GetInt32(reader.GetOrdinal("MaterialId")),
                Nombre = reader.GetString(reader.GetOrdinal("Nombre")),
                Descripcion = reader.IsDBNull(reader.GetOrdinal("Descripcion"))
                    ? null : reader.GetString(reader.GetOrdinal("Descripcion")),
                ImagenUrl = reader.IsDBNull(reader.GetOrdinal("ImagenUrl"))
                    ? null : reader.GetString(reader.GetOrdinal("ImagenUrl")),
                Cantidad = reader.GetInt32(reader.GetOrdinal("Cantidad"))
            });
        }

        return inventario;
    }
}