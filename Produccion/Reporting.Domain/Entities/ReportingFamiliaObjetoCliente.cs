using System.ComponentModel.DataAnnotations.Schema;

namespace Reporting.Domain.Entities
{
    [Table("ReportingFamiliaObjetoCliente")]
    public class ReportingFamiliaObjetoCliente
    {
        public int Id { get; set; }
        public int IdCliente { get; set; }
        public int IdFamilia { get; set; }

        [ForeignKey("IdCliente")]
        public virtual Cliente Cliente { get; set; }

        [ForeignKey("IdFamilia")]
        public virtual ReportingFamiliaObjeto FamiliaObjeto{get;set;}
    }
}
