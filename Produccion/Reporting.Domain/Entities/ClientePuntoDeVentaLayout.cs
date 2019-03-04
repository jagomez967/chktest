using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Reporting.Domain.Entities
{
    [Table("ClientePuntoDeVentaLayout")]
    public class ClientePuntoDeVentaLayout
    {
        [Key]
        public int id { get; set; }
        public int? idClientePdv { get; set; }
        public int? PosX { get; set; }
        public int? PosY { get; set; }
    }
}
