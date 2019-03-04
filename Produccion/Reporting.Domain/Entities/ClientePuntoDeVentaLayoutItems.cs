using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Reporting.Domain.Entities
{
    [Table("ClientePuntoDeVentaLayoutItems")]
    public class ClientePuntoDeVentaLayoutItems
    {
        [Key]
        public int id { get; set; }
        public int? idLayout { get; set; }
        public int? x { get; set; }
        public int? y { get; set; }
    }
}
