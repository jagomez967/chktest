using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Reporting.Domain.Entities
{
    [Table("Cadena")]
    public class Cadena
    {
        public Cadena()
        {
            PuntosDeVenta = new HashSet<PuntoDeVenta>();
        }

        [Key]
        public int IdCadena { get; set; }

        [Required]
        [StringLength(50)]
        public string Nombre { get; set; }
        public int? IdNegocio { get; set; }
        public string Logo { get; set; }
        public int? IdTipoCadena { get; set; }
        public string IdExterno { get; set; }
        public int LimiteDoci { get; set; }

        public virtual Negocio Negocio { get; set; }
        public virtual TipoCadena TipoCadena { get; set; }
        public virtual ICollection<PuntoDeVenta> PuntosDeVenta { get; set; }
    }
}
