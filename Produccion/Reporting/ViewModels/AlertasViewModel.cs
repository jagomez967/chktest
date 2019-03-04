using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

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
        public int CantProductos { get; set; }
        public string Destinatarios { get; set; }
        public bool Activo { get; set; }
    }
    public class AlertaVM
    {
        public AlertaVM()
        {
            this.Campos = new List<CampoAlerta>();
            this.Productos = new List<ProductoAlerta>();
            this.PuntosDeVenta = new List<PuntoDeVentaAlertaVM>();
            this.Modulos = new List<ModuloAlerta>();
            this.Distancia = 0;
            this.HoraInicio = "";
            this.HoraFin = "";
        }

        public int Id { get; set; }

        [Required(ErrorMessageResourceType = typeof(Reporting.Resources.Alertas), ErrorMessageResourceName = "AlertasVM_Descripcion_Required")]
        [StringLength(200, MinimumLength = 10, ErrorMessageResourceType = typeof(Reporting.Resources.Alertas), ErrorMessageResourceName = "AlertasVM_Descripcion_StringLength")]
        [Display(ResourceType = typeof(Reporting.Resources.Alertas), Name = "AlertasVM_Descripcion_Display")]
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

        [Display(Name = "Productos")]
        public List<ProductoAlerta> Productos { get; set; }

        [Required(ErrorMessageResourceType = typeof(Reporting.Resources.Alertas), ErrorMessageResourceName = "AlertasVM_Destinatarios_Required")]
        [Display(ResourceType = typeof(Reporting.Resources.Alertas), Name = "AlertasVM_Destinatarios_Display")]
        public string Destinatarios { get; set; }

        [Display(ResourceType = typeof(Reporting.Resources.Alertas), Name = "AlertasVM_Activo_Display")]
        public bool Activo { get; set; }

        [Display(Name = "Pdvs")]
        public List<PuntoDeVentaAlertaVM> PuntosDeVenta { get; set; }

        [Display(Name = "Modulos")]
        public List<ModuloAlerta> Modulos { get; set; }

        public decimal? Distancia { get; set; }


        [DataType(DataType.Time)]
        [Display(Name = "Hora Inicio")]
        public string HoraInicio { get; set; }


        [DataType(DataType.Time)]
        [Display(Name = "Hora Fin")] 
        public string HoraFin { get; set; }
    }

    public class ModuloAlerta
    {
        public int idModuloClienteItem { get; set; }
        public int idModuloItem { get; set; }
        public string leyenda { get; set; }
        public Decimal? valor { get; set; }
        public bool esMayor { get; set; }
        public bool esMenor { get; set; }
        public bool esIgual { get; set; }
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
        public string RazonSocial { get; set; }
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
    public class ProductoAlerta
    {
        public int Id { get; set; }
        public int IdMarca { get; set; }
        public int IdProducto { get; set; }
        public string MarcaDescr { get; set; }
        public string ProductoDescr { get; set; }
        public bool Selected { get; set; }
    }
}