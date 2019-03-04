using System.Collections.Generic;

namespace Reporting.Domain.Entities
{
    public class ScatterChart : Chart
    {
        public ScatterChart()
        {
            this.PlotBands = new List<PlotBandsSeries>();
            this.PlotLines = new List<PlotLinesSeries>();
            this.Valores = new List<DataScatter>();
            this.dataDrillDown = new List<DataScatterWithId>();
            this.imagenes = new Dictionary<string, string>();
            base.Tipo = TipoChart.Scatter;
        }

        public List<PlotBandsSeries> PlotBands { get; set; }
        public List<PlotLinesSeries> PlotLines { get; set; }
        public List<DataScatter> Valores { get; set; }
        public List<DataScatterWithId> dataDrillDown { get; set; }
        public Dictionary<string, string> imagenes;
        public string xTitulo { get; set; }
        public string yTitulo { get; set; }       
    }

    public class PlotBandsSeries
    {
        public PlotBandsSeries()
        {
            this.label = new labelSeries();
        }
        public int from { get; set; }
        public int to { get; set; }
        public string color { get; set; }
        public labelSeries label { get; set; }
    }

    public class labelSeries
    {
        public string text { get; set; }
    }

    public class PlotLinesSeries
    {
        public int value { get; set; }
        public string color { get; set; }
        public string dashStyle { get; set; }
        public int width { get; set; }
        public labelSeriesStyle label { get; set; }
    }

    public class labelSeriesStyle
    {
        public string text { get; set; }
        public string align { get; set; }
        public int x { get; set; } //OFFSET
        public styleLabel style { get; set; }
    }

    public class styleLabel
    {
        public string color { get; set; }
        public string fontWeight { get; set; }
        public string fontSize { get; set; }
    }


    public class DataScatter
    {
        public double y { get; set; } //precio
        public string z { get; set; } //Producto
        public string name { get; set; } //nombre
        public string color { get; set; }  //color
        public string drilldown { get; set; }
    }

    public class DataScatterWithId
    {
        public DataScatterWithId()
        {
            this.data = new List<DataScatter>();
        }
        public string id { get; set; } 
        public List<DataScatter> data { get; set; }
        
    }

}
