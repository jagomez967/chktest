namespace Reporting.Domain.Entities
{
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    
    public partial class ReportingRoles
    {
        public ReportingRoles()
        {
            ReportingRolPermisos = new HashSet<ReportingRolPermisos>();
            Usuario_Cliente = new HashSet<Usuario_Cliente>();
        }

        public int id { get; set; }

        public int idCliente { get; set; }

        [Required]
        [StringLength(50)]
        public string nombre { get; set; }

        public virtual Cliente Cliente { get; set; }

        public virtual ICollection<ReportingRolPermisos> ReportingRolPermisos { get; set; }
        public virtual ICollection<Usuario_Cliente> Usuario_Cliente { get; set; }
    }
}
