using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Web;
using System.Web.Mvc;

namespace Reporting.ViewModels
{
    public class ConfModuloReportingVM
    {
        public int ModuloId { get; set; }
        public string Leyenda { get; set; }
    }

    public class RolViewModel
    {
        public int Id { get; set; }
        [Display(ResourceType = typeof(Resources.Configuracion), Name = "confRolLabel")]
        [Required(ErrorMessageResourceType = typeof(Resources.Configuracion), ErrorMessageResourceName = "confRolNameRequiredError")]
        [MaxLength(50, ErrorMessageResourceType = typeof(Resources.Configuracion), ErrorMessageResourceName = "confRolNameMaxLengthError")]
        public string Name { get; set; }
        public bool Selected { get; set; }
    }

    public class UsuarioViewModel
    {
        public int Id { get; set; }
        public string NombreApellido { get; set; }
        public bool Selected { get; set; }
        public string ImgPerfil { get; set; }
    }

    #region Filtros
    public class ConfFiltroVM
    {
        public int Id { get; set; }
        public string Nombre { get; set; }
        [StringLength(50, ErrorMessageResourceType = typeof(Resources.Configuracion), ErrorMessageResourceName = "errFamiliaNombreAsignadoLength")]
        public string NombreAsignadoPorUsuario { get; set; }
        public bool Asignado { get; set; }
        public bool Visible { get; set; }
        public string MensajeExito { get; set; }
        public string MensajeError { get; set; }
    }
    #endregion

    #region Objetos
    public class ConfigurarObjetosVM
    {
        public ConfigurarObjetosVM()
        {
            Familias = new List<ConfObjetoFamilia>();
        }
        public List<ConfObjetoFamilia> Familias { get; set; }
    }

    public class ConfObjetoFamilia
    {
        public ConfObjetoFamilia()
        {
            Objetos = new List<ConfObjetoDeFamiliaVM>();
        }
        public int Id { get; set; }
        public string Nombre { get; set; }
        [StringLength(50, ErrorMessageResourceType = typeof(Resources.Configuracion), ErrorMessageResourceName = "errFamiliaNombreAsignadoLength")]
        public string NombreAsignadoPorUsuario { get; set; }
        public List<ConfObjetoDeFamiliaVM> Objetos { get; set; }
        public string Categoria { get; set; }
        public bool EsAdHoc { get; set; }
        public bool Asignado { get; set; }
        public string MensajeExito { get; set; }
        public string MensajeError { get; set; }
    }

    public class ConfObjetoDeFamiliaVM
    {
        public int Id { get; set; }
        public int TipoObjeto { get; set; }
        public string Tooltip { get; set; }
        public bool Selected { get; set; }
    }
    #endregion

    #region Marca Blanca
    public class MarcaBlancaViewModel
    {
        [Display(ResourceType = typeof(Resources.Configuracion), Name = "flgMarcaBlancaLabel")]
        public bool FlgMarcaBlanca { get; set; }

        [DataType(DataType.Upload)]
        [Display(ResourceType = typeof(Resources.Configuracion), Name = "imgMarcaBlancaLabel")]
        public HttpPostedFileBase Fondo { get; set; }

        [DataType(DataType.Upload)]
        [Display(ResourceType = typeof(Resources.Configuracion), Name = "logoMarcaBlancaLabel")]
        public HttpPostedFileBase Logo { get; set; }

        [DataType(DataType.Upload)]
        [Display(ResourceType = typeof(Resources.Configuracion), Name = "footerMarcaBlancaLabel")]
        public HttpPostedFileBase Footer { get; set; }

        [Display(ResourceType = typeof(Resources.Configuracion), Name = "linkMarcaBlancaLabel")]
        public string Link { get; set; }

        [Display(ResourceType = typeof(Resources.Configuracion), Name = "imgPreviewMarcaBlancaLabel")]
        public string ImgUrl { get; set; }
        public string ImgLogo { get; set; }
        public string ImgFooter { get; set; }

    }
    #endregion

    #region Usuarios
    public class ConfUsuarioVM
    {
        public ConfUsuarioVM()
        {
            this.RoleList = new List<SelectListItem>();
            this.Idiomas = new List<SelectListItem>();
        }
        public int Id { get; set; }

        [Required(ErrorMessageResourceType = typeof(Resources.Configuracion), ErrorMessageResourceName = "PerfilNombreRequiredError")]
        [StringLength(30, MinimumLength = 3, ErrorMessageResourceType = typeof(Resources.Configuracion), ErrorMessageResourceName = "PerfilNombreErrorLength")]
        [Display(ResourceType = typeof(Resources.Configuracion), Name = "lblPerfilNombre")]
        public string Nombre { get; set; }

        [Required(ErrorMessageResourceType = typeof(Resources.Configuracion), ErrorMessageResourceName = "PerfilApellidoRequiredError")]
        [StringLength(30, MinimumLength = 3, ErrorMessageResourceType = typeof(Resources.Configuracion), ErrorMessageResourceName = "PerfilApellidoErrorLength")]
        [Display(ResourceType = typeof(Resources.Configuracion), Name = "lblPerfilApellido")]
        public string Apellido { get; set; }

        [Required(ErrorMessageResourceType = typeof(Resources.Configuracion), ErrorMessageResourceName = "PerfilEmailRequiredError")]
        [StringLength(100, ErrorMessageResourceType = typeof(Resources.Configuracion), ErrorMessageResourceName = "PerfilEmailErrorLength")]
        [Display(ResourceType = typeof(Resources.Configuracion), Name = "lblPerfilEmail")]
        [DataType(DataType.EmailAddress)]
        public string Email { get; set; }

        [DataType(DataType.Upload)]
        public HttpPostedFileBase Imagen { get; set; }
        public string Imagenb64 { get; set; }
        public bool EsCheckPos { get; set; }
        public bool PermiteModificarCalendario { get; set; }
        public bool RegenerarUsuario { get; set; }

        [Display(ResourceType = typeof(Resources.Configuracion), Name = "lblPerfilTelefono")]
        public string Telefono { get; set; }

        [Display(ResourceType = typeof(Resources.Configuracion), Name = "lblPerfilRol")]
        public int RolId { get; set; }

        [Display(ResourceType = typeof(Resources.Configuracion), Name = "lblPerfilIdioma")]
        public string IdiomaId { get; set; }

        public bool TieneUsuarioReporting { get; set; }
        public List<SelectListItem> RoleList { get; set; }
        public List<SelectListItem> Idiomas { get; set; }


    }

    
    #endregion
    #region Roles
    public class ConfRolVM
    {
        public ConfRolVM()
        {
            this.Permisos = new List<ConfPermisoVM>();
        }
        public int Id { get; set; }
        public string Nombre { get; set; }
        public List<ConfPermisoVM> Permisos { get; set; }
    }

    public class ConfPermisoVM
    {
        public int Id { get; set; }
        public string Nombre { get; set; }
        public bool Seleccionado { get; set; }
    }
    #endregion
}
