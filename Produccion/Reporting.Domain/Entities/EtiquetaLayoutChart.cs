using System.Collections.Generic;

namespace Reporting.Domain.Entities
{
    public class EtiquetaLayoutChart : Chart
    {
        public List<EtiquetaLayoutItem> Valores { get; set; }
        public EtiquetaLayoutChart()
        {
            this.Valores = new List<EtiquetaLayoutItem>();
            base.Tipo = TipoChart.EtiquetaLayout;
        }
    }

    public class EtiquetaLayoutItem
    {
        public int IdPuntoDeVenta { get; set; }
        public string NombrePdv { get; set; }
        public int Cantidad { get; set; }
        public int IdExhibidor { get; set; }
        public string NombreExhibidor { get; set; }
        public int PosX { get; set; }
        public int PosY { get; set; }
        public int IdCliente { get; set; }
        public int PosxHover { get; set; }
        public int PosyHover { get; set; }
        public int PosxPorcentaje { get; set; }
        public int PosyPorcentaje { get; set; }
        public string Label { get; set; }
    }
}