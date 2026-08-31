using Microsoft.AspNetCore.Mvc;
using Services.WebApi.Interface;
using WebApi.Model.DTOs;

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
    public IActionResult Registrar([FromBody] RegistroUsuarioDto dto)
    {
        var nuevoId = _usuarioService.Registrar(dto);
        return Ok(new { UsuarioId = nuevoId });
    }
}