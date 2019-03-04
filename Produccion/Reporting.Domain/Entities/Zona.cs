using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;


namespace Reporting.Domain.Entities
{
   [Table("Zona")]
   public class Zona
    {
        [Key]
        public int IdZona { get; set; }
        public string Nombre { get; set; }
    }
}
