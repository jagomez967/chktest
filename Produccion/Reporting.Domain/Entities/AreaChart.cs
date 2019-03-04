using System.Collections.Generic;

namespace Reporting.Domain.Entities
{
    public class AreaChart : Chart
    {
        public AreaChart()
        {
            this.Categories = new List<string>();
            this.Valores = new List<AreaChartSerie>();
            base.Tipo = TipoChart.Area;
        }
        public List<string> Categories { get; set; }
        public List<AreaChartSerie> Valores { get; set; }
    }

    public class AreaChartSerie
    {
        public AreaChartSerie()
        {
            this.data = new List<double>();
        }
        public string name { get; set; }
        public List<double> data { get; set; }

    }
}
