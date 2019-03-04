using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

namespace Reporting.Models
{
    public class ExternalLoginConfirmationViewModel
    {
        [Required]
        [Display(Name = "Correo electrónico")]
        public string Email { get; set; }
    }

    public class ExternalLoginListViewModel
    {
        public string ReturnUrl { get; set; }
    }

    public class SendCodeViewModel
    {
        public string SelectedProvider { get; set; }
        public ICollection<System.Web.Mvc.SelectListItem> Providers { get; set; }
        public string ReturnUrl { get; set; }
        public bool RememberMe { get; set; }
    }

    public class VerifyCodeViewModel
    {
        [Required]
        public string Provider { get; set; }

        [Required]
        [Display(Name = "Código")]
        public string Code { get; set; }
        public string ReturnUrl { get; set; }

        [Display(Name = "¿Recordar este explorador?")]
        public bool RememberBrowser { get; set; }

        public bool RememberMe { get; set; }
    }

    public class ForgotViewModel
    {
        [Required]
        [Display(Name = "Correo electrónico")]
        public string Email { get; set; }
    }

    public class LoginViewModel
    {
        [Required]
        [Display(Name = "Correo electrónico")]
        [EmailAddress]
        public string Email { get; set; }

        [Required]
        [DataType(DataType.Password)]
        [Display(Name = "Contraseña")]
        public string Password { get; set; }

        [Display(Name = "¿Recordar cuenta?")]
        public bool RememberMe { get; set; }
    }

    public class RegisterViewModel
    {
        [EmailAddress]
        [Display(Name = "Correo electrónico")]
        [Required(ErrorMessageResourceType = typeof(Reporting.Resources.Configuracion), ErrorMessageResourceName = "confUsuarioEmailNotNull")]
        public string Email { get; set; }

        [StringLength(100, ErrorMessageResourceType = typeof(Reporting.Resources.Configuracion), ErrorMessageResourceName = "confUsuarioPasswordLength")]
        [DataType(DataType.Password)]
        [Display(Name = "Contraseña")]
        [Required(ErrorMessageResourceType = typeof(Reporting.Resources.Configuracion), ErrorMessageResourceName = "confUsuarioPasswordNotNull")]
        [MinLength(6, ErrorMessageResourceType = typeof(Reporting.Resources.Configuracion), ErrorMessageResourceName = "confUsuarioPasswordLength")]
        public string Password { get; set; }

        [DataType(DataType.Password)]
        [Display(Name = "Confirmar contraseña")]
        [Compare("Password", ErrorMessage = "La contraseña y la contraseña de confirmación no coinciden.")]
        [Required(ErrorMessageResourceType = typeof(Reporting.Resources.Configuracion), ErrorMessageResourceName = "confUsuarioConfirmPassword")]
        public string ConfirmPassword { get; set; }

        [MaxLength(100)]
        [Display(Name="Nombre")]
        [Required(ErrorMessageResourceType = typeof(Reporting.Resources.Configuracion), ErrorMessageResourceName = "confUsuarioNombreRequired")]
        public string FirstName { get; set; }

        [MaxLength(100)]
        [Display(Name = "Apellido")]
        [Required(ErrorMessageResourceType = typeof(Reporting.Resources.Configuracion), ErrorMessageResourceName = "confUsuarioApellidoRequired")]
        public string LastName { get; set; }

        [MaxLength(20)]
        [Display(Name = "Celular")]
        public string CellPhone { get; set; }
    }

    public class ResetPasswordViewModel
    {
        [Required]
        [EmailAddress]
        [Display(Name = "Correo electrónico")]
        public string Email { get; set; }

        [Required]
        [StringLength(100, ErrorMessage = "El número de caracteres de {0} debe ser al menos {2}.", MinimumLength = 6)]
        [DataType(DataType.Password)]
        [Display(Name = "Contraseña")]
        public string Password { get; set; }

        [DataType(DataType.Password)]
        [Display(Name = "Confirmar contraseña")]
        [Compare("Password", ErrorMessage = "La contraseña y la contraseña de confirmación no coinciden.")]
        public string ConfirmPassword { get; set; }

        public string Code { get; set; }
    }

    public class ForgotPasswordViewModel
    {
        [Required]
        [EmailAddress]
        [Display(Name = "Correo electrónico")]
        public string Email { get; set; }
    }
}
