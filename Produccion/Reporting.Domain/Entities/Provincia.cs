using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Reporting.Domain.Entities
{
    [Table("Provincia")]
    public partial class Provincia
    {
        public Provincia()
        {
            Localidad = new HashSet<Localidad>();
        }

        [Key]
        public int IdProvincia { get; set; }

        [Required]
        [StringLength(50)]
        public string Nombre { get; set; }

        public bool New { get; set; }

        public int DataMigrationId { get; set; }

        public int DataMigrationId2 { get; set; }

        public int? IdCliente { get; set; }

        public virtual ICollection<Localidad> Localidad { get; set; }
    }
}
