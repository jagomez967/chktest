using System.Collections.Generic;

namespace Reporting.Domain.Entities
{
    public class ClassicTable : Chart
    {
        public ClassicTable()
        {
            this.Headers = new List<string>();
            this.Valores = new List<List<string>>();
            base.Tipo = TipoChart.ClassicTable;
        }

        public List<string> Headers;
        public List<List<string>> Valores;
    }
}
