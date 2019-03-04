using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Reporting.Domain.Entities
{
    public class BigKPIChart : Chart
    {
        public List<KPISeries> Valores { get; set; }

        public BigKPIChart()
        {
            this.Valores = new List<KPISeries>();
            base.Tipo = TipoChart.BigKPI;
        }
    }
}
