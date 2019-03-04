namespace Reporting.Domain.Entities
{
    public class GeoMarkerSimple
    {
        public decimal lat { get; set; }
        public decimal lng { get; set; }
        public string visitado { get; set; }
        public string icon { get; set; }     
        public int idPuntoDeVenta { get; set; }
        public string ultimoReporte { get; set; }
        public string usuario { get; set; }
    }
}


