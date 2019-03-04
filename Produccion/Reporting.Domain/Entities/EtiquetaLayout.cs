using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Reporting.Domain.Entities
{
    public class EtiquetaLayout : Chart
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

        public List<EtiquetaLayout> layoutItems { get; set; }
        public EtiquetaLayout()
        {
            this.IdPuntoDeVenta = int.MinValue;
            this.NombrePdv = string.Empty;
            this.Cantidad = int.MinValue;
            this.IdExhibidor = int.MinValue;
            this.NombreExhibidor = string.Empty;
            this.PosX = int.MinValue;
            this.PosY = int.MinValue;
            this.IdCliente = int.MinValue;
            this.PosxHover = int.MinValue;
            this.PosyHover = int.MinValue;
            this.PosxPorcentaje = int.MinValue;
            this.PosyPorcentaje = int.MinValue;
            this.layoutItems = new List<EtiquetaLayout>();
        }
    }
}