using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

namespace Reporting.ViewModels
{
    public class SeguridadViewModel
    {
    }
    public class IndexViewModel
    {
        public int CantUsuarios { get; set; }
    }

    public class UserViewModel
    {
        public UserViewModel()
        {
            this.Roles = new List<RolViewModel>();
        }

        public int Id { get; set; }
        public string UserName { get; set; }//Es el email utilizado como username
        [Required]
        [MaxLength(100)]
        public string FirstName { get; set; }

        [Required]
        [MaxLength(100)]
        public string LastName { get; set; }

        [Required]
        [MaxLength(20)]
        public string CellPhone { get; set; }
        public virtual List<RolViewModel> Roles { get; set; }
    }


    public class EditarUsuarioViewModel
    {
        public EditarUsuarioViewModel()
        {
            this.Roles = new List<UsuarioRolViewModel>();
            this.Clientes = new List<UsuarioClienteViewModel>();
        }

        public int Id { get; set; }
        public string UserName { get; set; }
        [Required]
        [MaxLength(100)]
        public string FirstName { get; set; }

        [Required]
        [MaxLength(100)]
        public string LastName { get; set; }

        [Required]
        [MaxLength(20)]
        public string CellPhone { get; set; }
        public virtual List<UsuarioRolViewModel> Roles { get; set; }
        public virtual List<UsuarioClienteViewModel> Clientes { get; set; }
    }

    public class UsuarioRolViewModel
    {
        public int RolId { get; set; }
        public string Name { get; set; }
        public bool Selected { get; set; }
    }
    public class UsuarioClienteViewModel
    {
        public int ClienteId { get; set; }
        public string Name { get; set; }
        public bool Selected { get; set; }
    }
}