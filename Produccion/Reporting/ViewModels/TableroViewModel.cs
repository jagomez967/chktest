using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Web;

namespace Reporting.ViewModels
{

    public class TableroViewModel
    {
        public TableroViewModel()
        {
            this.Tabs = new ListTabViewModel();
        }
        public ListTabViewModel Tabs { get; set; }
    }

    public class FiltrosViewModel
    {
        public FiltrosViewModel()
        {
            this.FiltrosChecks = new List<FiltroCheckViewModel>();
            this.FiltrosFechas = new List<FiltroFechaViewModel>();
            this.isLocked = false;
        }
        public List<FiltroCheckViewModel> FiltrosChecks { get; set; }
        public List<FiltroFechaViewModel> FiltrosFechas { get; set; }
        public bool isLocked { get; set; }
        public bool permitebloquearfiltros { get; set; }
        public int idCliente { get; set; }
    }

    public class FiltroCheckViewModel
    {
        public FiltroCheckViewModel()
        {
            this.Items = new List<ItemViewModel>();
        }
        public string Id { get; set; }
        public string Nombre { get; set; }
        public List<ItemViewModel> Items { get; set; }
    }

    public class FiltroFechaViewModel
    {
        public string Id { get; set; }
        public string Nombre { get; set; }

        public string TipoFechaSeleccionada { get; set; }

        [DataType(DataType.Date)]
        [Display(Name = "Desde")]
        public string DiaDesde { get; set; }

        [DataType(DataType.Date)]
        [Display(Name = "Hasta")]
        public string DiaHasta { get; set; }

        [Display(Name = "Desde")]
        public string SemanaDesde { get; set; }

        [Display(Name = "Hasta")]
        public string SemanaHasta { get; set; }

        [Display(Name = "Desde")]
        public string MesDesde { get; set; }

        [Display(Name = "Hasta")]
        public string MesHasta { get; set; }

        [Display(Name = "Desde")]
        public string TrimestreDesde { get; set; }

        [Display(Name = "Hasta")]
        public string TrimestreHasta { get; set; }
    }

    public class ItemDropDownListViewModel
    {
        public string Value { get; set; }
        public string Descripcion { get; set; }
        public string ParentValue { get; set; }
    }

    public class ObjetosDeTableroViewModel
    {
        public ObjetosDeTableroViewModel()
        {
            this.Objetos = new List<ObjetoViewModel>();
        }
        public int TableroId { get; set; }
        public List<ObjetoViewModel> Objetos { get; set; }
    }
    public class ObjetoViewModel
    {
        public ObjetoViewModel()
        {
            this.Chart = new ChartViewModel();
        }
        public int Id { get; set; }
        public int IdTipoObjeto { get; set; }
        public string TextoHeader { get; set; }
        public string TextoFooter { get; set; }
        public int Orden { get; set; }
        public int Tipo { get; set; }
        public string SPDatos { get; set; }
        public bool Selected { get; set; }
        public string Size { get; set; }
        public string SizePage { get; set; }
        public int CategoriaId { get; set; }
        public bool? dataLabels { get; set; }
        public int? stackLabels { get; set; }
        public ChartViewModel Chart { get; set; }
        public string altura { get; set; }
        public string Descripcion { get; set; }
    }

    public class ItemViewModel
    {
        public string IdItem { get; set; }
        public string Descripcion { get; set; }
        public bool Selected { get; set; }
        public string TipoItem { get; set; }
        public bool isLocked { get; set; }
    }

    public class ItemViewModelCountry : ItemViewModel
    {
        public string CountryCode { get; set; }
    }

    public class TabViewModel
    {
        public string Titulo { get; set; }
        public int Id { get; set; }
        public bool Active { get; set; }
    }

    public class FiltroSeleccionadoViewModel
    {
        public string Filtro { get; set; }
        public string TipoFecha { get; set; }
        public string[] Valores { get; set; }
    }

    public class PermisosViewModel
    {
        public PermisosViewModel()
        {
            this.permisos = new List<PermisoUsuarioViewModel>();
        }
        public int idTablero { get; set; }
        public List<PermisoUsuarioViewModel> permisos { get; set; }
    }
    public class PermisoUsuarioViewModel
    {
        public int idusuario { get; set; }
        public string nombre { get; set; }
        public bool permiteLectura { get; set; }
        public bool permiteEscritura { get; set; }
        public string imgPerfil { get; set; }
    }

    public class UsuarioPerfilViewModel
    {
        public UsuarioPerfilViewModel()
        {
            Idiomas = new List<System.Web.Mvc.SelectListItem>();
        }
        public int userId { get; set; }

        [Required(ErrorMessage="Es obligatorio especificar un Nombre de usuario")]
        [StringLength(30, MinimumLength=3, ErrorMessage="El Nombre de usuario debe tener entre 3 y 30 caracteres")]
        [Display(Name="Nombre")]
        public string Nombre { get; set; }

        [Required(ErrorMessage = "Es obligatorio especificar un Apellido de usuario")]
        [StringLength(30, MinimumLength = 3, ErrorMessage = "El Apellido de usuario debe tener entre 3 y 30 caracteres")]
        [Display(Name = "Apellido")]
        public string Apellido { get; set; }

