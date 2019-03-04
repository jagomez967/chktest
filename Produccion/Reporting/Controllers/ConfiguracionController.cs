using System.Web;
using System.Linq;
using System.Web.Mvc;
using Microsoft.AspNet.Identity;
using Reporting.Domain.Abstract;
using System.Collections.Generic;
using Reporting.Domain.Entities;
using Reporting.Models;
using Microsoft.AspNet.Identity.Owin;
using System.IO;
using Reporting.ViewModels;
using System;


namespace Reporting.Controllers
{
    [Authorize(Roles = "Administrador,ClienteAdmin")]
    public class ConfiguracionController : BaseController
    {
        public ConfiguracionController(IUsuarioRepository usuarioRepository, IClienteRepository clienteRepository, ITableroRepository tableroRepository, IFiltroRepository filtroRepository)
        {
            this.usuarioRepository = usuarioRepository;
            this.clienteRepository = clienteRepository;
            this.tableroRepository = tableroRepository;
            this.filtroRepository = filtroRepository;
        }

        [OutputCache(Duration = 300, Location = System.Web.UI.OutputCacheLocation.Client, NoStore = true, VaryByParam = "clienteId")]

        public ActionResult Index()
        {
            int ClienteId = GetClienteSeleccionado();
            if (ClienteId == 0)
                return View("UsuarioSinClientes");

            return View();
        }

        #region Filtros
        public ActionResult Filtros()
        {
            int ClienteId = GetClienteSeleccionado();
            if (ClienteId == 0)
                return View("UsuarioSinClientes");

            List<ReportingModulos> modulos = tableroRepository.GetModulos(true);
            List<ConfModuloReportingVM> model = new List<ConfModuloReportingVM>();

            foreach (ReportingModulos m in modulos)
            {
                model.Add(new ConfModuloReportingVM() { ModuloId = m.Id, Leyenda = m.Nombre });
            }

            return View(model);
        }

        public PartialViewResult FiltrosFormEditarNombre(int filtroId)
        {
            int ClienteId = GetClienteSeleccionado();
            if (ClienteId == 0)
                return PartialView("_Filtros_FormEditarNombre", null);

            var filtro = tableroRepository.GetFiltros().FirstOrDefault(f => f.id == filtroId);

            ConfFiltroVM model = new ConfFiltroVM()
            {
                Id = filtro.id,
                Nombre = filtro.nombre,
                NombreAsignadoPorUsuario = (filtro.ReportingFiltroNombreCliente.Any(fn => fn.idCliente == ClienteId) ? filtro.ReportingFiltroNombreCliente.First(fn => fn.idCliente == ClienteId).Nombre : null),
                Visible = true
            };

            return PartialView("_Filtros_FormEditarNombre", model);
        }

        [HttpPost]
        public PartialViewResult FiltrosFormEditarNombre(ConfFiltroVM model)
        {
            int ClienteId = GetClienteSeleccionado();
            if (ClienteId == 0)
            {
                model.MensajeError = Resources.Configuracion.noTieneClienteSeleccionado;
                return PartialView("_Filtros_FormEditarNombre", model);
            }

            if (model.Id == 0)
                return null;

            if (ModelState.IsValid)
            {
                if (string.IsNullOrEmpty(model.NombreAsignadoPorUsuario))
                {
                    tableroRepository.ResetFiltroName(model.Id, ClienteId);
                    model.NombreAsignadoPorUsuario = Resources.Configuracion.utilizaNombrePorDefecto;
                }
                else
                {
                    tableroRepository.SetFiltroName(model.Id, ClienteId, model.NombreAsignadoPorUsuario);
                }

                model.MensajeExito = Resources.Configuracion.cambioRealizadoConExito;
                return PartialView("_Filtros_FormEditarNombre", model);
            }
            else
            {
                model.MensajeError = Resources.Configuracion.errInesperadoModificacion;
                return PartialView("_Filtros_FormEditarNombre", model);
            }
        }

        [HttpPost]
        public JsonResult FiltrosToggleFiltroActivo(int moduloid, int filtroid, bool activo)
        {
            int ClienteId = GetClienteSeleccionado();
            if (ClienteId == 0)
                return Json(false, JsonRequestBehavior.AllowGet);

            bool res = tableroRepository.SetFiltroActivo(filtroid, ClienteId, moduloid, activo);

            return Json(res, JsonRequestBehavior.AllowGet);
        }

