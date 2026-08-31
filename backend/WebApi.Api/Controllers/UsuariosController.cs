using Microsoft.AspNetCore.Mvc;
using Services.WebApi.Interface;
using WebApi.Model;

namespace WebApi.Api.Controllers;

[ApiController]
[Route("api/[controller]")]
public class UsuariosController : ControllerBase
{
    private readonly IUsuarioService _usuarioService;

    public UsuariosController(IUsuarioService usuarioService)
    {
        _usuarioService = usuarioService;
    }

    [HttpPost("registrar")]
    public IActionResult Registrar([FromBody] Usuario usuario)
    {
        var nuevoId = _usuarioService.Registrar(usuario);
        return Ok(new { UsuarioId = nuevoId });
    }
}