using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Reporting.Domain.Entities
{
    public class SparkLineChart:Chart
    {
        public SparkLineChart()
        {
            Categories = new List<string>();
            Valores = new List<SparkLineSerie>();
            base.Tipo = TipoChart.SparkLine;
        }
        public List<string> Categories { get; set; }
        public List<SparkLineSerie> Valores { get; set; }
    }

    public class SparkLineSerie
    {
        public SparkLineSerie()
        {
            data = new List<SparkLineData>();
        }
        public string name { get; set; }
        public List<SparkLineData> data { get; set; }
    }
    public class SparkLineData
    {
        public double y { get; set; }
        public string dateFrom { get; set; }
        public string dateTo { get; set; }
    }
}
