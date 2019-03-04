using System.Collections.Generic;

namespace Reporting.Domain.Entities
{
    public class ColumnChart : Chart
    {
        public ColumnChart()
        {
            Categories = new List<string>();
            Valores = new List<ColumnChartSerie>();
            ShowValues = false;
            LabelsEnabled = false;
            base.Tipo = TipoChart.Column;
            IsInverted = false;
            ShowLegend = true;
            IsPercentage = false;
            ShowTitle = true;
            Height = 0;
        }
        public List<string> Categories { get; set; }
        public List<ColumnChartSerie> Valores { get; set; }
        public string Totales { get; set; }
        public bool ShowValues { get; set; }
        public bool LabelsEnabled { get; set; }
        public bool IsInverted { get; set; }
        public bool ShowLegend { get; set; }
        public bool IsPercentage { get; set; }
        public bool ShowTitle { get; set; }
        public int Height { get; set; }
    }

    public class ColumnChartSerie
    {
        public ColumnChartSerie()
        {
            this.data = new List<double>();
        }
        public string name { get; set; }
        public string pointPadding { get; set; }
        public string color { get; set; }
        public List<double> data { get; set; }
    }
}