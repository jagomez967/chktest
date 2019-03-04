namespace Reporting.Domain.Entities
{
    using System.ComponentModel.DataAnnotations.Schema;
    
    [Table("ReportingClienteObjeto")]
    public partial class ReportingClienteObjeto
    {
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public int id { get; set; }

        public int IdObjeto { get; set; }

        public int IdCliente { get; set; }

        public virtual Cliente Cliente { get; set; }

        public virtual ReportingObjeto ReportingObjeto { get; set; }
    }
}