        [HttpPost]
        public PartialViewResult FiltrosGetTablaFiltrosPorModulo(int moduloid)
        {
            int ClienteId = GetClienteSeleccionado();
            if (ClienteId == 0)
                return PartialView("_Filtros_TablaFiltros", null);

            List<ReportingFiltros> filtros = tableroRepository.GetFiltrosDeCliente(ClienteId);

            List<ConfFiltroVM> model = new List<ConfFiltroVM>();

            foreach (var f in filtros)
            {
                model.Add(new ConfFiltroVM()
                {
                    Id = f.id,
                    Visible = f.ReportingFiltrosModulo.Any(ff => ff.idCliente == ClienteId && ff.idModulo == moduloid),
                    Nombre = f.nombre,
                    NombreAsignadoPorUsuario = (f.ReportingFiltroNombreCliente.Any(fn => fn.idCliente == ClienteId) ? f.ReportingFiltroNombreCliente.First(fn => fn.idCliente == ClienteId).Nombre : "(Utiliza Nombre por Defecto)")
                });
            }

            return PartialView("_Filtros_TablaFiltros", model);
        }
        #endregion

        #region Objetos
        public ActionResult Objetos()
        {
            int ClienteId = GetClienteSeleccionado();
            if (ClienteId == 0)
                return View("UsuarioSinClientes");

            int userId = GetUsuarioLogueado();
            userId = usuarioRepository.GetUsuarioPerformance(userId);

            List<ReportingFamiliaObjeto> flias = tableroRepository.GetFamiliasObjetoDeCliente(ClienteId);

            ConfigurarObjetosVM model = new ConfigurarObjetosVM();

            foreach (var f in flias)
            {
                model.Familias.Add(new ConfObjetoFamilia()
                {
                    Id = f.Id,
                    Nombre = tableroRepository.GetNombreObjeto(f.Id,userId),
                    Categoria = f.ReportingObjetoCategoria.Nombre,
                    NombreAsignadoPorUsuario = (f.ReportingFamiliaNombreCliente.Any(fnc => fnc.idFamilia == f.Id && fnc.idCliente == ClienteId)) ? f.ReportingFamiliaNombreCliente.First(fnc => fnc.idFamilia == f.Id && fnc.idCliente == ClienteId).Nombre : "(Utiliza Nombre por Defecto)",
                    Objetos = f.ReportingObjeto.Select(o => new ConfObjetoDeFamiliaVM
                    {
                        Id = o.Id,
                        Selected = o.ReportingClienteObjeto.Any(co => co.IdCliente == ClienteId && co.IdObjeto == o.Id),
                        Tooltip = o.TipoChart.ToString(),
                        TipoObjeto = (int)o.TipoChart
                    }).ToList()
                });
            }

            return View(model);
        }

        public PartialViewResult ObjetosFormEditarNombre(int familiaid)
        {
            int ClienteId = GetClienteSeleccionado();
            if (ClienteId == 0)
                return PartialView("_Objetos_FormEditarNombre", null);

            var familia = tableroRepository.GetFamiliasObjetoDeCliente(ClienteId).FirstOrDefault(f => f.Id == familiaid);

            if (familia != null)
            {
                ConfObjetoFamilia model = new ConfObjetoFamilia()
                {
                    Id = familia.Id,
                    Nombre = familia.Nombre,
                    NombreAsignadoPorUsuario = (familia.ReportingFamiliaNombreCliente.Any(fo => fo.idCliente == ClienteId && fo.idFamilia == familia.Id)) ? familia.ReportingFamiliaNombreCliente.First(fo => fo.idCliente == ClienteId && fo.idFamilia == familia.Id).Nombre : string.Empty
                };

                return PartialView("_Objetos_FormEditarNombre", model);
            }
            else
            {
                return null;
            }
        }

        [HttpPost]
        public PartialViewResult ObjetosFormEditarNombre(ConfObjetoFamilia model)
        {
            int ClienteId = GetClienteSeleccionado();
            if (ClienteId == 0)
            {
                model.MensajeError = Resources.Configuracion.noTieneClienteSeleccionado;
                return PartialView("_Objetos_FormEditarNombre", model);
            }

            if (model.Id == 0)
            {
                return null;
            }

            if (ModelState.IsValid)
            {
                if (string.IsNullOrEmpty(model.NombreAsignadoPorUsuario))
                {
                    tableroRepository.ResetObjectName(model.Id, ClienteId);
                    model.NombreAsignadoPorUsuario = Resources.Configuracion.utilizaNombrePorDefecto;
                }
                else
                {
                    tableroRepository.SetObjectName(model.Id, ClienteId, model.NombreAsignadoPorUsuario);
                }

                model.MensajeExito = Resources.Configuracion.cambioRealizadoConExito;

                return PartialView("_Objetos_FormEditarNombre", model);
            }
            else
            {
                model.MensajeError = Resources.Configuracion.errInesperadoModificacion;
                return PartialView("_Objetos_FormEditarNombre", model);
            }
        }

