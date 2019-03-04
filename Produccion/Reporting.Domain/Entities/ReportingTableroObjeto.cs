namespace Reporting.Domain.Entities
{
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;

    [Table("ReportingTableroObjeto")]
    public partial class ReportingTableroObjeto
    {
        [Key]
        public int Id { get; set; }
        
        public int IdTablero { get; set; }

        public int IdObjeto { get; set; }

        [Required]
        [StringLength(50)]
        public string Size { get; set; }

        public int Orden { get; set; }

        public bool? FlgDataLabel { get; set; }

        public int? StackLabel { get; set; }

        public virtual ReportingObjeto ReportingObjeto { get; set; }

        public virtual ReportingTablero ReportingTablero { get; set; }

        public string Altura { get; set; }
    }
}
