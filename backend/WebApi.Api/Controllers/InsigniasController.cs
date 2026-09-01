using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Services.WebApi.Interface;

namespace WebApi.Api.Controllers;

[ApiController]
[Route("api/[controller]")]
[Authorize]
public class InsigniasController : ControllerBase
{
    private readonly IInsigniaService _insigniaService;

    public InsigniasController(IInsigniaService insigniaService)
    {
        _insigniaService = insigniaService;
    }

    private int ObtenerUsuarioIdDelToken()
    {
        return int.Parse(User.FindFirst("UsuarioId")!.Value);
    }

    [HttpGet("mis-insignias")]
    public IActionResult ListarMisInsignias()
    {
        var usuarioId = ObtenerUsuarioIdDelToken();
        return Ok(_insigniaService.ListarPorUsuario(usuarioId));
    }
}