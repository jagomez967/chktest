using System.Collections.Generic;

namespace Reporting.Domain.Entities
{
    public class TableChart : Chart
    {
        public int pages { get; set; }
        public List<TableChartColumn> Columns { get; set; }
        public List<Dictionary<string, object>> Valores { get; set; }
        public string Totales { get; set; }
        public TableChart()
        {
            Columns = new List<TableChartColumn>();
            Valores = new List<Dictionary<string, object>>();
            base.Tipo = TipoChart.Tabla;
        }
    }

    public class TableChartColumn
    {
        public string esclave { get; set; }
        public string mostrar { get; set; }
        public string esAgrupador { get; set; }
        public string name { get; set; }
        public string title { get; set; }
        public int width { get; set; }
    }
}

