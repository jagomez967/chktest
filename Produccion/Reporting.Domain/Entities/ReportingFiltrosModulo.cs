namespace Reporting.Domain.Entities
{
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;
    [Table("ReportingFiltrosModulo")]
    public partial class ReportingFiltrosModulo
    {
        [Key]
        [Column(Order = 0)]
        [DatabaseGenerated(DatabaseGeneratedOption.None)]
        public int idCliente { get; set; }

        [Key]
        [Column(Order = 1)]
        [DatabaseGenerated(DatabaseGeneratedOption.None)]
        public int idModulo { get; set; }

        [Key]
        [Column(Order = 2)]
        [DatabaseGenerated(DatabaseGeneratedOption.None)]
        public int idFiltro { get; set; }

        public virtual Cliente Cliente { get; set; }

        public virtual ReportingFiltros ReportingFiltros { get; set; }

        public virtual ReportingModulos ReportingModulos { get; set; }
    }
}
