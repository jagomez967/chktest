using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;

namespace Reporting.Domain.Entities
{
    [Table("CalendarioConceptos")]
    public partial class CalendarioConcepto
    {
        public CalendarioConcepto()
        {
            EventosCalendario = new HashSet<Calendario>();
        }
        public int Id { get; set; }
        public int IdCliente { get; set; }
        public string Descripcion { get; set; }
        public bool Activo { get; set; }

        public virtual Cliente Cliente { get; set; }
        public virtual ICollection<Calendario> EventosCalendario { get; set; }
    }
}
