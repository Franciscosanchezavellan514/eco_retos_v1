namespace WebApi.Model.DTOs;

public class EnviarSolicitudDto
{
    public string UID { get; set; } = string.Empty;
}

public class ResponderSolicitudDto
{
    public int AmistadId { get; set; }
    public bool Aceptar { get; set; }
}