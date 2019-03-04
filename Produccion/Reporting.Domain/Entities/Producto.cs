using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Reporting.Domain.Entities
{
    [Table("Producto")]
    public partial class Producto
    {
        [Key]
        public int IdProducto { get; set; }
        public string IdExterno { get; set; }

        public int IdMarca { get; set; }

        [Required]
        [StringLength(100)]
        public string Nombre { get; set; }

        public bool? Reporte { get; set; }

        public bool? GenericoPorMarca { get; set; }

        public int? IdFamilia { get; set; }

        [StringLength(100)]
        public string CodigoBarras { get; set; }

        public int? Orden { get; set; }

        public int? IdCategoria { get; set; }

        [NotMapped]
        public int CurrentChannelInv { get; set; }

        public virtual Familia Familia { get; set; }

        public virtual Marca Marca { get; set; }
    }
}
