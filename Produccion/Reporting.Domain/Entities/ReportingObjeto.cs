namespace Reporting.Domain.Entities
{
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;
    
    [Table("ReportingObjeto")]
    public partial class ReportingObjeto
    {
        public ReportingObjeto()
        {
            ReportingClienteObjeto = new HashSet<ReportingClienteObjeto>();
            ReportingTableroObjeto = new HashSet<ReportingTableroObjeto>();
        }

        public int Id { get; set; }

        public int IdFamiliaObjeto { get; set; }

        [Required]
        [StringLength(50)]
        public string SpDatos { get; set; }

        public TipoChart TipoChart { get; set; }

        public string SpAnidado { get; set; }

        public virtual ICollection<ReportingClienteObjeto> ReportingClienteObjeto { get; set; }

        public virtual ReportingFamiliaObjeto ReportingFamiliaObjeto { get; set; }

        public virtual ICollection<ReportingTableroObjeto> ReportingTableroObjeto { get; set; }
    }
}
