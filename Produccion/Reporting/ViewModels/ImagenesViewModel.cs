using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Reporting.ViewModels
{
    public class ImagenViewModel
    {
        public ImagenViewModel()
        {
            this.tags = new List<string>();
        }
        public int id { get; set; }
        public string comentarios { get; set; }
        public string imgb64 { get; set; }
        public List<string> tags { get; set; }
        public int cantTags { get; set; }
        public int idPuntoDeVenta { get; set; }
        public string nombrePuntoDeVenta { get; set; }
        public string direccionPuntoDeVenta { get; set; }
        public int idReporte { get; set; }
        public string fechaCreacion { get; set; }
        public string provincia { get; set; }
        public string Usuario { get; set; }
    }

    public class FileViewModel
    {
        public string filename { get; set; }
        public string size { get; set; }
    }
}