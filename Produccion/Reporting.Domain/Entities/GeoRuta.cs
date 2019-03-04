using System.Collections.Generic;

namespace Reporting.Domain.Entities
{
    public class GeoRuta
    {
        public GeoRuta()
        {
            this.marcadores = new List<GeoMarker>();
            this.ruta = new List<GeoPos>();
        }
        public List<GeoMarker> marcadores { get; set; }
        public List<GeoPos> ruta { get; set; }
    }
}