        [HttpPost]
        public JsonResult ObjetosToggleObjetoActivo(int familiaid, int objetoid, bool activo)
        {
            int ClienteId = GetClienteSeleccionado();
            if (ClienteId == 0)
                return Json(false, JsonRequestBehavior.AllowGet);

            bool res = tableroRepository.SetObjetoSeleccionado(ClienteId, objetoid, activo);

            return Json(res, JsonRequestBehavior.AllowGet);
        }
        #endregion

        #region Marca Blanca
        public ActionResult MarcaBlanca()
        {
            int clienteId = GetClienteSeleccionado();
            if (clienteId == 0)
                return View("UsuarioSinClientes");

            Cliente cliente = clienteRepository.GetCliente(clienteId);
            MarcaBlancaViewModel model = new MarcaBlancaViewModel
            {
                FlgMarcaBlanca = cliente.flgMarcaBlanca,
                Link = cliente.link
            };

            Dictionary<string,string> paths = new Dictionary<string, string>();

            if (cliente.hashCliente != null && cliente.hashCliente != "")
            {
                paths.Add("fondo",Path.Combine(Server.MapPath(string.Format("~/ContentClientes/{0}/MarcaBlanca/", cliente.hashCliente)), "fondo.jpg"));
                paths.Add("logo", Path.Combine(Server.MapPath(string.Format("~/ContentClientes/{0}/MarcaBlanca/", cliente.hashCliente)), "logo.jpg"));
                paths.Add("footer",Path.Combine(Server.MapPath(string.Format("~/ContentClientes/{0}/MarcaBlanca/", cliente.hashCliente)), "footer.jpg"));
            }
            else
            {
                paths.Add("fondo",Path.Combine(Server.MapPath(string.Format("~/ContentClientes/{0}/MarcaBlanca/", cliente.IdCliente.ToString().Trim())), "fondo.jpg"));
                paths.Add("logo", Path.Combine(Server.MapPath(string.Format("~/ContentClientes/{0}/MarcaBlanca/", cliente.IdCliente.ToString().Trim())), "logo.jpg"));
                paths.Add("footer", Path.Combine(Server.MapPath(string.Format("~/ContentClientes/{0}/MarcaBlanca/", cliente.IdCliente.ToString().Trim())), "logo.jpg"));
            }

            if (!System.IO.File.Exists(paths["fondo"]))
            {
                model.ImgUrl = null;
            }
            else 
            {
                model.ImgUrl = paths["fondo"];
            }

            if (!System.IO.File.Exists(paths["logo"]))
            {
                model.ImgLogo = null;
            }
            else
            {
                model.ImgLogo = paths["logo"];
            }
            

            if (!System.IO.File.Exists(paths["footer"]))
            {
                model.ImgFooter = null;
            }
            else
            {
                model.ImgFooter = paths["footer"];
            }
            return View(model);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult MarcaBlanca(MarcaBlancaViewModel model)
        {
            var validImageTypes = new string[]
            {
                "image/gif",
                "image/jpeg",
                "image/jpg",
                "image/pjpeg",
                "image/png",
                "image/bmp"
            };

            if (model.Fondo != null && !validImageTypes.Contains(model.Fondo.ContentType))
            {
                ModelState.AddModelError("Err_Fondo_FileType", Resources.Configuracion.errorTipoImagenMarcaBlanca);
            }

            if (model.Fondo != null && model.Fondo.InputStream.Length > 512000)
            {
                ModelState.AddModelError("Err_Fondo_FileSize", Resources.Configuracion.errorSizeImagenMarcaBlanca);
            }

            if (model.Logo != null && !validImageTypes.Contains(model.Logo.ContentType))
            {
                ModelState.AddModelError("Err_Logo_FileType", Resources.Configuracion.errorTipoImagenMarcaBlanca);
            }

            if (model.Logo != null && model.Logo.InputStream.Length > 512000)
            {
                ModelState.AddModelError("Err_Logo_FileSize", Resources.Configuracion.errorSizeImagenMarcaBlanca);
            }

            if (model.Footer != null && !validImageTypes.Contains(model.Footer.ContentType))
            {
                ModelState.AddModelError("Err_Footer_FileType", Resources.Configuracion.errorTipoImagenMarcaBlanca);
            }

            if (model.Footer != null && model.Footer.InputStream.Length > 512000)
            {
                ModelState.AddModelError("Err_Footer_FileSize", Resources.Configuracion.errorSizeImagenMarcaBlanca);
            }

            if (!ModelState.IsValid)
            {
                return View(model);
            }

            int clienteId = GetClienteSeleccionado();
            if (clienteId == 0)
                return View("UsuarioSinClientes");

            Cliente cliente = clienteRepository.GetCliente(clienteId);

            string folderCliente = cliente.hashCliente;

            if (!(folderCliente != null && folderCliente != ""))
            {
                folderCliente = cliente.IdCliente.ToString().Trim();
            }            

                if (!Directory.Exists(Server.MapPath(string.Format("~/ContentClientes/{0}", folderCliente))))
            {
                Directory.CreateDirectory(Server.MapPath(string.Format("~/ContentClientes/{0}", folderCliente)));
                Directory.CreateDirectory(Server.MapPath(string.Format("~/ContentClientes/{0}/MarcaBlanca", folderCliente)));
            }

            if (!Directory.Exists(Server.MapPath(string.Format("~/ContentClientes/{0}/MarcaBlanca", folderCliente))))
            {
                Directory.CreateDirectory(Server.MapPath(string.Format("~/ContentClientes/{0}/MarcaBlanca", folderCliente)));
            }

            if (ModelState.IsValid)
            {
                if (model.Fondo != null)
                {
                    if (model.Fondo != null && model.Fondo.ContentLength > 0)
                    {
                        var uploadDir = string.Format("~/ContentClientes/{0}/MarcaBlanca", folderCliente);
                        var imagePath = Path.Combine(Server.MapPath(uploadDir), "fondo.jpg");

                        model.Fondo.SaveAs(imagePath);
                    }
                }

                if (model.Logo != null)
                {
                    if (model.Logo != null && model.Logo.ContentLength > 0)
                    {
                        var uploadDir = string.Format("~/ContentClientes/{0}/MarcaBlanca", folderCliente);
                        var logoPath = Path.Combine(Server.MapPath(uploadDir), "logo.jpg");

                        model.Logo.SaveAs(logoPath);
                    }
                }

                if (model.Footer != null)
                {
                    if (model.Footer != null && model.Footer.ContentLength > 0)
                    {
                        var uploadDir = string.Format("~/ContentClientes/{0}/MarcaBlanca", folderCliente);
                        var footerPath = Path.Combine(Server.MapPath(uploadDir), "footer.jpg");

                        model.Footer.SaveAs(footerPath);
                    }
                }

                if (model.Fondo == null && model.ImgUrl == null)
                {
                    System.IO.File.Delete(Path.Combine(Server.MapPath(string.Format("~/ContentClientes/{0}/MarcaBlanca", folderCliente)), "fondo.jpg"));
                }
                if (model.Logo == null && model.ImgLogo == null)
                {
                    System.IO.File.Delete(Path.Combine(Server.MapPath(string.Format("~/ContentClientes/{0}/MarcaBlanca", folderCliente)), "logo.jpg"));
                }
                if (model.Footer == null && model.ImgFooter == null)
                {
                    System.IO.File.Delete(Path.Combine(Server.MapPath(string.Format("~/ContentClientes/{0}/MarcaBlanca", folderCliente)), "footer.jpg"));
                }

                clienteRepository.SaveMarcaBlanca(clienteId, model.FlgMarcaBlanca, model.Link);
                ViewBag.successMessage = Resources.Configuracion.successMarcaBlanca;
            }

            string path = Path.Combine(Server.MapPath(string.Format("~/ContentClientes/{0}/MarcaBlanca/", folderCliente)), "fondo.jpg");
            if (!System.IO.File.Exists(path))
            {
                model.ImgUrl = null;
            }
            else
            {
                model.ImgUrl = string.Format("ContentClientes/{0}/MarcaBlanca/fondo.jpg", folderCliente);
            }

            string pathLogo = Path.Combine(Server.MapPath(string.Format("~/ContentClientes/{0}/MarcaBlanca/", folderCliente)), "logo.jpg");
            if (!System.IO.File.Exists(pathLogo))
            {
                model.ImgLogo = null;
            }
            else
            {
                model.ImgLogo = string.Format("ContentClientes/{0}/MarcaBlanca/logo.jpg", folderCliente);
            }

            string pathFooter = Path.Combine(Server.MapPath(string.Format("~/ContentClientes/{0}/MarcaBlanca/", folderCliente)), "footer.jpg");
            if (!System.IO.File.Exists(pathFooter))
            {
                model.ImgFooter = null;
            }
            else
            {
                model.ImgFooter = string.Format("ContentClientes/{0}/MarcaBlanca/footer.jpg", folderCliente);
            }
            
            return View(model);
        }
        #endregion

        #region Usuarios
        public ActionResult Usuarios()
        {
            int ClienteId = GetClienteSeleccionado();
            int UserId = GetUsuarioLogueado();
            UserId = usuarioRepository.GetUsuarioPerformance(UserId);

            Usuario usuario = usuarioRepository.GetUsuarioById(UserId);

            List<Usuario> usuarios = usuarioRepository.GetUsuariosByCliente(ClienteId, true);

            List<ConfUsuarioVM> model = new List<ConfUsuarioVM>();

            foreach (var u in usuarios)
            {
                model.Add(new ConfUsuarioVM()
                {
                    Apellido = u.Apellido,
                    Nombre = u.Nombre,
                    Email = u.Email,
                    EsCheckPos = u.esCheckPos,
                    Id = u.IdUsuario,
                    Imagenb64 = u.imagen,
                    Telefono = u.Telefono,
                    TieneUsuarioReporting = u.ReportingAspNetUsuario.Any()
                });
            }

            return View(model);
        }

        public ActionResult EditarUsuario(int? Id)
        {
            if (Id == null)
            {
                return View("UsuarioNoEncontrado");
            }

            int ClienteId = GetClienteSeleccionado();

            Usuario usuario = usuarioRepository.GetUsuarioInClientById((int)Id, ClienteId);
            List<ReportingRoles> roles = usuarioRepository.GetRolesDeCliente(ClienteId);

            if (usuario != null)
            {
                ConfUsuarioVM model = new ConfUsuarioVM()
                {
                    Apellido = usuario.Apellido,
                    Nombre = usuario.Nombre,
                    Email = usuario.Email,
                    Id = usuario.IdUsuario,
                    Telefono = usuario.Telefono,
                    EsCheckPos = usuario.esCheckPos,
                    Imagenb64 = usuario.imagen,
                    PermiteModificarCalendario = usuario.PermiteModificarCalendario
                };

                var usucliente = usuario.Usuario_Cliente.FirstOrDefault(uc => uc.IdCliente == ClienteId);

                if (usucliente != null && usucliente.Rol != null)
                {
                    model.RolId = usucliente.Rol.id;
                }

                model.RoleList.Add(new SelectListItem()
                {
                    Text = Resources.Configuracion.seleccionUnRol,
                    Value = "0"
                });

                foreach (var r in roles)
                {
                    model.RoleList.Add(new SelectListItem()
                    {
                        Text = r.nombre,
                        Value = r.id.ToString()
                    });
                }

                return View(model);
            }
            else
            {
                return View("UsuarioNoEncontrado");
            }
        }


        public ActionResult GetRegenerateUser(int idUsuario)
        {
            ViewModelPasswordUser model = new ViewModelPasswordUser
            {
                UserId = idUsuario
            };

            return PartialView("_UserRegeneratePassword", model);
        }

        public JsonResult RegenerarUsuario(int UserId,string Password)
        {
            if (!usuarioRepository.RegenerarUsuario(UserId))
            {
                return Json("No se pudo regenerar el usuario en reporting", JsonRequestBehavior.AllowGet);
            }

            Usuario usu = usuarioRepository.GetUsuarioById(UserId);

            if (usu == null || string.IsNullOrEmpty(usu.Email))
            {                
                return Json("No se pudo obtener usuario de reporting por Id " + UserId.ToString(), JsonRequestBehavior.AllowGet);
            }

            var userManager = HttpContext.GetOwinContext().GetUserManager<ApplicationUserManager>();
            
            var newUser = userManager.Create(new ApplicationUser()
            {
                FirstName = usu.Nombre,
                LastName = usu.Apellido,
                UserName = usu.Email,
                Email = usu.Email,
                EmailConfirmed = true,
                PhoneNumberConfirmed = false,
                TwoFactorEnabled = false,
                LockoutEnabled = false,
                AccessFailedCount = 0
            }, Password);

            if (!newUser.Succeeded)
            {
                return Json("No se pudo regenerar el usuario", JsonRequestBehavior.AllowGet);
            }

            var usuarioReporting = userManager.FindByEmail(usu.Email);

            if (!usuarioRepository.AsignarUsuarioPerfConUsuReporting(UserId, usuarioReporting.Id))
            {
                return Json("No se pudo asignar perfil de reporting al usuario", JsonRequestBehavior.AllowGet);
            }
            return Json("OK", JsonRequestBehavior.AllowGet);
        }



        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult EditarUsuario(ConfUsuarioVM model)
        {
            try
            {
                var validImageTypes = new string[]
                {
                    "image/gif",
                    "image/jpeg",
                    "image/jpg",
                    "image/pjpeg",
                    "image/png",
                    "image/bmp"
                };


                if (model.Imagen != null && !validImageTypes.Contains(model.Imagen.ContentType))
                {
                    ModelState.AddModelError("Err_Imagen_FileType", Resources.Configuracion.errFormatoImagen);
                }

                if (model.Imagen != null && model.Imagen.InputStream.Length > 512000)
                {
                    ModelState.AddModelError("Err_Imagen_FileSize", Resources.Configuracion.errImagenSize);
                }

                int ClienteId = GetClienteSeleccionado();
                List<ReportingRoles> roles = usuarioRepository.GetRolesDeCliente(ClienteId);
                model.RoleList.Add(new SelectListItem()
                {
                    Text = Resources.Configuracion.seleccionUnRol,
                    Value = "0"
                });
                foreach (var r in roles)
                {
                    model.RoleList.Add(new SelectListItem()
                    {
                        Text = r.nombre,
                        Value = r.id.ToString()
                    });
                }
               

                if (ModelState.IsValid)
                {
                    Usuario usuario = usuarioRepository.GetUsuarioById(model.Id);

                    usuario.Nombre = model.Nombre;
                    usuario.Apellido = model.Apellido;
                    usuario.Telefono = model.Telefono;
                    usuario.esCheckPos = model.EsCheckPos;
                    usuario.PermiteModificarCalendario = model.PermiteModificarCalendario;

                    if (model.Imagen != null)
                    {
                        byte[] binaryData = new byte[model.Imagen.InputStream.Length];
                        long bytesRead = model.Imagen.InputStream.Read(binaryData, 0, (int)model.Imagen.InputStream.Length);
                        model.Imagen.InputStream.Close();
                        string b64 = Convert.ToBase64String(binaryData, 0, binaryData.Length);

                        if (!string.IsNullOrEmpty(b64))
                        {
                            usuario.imagen = b64;
                            model.Imagenb64 = b64;
                        }
                    }

                    if (usuarioRepository.EdicionUsuarioPerfil(ClienteId, usuario, model.RolId))
                    {
                        ViewBag.Success = true;
                        return View(model);
                    }
                    else
                    {
                        ViewBag.Error = true;
                        ViewBag.ErrorMessage = Resources.Configuracion.reviseSiDatosSonCorrectos;
                        return View(model);
                    }


                }
                else
                {
                    ViewBag.Error = true;
                    ViewBag.ErrorMessage = Resources.Configuracion.reviseSiDatosSonCorrectos;
                    return View(model);
                }
            }
            catch
            {
                return View("Error");
            }
        }
        #endregion

        #region Roles
        public ActionResult Roles()
        {
            int ClienteId = GetClienteSeleccionado();
            int UserId = GetUsuarioLogueado();
            UserId = usuarioRepository.GetUsuarioPerformance(UserId);

            List<ReportingRoles> roles = usuarioRepository.GetRolesDeCliente(ClienteId);
            List<ConfRolVM> model = new List<ConfRolVM>();

            foreach (var rol in roles)
            {
                model.Add(new ConfRolVM()
                {
                    Id = rol.id,
                    Nombre = rol.nombre
                });
            }

            return View(model);
        }

        public ActionResult EditarRol(int? Id)
        {
            if (Id == null)
            {
                return View("RolNoEncontrado");
            }

            int ClienteId = GetClienteSeleccionado();

            ReportingRoles rol = usuarioRepository.GetRolById((int)Id, ClienteId);

            if (rol == null)
            {
                return View("RolNoEncontrado");
            }

            ConfRolVM model = new ConfRolVM()
            {
                Id = rol.id,
                Nombre = rol.nombre
            };

            List<ReportingPermisos> permisos = usuarioRepository.GetPermisos();
            model.Permisos = permisos.Select(p => new ConfPermisoVM { Id = p.id, Nombre = p.permiso, Seleccionado = false }).ToList();

            foreach (var per in rol.ReportingRolPermisos)
            {
                if (model.Permisos.Any(p => p.Id == per.idPermiso))
                {
                    model.Permisos.First(p => p.Id == per.idPermiso).Seleccionado = true;
                }
            }

            return View(model);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult EditarRol(ConfRolVM model)
        {
            try
            {
                int ClienteId = GetClienteSeleccionado();

                if (ModelState.IsValid)
                {

                    ReportingRoles rol = usuarioRepository.GetRolById(model.Id, ClienteId);

                    if (rol == null)
                    {
                        return View("RolNoEncontrado");
                    }

                    rol.nombre = model.Nombre;

                    List<int> permisos = model.Permisos.Where(p => p.Seleccionado).Select(p => p.Id).ToList();

                    if (usuarioRepository.EditarRol(ClienteId, rol, permisos))
                    {
                        ViewBag.Success = true;
                        return View(model);
                    }

                    ViewBag.Error = true;
                    ViewBag.ErrorMessage = Resources.Configuracion.reviseSiDatosSonCorrectos;
                    return View(model);
                }
                else
                {
                    ViewBag.Error = true;
                    ViewBag.ErrorMessage = Resources.Configuracion.reviseSiDatosSonCorrectos;
                    return View(model);
                }
            }
            catch
            {
                return View("Error");
            }
        }

        public ActionResult CrearRol()
        {
            ConfRolVM model = new ConfRolVM();
            List<ReportingPermisos> permisos = usuarioRepository.GetPermisos();
            foreach (var p in permisos)
            {
                model.Permisos.Add(new ConfPermisoVM()
                {
                    Id = p.id,
                    Nombre = p.permiso
                });
            }

            return View(model);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult CrearRol(ConfRolVM model)
        {
            try
            {
                int ClienteId = GetClienteSeleccionado();

                if (ModelState.IsValid)
                {
                    List<int> permisos = model.Permisos.Where(p => p.Seleccionado).Select(p => p.Id).ToList();

                    if (usuarioRepository.CrearRol(ClienteId, model.Nombre, permisos))
                    {
                        return RedirectToAction("Roles");
                    }

                    ViewBag.Error = true;
                    ViewBag.ErrorMessage = Resources.Configuracion.reviseSiDatosSonCorrectos;
                    return View(model);
                }
                else
                {
                    ViewBag.Error = true;
                    ViewBag.ErrorMessage = Resources.Configuracion.reviseSiDatosSonCorrectos;
                    return View(model);
                }
            }
            catch
            {
                return View("Error");
            }
        }
        #endregion

        #region Administracion
        [Authorize(Roles = "Administrador")]
        public ActionResult AdministrarObjetos()
        {
            int ClienteId = GetClienteSeleccionado();
            if (ClienteId == 0)
                return View("UsuarioSinClientes"); 

            int userId = GetUsuarioLogueado();
            userId = usuarioRepository.GetUsuarioPerformance(userId);

            List<ReportingFamiliaObjeto> flias = tableroRepository.GetAllFamilias();

            ConfigurarObjetosVM model = new ConfigurarObjetosVM();

            foreach (var f in flias)
            {
                model.Familias.Add(new ConfObjetoFamilia()
                {
                    Id = f.Id,
                    Asignado = f.ReportingFamiliaObjetoCliente.Any(rf => rf.IdCliente == ClienteId && rf.IdFamilia == f.Id),
                    Nombre = tableroRepository.GetNombreObjeto(f.Id,userId),
                    Categoria = f.ReportingObjetoCategoria.Nombre,
                    EsAdHoc = f.EsAdHoc,
                    NombreAsignadoPorUsuario = (f.ReportingFamiliaNombreCliente.Any(fnc => fnc.idFamilia == f.Id && fnc.idCliente == ClienteId)) ? f.ReportingFamiliaNombreCliente.First(fnc => fnc.idFamilia == f.Id && fnc.idCliente == ClienteId).Nombre : string.Empty
                });
            }
            return View(model);
        }

        [HttpPost]
        public JsonResult AdmFliaObjCliente(int familiaid, bool activo)
        {
            int ClienteId = GetClienteSeleccionado();
            if (ClienteId == 0)
                return Json(false, JsonRequestBehavior.AllowGet);

            bool res = false;

            if (activo)
            {
                res = tableroRepository.AsignarFamiliaACliente(ClienteId, familiaid);
            }
            else
            {
                res = tableroRepository.QuitarFamiliaDeCliente(ClienteId, familiaid);
            }

            return Json(res, JsonRequestBehavior.AllowGet);
        }

        [Authorize(Roles = "Administrador")]
        public ActionResult AdministrarFiltros()
        {
            int ClienteId = GetClienteSeleccionado();
            if (ClienteId == 0)
                return View("UsuarioSinClientes");

            List<ReportingFiltros> filtros = tableroRepository.GetFiltros();

            List<ConfFiltroVM> model = filtros.Select(f => new ConfFiltroVM()
            {
                Id = f.id,
                Asignado = f.ReportingFiltrosCliente.Any(fc => fc.IdCliente == ClienteId),
                Nombre = f.nombre,
                NombreAsignadoPorUsuario = (f.ReportingFiltroNombreCliente.Any(fn => fn.idCliente == ClienteId) ? f.ReportingFiltroNombreCliente.First(fn => fn.idCliente == ClienteId).Nombre : string.Empty)
            }).ToList();

            return View(model);
        }

        [HttpPost]
        [Authorize(Roles = "Administrador")]
        public JsonResult AdmFiltroCliente(int filtroid, bool activo)
        {
            int ClienteId = GetClienteSeleccionado();
            if (ClienteId == 0)
                return Json(false, JsonRequestBehavior.AllowGet);

            bool res = false;

            if (activo)
            {
                res = tableroRepository.ActivarFiltroParaCliente(filtroid, ClienteId);
            }
            else
            {
                res = tableroRepository.DesactivarFiltroParaCliente(filtroid, ClienteId);
            }

            return Json(res, JsonRequestBehavior.AllowGet);
        }

        [HttpPost]
        [Authorize(Roles = "Administrador")]
        public JsonResult ActivarUsuarioReporting(int IdUsuario)
        {
            try
            {
                int ClienteId = GetClienteSeleccionado();
                if (ClienteId == 0)
                {
                    return Json("404 Cliente", JsonRequestBehavior.AllowGet);
                }

                if (!usuarioRepository.IsUsuarioInCliente(ClienteId, IdUsuario))
                {
                    return Json(Resources.Configuracion.usuarioNoEncontrado, JsonRequestBehavior.AllowGet);
                }

                Usuario usu = usuarioRepository.GetUsuarioById(IdUsuario);

                if (usu == null || string.IsNullOrEmpty(usu.Email))
                {
                    return Json(Resources.Configuracion.usuarioDebeTenerMailValido, JsonRequestBehavior.AllowGet);
                }

                var userManager = HttpContext.GetOwinContext().GetUserManager<ApplicationUserManager>();
                var usuarioReporting = userManager.FindByEmail(usu.Email);

                if (usuarioReporting == null)
                {
                    var newUser = userManager.Create(new ApplicationUser()
                    {
                        FirstName = usu.Nombre,
                        LastName = usu.Apellido,
                        UserName = usu.Email,
                        Email = usu.Email,
                        EmailConfirmed = true,
                        PhoneNumberConfirmed = false,
                        TwoFactorEnabled = false,
                        LockoutEnabled = false,
                        AccessFailedCount = 0
                    }, "secreto");

                    if (!newUser.Succeeded)
                    {
                        return Json(Resources.Configuracion.errIntentarCrearUsuario, JsonRequestBehavior.AllowGet);
                    }

                    usuarioReporting = userManager.FindByEmail(usu.Email);
                }

                if (!usuarioRepository.AsignarUsuarioPerfConUsuReporting(IdUsuario, usuarioReporting.Id))
                {
                    return Json(Resources.Configuracion.errAsignarUsuarioPerformanceReporting, JsonRequestBehavior.AllowGet);
                }

                return Json(string.Empty, JsonRequestBehavior.AllowGet);
            }
            catch
            {
                return Json(false, JsonRequestBehavior.AllowGet);
            }

        }
        #endregion
    }
}
