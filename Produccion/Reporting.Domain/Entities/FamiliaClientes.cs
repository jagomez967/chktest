using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Reporting.Domain.Entities
{
    [Table("FamiliaClientes")]
    public partial class FamiliaClientes
    {
        [Key]
        public int Id { get; set; }
        public string Familia { get; set; }
        public int IdCliente { get; set; }
        public virtual Cliente Cliente { get; set; }
    }
}
