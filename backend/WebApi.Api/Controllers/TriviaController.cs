using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Services.WebApi.Interface;
using WebApi.Model.DTOs;

namespace WebApi.Api.Controllers;

[ApiController]
[Route("api/[controller]")]
[Authorize]
public class TriviaController : ControllerBase
{
    private readonly ITriviaService _triviaService;

    public TriviaController(ITriviaService triviaService)
    {
        _triviaService = triviaService;
    }

    private int ObtenerUsuarioIdDelToken()
    {
        return int.Parse(User.FindFirst("UsuarioId")!.Value);
    }

    [HttpGet("categorias")]
    public IActionResult ListarCategorias()
    {
        return Ok(_triviaService.ListarCategorias());
    }

    [HttpGet("categorias/{categoriaId}/preguntas")]
    public IActionResult ListarPreguntas(int categoriaId)
    {
        return Ok(_triviaService.ListarPreguntas(categoriaId));
    }

    [HttpPost("responder")]
    public IActionResult Responder([FromBody] ResponderTriviaDto dto)
    {
        var usuarioId = ObtenerUsuarioIdDelToken();
        var resultado = _triviaService.Responder(usuarioId, dto.PreguntaId, dto.OpcionId, dto.CategoriaId);
        return Ok(resultado);
    }
}