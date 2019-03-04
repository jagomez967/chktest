namespace Reporting.Domain.Entities
{
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;
    
    [Table("ReportingFiltroNombreCliente")]
    public partial class ReportingFiltroNombreCliente
    {
        public int id { get; set; }

        public int? idFiltro { get; set; }

        public int? idCliente { get; set; }

        [StringLength(200)]
        public string Nombre { get; set; }

        public virtual Cliente Cliente { get; set; }

        public virtual ReportingFiltros ReportingFiltros { get; set; }
    }
}