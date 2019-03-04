namespace Reporting.Domain.Entities
{
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;

    [Table("ReportingTablero")]
    public partial class ReportingTablero
    {
        public ReportingTablero()
        {
            ReportingTableroObjeto = new HashSet<ReportingTableroObjeto>();
            ReportingTableroUsuario = new HashSet<ReportingTableroUsuario>();
        }

        public int Id { get; set; }

        [Required]
        [StringLength(30)]
        public string Nombre { get; set; }

        [StringLength(100)]
        public string Descripcion { get; set; }

        public int IdUsuario { get; set; }

        public int IdCliente { get; set; }

        public int? IdModulo { get; set; }
        public string filtrosBloqueados { get; set; }
        public virtual ReportingModulos ReportingModulos { get; set; }

        public virtual ICollection<ReportingTableroObjeto> ReportingTableroObjeto { get; set; }

        public virtual ICollection<ReportingTableroUsuario> ReportingTableroUsuario { get; set; }

        public int? orden { get; set; }
    }
}
