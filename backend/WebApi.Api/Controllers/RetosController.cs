using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Services.WebApi.Interface;

namespace WebApi.Api.Controllers;

[ApiController]
[Route("api/[controller]")]
[Authorize]
public class RetosController : ControllerBase
{
    private readonly IRetoService _retoService;

    public RetosController(IRetoService retoService)
    {
        _retoService = retoService;
    }

    private int ObtenerUsuarioIdDelToken()
    {
        return int.Parse(User.FindFirst("UsuarioId")!.Value);
    }

    [HttpGet("activos")]
    public IActionResult ListarActivos()
    {
        var retos = _retoService.ListarActivos();
        return Ok(retos);
    }

    [HttpPost("{retoId}/completar")]
    public IActionResult Completar(int retoId)
    {
        var usuarioId = ObtenerUsuarioIdDelToken();
        var resultado = _retoService.Completar(usuarioId, retoId);

        return resultado switch
        {
            1 => Ok(new { mensaje = "¡Reto completado! Puntos otorgados." }),
            -1 => Conflict(new { mensaje = "Ya completaste este reto anteriormente." }),
            -2 => BadRequest(new { mensaje = "No tienes suficientes materiales para completar este reto." }),
            -3 => NotFound(new { mensaje = "Este reto no existe o ya no está activo." }),
            _ => StatusCode(500, new { mensaje = "Error inesperado." })
        };
    }
}