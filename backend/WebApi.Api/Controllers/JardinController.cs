using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Services.WebApi.Interface;
using WebApi.Model.DTOs;

namespace WebApi.Api.Controllers;

[ApiController]
[Route("api/[controller]")]
[Authorize]
public class JardinController : ControllerBase
{
    private readonly IJardinService _jardinService;

    public JardinController(IJardinService jardinService)
    {
        _jardinService = jardinService;
    }

    private int ObtenerUsuarioIdDelToken()
    {
        return int.Parse(User.FindFirst("UsuarioId")!.Value);
    }

    [HttpPost("colocar")]
    public IActionResult ColocarPlanta([FromBody] ColocarPlantaDto dto)
    {
        var usuarioId = ObtenerUsuarioIdDelToken();
        var resultado = _jardinService.ColocarPlanta(usuarioId, dto.NumeroSlot, dto.PlantaId);

        return resultado switch
        {
            1 => Ok(new { mensaje = "Planta colocada en el jardín." }),
            -1 => BadRequest(new { mensaje = "No tienes esta planta desbloqueada. Cómprala primero en la tienda." }),
            -2 => BadRequest(new { mensaje = "Número de slot inválido." }),
            _ => StatusCode(500, new { mensaje = "Error inesperado." })
        };
    }

    [HttpGet("estado")]
    public IActionResult VerEstado()
    {
        var usuarioId = ObtenerUsuarioIdDelToken();
        return Ok(_jardinService.VerEstado(usuarioId));
    }
}