namespace Reporting.Domain.Entities
{
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;
    
    [Table("ReportingTableroUsuario")]
    public partial class ReportingTableroUsuario
    {
        [Key]
        [Column(Order = 0)]
        [DatabaseGenerated(DatabaseGeneratedOption.None)]
        public int IdTablero { get; set; }

        [Key]
        [Column(Order = 1)]
        [DatabaseGenerated(DatabaseGeneratedOption.None)]
        public int IdUsuario { get; set; }

        public bool? PermiteEscritura { get; set; }

        public virtual ReportingTablero ReportingTablero { get; set; }

        public int? orden { get; set; }
    }
}
