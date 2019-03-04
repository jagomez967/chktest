using System.Collections.Generic;

namespace Reporting.Domain.Entities
{
    class PieWheelChart : Chart
    {
        public PieWheelChart()
        {
            this.Valores = new List<PieWheelChartValues>();
            base.Tipo = TipoChart.PieWheel;
        }
        public string SerieName;
        public string SubTitle;
        public string LegendFontSize;
        public string Total;
        public string Target;
        public int FullPie;
        public int showText;
        
        public List<PieWheelChartValues> Valores;
    }

    public class PieWheelChartValues
    {
        public string name { get; set; }
        public double y { get; set; }
        public string color { get; set; }
        public string text { get; set; }
    }
}
