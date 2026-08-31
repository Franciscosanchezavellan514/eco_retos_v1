using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Services.WebApi.Interface;

namespace WebApi.Api.Controllers;

[ApiController]
[Route("api/[controller]")]
[Authorize]
public class TiendaController : ControllerBase
{
    private readonly IPlantaService _plantaService;

    public TiendaController(IPlantaService plantaService)
    {
        _plantaService = plantaService;
    }

    private int ObtenerUsuarioIdDelToken()
    {
        return int.Parse(User.FindFirst("UsuarioId")!.Value);
    }

    [HttpGet("plantas")]
    public IActionResult ListarPlantas()
    {
        return Ok(_plantaService.ListarTienda());
    }

    [HttpPost("plantas/{plantaId}/comprar")]
    public IActionResult Comprar(int plantaId)
    {
        var usuarioId = ObtenerUsuarioIdDelToken();
        var resultado = _plantaService.Comprar(usuarioId, plantaId);

        return resultado switch
        {
            1 => Ok(new { mensaje = "¡Planta comprada!" }),
            -1 => Conflict(new { mensaje = "Ya tienes esta planta." }),
            -2 => BadRequest(new { mensaje = "No tienes suficientes monedas." }),
            -3 => NotFound(new { mensaje = "Esa planta no existe." }),
            _ => StatusCode(500, new { mensaje = "Error inesperado." })
        };
    }
}