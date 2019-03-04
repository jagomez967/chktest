
using System.Collections.Generic;

namespace Reporting.Domain.Entities
{
    public class ChartError : Chart
    {
        public ChartError()
        {
            Message = "empty error message";
            base.Tipo = TipoChart.Error;
            Valores = new List<string>();
        }
        public ChartError(string _Message)
        {
            Message = _Message;
            base.Tipo = TipoChart.Error;
            Valores = new List<string>();
        }
        public string Message { get; }
        public List<string> Valores { get; set; }
    }
}