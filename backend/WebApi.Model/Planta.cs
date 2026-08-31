namespace WebApi.Model;

public class PlantaInfo
{
    public int PlantaId { get; set; }
    public string Nombre { get; set; } = string.Empty;
    public int PrecioMonedas { get; set; }
    public string? ImagenUrl { get; set; }
}

public class JardinSlotInfo
{
    public int NumeroSlot { get; set; }
    public int PlantaId { get; set; }
    public string NombrePlanta { get; set; } = string.Empty;
    public DateTime FechaColocacion { get; set; }
}