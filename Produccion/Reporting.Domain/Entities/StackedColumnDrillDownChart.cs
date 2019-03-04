using System.Collections.Generic;

namespace Reporting.Domain.Entities
{
    public class StackedColumnDrillDownChart : Chart
    {
        public StackedColumnDrillDownChart()
        {
            Valores = new List<StackedColumnDrillDownChartSerie>();
            DrillDown = new List<StackedColumnDrillDownChartDrillDown>();
            VisibleLegend = false;
            Visiblelabel = false;
            ShowText = false;
            base.Tipo = TipoChart.StackedColumnDrillDown;
            IsInverted = false;
            ShowLegend = true;

        }
        public List<StackedColumnDrillDownChartSerie> Valores { get; set; }
        public List<StackedColumnDrillDownChartDrillDown> DrillDown { get; set; }
        public bool VisibleLegend { get; set; }
        public bool Visiblelabel{ get; set; }
        public bool IsPercentage { get; set; }
        public bool ShowText { get; set; }
        public bool IsInverted { get; set; }
        public bool ShowLegend { get; set; }

    }
    public class StackedColumnDrillDownChartSerie
    {
        public StackedColumnDrillDownChartSerie()
        {
            this.data = new List<StackedColumnDrillDownChartSerieData>();
        }
        public string name { get; set; }
        public string color { get; set; }
        public List<StackedColumnDrillDownChartSerieData> data { get; set; }
    }
    public class StackedColumnDrillDownChartSerieData
    {
        public string name { get; set; }
        public double y { get; set; }
        public string drilldown { get; set; }
        public string ExtraText { get; set; }
        public string color { get; set; }
    }
    public class StackedColumnDrillDownChartDrillDown
    {
        public StackedColumnDrillDownChartDrillDown()
        {
            data = new List<StackedColumnDrillDownChartSerieData>();
        }
        public string id { get; set; }
        public string name { get; set; }
        public List<StackedColumnDrillDownChartSerieData> data { get; set; }
    }
    public class StackedColumnDrillDownChartDrillDownData
    {
        public string name { get; set; }
        public double y { get; set; }
        public double color { get; set; }
    }

    public class DataItem
    {
        public string Name { get; set; }
        public decimal Y { get; set; }
        public string Drilldown { get; set; }
    }

    public class Serie
    {
        public string Name { get; set; }
    }

    public class Drilldown
    {
        public string Id { get; set; }
        public string Name { get; set; }
    }
}
