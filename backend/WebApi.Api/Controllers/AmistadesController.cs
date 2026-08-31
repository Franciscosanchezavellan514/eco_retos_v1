using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Services.WebApi.Interface;
using WebApi.Model.DTOs;

namespace WebApi.Api.Controllers;

[ApiController]
[Route("api/[controller]")]
[Authorize] // todo este controlador exige estar logueado
public class AmistadesController : ControllerBase
{
    private readonly IAmistadService _amistadService;

    public AmistadesController(IAmistadService amistadService)
    {
        _amistadService = amistadService;
    }

    private int ObtenerUsuarioIdDelToken()
    {
        return int.Parse(User.FindFirst("UsuarioId")!.Value);
    }

    [HttpPost("solicitar")]
    public IActionResult EnviarSolicitud([FromBody] EnviarSolicitudDto dto)
    {
        var usuarioId = ObtenerUsuarioIdDelToken();
        var resultado = _amistadService.EnviarSolicitud(usuarioId, dto.UID);

        return resultado switch
        {
            -1 => Conflict(new { mensaje = "Ya existe una relación de amistad con este usuario." }),
            -2 => NotFound(new { mensaje = "No se encontró un usuario con ese UID." }),
            -3 => BadRequest(new { mensaje = "No puedes agregarte a ti mismo." }),
            _ => Ok(new { AmistadId = resultado })
        };
    }

    [HttpPost("responder")]
    public IActionResult Responder([FromBody] ResponderSolicitudDto dto)
    {
        var usuarioId = ObtenerUsuarioIdDelToken();
        var exito = _amistadService.Responder(dto.AmistadId, usuarioId, dto.Aceptar);

        if (!exito)
        {
            return NotFound(new { mensaje = "Solicitud no encontrada, ya respondida, o no te pertenece." });
        }

        return Ok(new { mensaje = dto.Aceptar ? "Amistad aceptada." : "Solicitud rechazada." });
    }

    [HttpGet("mis-amigos")]
    public IActionResult ListarAmigos()
    {
        var usuarioId = ObtenerUsuarioIdDelToken();
        var amigos = _amistadService.ListarAmigos(usuarioId);
        return Ok(amigos);
    }
}