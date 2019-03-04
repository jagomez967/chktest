namespace Reporting.Domain.Entities
{
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;

    [Table("ReportingFamiliaObjeto")]
    public partial class ReportingFamiliaObjeto
    {
        public ReportingFamiliaObjeto()
        {
            ReportingFamiliaNombreCliente = new HashSet<ReportingFamiliaNombreCliente>();
            ReportingObjeto = new HashSet<ReportingObjeto>();
            ReportingFamiliaObjetoCliente = new HashSet<ReportingFamiliaObjetoCliente>();
        }
        [Key]
        public int Id { get; set; }

        [Required]
        [StringLength(50)]
        public string Nombre { get; set; }
        public int IdCategoria { get; set; }
        public string Identificador { get; set; }
        public bool EsAdHoc { get; set; }
        public virtual ICollection<ReportingFamiliaNombreCliente> ReportingFamiliaNombreCliente { get; set; }

        public virtual ICollection<ReportingObjeto> ReportingObjeto { get; set; }
        public virtual ReportingObjetoCategoria ReportingObjetoCategoria { get; set; }
        public virtual ICollection<ReportingFamiliaObjetoCliente> ReportingFamiliaObjetoCliente { get; set; }

    }
}
