using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Reporting.Domain.Entities
{
    [Table("Familia")]
    public partial class Familia
    {
        public Familia()
        {
            Producto = new HashSet<Producto>();
        }

        [Key]
        public int IdFamilia { get; set; }

        public int? IdMarca { get; set; }

        [StringLength(100)]
        public string Nombre { get; set; }

        public string Grupo { get; set; }

        public virtual ICollection<Producto> Producto { get; set; }
        public virtual Marca Marca { get; set; }
    }
}
