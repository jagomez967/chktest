using System.Collections.Generic;

namespace Reporting.Domain.Entities
{
   public class TimelineChart : Chart
    {
       public List<TimeLineSeries> Valores { get; set; }

        public TimelineChart()
        {
            this.Valores = new List<TimeLineSeries>();
            base.Tipo = TipoChart.Timeline;
        }
    }
   public class TimeLineSeries
   {
       public int Id { get; set; }
       public int IdUsuario { get; set; }
       public string NombreUsuario { get; set; }
       public string ApellidoUsuario { get; set; }
       public string FechaCreacion { get; set; }
       public string AccionTipo { get; set; }
       public string Descripcion { get; set; }
        public string Cliente { get; set; }
   }
}
