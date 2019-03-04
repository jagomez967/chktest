using System.Collections.Generic;

namespace Reporting.Domain.Entities
{
    public class MeasureChart : Chart
    {
        public MeasureChart()
        {
            Etiquetas = new List<MeasureLabel>();
            base.Tipo = TipoChart.Measure;
            Texto = "COMPETIMETER";
            ExplicitValues = false;
            Valores = new List<string>() {"","",""};
        }
        public int Valor { get; set; }
        public string Producto { get; set; }
        public string Competencia { get; set; }
        public string Texto { get; set; }
        public int MinValor { get; set; }
        public int MaxValor { get; set; }
        public bool ExplicitValues { get; set; } //TENGO QUE MERGEAR TODA ESTA MIERDA
         public List<MeasureLabel> Etiquetas { get; set; }
        public List<string> Valores { get; set; }
    }
    public class MeasureLabel
    {
        public int Valor { get; set; }
        public string Label { get; set; }
    }
}

