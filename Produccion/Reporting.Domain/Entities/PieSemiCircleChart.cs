using System.Collections.Generic;

namespace Reporting.Domain.Entities
{
    public class PieSemiCircleChart : Chart
    {
        public double Valor { get; set; }
        public List<PieChartColorLimit> Limites { get; set; }
        public PieSemiCircleChart()
        {
            this.Limites = new List<PieChartColorLimit>();
            base.Tipo = TipoChart.PieSemiCircle;
        }
    }

    public class PieChartColorLimit
    {
        public string name { get; set; }
        public string HexColor { get; set; }
        public double min { get; set; }
        public double max { get; set; }
    }
}
