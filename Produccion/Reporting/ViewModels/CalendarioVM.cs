using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;
using System.Web.Mvc;

namespace Reporting.ViewModels
{
    public class EventoVM
    {
        public EventoVM()
        {
            this.Usuarios = new List<SelectListItem>();
            this.PuntosDeVenta = new List<SelectListItem>();
            this.Conceptos = new List<SelectListItem>();
        }

        public int Id { get; set; }

        [Required(ErrorMessage="Debe seleccionar un Usuario")]
        [Display(Name="Usuario")]
        public int IdUsuario { get; set; }

        [Required(ErrorMessage = "Debe seleccionar un Punto de Venta")]
        [Display(Name = "Punto de Venta")]
        public int IdPuntoDeVenta { get; set; }
        public DateTime EventDate { get; set; }

        [DefaultValue("0:0:0")]
        public TimeSpan EventTime { get; set; }

        [Display(Name = "Concepto")]
        public int? ConceptoId { get; set; }
        public string Observaciones { get; set; }
        public string CodigoEvento { get; set; }
        public List<SelectListItem> Usuarios { get; set; }
        public List<SelectListItem> PuntosDeVenta { get; set; }
        public List<SelectListItem> Conceptos { get; set; }
    }

    public class EventoCalendarioVM
    {
        public int Id { get; set; }
        public int IdUsuario { get; set; }
        public int IdPuntoDeVenta { get; set; }
        public DateTime Date { get; set; }
        public string NombrePuntoDeVenta { get; set; }
        public string DireccionPuntoDeVenta { get; set; }
        public string NombreUsuario { get; set; }
        public string Concepto { get; set; }
        public string Observaciones { get; set; }
        public string CodigoEvento { get; set; }
        public string Localidad { get; set; }

    }

    public class EventoConceptoVM
    {
        public int Id { get; set; }
        public string Descripcion { get; set; }
    }

    public class ListadoEventosVM
    {
        public ListadoEventosVM()
        {
            this.Usuarios = new List<SelectListItem>();
        }
        public int IdUsuario { get; set; }
        public List<SelectListItem> Usuarios { get; set; }
    }
}