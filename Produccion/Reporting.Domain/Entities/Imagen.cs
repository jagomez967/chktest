using System.Collections.Generic;

namespace Reporting.Domain.Entities
{
    public class Imagen
    {
        public int id { get; set; }
        public string comentarios { get; set; }
        public string imgb64 { get; set; }
        public List<string> tags { get; set; }
        public int cantTags { get; set; }
        public int idPuntoDeVenta { get; set; }
        public string nombrePuntoDeVenta { get; set; }
        public int idReporte { get; set; }
        public string fechaCreacion { get; set; }
        public string direccion { get; set; }
        public string zona { get; set; }
        public string provincia { get; set; }
        public string usuario { get; set; }
    }
}