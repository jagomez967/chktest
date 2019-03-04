using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Reporting.Domain.Entities
{
    [Table("Marca")]
    public partial class Marca
    {
        public Marca()
        {
            Producto = new HashSet<Producto>();
        }

        [Key]
        public int IdMarca { get; set; }

        [Required]
        [StringLength(100)]
        public string Nombre { get; set; }

        public int? IdEmpresa { get; set; }

        public int? Orden { get; set; }

        public bool? Reporte { get; set; }

        public string Imagen { get; set; }

        public bool? SoloCompetencia { get; set; }
        public virtual Empresa Empresa { get; set; }
        public virtual ICollection<Producto> Producto { get; set; }
        public virtual ICollection<Familia> Familias { get; set; }
    }
}
