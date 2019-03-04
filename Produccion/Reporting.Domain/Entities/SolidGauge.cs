using System.Collections.Generic;

namespace Reporting.Domain.Entities
{
    class SolidGauge : Chart
    {
        public SolidGauge() { base.Tipo = TipoChart.SolidGauge; Valores = new List<string>(2); }
        public string SerieName;
        public string AxisLabel;
        public double Value;
        public string Color;
        public double MinY;
        public double MaxY;
        public double Target;
        public string TargetLabel;
        public List<string> Valores { get; }
    }
}

