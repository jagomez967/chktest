using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Reporting.Domain.Entities
{
    [Table("ReportingClienteObjeto")]
    public class ClienteObjeto
    {
        [ForeignKey("Cliente")]
        [Key, Column(Order = 0)]
        public int IdCliente { get; set; }

        [ForeignKey("Objeto")]
        [Key, Column(Order = 1)]
        public int IdObjeto { get; set; }

        public Cliente Cliente { get; set; }
        public Objeto Objeto { get; set; }
    }
}
