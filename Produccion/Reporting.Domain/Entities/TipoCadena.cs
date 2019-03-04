using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Reporting.Domain.Entities
{
    [Table("TipoCadena")]
    public class TipoCadena
    {
        [Key]
        public int IdTipoCadena { get; set; }

        [Required]
        public string Nombre { get; set; }

        [Required]
        public string Identificador { get; set; }

        [Required]
        public int IdCliente { get; set; }

        public virtual Cliente Cliente { get; set; }
    }
}
