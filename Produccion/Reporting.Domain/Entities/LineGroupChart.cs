using System.Collections.Generic;

namespace Reporting.Domain.Entities
{
    public class LineGroupChart : Chart
    {
        public LineGroupChart()
        {
            PlotBands = new List<PlotBandsSeriesL>();
            PlotLines = new List<PlotLinesSeriesL>();
            Categories = new List<string>();
            Valores = new List<LineGroupChartSerie>();
            TipoPrecio = 1;
            LabelFullName = false;
            base.Tipo = TipoChart.Spiline;
        }
        public List<string> Categories { get; set; }
        public List<LineGroupChartSerie> Valores { get; set; }
        public List<PlotBandsSeriesL> PlotBands { get; set; }
        public List<PlotLinesSeriesL> PlotLines { get; set; }
        public int TipoPrecio { get; set; }
        public bool LabelFullName { get; set; }
    }

    public class LineGroupChartSerie
    {
        public LineGroupChartSerie()
        {
            this.data = new List<DataLineGroup>();
        }
        public string name { get; set; }
        public string color { get; set; }
        public List<DataLineGroup> data { get; set; }
        public string dashStyle { get; set; }
    }


    public class DataLineGroup
    {
        public double y { get; set; } //precio
        public string name { get; set; } //nombre 
        public int reportes { get;  set; } //
        public string valorFecha { get; set; }
    }

    public class LineGroupChartTemp
    {
        public LineGroupChartTemp()
        {
            this.Categories = new Dictionary<string, string>();
            this.Valores = new List<LineGroupChartSerieTemp>();
        }
        public Dictionary<string, string> Categories { get; set; }
        public List<LineGroupChartSerieTemp> Valores { get; set; }
    }

    public class LineGroupChartSerieTemp
    {
        public LineGroupChartSerieTemp()
        {
            //   this.data = new Dictionary<string, double>();
            data = new List<SerieTempData>();
        }
        public string keycol { get; set; }
        public string name { get; set; }
       // public Dictionary<string, double> data { get; set; }
       public List<SerieTempData> data { get; set; }
        public string color { get; set; }
        public string dashStyle { get; set; }
    }

    public class SerieTempData
    {
        public string name { get; set; }
        public double y { get; set; }
        public int reportes { get; set; }
        public string valorFecha { get; set; }
    }

    public class PlotBandsSeriesL
    {
        public PlotBandsSeriesL()
        {
            this.label = new labelSeriesL();
        }
        public int from { get; set; }
        public int to { get; set; }
        public string color { get; set; }
        public labelSeriesL label { get; set; }
    }

    public class labelSeriesL
    {
        public string text { get; set; }
        public string align { get; set; }
        public int x { get; set; } //OFFSET
        public string style { get; set; }
    }

    public class PlotLinesSeriesL
    {
        public int value { get; set; }
        public string color { get; set; }
        public string dashStyle { get; set; }
        public int width { get; set; }
        public styleLabelSeriesL label { get; set; }
    }

    public class styleLabelSeriesL
    {
        public string text { get; set; }
        public string align { get; set; }
        public int x { get; set; } //OFFSET
        public styleLabelL style { get; set; }
    }

    public class styleLabelL
    {
        public string color { get; set; }
        public string fontWeight { get; set; }
        public string fontSize { get; set; }
    }

}
