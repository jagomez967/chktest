namespace Reporting.Domain.Entities
{
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;

    [Table("ReportingObjetoCategoria")]
    public partial class ReportingObjetoCategoria
    {
        public ReportingObjetoCategoria()
        {
            ReportingFamiliaObjeto = new HashSet<ReportingFamiliaObjeto>();
        }

        public int Id { get; set; }

        [Required]
        [StringLength(50)]
        public string Nombre { get; set; }

        public virtual ICollection<ReportingFamiliaObjeto> ReportingFamiliaObjeto { get; set; }
    }
}
