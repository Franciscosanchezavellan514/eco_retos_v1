using WebApi.Model.DTOs;

namespace Services.WebApi.Interface;

public interface IUsuarioService
{
    int Registrar(RegistroUsuarioDto dto);
    LoginResponseDto? Login(LoginDto dto);
    LoginResponseDto? RenovarToken(string refreshTokenPlano);
    void Logout(string refreshTokenPlano);
}