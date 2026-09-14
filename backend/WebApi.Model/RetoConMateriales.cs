namespace WebApi.Model;

public class MaterialRequeridoInfo
{
    public int MaterialId { get; set; }
    public string NombreMaterial { get; set; } = string.Empty;
    public int CantidadRequerida { get; set; }
    public int CantidadDisponible { get; set; }
    public bool Cumple => CantidadDisponible >= CantidadRequerida;
}

public class RetoConMaterialesInfo
{
    public int RetoId { get; set; }
    public string Titulo { get; set; } = string.Empty;
    public string Descripcion { get; set; } = string.Empty;
    public int PuntosRecompensa { get; set; }
    public string Dificultad { get; set; } = string.Empty;
    public List<MaterialRequeridoInfo> Materiales { get; set; } = new();

    /// El reto se puede completar solo si TODOS sus materiales cumplen la cantidad requerida
    public bool PuedeCompletarse => Materiales.All(m => m.Cumple);
}