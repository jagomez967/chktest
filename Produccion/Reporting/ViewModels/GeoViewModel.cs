using System;
using System.Collections.Generic;

namespace Reporting.ViewModels
{
    public class GeoRutaViewModel
    {
        public GeoRutaViewModel()
        {
            this.marcadores = new List<GeoMarkerViewModel>();
            this.ruta = new List<GeoPosViewModel>();
            this.color="#000080";
        }

        public List<GeoPosViewModel> ruta { get; set; }
        public List<GeoMarkerViewModel> marcadores { get; set; }
        public string color { get; set; }
    }


    public class MarkersViewModel
    {
        public MarkersViewModel()
        {
            this.Markers = new List<GeoMarkerViewModel>();
        }
        public decimal MiddleLat { get; set; }
        public decimal MiddleLng { get; set; }
        public List<GeoMarkerViewModel> Markers { get; set; }
    }

    public class GeoMarkerViewModel
    {
        public GeoMarkerViewModel()
        {
            this.position = new GeoPosViewModel();
        }
        public GeoPosViewModel position { get; set; }
        public int idUsuario { get; set; }
        public string visitado { get; set; }
        public string icon { get; set; }
        public string layer { get; set; }
        public string title { get; set; }
        public int idReporte { get; set; }
        public string usuario { get; set; }
        public string fechaReporte { get; set; }
        public string label { get; set; }
        public int idPuntoDeVenta { get; set; }
        public string fecha { get; set; }
        public string operacion { get; set; }
        public string categoria { get; set; }
        public string ultimoReporte { get; set; }
    }

    public class GeoPosViewModel
    {
        public GeoPosViewModel() { }
        public GeoPosViewModel(decimal _lat, decimal _lon) {
            lat = _lat;
            lng = _lon;
        }
        public GeoPosViewModel(decimal _lat, decimal _lon,string _label)
        {
            lat = _lat;
            lng = _lon;
            label = _label;
        }
        public decimal lat { get; set; }
        public decimal lng { get; set; }
        public string label { get; set; }
    }

    public class UsuarioSeguimientoViewModel
    {
        public UsuarioSeguimientoViewModel() { }
        public UsuarioSeguimientoViewModel(int id, string nombre, string img)
        {
            idUsuario = id;
            nombreApellido = nombre;
            imagen = img;
        }
        public int idUsuario { get; set; }
        public string nombreApellido { get; set; }
        public string imagen { get; set; }
    }

    public class InfoWindowReporteViewModel
    {
        public InfoWindowReporteViewModel()
        {
            this.Fotos = new List<string>();
        }
        public DateTime FechaReporte { get; set; }
        public int IdReporte { get; set; }
        public string PuntoDeVentaNombre { get; set; }
        public string PuntoDeVentaDireccion { get; set; }
        public string UsuarioNombre { get; set; }
        public string Latitud { get; set; }
        public string Longitud { get; set; }
        public List<string> Fotos { get; set; }
    }

    public class InfoWindowPuntoDeVenta
    {
        public int IdPuntoDeVenta { get; set; }
        public string Nombre { get; set; }
        public string Direccion { get; set; }
        public string Latitude { get; set; }
        public string Longitude { get; set; }
    }
}