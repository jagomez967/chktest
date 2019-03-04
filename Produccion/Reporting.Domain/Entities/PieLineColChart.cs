using System.Collections.Generic;

namespace Reporting.Domain.Entities
{
    public class PieLineColChart : Chart
    {
        public PieLineColChart()
        {
            this.Categories = new List<string>();
            this.Valores = new List<PieLineColChartSerie>();
            base.Tipo = TipoChart.PieLineCol;
        }
        public List<string> Categories { get; set; }
        public List<PieLineColChartSerie> Valores { get; set; }
    }

    public class PieLineColChartSerie
    {
        public PieLineColChartSerie()
        {
            this.type = "column";
            this.data = new List<double>();
        }

        public string type { get; set; }
        public string name { get; set; }
        public List<double> data { get; set; }
    }
}