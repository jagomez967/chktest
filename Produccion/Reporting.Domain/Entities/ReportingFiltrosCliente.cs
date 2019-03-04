using System.ComponentModel.DataAnnotations.Schema;

namespace Reporting.Domain.Entities
{
    [Table("ReportingFiltrosCliente")]
    public class ReportingFiltrosCliente
    {
        public int Id { get; set; }
        public int IdCliente { get; set; }
        public int IdFiltro { get; set; }

        [ForeignKey("IdCliente")]
        public virtual Cliente Cliente { get; set; }

        [ForeignKey("IdFiltro")]
        public virtual ReportingFiltros Filtro { get; set; }
    }
}
