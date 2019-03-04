using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Reporting.Domain.Entities
{
    [Table("ReportingTableroObjeto")]
    public class TableroObjeto
    {
        [Key, Column(Order=0)]
        public int TableroId { get; set; }
        [Key, Column(Order = 1)]
        public int ObjetoId { get; set; }
        public string Size { get; set; }
        public int Orden { get; set; }
        public bool dataLabels { get; set; }
        public int stackLabels { get; set; }//0: nada, 1:Promedio(AVG), 2:Suma total(SUM)
        public virtual Objeto Objeto { get; set; }
    }
}
