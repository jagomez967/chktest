using System.Collections.Generic;

namespace Reporting.Domain.Entities
{
    public class ImagenesChart : Chart
    {
        public int pages { get; set; }

        public ImagenesChart()
        {
            this.Categories = new List<string>();
            this.Valores = new List<Imagen>();
            this.marcaBase64 = string.Empty;
            base.Tipo = TipoChart.Imagenes;
        }
        public List<string> Categories { get; set; }
        public List<Imagen> Valores { get; set; }
        public string marcaBase64 { get; set; }
    }
}
