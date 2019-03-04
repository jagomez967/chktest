namespace Reporting.Domain.Entities
{
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;
    
    [Table("ReportingFiltros")]
    public class ReportingFiltros
    {
        public ReportingFiltros()
        {
            ReportingFiltroNombreCliente = new HashSet<ReportingFiltroNombreCliente>();
            ReportingFiltrosModulo = new HashSet<ReportingFiltrosModulo>();
            ReportingFiltrosCliente = new HashSet<ReportingFiltrosCliente>();
        }

        [DatabaseGenerated(DatabaseGeneratedOption.None)]
        public int id { get; set; }

        [Required]
        [StringLength(50)]
        public string identificador { get; set; }

        [Required]
        [StringLength(50)]
        public string nombre { get; set; }

        [Required]
        [StringLength(100)]
        public string storedProcedure { get; set; }
        public int tipoFiltro { get; set; }
        public virtual ICollection<ReportingFiltroNombreCliente> ReportingFiltroNombreCliente { get; set; }
        public virtual ICollection<ReportingFiltrosModulo> ReportingFiltrosModulo { get; set; }
        public virtual ICollection<ReportingFiltrosCliente> ReportingFiltrosCliente { get; set; }
    }
}
