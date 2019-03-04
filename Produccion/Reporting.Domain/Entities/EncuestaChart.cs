using System.Collections.Generic;

namespace Reporting.Domain.Entities
{
    public class EncuestaChart : Chart
    {
        public EncuestaChart()
        {
            this.Valores = new List<MetricasNivel>();
            base.Tipo = TipoChart.MetEncuestas;
        }
        public List<MetricasNivel> Valores = new List<MetricasNivel>();
    }

    public class MetricasNivel
    {
        public MetricasNivel()
        {
            this.data = new List<MetricaData>();
        }
        public bool usaTotal { get; set; }
        public double valorTotalAVG { get; set; }
        public double valorVarianzaTotal { get; set; }
        public string color { get; set; }
        public int nivel { get; set; }
        public int max { get; set; }
        public List<MetricaData> data { get; set; }
    }
    public class MetricaData
    {
        public int id { get; set; }
        public double valor { get; set; }
        public double varianza { get; set; }
        public string logo { get; set; }
        public string color { get; set; }
        public int parentId { get; set; }
        public string info { get; set; }
        public int max { get; set; }
    }
}
