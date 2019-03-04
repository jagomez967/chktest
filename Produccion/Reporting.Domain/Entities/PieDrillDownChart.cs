using System.Collections.Generic;

namespace Reporting.Domain.Entities
{
    public class PieDrillDownChart : Chart
    {
        public PieDrillDownChart()
        {
            this.Valores = new List<PieDrillDownChartSerie>();
            this.DrillDown = new List<PieDrillDownChartDrillDown>();
            base.Tipo = TipoChart.PieDrillDown;
        }
        public List<PieDrillDownChartSerie> Valores { get; set; }
        public List<PieDrillDownChartDrillDown> DrillDown { get; set; }
        public bool showVal { get; set; }
    }
    public class PieDrillDownChartSerie
    {
        public string name { get; set; }
        public double y { get; set; }
        public string drilldown { get; set; }
        public bool showVal { get; set; }
        public string color { get; set; }
    }
    public class PieDrillDownChartDrillDown
    {
        public PieDrillDownChartDrillDown()
        {
            this.data = new List<PieDrillDownChartDrillDownData>();
        }
        public string id { get; set; }
        public string name { get; set; }
        public List<PieDrillDownChartDrillDownData> data { get; set; }
    }
    public class PieDrillDownChartDrillDownData
    {
        public string name { get; set; }
        public double y { get; set; }
    }
}
