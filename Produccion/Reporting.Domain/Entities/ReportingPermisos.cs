namespace Reporting.Domain.Entities
{
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    
    public partial class ReportingPermisos
    {
        public ReportingPermisos()
        {
            ReportingRolPermisos = new HashSet<ReportingRolPermisos>();
        }

        public int id { get; set; }
        [Required]
        public int idModulo { get; set; }

        [Required]
        [StringLength(50)]
        public string permiso { get; set; }

        public bool activo { get; set; }

        public virtual ICollection<ReportingRolPermisos> ReportingRolPermisos { get; set; }
    }
}
