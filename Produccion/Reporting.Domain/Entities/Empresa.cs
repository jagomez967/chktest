using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Reporting.Domain.Entities
{
    [Table("Empresa")]
    public partial class Empresa
    {
        public Empresa()
        {
            Cliente = new HashSet<Cliente>();
            Reporte = new HashSet<Reporte>();
            Marcas = new HashSet<Marca>();
        }

        [Key]
        public int IdEmpresa { get; set; }

        public int IdNegocio { get; set; }

        [Required]
        [StringLength(50)]
        public string Nombre { get; set; }

        public string Logo { get; set; }

        public virtual Negocio Negocio { get; set; }

        public virtual ICollection<Cliente> Cliente { get; set; }

        public virtual ICollection<Reporte> Reporte { get; set; }
        public virtual ICollection<Marca> Marcas { get; set; }
    }
}