        [Required(ErrorMessage = "Es obligatorio especificar un Apellido de usuario")]
        [StringLength(50, MinimumLength = 3, ErrorMessage = "El Apellido de usuario debe tener entre 3 y 50 caracteres")]
        [Display(Name = "Email")]
        [DataType(DataType.EmailAddress)]
        [UIHint("userEmail")]

        public string Email { get; set; }

        [StringLength(40, MinimumLength = 8, ErrorMessage = "La contraseña actual debe tener un minimo de 6 caracteres")]
        [Display(Name = "Contraseña Actual")]
        [DataType(DataType.Password)]
        public string PasswordActual { get; set; }

        //[Required(ErrorMessage = "Es obligatorio especificar una contraseña")]
        [StringLength(40, MinimumLength=6,ErrorMessage="La contraseña debe tener un minimo de 8 caracteres")]
        [Display(Name = "Contraseña")]
        [DataType(DataType.Password)]
        public string Password { get; set; }

        //[Required(ErrorMessage = "Debe confirmar la contraseña")]
        [Display(Name = "Confirmar Contraseña")]
        [StringLength(40, MinimumLength = 8, ErrorMessage = "La contraseña debe tener un minimo de 8 caracteres")]
        [DataType(DataType.Password)]
        [Compare("Password", ErrorMessage="Las contraseñas no coinciden")]
        public string ConfirmPassword { get; set; }

        [DataType(DataType.Upload)]
        public HttpPostedFileBase ImageUpload { get; set; }

        public List<System.Web.Mvc.SelectListItem> Idiomas { get; set; }

        [Required]
        [Display(Name="Idioma")]
        public string SelectedIdioma { get; set; }

        public int passwordFlag { get; set; }
    }

    public class CrearTableroViewModel
    {
        public CrearTableroViewModel()
        {
            this.Tipos = new List<ObjetoTipoViewModel>();
            this.Categorias = new List<CategoriaObjetoViewModel>();
        }

        [Display(Name = "Nombre")]
        [Required(ErrorMessage = "Debe ingresar Nombre")]
        [MaxLength(50, ErrorMessage = "El campo Nombre soporta hasta 50 caracteres")]
        public string Nombre { get; set; }
        public List<CategoriaObjetoViewModel> Categorias { get; set; }
        public List<ObjetoTipoViewModel> Tipos { get; set; }
    }

    public class CategoriaObjetoViewModel
    {
        public int Id { get; set; }
        public string Nombre { get; set; }

    }

    public class ObjetoTipoViewModel
    {
        public ObjetoTipoViewModel()
        {
            this.TipoGrafico = new List<TipoGraficosViewModel>();
        }
        public int Id { get; set; }
        public string Nombre { get; set; }
        public string Size { get; set; }
        public int Orden { get; set; }
        public bool Selected { get; set; }
        public int TipoGraficoSeleccionado { get; set; }
        public bool dataLabels { get; set; }
        public int stackLabels { get; set; }//0: nada, 1:Promedio(AVG), 2:Suma total(SUM)
        public int IdFamilia { get; set; }
        public int IdCategoria { get; set; }
        public string Altura { get; set; }

        public List<TipoGraficosViewModel> TipoGrafico { get; set; }
    }
    public class TipoGraficosViewModel
    {
        public int Tipo { get; set; }
        public string Tooltip { get; set; }
    }

    public class EditarTableroViewModel
    {
        public EditarTableroViewModel()
        {
            this.Tipos = new List<ObjetoTipoViewModel>();
        }

        [Required]
        public int Id { get; set; }

        [Display(Name = "Nombre")]
        [Required(ErrorMessage = "Debe ingresar Nombre")]
        [MaxLength(50, ErrorMessage = "El campo Nombre soporta hasta 50 caracteres")]
        public string Nombre { get; set; }
        public List<ObjetoTipoViewModel> Tipos { get; set; }
    }

    public class TableroPermisoViewModel
    {
        public int tableroId { get; set; }
        public string tableroNombre { get; set; }
        public bool propio { get; set; }
        public bool permiteEscritura { get; set; }
        public string propietario { get; set; }
        public int? orden { get; set;}
    }

    public class DatosViewModel
    {
        public DatosViewModel()
        {
            this.Tabs = new ListTabViewModel();
        }
        public ListTabViewModel Tabs { get; set; }
    }

    public class ListTabViewModel
    {
        public ListTabViewModel()
        {
            this.Tabs = new List<TabViewModel>();
        }
        public List<TabViewModel> Tabs { get; set; }
        public int IdModulo { get; set; }
    }

    public class AmpliarObjetoViewModel
    {
        public AmpliarObjetoViewModel()
        {
            this.tipos = new List<ObjetoTipoVista>();
        }
        public int idObjeto { get; set; }
        [Required]
        public int tipoSeleccionado { get; set; }
        public string nombre { get; set; }
        public List<ObjetoTipoVista> tipos { get; set; }
    }
    public class ObjetoTipoVista
    {
        [Required]
        public int idobjeto { get; set; }
        [Required]
        public int idtipo { get; set; }
        public string descripcion { get; set; }
        public bool selected { get; set; }
    }
    public class ImagenesVM
    {
        public ImagenesVM()
        {
            this.imagenes = new List<ImagenVM>();
        }
        public List<ImagenVM> imagenes;
        public string marcaBase64;
    }


    public class ImagenVM
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
    }

    public class PuntoDeVentaVM
    {
        public int Id { get; set; }
        public string Nombre { get; set; }
    }
    
  
}