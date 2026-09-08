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

    [HttpPost("comprar-colocar")]
    public IActionResult ComprarYColocar([FromBody] ColocarPlantaDto dto)
    {
        var usuarioId = ObtenerUsuarioIdDelToken();
        var resultado = _jardinService.ComprarYColocar(usuarioId, dto.PlantaId, dto.NumeroSlot);

        return resultado switch
        {
            1 => Ok(new { mensaje = "¡Planta comprada y colocada en el jardín!" }),
            -1 => NotFound(new { mensaje = "Esa planta no existe." }),
            -2 => BadRequest(new { mensaje = "Número de slot inválido." }),
            -3 => BadRequest(new { mensaje = "Ese slot está bloqueado. Sube de nivel completando más retos y trivia." }),
            -4 => BadRequest(new { mensaje = "No tienes suficientes monedas." }),
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