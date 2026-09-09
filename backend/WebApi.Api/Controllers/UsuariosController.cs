using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Authorization;
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

    private int ObtenerUsuarioIdDelToken()
    {
        return int.Parse(User.FindFirst("UsuarioId")!.Value);
    }

    [HttpPost("registrar")]
    public IActionResult Registrar([FromBody] RegistroUsuarioDto dto)
    {
        var nuevoId = _usuarioService.Registrar(dto);
        return Ok(new { UsuarioId = nuevoId });
    }

    [HttpPost("login")]
    public IActionResult Login([FromBody] LoginDto dto)
    {
        var resultado = _usuarioService.Login(dto);

        if (resultado == null)
        {
            return Unauthorized(new { mensaje = "Email o contraseña incorrectos." });
        }

        return Ok(resultado);
    }

    [HttpPost("refresh-token")]
    public IActionResult RefreshToken([FromBody] RefreshTokenDto dto)
    {
        var resultado = _usuarioService.RenovarToken(dto.RefreshToken);

        if (resultado == null)
        {
            return Unauthorized(new { mensaje = "Refresh token inválido o expirado." });
        }

        return Ok(resultado);
    }

    [HttpPost("logout")]
    public IActionResult Logout([FromBody] RefreshTokenDto dto)
    {
        _usuarioService.Logout(dto.RefreshToken);
        return Ok(new { mensaje = "Sesión cerrada correctamente." });
    }

    [Authorize]
    [HttpGet("me")]
    public IActionResult Me()
    {
        var usuarioId = ObtenerUsuarioIdDelToken();
        var perfil = _usuarioService.ObtenerPerfil(usuarioId);

        if (perfil == null)
        {
            return NotFound(new { mensaje = "Usuario no encontrado." });
        }

        return Ok(perfil);
    }
}