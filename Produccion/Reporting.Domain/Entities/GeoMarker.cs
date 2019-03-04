namespace Reporting.Domain.Entities
{
    public class GeoMarker
    {
        public int id { get; set; }
        public decimal lat { get; set; }
        public decimal lng { get; set; }
        public int idUsuario { get; set; }
        public string visitado { get; set; }
        public string icon { get; set; }
        public string layer { get; set; }
        public string title { get; set; }
        public int idReporte { get; set; }
        public string usuario { get; set; }
        public string fecha { get; set; }
        public string tipo { get; set; }
        public string label { get; set; }
        public int idPuntoDeVenta { get; set; }
        public string operacion { get; set; }
        public string categoria { get; set; }
    }
}


