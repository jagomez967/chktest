using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Reporting.Domain.Entities
{
    class CircleDetailChart:Chart
    {
        public CircleDetailChart()
        {
            Valores = new List<CircleDetailItem>();
            base.Tipo = TipoChart.CircleWithDetail;
        }
        public List<CircleDetailItem> Valores { get; set; }
    }

    public class CircleDetailItem
    {
        public CircleDetailItem()
        {
            SubItems = new List<CircleDetailSubItem>();
        }

        public string Title { get; set; }
        public string SubTitle { get; set; }
        public int Valor { get; set; }
        public string LabelValor { get; set; }
        public string Unidad { get; set; }
        public string Imagen { get; set; }
        public string Color { get; set; }
        public int AlwaysFull { get; set; }

        public List<CircleDetailSubItem> SubItems { get; set; }
    }

    public class CircleDetailSubItem
    {
        public int Valor { get; set; }
        public string Text { get; set; }
        public string Unidad { get; set; }
        public string Imagen { get; set; }

    }
}
