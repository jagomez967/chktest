using System;
using System.Collections.Generic;

namespace Reporting.Domain.Entities
{
    public class SimpleKPIChart : Chart
    {
        public List<KPISeries> Valores { get; set; }

        public SimpleKPIChart()
        {
            this.Valores = new List<KPISeries>();
            base.Tipo = TipoChart.SimpleKPI;
        }
    }
    public class KPISeries
    {
        public String Valor { get; set; }
        public String Titulo { get; set; }
        public String Icono { get; set; }
        public String Color { get; set; }
        public String Descripcion { get; set; }        
    }
}
