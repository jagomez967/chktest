namespace Reporting.Domain.Entities
{
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;
    
    [Table("ReportingFamiliaNombreCliente")]
    public partial class ReportingFamiliaNombreCliente
    {
        public int id { get; set; }

        public int? idFamilia { get; set; }

        public int? idCliente { get; set; }

        [StringLength(50)]
        public string Nombre { get; set; }

        public virtual Cliente Cliente { get; set; }

        public virtual ReportingFamiliaObjeto ReportingFamiliaObjeto { get; set; }
    }
}
