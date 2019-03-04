using System.Collections.Generic;

namespace Reporting.Domain.Entities
{
    public class StackedColumnChart : Chart
    {
        public StackedColumnChart()
        {
            Categories = new List<string>();
            Valores = new List<StackedColumnChartSerie>();
            IsPercentage = false;
            Visiblelabel = false;
            base.Tipo = TipoChart.StackedColumn;
        }
        public bool IsPercentage { get; set; }
        public List<string> Categories { get; set; }
        public List<StackedColumnChartSerie> Valores { get; set; }
        public bool Visiblelabel { get; set; }
    }

    public class StackedColumnChartSerie
    {
        public StackedColumnChartSerie()
        {
            this.data = new List<StackedColumnChartSerieData>();
        }
        public string name { get; set; }
        public string color { get; set; }
        public List<StackedColumnChartSerieData> data { get; set; }
    }

    public class StackedColumnChartSerieData
    {
        public double y { get; set; }
        public string texto { get; set; }
    }
}
