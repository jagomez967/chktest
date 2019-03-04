using System.Collections.Generic;

namespace Reporting.Domain.Entities
{
    public class MultiTendenciaChart : Chart
    {
        public MultiTendenciaChart()
        {
            Categories = new List<string>();
            Valores = new List<MultiTendenciaSerie>();
            YAxis = new List<MultiTendenciaYAxis>();
            base.Tipo = TipoChart.MultiTendencia;
        }
        public List<string> Categories { get; set; }
        public List<MultiTendenciaSerie> Valores { get; set; }
        public List<MultiTendenciaYAxis> YAxis { get; set; }
    }
    public class MultiTendenciaYAxis
    {
        public MultiTendenciaYAxis()
        {
            labels = new YAxisLabels();
            title = new YAxisTitle();
        }
        public YAxisLabels labels { get; set; }
        public YAxisTitle title { get; set; }
        public bool opposite { get; set; }
        
    }
    public class YAxisLabels
    {
        public string format { get; set; }
        public string enabled { get; set; }
    }
    public class YAxisTitle
    {
        public string text { get; set; }
        public string enabled { get; set; }
    }
    public class MultiTendenciaSerie
    {
        public MultiTendenciaSerie()
        {
            tooltip = new ToolTipSerie();
        }
        public string name { get; set; }
        public string Unit { get; set; }
        public string type { get; set; }//column o spline
        public int yAxis { get; set; }
        public string color { get; set; }
        public List<double> data { get; set; }
        public ToolTipSerie tooltip { get; set; }

    }
    public class ToolTipSerie
    {
        public string valueSuffix { get; set; }
    }
}
