using System.Collections.Generic;

namespace Reporting.Domain.Entities
{
    public class LineChart : Chart
    {
        public LineChart()
        {
            Categories = new List<string>();
            Valores = new List<LineChartSerie>();
            Visibletooltip = false;
            base.Tipo = TipoChart.LineChart;
        }
        public List<string> Categories { get; set; }
        public List<LineChartSerie> Valores { get; set; }
        public bool showText { get; set; }
        public bool Visibletooltip { get; set; }
    }

    public class LineChartSerie
    {
        public LineChartSerie()
        {
            this.data = new List<LineChartSerieData>();
        }
        public string name { get; set; }
        public string color { get; set; }
        public List<LineChartSerieData> data { get; set; }
    }

    public class LineChartSerieData
    {
        public double y { get; set; }
        public string texto { get; set; }
        public int? reportes { get; set;}
        public string color { get; set;}
    }

    public class LineChartTemp
    {
        public LineChartTemp()
        {
            this.Categories = new Dictionary<string, string>();
            this.Valores = new List<LineChartSerieTemp>();
        }
        public Dictionary<string, string> Categories { get; set; }
        public List<LineChartSerieTemp> Valores { get; set; }
    }

    public class LineChartSerieTemp
    {
        public LineChartSerieTemp()
        {
            this.data = new Dictionary<string, LineChartSerieData>();
        }
        public string keycol { get; set; }
        public string name { get; set; }
        public Dictionary<string, LineChartSerieData> data { get; set; }
        public string texto { get; set; }
    }


}
