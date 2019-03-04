
using System.ComponentModel.DataAnnotations;

namespace Reporting.ViewModels
{
    public class ViewModelPasswordUser
    {
        public int UserId { get; set; }

        [Required(ErrorMessage = "Contraseña requerida")]
        public string Password { get; set; }

        [Required(ErrorMessage = "Debe ingresar la confirmacion de la contraseña")]
        [Compare("Password", ErrorMessage = "Las constraseñas no coindicen")]
        public string ConfirmPassword { get; set; }
    }
}