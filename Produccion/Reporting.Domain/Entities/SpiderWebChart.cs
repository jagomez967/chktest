using System.Collections.Generic;

namespace Reporting.Domain.Entities
{
    public class SpiderWebChart : Chart
    {
        public SpiderWebChart()
        {
            this.Categories = new List<string>();
            this.Valores = new List<SpiderWebChartSerie>();
            base.Tipo = TipoChart.SpiderWebChart;
        }
        public List<string> Categories { get; set; }
        public List<SpiderWebChartSerie> Valores { get; set; }
    }
    public class SpiderWebChartSerie
    {
        public SpiderWebChartSerie()
        {
            this.data = new List<double>();
        }
        public string name { get; set; }
        public List<double> data { get; set; }
        public string pointPlacement { get; set; }
    }
}
