using System.Collections.Generic;

namespace Reporting.ViewModels
{
    public class ChartViewModel
    {
        public int TipoChart { get; set; }
        public string SPDatos { get; set; }
    }
    public class PieChartViewModel : ChartViewModel
    {
        public PieChartViewModel()
        {
            this.Valores = new List<PieChartSerieViewModel>();
        }

        public List<PieChartSerieViewModel> Valores { get; set; }
    }

    public class PieChartSerieViewModel
    {
        public string name { get; set; }
        public double y { get; set; }
    }

    public class ColumnChartViewModel : ChartViewModel
    {
        public ColumnChartViewModel()
        {
            this.Categories = new List<string>();
            this.Valores = new List<ColumnChartSerieViewModel>();
        }
        public string SPCategories { get; set; }
        public List<string> Categories { get; set; }
        public List<ColumnChartSerieViewModel> Valores { get; set; }
    }

    public class ColumnChartSerieViewModel
    {
        public string name { get; set; }
        public List<double> data { get; set; }
    }

    public class StackedColumnChartViewModel : ChartViewModel
    {
        public StackedColumnChartViewModel()
        {
            this.Categories = new List<string>();
            this.Valores = new List<StackedColumnChartSerieViewModel>();
        }
        public StackedColumnChartViewModel(bool IsStacked)
            : base()
        {
            this.IsStacked = IsStacked;
        }

        public string StackingViewModel
        {
            get { return (IsStacked) ? "stacked" : "normal"; }
        }
        private bool IsStacked;
        public string SPCategories { get; set; }
        public List<string> Categories { get; set; }
        public List<StackedColumnChartSerieViewModel> Valores { get; set; }
    }
    public class StackedColumnChartSerieViewModel
    {
        public string name { get; set; }
        public List<double> data { get; set; }
    }

}