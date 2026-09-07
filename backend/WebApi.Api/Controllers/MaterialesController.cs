using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Services.WebApi.Interface;
using WebApi.Model.DTOs;

namespace WebApi.Api.Controllers;

[ApiController]
[Route("api/[controller]")]
[Authorize]
public class MaterialesController : ControllerBase
{
    private readonly IMaterialService _materialService;

    public MaterialesController(IMaterialService materialService)
    {
        _materialService = materialService;
    }

    private int ObtenerUsuarioIdDelToken()
    {
        return int.Parse(User.FindFirst("UsuarioId")!.Value);
    }

    [HttpGet("tienda")]
    public IActionResult ListarTienda()
    {
        return Ok(_materialService.ListarTienda());
    }

    [HttpPost("{materialId}/comprar")]
    public IActionResult Comprar(int materialId, [FromBody] ComprarMaterialDto dto)
    {
        var usuarioId = ObtenerUsuarioIdDelToken();
        var resultado = _materialService.Comprar(usuarioId, materialId, dto.Cantidad);

        return resultado switch
        {
            1 => Ok(new { mensaje = "¡Material comprado!" }),
            -1 => NotFound(new { mensaje = "Ese material no existe." }),
            -2 => BadRequest(new { mensaje = "No tienes suficientes puntos." }),
            -3 => BadRequest(new { mensaje = "La cantidad debe ser al menos 1." }),
            _ => StatusCode(500, new { mensaje = "Error inesperado." })
        };
    }

    [HttpGet("inventario")]
    public IActionResult ListarInventario()
    {
        var usuarioId = ObtenerUsuarioIdDelToken();
        return Ok(_materialService.ListarInventario(usuarioId));
    }
}