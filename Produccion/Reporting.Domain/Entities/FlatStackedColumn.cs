using System.Collections.Generic;

namespace Reporting.Domain.Entities
{
    class FlatStackedColumn : Chart
    {
        public FlatStackedColumn()
        {
            this.Valores = new List<FlatStackedColumnSeries>();
            this.Categories = new List<string>();
            base.Tipo = TipoChart.FlatStackedColumn;
        }
        public string SerieName;
        public string Percent;
        public double minY;
        public double maxY;
        public int stack;
        public int showText;
        public int PersistTooltip;
        public int ShowYAxisLabels;
        public List<string> Categories;
        public List<FlatStackedColumnSeries> Valores;
        public List<FlatStackedColumnPlotLine> PlotLines;
        public List<FlatStackedColumnPlotBand> PlotBands;
    }

    public class FlatStackedColumnSeries
    {
        public string name { get; set; }
        public string color { get; set; }
        public string size { get; set; }
        public string type { get; set; }
        public int zIndex { get; set; }
        public List<FlatStackedColumnValues> data { get; set; }
    }

    public class FlatStackedColumnValues
    {
        public string name { get; set; }
        public double y { get; set; }
        public string text { get; set; }
        public string perc { get; set; }
    }

    public class FlatStackedColumnPlotLine
    {
        public string color { get; set; }
        public string dashStyle { get; set; }
        public double width { get; set; }
        public double value { get; set; }
        public FlatStackedColumnPlotLineLabel label { get; set; }
    }

    public class FlatStackedColumnPlotLineLabel
    {
        public string text { get; set; }
    }

    public class FlatStackedColumnPlotBand
    {
        public string color { get; set; }
        public int from { get; set; }
        public int to { get; set; }
    }
}
 