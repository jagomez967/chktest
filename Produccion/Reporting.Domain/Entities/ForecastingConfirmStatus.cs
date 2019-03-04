using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Reporting.Domain.Entities
{
    [Table("ForecastingConfirmStatus")]
    public class ForecastingConfirmStatus
    {
        [Key]
        public int Id { get; set; }
        public int IdCliente { get; set; }
        public int IdCadena { get; set; }
        public DateTime Fecha { get; set; }
        public int IdUsuario { get; set; }

        public virtual Usuario Usuario { get; set; }
        public virtual Cadena Cadena { get; set; }
    }
}
