using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Reporting.Domain.Entities
{
    [Table("Localidad")]
    public partial class Localidad
    {
        public Localidad()
        {
            PuntoDeVenta = new HashSet<PuntoDeVenta>();
        }

        [Key]
        public int IdLocalidad { get; set; }

        public int IdProvincia { get; set; }

        [Required]
        [StringLength(50)]
        public string Nombre { get; set; }

        public bool New { get; set; }

        public int DataMigrationId { get; set; }

        public int DataMigrationId2 { get; set; }
        public virtual Provincia Provincia { get; set; }

        public virtual ICollection<PuntoDeVenta> PuntoDeVenta { get; set; }
    }
}
