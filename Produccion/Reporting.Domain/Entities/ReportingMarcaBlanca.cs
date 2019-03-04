using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Reporting.Domain.Entities
{
    [Table("ReportingMarcaBlanca")]
    public class ReportingMarcaBlanca
    {
        [Key]
        public int idCliente { get; set; }
        public string logo { get; set; }
        public string fondo { get; set; }
        public string link { get; set; }
    }
}
