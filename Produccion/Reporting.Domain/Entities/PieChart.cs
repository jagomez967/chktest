using System.Collections.Generic;

namespace Reporting.Domain.Entities
{
    public class PieChart : Chart
    {
        public PieChart()
        {
            this.Valores = new List<PieChartSerie>();
            base.Tipo = TipoChart.Pie;
        }
        public List<PieChartSerie> Valores { get; set; }
    }

    public class PieChartSerie
    {
        public string name { get; set; }
        public double y { get; set; }
        public string color { get; set; }
    }
}
