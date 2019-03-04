using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Reporting.Domain.Entities
{
    [Table("Categoria")]
    public partial class Categoria
    {
        [Key]
        public int IdCategoria { get; set; }

        [Required]
        [StringLength(50)]
        public string Nombre { get; set; }

        public int? IdNegocio { get; set; }
    }
}
