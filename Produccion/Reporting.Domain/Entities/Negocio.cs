using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Reporting.Domain.Entities
{
    [Table("Negocio")]
    public class Negocio
    {
        public Negocio()
        {
            Cadena = new HashSet<Cadena>();
            Empresa = new HashSet<Empresa>();
        }

        [Key]
        public int IdNegocio { get; set; }

        [Required]
        [StringLength(50)]
        public string Nombre { get; set; }

        public virtual ICollection<Cadena> Cadena { get; set; }

        public virtual ICollection<Empresa> Empresa { get; set; }
    }
}
