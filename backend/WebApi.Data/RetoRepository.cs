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

    public List<RetoConMaterialesInfo> ListarActivosConMateriales(int usuarioId)
    {
        var retosDict = new Dictionary<int, RetoConMaterialesInfo>();

        using var connection = new SqlConnection(_connectionString);
        using var command = new SqlCommand("sp_Reto_ListarActivosConMateriales", connection);
        command.CommandType = CommandType.StoredProcedure;
        command.Parameters.AddWithValue("@UsuarioId", usuarioId);

        connection.Open();
        using var reader = command.ExecuteReader();

        while (reader.Read())
        {
            var retoId = reader.GetInt32(reader.GetOrdinal("RetoId"));

            if (!retosDict.TryGetValue(retoId, out var reto))
            {
                reto = new RetoConMaterialesInfo
                {
                    RetoId = retoId,
                    Titulo = reader.GetString(reader.GetOrdinal("Titulo")),
                    Descripcion = reader.GetString(reader.GetOrdinal("Descripcion")),
                    PuntosRecompensa = reader.GetInt32(reader.GetOrdinal("PuntosRecompensa")),
                    Dificultad = reader.GetString(reader.GetOrdinal("Dificultad"))
                };
                retosDict[retoId] = reto;
            }

            reto.Materiales.Add(new MaterialRequeridoInfo
            {
                MaterialId = reader.GetInt32(reader.GetOrdinal("MaterialId")),
                NombreMaterial = reader.GetString(reader.GetOrdinal("NombreMaterial")),
                CantidadRequerida = reader.GetInt32(reader.GetOrdinal("CantidadRequerida")),
                CantidadDisponible = reader.GetInt32(reader.GetOrdinal("CantidadDisponible"))
            });
        }

        return retosDict.Values.ToList();
    }

    public ResultadoCompletarReto Completar(int usuarioId, int retoId)
    {
        using var connection = new SqlConnection(_connectionString);
        using var command = new SqlCommand("sp_Reto_Completar", connection);
        command.CommandType = CommandType.StoredProcedure;
        command.Parameters.AddWithValue("@UsuarioId", usuarioId);
        command.Parameters.AddWithValue("@RetoId", retoId);

        connection.Open();
        using var reader = command.ExecuteReader();
        reader.Read();

        var resultado = reader.GetInt32(reader.GetOrdinal("Resultado"));

        return new ResultadoCompletarReto
        {
            Resultado = resultado,
            PuntosOtorgados = resultado == 1 ? reader.GetInt32(reader.GetOrdinal("PuntosOtorgados")) : 0,
            MonedasOtorgadas = resultado == 1 ? reader.GetInt32(reader.GetOrdinal("MonedasOtorgadas")) : 0
        };
    }
}