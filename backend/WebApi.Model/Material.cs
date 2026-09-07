namespace WebApi.Model;

public class MaterialInfo
{
    public int MaterialId { get; set; }
    public string Nombre { get; set; } = string.Empty;
    public string? Descripcion { get; set; }
    public int PrecioPuntos { get; set; }
    public string? ImagenUrl { get; set; }
}

public class InventarioMaterialInfo
{
    public int MaterialId { get; set; }
    public string Nombre { get; set; } = string.Empty;
    public string? Descripcion { get; set; }
    public string? ImagenUrl { get; set; }
    public int Cantidad { get; set; }
}