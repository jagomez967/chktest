namespace Reporting.Domain.Entities
{
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;
    
    [Table("ReportingModulos")]
    public partial class ReportingModulos
    {
        public ReportingModulos()
        {
            ReportingFiltrosModulo = new HashSet<ReportingFiltrosModulo>();
            ReportingTablero = new HashSet<ReportingTablero>();
        }

        [DatabaseGenerated(DatabaseGeneratedOption.None)]
        public int Id { get; set; }

        [StringLength(50)]
        public string Nombre { get; set; }

        public bool UsaFiltros { get; set; }

        public virtual ICollection<ReportingFiltrosModulo> ReportingFiltrosModulo { get; set; }

        public virtual ICollection<ReportingTablero> ReportingTablero { get; set; }
    }
}
