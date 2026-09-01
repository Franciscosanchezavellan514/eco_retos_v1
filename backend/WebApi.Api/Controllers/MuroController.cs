using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Services.WebApi.Interface;
using WebApi.Model.DTOs;

namespace WebApi.Api.Controllers;

[ApiController]
[Route("api/[controller]")]
[Authorize]
public class MuroController : ControllerBase
{
    private readonly IMuroService _muroService;

    public MuroController(IMuroService muroService)
    {
        _muroService = muroService;
    }

    private int ObtenerUsuarioIdDelToken()
    {
        return int.Parse(User.FindFirst("UsuarioId")!.Value);
    }

    [HttpPost("publicaciones")]
    public IActionResult CrearPublicacion([FromBody] CrearPublicacionDto dto)
    {
        var usuarioId = ObtenerUsuarioIdDelToken();
        var id = _muroService.CrearPublicacion(usuarioId, dto.Contenido, dto.ImagenUrl);
        return Ok(new { PublicacionId = id });
    }

    [HttpGet("publicaciones")]
    public IActionResult ListarMuro()
    {
        return Ok(_muroService.ListarMuro());
    }

    [HttpPost("publicaciones/{publicacionId}/comentarios")]
    public IActionResult CrearComentario(int publicacionId, [FromBody] CrearComentarioDto dto)
    {
        var usuarioId = ObtenerUsuarioIdDelToken();
        var resultado = _muroService.CrearComentario(publicacionId, usuarioId, dto.Contenido, dto.ComentarioPadreId);

        return resultado switch
        {
            -1 => NotFound(new { mensaje = "La publicación no existe." }),
            -2 => BadRequest(new { mensaje = "El comentario padre no es válido para esta publicación." }),
            _ => Ok(new { ComentarioId = resultado })
        };
    }

    [HttpGet("publicaciones/{publicacionId}/comentarios")]
    public IActionResult ListarComentarios(int publicacionId)
    {
        return Ok(_muroService.ListarComentarios(publicacionId));
    }

    [HttpPost("publicaciones/{publicacionId}/reaccionar")]
    public IActionResult ToggleReaccion(int publicacionId)
    {
        var usuarioId = ObtenerUsuarioIdDelToken();
        var accion = _muroService.ToggleReaccion(publicacionId, usuarioId);
        return Ok(new { accion });
    }
}