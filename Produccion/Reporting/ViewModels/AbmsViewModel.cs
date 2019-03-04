using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace Reporting.ViewModels
{
    public class AlertaItemList
    {
        public int Id { get; set; }
        public string Descripcion { get; set; }
        public bool Lunes { get; set; }
        public bool Martes { get; set; }
        public bool Miercoles { get; set; }
        public bool Jueves { get; set; }
        public bool Viernes { get; set; }
        public bool Sabado { get; set; }
        public bool Domingo { get; set; }
        public string Hora { get; set; }
        public string AccionTrigger { get; set; }
        public string TipoReporte { get; set; }
        public bool Consolidado { get; set; }
        public int CantCampos { get; set; }
        public int CantPdvs { get; set; }
        public string Destinatarios { get; set; }
        public bool Activo { get; set; }
    }
    public class AlertaVM
    {
        public AlertaVM()
        {
            this.Campos = new List<CampoAlerta>();
            this.PuntosDeVenta = new List<PuntoDeVentaAlertaVM>();
        }

        public int Id { get; set; }

        [Required(ErrorMessageResourceType = typeof(Reporting.Resources.Abms), ErrorMessageResourceName = "AlertasVM_Descripcion_Required")]
        [StringLength(200, MinimumLength = 10, ErrorMessageResourceType = typeof(Reporting.Resources.Abms), ErrorMessageResourceName = "AlertasVM_Descripcion_StringLength")]
        [Display(ResourceType = typeof(Reporting.Resources.Abms), Name = "AlertasVM_Descripcion_Display")]
        public string Descripcion { get; set; }

        [Display(Name = "Consolidado")]
        public bool Consolidado { get; set; }

        [Display(Name = "Lunes")]
        public bool Lunes { get; set; }

        [Display(Name = "Martes")]
        public bool Martes { get; set; }

        [Display(Name = "Miercoles")]
        public bool Miercoles { get; set; }

        [Display(Name = "Jueves")]
        public bool Jueves { get; set; }

        [Display(Name = "Viernes")]
        public bool Viernes { get; set; }

        [Display(Name = "Sabado")]
        public bool Sabado { get; set; }

        [Display(Name = "Domingo")]
        public bool Domingo { get; set; }

        [DataType(DataType.Time)]
        public string Hora { get; set; }

        [Display(Name = "Acciones Disparadoras de Informe")]
        public string AccionTriggerSeleccionada { get; set; }

        [Display(Name = "Tipo de Reporte")]
        public string TipoReporteSeleccionado { get; set; }

        [Display(Name = "Campos a Mostrar en el informe")]
        public List<CampoAlerta> Campos { get; set; }

        [Required(ErrorMessageResourceType = typeof(Reporting.Resources.Abms), ErrorMessageResourceName = "AlertasVM_Destinatarios_Required")]
        [Display(ResourceType = typeof(Reporting.Resources.Abms), Name = "AlertasVM_Destinatarios_Display")]
        public string Destinatarios { get; set; }

        [Display(ResourceType = typeof(Reporting.Resources.Abms), Name = "AlertasVM_Activo_Display")]
        public bool Activo { get; set; }

        [Display(Name = "Pdvs")]
        public List<PuntoDeVentaAlertaVM> PuntosDeVenta { get; set; }
    }
    public class PuntoDeVentaAlertaVM
    {
        public int idZona { get; set; }
        public int idCadena { get; set; }
        public int idPuntoDeVenta { get; set; }
        public string ZonaDescr { get; set; }
        public string CadenaDescr { get; set; }
        public string PuntoDeVentaDescr { get; set; }
        public bool Selected { get; set; }
    }
    public class CampoAlerta
    {
        public int Id { get; set; }
        public int IdMarca { get; set; }
        public int IdSeccion { get; set; }
        public int IdCampo { get; set; }
        public string MarcaDescr { get; set; }
        public string SeccionDescr { get; set; }
        public string CampoDescr { get; set; }
        public bool Selected { get; set; }
    }
}