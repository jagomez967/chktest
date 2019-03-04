using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.Mvc;
using Reporting.ViewModels;
using Reporting.Domain.Abstract;
using Reporting.Domain.Entities;
using Microsoft.AspNet.Identity;
using System.Web;
using System.IO;
using Microsoft.AspNet.Identity.Owin;
using System.Text;
using System.Web.Script.Serialization;
using Reporting.Filters;
using System.Drawing;
using System.Threading;
using System.Globalization;
using System.Data.SqlClient;

namespace Reporting.Controllers
{
    public class TablerosController : BaseController
    {
        private readonly int IdModulo;
        public TablerosController(ITableroRepository tableroRepository, IUsuarioRepository usuarioRepository, IClienteRepository clienteRepository, IFiltroRepository filtroRepository, ICommonRepository commonRepository)
        {
            this.IdModulo = 1;
            this.tableroRepository = tableroRepository;
            this.usuarioRepository = usuarioRepository;
            this.clienteRepository = clienteRepository;
            this.filtroRepository = filtroRepository;
            this.commonRepository = commonRepository;
        }

        [Autorizar(Permiso = "administrarTablero")]
        public ActionResult Administrar()
        {
            int userId = GetUsuarioLogueado();
            userId = usuarioRepository.GetUsuarioPerformance(userId);

            int ClienteId = GetClienteSeleccionado();
            if (ClienteId == 0)
                return View("UsuarioSinClientes");

            List<TableroPermiso> permisos = tableroRepository.GetPermisosDeTablero(ClienteId, userId);

            List<TableroPermisoViewModel> model = new List<TableroPermisoViewModel>();

            foreach (TableroPermiso t in permisos)
            {
                model.Add(new TableroPermisoViewModel() { tableroId = t.tableroId, propio = t.propio, permiteEscritura = t.permiteEscritura, tableroNombre = t.tableroNombre,propietario = t.propietario ,orden = t.orden});                
            }
            model = model.OrderBy(t => t.orden).ToList();

            if (model.Count == 0)
                return View("NoTieneTableros");

            return View(model);
        }

        private string GetTooltipTipoGrafico(TipoChart tipo)
        {
            string tooltip = "";
            switch (tipo)
            {
                case TipoChart.Column:
                    tooltip = Resources.Graficos.lblTipoColumna;
                    break;
                case TipoChart.Area:
                    tooltip = Resources.Graficos.lblTipoArea;
                    break;
                case TipoChart.ColumnDrillDown:
                    tooltip = Resources.Graficos.lblTipoColDrilldown;
                    break;
                case TipoChart.LineChart:
                    tooltip = Resources.Graficos.lblTipoLinea;
                    break;
                case TipoChart.Pie:
                    tooltip = Resources.Graficos.lblTipoPie;
                    break;
                case TipoChart.PieLineCol:
                    tooltip = Resources.Graficos.lblTipoTendencia;
                    break;
                case TipoChart.StackedColumn:
                    tooltip = Resources.Graficos.lblTipoColApiladas;
                    break;
                case TipoChart.StackedColumnDrillDown:
                    tooltip = Resources.Graficos.lblTipoDrilldownApiladas;
                    break;
                case TipoChart.StackedPercentColumnDrillDown:
                    tooltip = Resources.Graficos.lblTipoDrilldownApiladasPorc;
                    break;
                case TipoChart.Tabla:
                    tooltip = Resources.Graficos.lblTipoTabla;
                    break;
                case TipoChart.MetEncuestas:
                    tooltip = Resources.Graficos.lblTipoEncuesta;
                    break;
                case TipoChart.SpiderWebChart:
                    tooltip = Resources.Graficos.lblTipoSpiderWeb;
                    break;
                case TipoChart.PieSemiCircle:
                    tooltip = Resources.Graficos.lblTipoDoughnut;
                    break;
                case TipoChart.SimpleKPI:
                    tooltip = Resources.Graficos.lblSimpleKpi;
                    break;
                case TipoChart.Measure:
                    tooltip = Resources.Graficos.lblMesaure;
                    break;
            }
            return tooltip;
        }

        [Autorizar(Permiso = "crearTablero")]
        public ActionResult Crear()
        {
            int clienteId = GetClienteSeleccionado();
            if (clienteId == 0)
                return View("UsuarioSinClientes");

            int userId = GetUsuarioLogueado();
            userId = usuarioRepository.GetUsuarioPerformance(userId);

            List<ReportingObjeto> objetos = tableroRepository.GetObjetosDeCliente(clienteId);
            List<ReportingObjetoCategoria> categorias = objetos.Select(o => o.ReportingFamiliaObjeto.ReportingObjetoCategoria).Distinct().ToList();
            List<ReportingFamiliaObjeto> familias = objetos.Select(o => o.ReportingFamiliaObjeto).Distinct().ToList();

            if (categorias.Count == 0)
                return View("_NoPoseeObjetos");

            CrearTableroViewModel model = new CrearTableroViewModel();

            foreach (var cat in categorias)
            {
                model.Categorias.Add(new CategoriaObjetoViewModel() { Id = cat.Id, Nombre = cat.Nombre });

                foreach (var f in familias.Where(flia => flia.IdCategoria == cat.Id && objetos.Any(o => o.IdFamiliaObjeto == flia.Id)))
                {
                    var objtipo = new ObjetoTipoViewModel
                    {
                        Id = f.Id
                    };


                    var familiacliente = f.ReportingFamiliaNombreCliente.FirstOrDefault(o => o.idCliente == clienteId && o.idFamilia == f.Id);

                    if (familiacliente != null)
                    {
                        objtipo.Nombre = familiacliente.Nombre;
                    }
                    else
                    {
                        objtipo.Nombre =  tableroRepository.GetNombreObjeto(f.Id,userId);
                    }

                    if (string.IsNullOrEmpty(objtipo.Nombre))
                    {
                        objtipo.Nombre = f.Nombre;
                    }

                    objtipo.Size = "S";
                    objtipo.IdFamilia = f.Id;
                    objtipo.IdCategoria = f.IdCategoria;

                    foreach (var o in objetos.Where(obj => obj.IdFamiliaObjeto == f.Id).OrderBy(obj => obj.Id))
                    {
                        objtipo.TipoGrafico.Add(new TipoGraficosViewModel() { Tipo = (int)o.TipoChart, Tooltip = GetTooltipTipoGrafico(o.TipoChart) });
                    }

                    objtipo.TipoGraficoSeleccionado = objtipo.TipoGrafico.First().Tipo;

                    model.Tipos.Add(objtipo);
                }
            }
            return View(model);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        [Autorizar(Permiso = "crearTablero")]
        public ActionResult Crear(CrearTableroViewModel model)
        {
            try
            {
                ReportingTablero tablero = new ReportingTablero();
                int userId = GetUsuarioLogueado();
                userId = usuarioRepository.GetUsuarioPerformance(userId);

                int ClienteId = GetClienteSeleccionado();
                if (ClienteId == 0)
                    return View("UsuarioSinClientes");

                var objetos = tableroRepository.GetObjetosDeCliente(ClienteId);

                if (model.Tipos.Where(t => t.Selected).ToList().Count == 0)
                    ModelState.AddModelError("NohayObjetos", Resources.Tableros.crearTableroErrNoObjectSelected);

                if (ModelState.IsValid)
                {
                    tablero.Nombre = model.Nombre;
                    tablero.IdCliente = ClienteId;
                    tablero.IdUsuario = userId;
                    tablero.IdModulo = IdModulo;

                    foreach (ObjetoTipoViewModel o in model.Tipos.Where(x => x.Selected == true))
                    {
                        if (o.TipoGraficoSeleccionado == 0)
                        {
                            o.TipoGraficoSeleccionado = o.TipoGrafico[0].Tipo;
                        }

                        var objeto = objetos.FirstOrDefault(obj => obj.IdFamiliaObjeto == o.Id && (int)obj.TipoChart == o.TipoGraficoSeleccionado);
                        tablero.ReportingTableroObjeto.Add(new ReportingTableroObjeto() { IdObjeto = objeto.Id, Orden = o.Orden, Size = o.Size });
                    }

                    int TableroId = tableroRepository.AddTablero(tablero, userId, ClienteId);
                    return RedirectToAction("Administrar");
                }
                else
                {
                    return View(model);
                }
            }
            catch
            {
                return View("Error");
            }
        }

        [Autorizar(Permiso = "eliminarTablero")]
        [HttpPost]
        public ActionResult Delete(int TableroId)
        {
            try
            {
                int ClienteId = GetClienteSeleccionado();
                if (ClienteId == 0)
                    return Content(bool.FalseString);

                int userId = GetUsuarioLogueado();
                userId = usuarioRepository.GetUsuarioPerformance(userId);

                if (!tableroRepository.PermiteCambiarPermisosDeTablero(TableroId, userId, ClienteId))
                {
                    return Content(bool.FalseString);
                }

                if (tableroRepository.DeleteTablero(TableroId))
                    return Content(bool.TrueString);
                else
                    return Content(bool.FalseString);

            }
            catch
            {
                return Content(bool.FalseString);
            }
        }

        [HttpPost]
        public ActionResult GuardarOrden(Dictionary<string,int> ListaTablero)
        {
            int userId = GetUsuarioLogueado();
            userId = usuarioRepository.GetUsuarioPerformance(userId);            
            try
            {
                foreach (KeyValuePair<string, int> tablero in ListaTablero)
                {                    
                    tableroRepository.UpdateOrdenTablero(int.Parse(tablero.Key), tablero.Value, tableroRepository.ExisteTableroUsuario(int.Parse(tablero.Key),userId),userId);                   
                }
                return Content(bool.TrueString);
            }
            catch
            {
                return Content(bool.FalseString);
            }
        }

        [Autorizar(Permiso = "editarTablero")]
        public ActionResult Editar(int Id = 0)
        {
            int clienteId = GetClienteSeleccionado();
            if (clienteId == 0)
                return View("UsuarioSinClientes");

            int userId = GetUsuarioLogueado();
            userId = usuarioRepository.GetUsuarioPerformance(userId);

            if (Id == 0)
            {
                return View("Error404");
            }

            if (clienteId == 0)
                return View("UsuarioSinClientes");

            if (!tableroRepository.PermiteEditarTablero(Id, userId, clienteId))
            {
                return View("ErrorSoloLectura");
            }

            List<ReportingObjetoCategoria> categorias = tableroRepository.GetCategoriasObjetoDeCliente(clienteId);
            List<ReportingFamiliaObjeto> familias = tableroRepository.GetFamiliasObjetoDeCliente(clienteId);
            List<ReportingObjeto> objetos = tableroRepository.GetObjetosDeCliente(clienteId);
            ReportingTablero tablero = tableroRepository.GetTablero(Id, userId, clienteId);

            if (categorias.Count == 0)
                return View("_NoPoseeObjetos");

            CrearTableroViewModel model = new CrearTableroViewModel
            {
                Nombre = tablero.Nombre
            };

            foreach (var cat in categorias)
            {
                model.Categorias.Add(new CategoriaObjetoViewModel() { Id = cat.Id, Nombre = cat.Nombre });

                foreach (var f in familias.Where(flia => flia.IdCategoria == cat.Id && objetos.Any(o => o.IdFamiliaObjeto == flia.Id)))
                {
                    var objtipo = new ObjetoTipoViewModel
                    {
                        Id = f.Id
                    };

                    var familiacliente = f.ReportingFamiliaNombreCliente.FirstOrDefault(o => o.idCliente == clienteId && o.idFamilia == f.Id);

                    if (familiacliente != null)
                    {
                        objtipo.Nombre = familiacliente.Nombre;
                    }
                    else
                    {
                        objtipo.Nombre = tableroRepository.GetNombreObjeto(f.Id, userId);
                    }

                    if (string.IsNullOrEmpty(objtipo.Nombre))
                    {
                        objtipo.Nombre = f.Nombre;
                    }

                    objtipo.Size = "S";
                    objtipo.IdFamilia = f.Id;
                    objtipo.IdCategoria = f.IdCategoria;

                    foreach (var o in objetos.Where(obj => obj.IdFamiliaObjeto == f.Id).OrderBy(obj => obj.Id))
                    {
                        objtipo.TipoGrafico.Add(new TipoGraficosViewModel() { Tipo = (int)o.TipoChart, Tooltip = GetTooltipTipoGrafico(o.TipoChart) });
                    }

                    objtipo.TipoGraficoSeleccionado = objtipo.TipoGrafico.First().Tipo;

                    model.Tipos.Add(objtipo);
                }
            }

            var objetosDeTablero = tableroRepository.GetObjetosDeTablero(Id);

            foreach (ReportingTableroObjeto rto in objetosDeTablero)
            {
                var objeto = model.Tipos.FirstOrDefault(o => o.Id == rto.ReportingObjeto.IdFamiliaObjeto);
                if (objeto != null)
                {
                    objeto.Orden = rto.Orden;
                    objeto.Size = rto.Size;
                    objeto.Selected = true;
                    objeto.TipoGraficoSeleccionado = (int)rto.ReportingObjeto.TipoChart;
                    objeto.Altura = rto.Altura;
                }
            }

            if (model.Tipos.Count > 0)
                return View(model);
            else
                return View("_NoPoseeObjetos");
        }

        [Autorizar(Permiso = "editarTablero")]
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Editar(EditarTableroViewModel model)
        {
            try
            {
                ReportingTablero tablero = new ReportingTablero();

                int ClienteId = GetClienteSeleccionado();
                if (ClienteId == 0)
                    return View("UsuarioSinClientes");

                int userId = GetUsuarioLogueado();
                userId = usuarioRepository.GetUsuarioPerformance(userId);

                if (!tableroRepository.PermiteEditarTablero(model.Id, userId, ClienteId))
                    return View("Error404");


                var objetos = tableroRepository.GetObjetosDeCliente(ClienteId);

                if (model.Tipos.Where(t => t.Selected).ToList().Count == 0)
                    ModelState.AddModelError("NohayObjetos", Resources.Tableros.editarTableroErrNoObjectSelected);

                if (ModelState.IsValid)
                {
                    tablero.Id = model.Id;
                    tablero.Nombre = model.Nombre;
                    tablero.IdModulo = IdModulo;

                    foreach (ObjetoTipoViewModel o in model.Tipos.Where(x => x.Selected))
                    {
                        if (o.TipoGraficoSeleccionado == 0)
                        {
                            o.TipoGraficoSeleccionado = o.TipoGrafico[0].Tipo;
                        }
                        var objeto = objetos.FirstOrDefault(obj => obj.IdFamiliaObjeto == o.Id && (int)obj.TipoChart == o.TipoGraficoSeleccionado);
                        tablero.ReportingTableroObjeto.Add(new ReportingTableroObjeto() { IdObjeto = objeto.Id, Orden = o.Orden, Size = o.Size, IdTablero = model.Id, Altura = o.Altura });
                    }

                    if (tableroRepository.EditarTablero(tablero))
                    {
                        return RedirectToAction("Administrar");
                    }
                    else
                    {
                        return View("Error");
                    }
                }
                else
                {
                    return View(model);
                }
            }
            catch
            {
                return View("Error");
            }
        }

        [Autorizar(Permiso = "compartirTablero")]
        public ActionResult Permisos(int id)
        {
            int ClienteId = GetClienteSeleccionado();

            if (id == 0)
            {
                return View("Error404");
            }

            if (ClienteId == 0)
                return View("UsuarioSinClientes");

            int userId = GetUsuarioLogueado();
            userId = usuarioRepository.GetUsuarioPerformance(userId);
            //bool esCp = usuarioRepository.UsuarioPerteneceACheckPos(userId);

            if (!tableroRepository.PermiteCambiarPermisosDeTablero(id, userId, ClienteId))
            {
                return View("Error404");
            }

            PermisosViewModel model = new PermisosViewModel
            {
                idTablero = id
            };

            List<PermisoUsuarioViewModel> permisos = new List<PermisoUsuarioViewModel>();

            var usuarios = usuarioRepository.GetUsuariosConReportingByCliente(ClienteId, true);

            foreach (Usuario u in usuarios.Where(u => u.IdUsuario != userId))
            {
                string imgPerfil;

                if (string.IsNullOrEmpty(u.imagen))
                {
                    imgPerfil = Url.Content("/images/perfil.jpg");
                }
                else
                {
                    imgPerfil = "data:image;base64," + u.imagen;
                }

                permisos.Add(new PermisoUsuarioViewModel() { idusuario = u.IdUsuario, nombre = string.Format("{0}, {1}", u.Apellido, u.Nombre), permiteEscritura = false, permiteLectura = false, imgPerfil = imgPerfil });
            }

            model.permisos = permisos;

            var usuariosDeTablero = tableroRepository.GetUsuariosDeTablero(id);

            foreach (ReportingTableroUsuario ru in usuariosDeTablero)
            {
                var usu = model.permisos.FirstOrDefault(u => u.idusuario == ru.IdUsuario);
                if (usu != null)
                {
                    usu.permiteEscritura = (ru.PermiteEscritura.HasValue) ? (bool)ru.PermiteEscritura : false;
                    usu.permiteLectura = true;
                }
            }

            return View(model);
        }

        [Autorizar(Permiso = "compartirTablero")]
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Permisos(PermisosViewModel model)
        {
            try
            {
                int ClienteId = GetClienteSeleccionado();
                if (ClienteId == 0)
                    return View("UsuarioSinClientes");

                int userId = GetUsuarioLogueado();
                userId = usuarioRepository.GetUsuarioPerformance(userId);

                if (!tableroRepository.PermiteCambiarPermisosDeTablero(model.idTablero, userId, ClienteId))
                {
                    return View("Error404");
                }

                if (ModelState.IsValid)
                {
                    if (model.permisos.Count > 0)
                    {
                        if (!tableroRepository.QuitarPermisos(model.idTablero))
                            throw new Exception(Resources.Tableros.errGrabarPermisos);

                        foreach (PermisoUsuarioViewModel permiso in model.permisos.Where(p => (p.permiteLectura || p.permiteEscritura) && p.idusuario != userId))
                        {
                            if (!tableroRepository.AgregarPermisos(new ReportingTableroUsuario() { IdTablero = model.idTablero, IdUsuario = permiso.idusuario, PermiteEscritura = permiso.permiteEscritura }))
                            {
                                throw new Exception(Resources.Tableros.errGrabarPermisos);
                            };
                        }
                    }
                    return RedirectToAction("Administrar");
                }
                else
                {
                    return View(model);
                }
            }
            catch
            {
                return View("Error");
            }
        }

        [Autorizar(Permiso = "verTablero")]
        public ActionResult Mostrar(int Id)
        {
            TempData["TableroId"] = Id;
            return RedirectToAction("Index");
        }

        [Autorizar(Permiso = "verTablero")]
        public ActionResult Index()
        {
            int Id;
            try
            {
                Id = int.Parse(TempData["TableroId"].ToString());
            }
            catch
            {
                Id = 0;
            }

            int clienteId = GetClienteSeleccionado();
            if (clienteId == 0)
            {
                return PartialView("UsuarioSinClientes");
            }

            int userId = GetUsuarioLogueado();
            userId = usuarioRepository.GetUsuarioPerformance(userId);

            if (!commonRepository.tieneFiltrosAsignados(IdModulo, clienteId))
            {
                return View("_NoTieneFiltros");
            }

            if (Id == 0)
            {
                int tableroDefault = tableroRepository.GetTableroIdDefault(userId, clienteId);
                if (tableroDefault == 0)
                {
                    return View("NoTieneTableros");
                }
                else
                {
                    Id = tableroDefault;
                }
            }

            TableroViewModel model = new TableroViewModel();
            List<Tab> tabs = tableroRepository.GetTabs(userId, clienteId).ToList();

            if (tabs.Count == 0)
            {
                return View("NoTieneTableros");
            }

            foreach (Tab tab in tabs)
            {
                model.Tabs.Tabs.Add(new TabViewModel() { Id = tab.Id, Titulo = tab.Titulo });
            }

            if (Id == 0)
            {
                model.Tabs.Tabs.First().Active = true;
            }
            else
            {
                TabViewModel modelTab = model.Tabs.Tabs.FirstOrDefault(t => t.Id == Id);
                if (modelTab != null)
                    modelTab.Active = true;
            }

            model.Tabs.IdModulo = IdModulo;

            return View(model);

        }

        [HttpPost]
        public PartialViewResult GetClientes()
        {
            int userId = GetUsuarioLogueado();
            int ClienteId = GetClienteSeleccionado();

            List<ItemViewModelCountry> items = new List<ItemViewModelCountry>();
            int userIdPerformance = usuarioRepository.GetUsuarioPerformance(userId);
            var lstclientes = clienteRepository.GetClientes(userIdPerformance).OrderBy(c => c.Nombre);
            foreach (Cliente c in lstclientes)
            {
                var itm = new ItemViewModelCountry() {
                    IdItem = c.IdCliente.ToString(),
                    Descripcion = c.Nombre,
                    TipoItem = "IdCliente",
                    CountryCode = c.countrySymbol};

                itm.Selected = (itm.IdItem == ClienteId.ToString()) ? true : false;
                items.Add(itm);
            }
            return PartialView("_Clientes", items);
        }

        [HttpPost]
        public PartialViewResult GetObjetos(int TableroId)
        {
            int ClienteId = GetClienteSeleccionado();
            ObjetosDeTableroViewModel model = new ObjetosDeTableroViewModel();
            var objetos = tableroRepository.GetObjetosDeTablero(TableroId);
            List<ObjetoViewModel> objetosVM = new List<ObjetoViewModel>();
            List<ReportingFamiliaNombreCliente> fliaC = tableroRepository.GetFamiliasNombreCliente(ClienteId);

            int userId = GetUsuarioLogueado();
            userId = usuarioRepository.GetUsuarioPerformance(userId);

            foreach (ReportingTableroObjeto o in objetos)
            {
                var fc = fliaC.SingleOrDefault(f => f.idFamilia == o.ReportingObjeto.IdFamiliaObjeto);
                int idFamilia = o.ReportingObjeto.ReportingFamiliaObjeto.Id;
                string cultureName = null;

                HttpCookie cultureCookie = Request.Cookies["_culture"];
                if (cultureCookie != null)
                {
                    cultureName = cultureCookie.Value;
                }
                else
                {
                    cultureName = Request.UserLanguages != null && Request.UserLanguages.Length > 0 ? Request.UserLanguages[0] : null;
                }

                string tituloObjeto;
                if (fc != null)
                    tituloObjeto = fc.Nombre;
                else
                    tituloObjeto = tableroRepository.GetNombreObjeto(idFamilia, userId);

                var objVM = new ObjetoViewModel() {
                    Id = o.IdObjeto,
                    Orden = o.Orden,
                    TextoFooter = tituloObjeto,
                    TextoHeader = tituloObjeto,
                    Tipo = (int)o.ReportingObjeto.TipoChart,
                    dataLabels = o.FlgDataLabel,
                    stackLabels = o.StackLabel,
                    SizePage = o.Size,
                    Descripcion = tableroRepository.GetDescripcionObjeto(o.IdObjeto, cultureName.Split('-')[0])
                    
                };

                switch (o.Size)
                {
                    case "XS":
                        objVM.Size = "col-xs-12 col-sm-2 col-md-2 col-lg-2";
                        break;
                    case "S":
                        objVM.Size = "col-xs-12 col-sm-4 col-md-4 col-lg-4";
                        break;
                    case "SM":
                        objVM.Size = "col-xs-12 col-sm-6 col-md-6 col-lg-6";
                        break;
                    case "M":
                        objVM.Size = "col-xs-12 col-sm-8 col-md-8 col-lg-8";
                        break;
                    case "ML":
                        objVM.Size = "col-xs-12 col-sm-10 col-md-10 col-lg-10";
                        break;
                    case "L":
                        objVM.Size = "col-xs-12 col-sm-12 col-md-12 col-lg-12";
                        break;
                }             
                switch(o.Altura)
                {
                    case "XS":
                        objVM.altura = "s1-height";
                        break;
                    case "S":
                        objVM.altura = "m1-height";
                        break;
                    case "SM":
                        objVM.altura = "l1-height";
                        break;
                    case "M":
                        objVM.altura = "s2-height";
                        break;
                    case "ML":
                        objVM.altura = "m2-height";
                        break;
                    case "L":
                        objVM.altura = "l2-height";
                        break;
                    case "XL":
                        objVM.altura = "s3-height";
                        break;
                    case "XXL":
                        objVM.altura = "m3-height";
                        break;
                    case "XXXL":
                        objVM.altura = "l3-height";
                        break;
                    default:
                        objVM.altura = "l1-height"; //Altura Standard 255px               
                        break;
                }
                
                objetosVM.Add(objVM);
            }

            model.TableroId = TableroId;
            model.Objetos = objetosVM;
            return PartialView("_ObjetosTablero", model);
        }

        [HttpPost]
        public Chart GetDataGrafico(int ObjetoId, int tableroid, int page = 0, string tipoDeVista = "N")
        {
            int pageSize = 8;


            switch (tipoDeVista)
            {
                case "S":
                    pageSize = 3;
                    break;
                case "M":
                    pageSize = 6;
                    break;
                case "L":
                    pageSize = 9;
                    break;
                case "N":
                    pageSize = 8;
                    break;
                case "A":
                    pageSize = 16;
                    break;
                case "D":
                    pageSize = 24;
                    break;
            }

            int userId = GetUsuarioLogueado();
            userId = usuarioRepository.GetUsuarioPerformance(userId);

            int ClienteId = GetClienteSeleccionado();
        
            var filtros = GetFiltrosAplicadosPorTablero(IdModulo, tableroid);

            List<FiltroSeleccionado> filtrosSeleccionados = new List<FiltroSeleccionado>();
            if (filtros != null)
            {
                foreach (var ff in filtros.FiltrosFechas)
                {
                    var nfiltro = new FiltroSeleccionado
                    {
                        TipoFecha = ff.TipoFechaSeleccionada,
                        Filtro = ff.Id,
                        TipoFiltro = TipoFiltro.Fecha
                    };

                    switch (ff.TipoFechaSeleccionada)
                    {
                        case "D":
                            string diadesde = null;
                            string diahasta = null;

                            if (ff.DiaDesde != null)
                                diadesde = System.DateTime.Parse(ff.DiaDesde).ToString("yyyyMMdd");

                            if (ff.DiaHasta != null)
                                diahasta = System.DateTime.Parse(ff.DiaHasta).ToString("yyyyMMdd");

                            nfiltro.Valores = new string[] { ff.TipoFechaSeleccionada, diadesde, diahasta };
                            break;
                        case "S":
                            string sdesde = null;
                            string shasta = null;

                            if (ff.SemanaDesde != null)
                            {
                                var aniodesde = int.Parse(ff.SemanaDesde.Substring(0, 4));
                                int semanadesde = int.Parse(ff.SemanaDesde.Substring(ff.SemanaDesde.Length - 2, 2));
                                sdesde = FirstDateOfWeekISO8601(aniodesde, semanadesde).ToString("yyyyMMdd");
                            }

                            if (ff.SemanaHasta != null)
                            {
                                var aniohasta = int.Parse(ff.SemanaHasta.Substring(0, 4));
                                int semanahasta = int.Parse(ff.SemanaHasta.Substring(ff.SemanaHasta.Length - 2, 2));
                                shasta = FirstDateOfWeekISO8601(aniohasta, semanahasta).AddDays(6).ToString("yyyyMMdd");
                            }

                            nfiltro.Valores = new string[] { ff.TipoFechaSeleccionada, sdesde, shasta };
                            break;
                        case "M":

                            string mesDesde = null;
                            string mesHasta = null;

                            if (ff.MesDesde != null)
                                mesDesde = DateTime.Parse(ff.MesDesde).ToString("yyyyMMdd");

                            if (ff.MesHasta != null)
                                mesHasta = DateTime.Parse(ff.MesHasta).AddMonths(1).AddDays(-1).ToString("yyyyMMdd");

                            nfiltro.Valores = new string[] { ff.TipoFechaSeleccionada, mesDesde, mesHasta };
                            break;
                        case "T":
                            switch (ff.TrimestreDesde)
                            {
                                case "1":
                                    ff.TrimestreDesde = new DateTime(DateTime.Today.Year, 1, 1).ToString("yyyyMMdd");
                                    break;
                                case "2":
                                    ff.TrimestreDesde = new DateTime(DateTime.Today.Year, 4, 1).ToString("yyyyMMdd");
                                    break;
                                case "3":
                                    ff.TrimestreDesde = new DateTime(DateTime.Today.Year, 7, 1).ToString("yyyyMMdd");
                                    break;
                                case "4":
                                    ff.TrimestreDesde = new DateTime(DateTime.Today.Year, 10, 1).ToString("yyyyMMdd");
                                    break;
                                default:
                                    ff.TrimestreDesde = null;
                                    break;
                            }
                            switch (ff.TrimestreHasta)
                            {
                                case "1":
                                    ff.TrimestreHasta = new DateTime(DateTime.Today.Year, 4, 1).AddDays(-1).ToString("yyyyMMdd");
                                    break;
                                case "2":
                                    ff.TrimestreHasta = new DateTime(DateTime.Today.Year, 7, 1).AddDays(-1).ToString("yyyyMMdd");
                                    break;
                                case "3":
                                    ff.TrimestreHasta = new DateTime(DateTime.Today.Year, 10, 1).AddDays(-1).ToString("yyyyMMdd");
                                    break;
                                case "4":
                                    ff.TrimestreHasta = new DateTime(DateTime.Today.Year, 1, 1).AddDays(-1).ToString("yyyyMMdd");
                                    break;
                                default:
                                    ff.TrimestreHasta = null;
                                    break;
                            }

                            nfiltro.Valores = new string[] { ff.TipoFechaSeleccionada, ff.TrimestreDesde, ff.TrimestreHasta };
                            break;
                    }

                    filtrosSeleccionados.Add(nfiltro);
                }

                foreach (var fc in filtros.FiltrosChecks)
                {
                    var nfiltro = new FiltroSeleccionado
                    {
                        Filtro = fc.Id,
                        TipoFiltro = TipoFiltro.CheckBox,
                        Valores = fc.Items.Where(f => f.Selected).Select(f => f.IdItem).ToArray<string>()
                    };

                    if (nfiltro.Valores.Length > 0)
                        filtrosSeleccionados.Add(nfiltro);
                }
            }

            Chart chart = tableroRepository.GetDataObjeto(filtrosSeleccionados, ClienteId, ObjetoId, page, userId, pageSize);

            return chart;
        }

        [HttpPost]
        public ActionResult GetDataGraficoJson(int objetoid, int tableroid, int page = -1, int tipoobj = 0, string tipoDeVista = "N")
        {
            var chart = GetDataGrafico(objetoid, tableroid, page, tipoDeVista);

            if (tipoobj == 15)
            {
                ImagenesChart imagenes = (ImagenesChart)chart;
                ImagenesVM model = new ImagenesVM();
                foreach (Imagen i in imagenes.Valores)
                {
                    model.imagenes.Add(new ImagenVM() { imgb64 = i.imgb64
                       , idPuntoDeVenta = i.idPuntoDeVenta
                       , nombrePuntoDeVenta = i.nombrePuntoDeVenta
                       , comentarios = i.comentarios
                       , tags = i.tags
                       , id = i.id
                    });
                }
                model.marcaBase64 = imagenes.marcaBase64;

                return PartialView("_ObjetoTipo15", model);
            }
           
            
            var jsonData = Json(chart, JsonRequestBehavior.AllowGet);
            jsonData.MaxJsonLength = Int32.MaxValue;
            return jsonData;
        }


        [HttpPost]
        public ActionResult GetReporteT22(string producto, string fecha, string precio,int tableroid, int tipoPrecio,string anio = "2018")
        {
            int ClienteId = GetClienteSeleccionado();

            int userId = GetUsuarioLogueado();
            userId = usuarioRepository.GetUsuarioPerformance(userId);

            var filtros = GetFiltrosAplicadosPorTablero(IdModulo, tableroid);

            List<FiltroSeleccionado> filtrosSeleccionados = new List<FiltroSeleccionado>();
            if (filtros != null)
            {

                foreach (var fc in filtros.FiltrosChecks)
                {
                    var nfiltro = new FiltroSeleccionado
                    {
                        Filtro = fc.Id,
                        TipoFiltro = TipoFiltro.CheckBox,
                        Valores = fc.Items.Where(f => f.Selected).Select(f => f.IdItem).ToArray<string>()
                    };

                    if (nfiltro.Valores.Length > 0)
                        filtrosSeleccionados.Add(nfiltro);
                }
            }

            anio = anio.Substring(0,4);
            List<ReporteSimple> reportes;
            List<ReportePaisSimple> paises;    
            JsonResult jsonData;
            try
            {
                precio = precio.Split('.')[0].Replace(" ",string.Empty);                
                reportes = tableroRepository.GetDataReporteT22(ClienteId, producto, fecha, precio, tipoPrecio,filtrosSeleccionados, anio);

                if (reportes.Count > 0)
                {
                    jsonData = Json(reportes, JsonRequestBehavior.AllowGet);
                }
                else
                {              
                    paises = tableroRepository.GetDataPaisesT22(ClienteId, producto,filtrosSeleccionados, fecha);
                    jsonData = Json(paises, JsonRequestBehavior.AllowGet);
                }                
            }
            catch (SqlException sqlErr)
            {   //EN ESTE CASO NO SE PUDO ENCONTRAR DATA
                var msgSQL = sqlErr.Message;
                paises = tableroRepository.GetDataPaisesT22(ClienteId, producto,filtrosSeleccionados, fecha);
                jsonData = Json(paises, JsonRequestBehavior.AllowGet);

            }
            catch (Exception E){
                var tipo = E.GetType();
                reportes = new List<ReporteSimple>();
                jsonData = Json(reportes, JsonRequestBehavior.AllowGet);
            }
            
            
            return jsonData;
        }

        [HttpPost]
        public void DownloadDataFromObjeto(string jsonFiltros, int ObjetoId, string fileName, int tableroid)
        {

            JavaScriptSerializer js = new JavaScriptSerializer();
            var Filtros = js.Deserialize<List<FiltroSeleccionadoViewModel>>(jsonFiltros);

            System.IO.Stream iStream = null;

            byte[] buffer = new Byte[100000];
            int length;
            long dataToRead;

            try
            {
                foreach (FiltroSeleccionadoViewModel x in Filtros)
                {
                    if (x.Valores.Length == 0)
                    {
                        x.Valores = null;
                    }
                }

                var objeto = tableroRepository.GetObjeto(ObjetoId);

                var chart = GetDataGrafico(ObjetoId, tableroid);

                if (chart.Tipo != TipoChart.Tabla)
                    throw new Exception(Resources.Tableros.errOperacionNoSoportadaTipo9);

                var tabla = (TableChart)chart;

                string columnas = string.Join(";", tabla.Valores[0].Keys);

                StringBuilder sbvalores = new StringBuilder();
                foreach (var i in tabla.Valores)
                {
                    sbvalores.Append(string.Join(";", i.Values) + "\n");
                }

                string valores = sbvalores.ToString();

                string data = columnas + "\n" + valores;

                byte[] byteArray = Encoding.UTF8.GetBytes(data);

                iStream = new MemoryStream(byteArray);

                dataToRead = iStream.Length;

                Response.Clear();
                Response.ContentType = "text/csv;charset=UTF-8";
                Response.ContentEncoding = Encoding.UTF8;

                Response.AddHeader("Content-Disposition", "attachment; filename=" + fileName + ".csv");
                Response.AddHeader("Content-Length", iStream.Length.ToString());

                while (dataToRead > 0)
                {
                    if (Response.IsClientConnected)
                    {
                        length = iStream.Read(buffer, 0, 100000);
                        Response.OutputStream.Write(buffer, 0, length);
                        Response.Flush();
                        buffer = new Byte[100000];
                        dataToRead = dataToRead - length;
                    }
                    else
                    {
                        dataToRead = -1;
                    }
                }
            }
            catch
            {

            }
            finally
            {
                if (iStream != null)
                {
                    iStream.Close();
                }
                Response.Close();
            }
        }

        [HttpPost]
        public PartialViewResult GetPerfil()
        {
            UsuarioPerfilViewModel vmodel = new UsuarioPerfilViewModel();

            int userId = GetUsuarioLogueado();
            int userIdPerf = usuarioRepository.GetUsuarioPerformance(userId);

            Usuario usuario = usuarioRepository.getPerfilUsuario(userIdPerf);
            vmodel.userId = userId;
            vmodel.Nombre = usuario.Nombre;
            vmodel.Apellido = usuario.Apellido;
            vmodel.Email = User.Identity.Name;
            vmodel.SelectedIdioma = usuario.Idioma;
            if (vmodel.SelectedIdioma == "es")
            {
                vmodel.Idiomas.Add(new SelectListItem() { Text = "Español", Value = "es", Selected = true });
                vmodel.Idiomas.Add(new SelectListItem() { Text = "English", Value = "en" });
            }
            else
            {
                vmodel.Idiomas.Add(new SelectListItem() { Text = "Español", Value = "es" });
                vmodel.Idiomas.Add(new SelectListItem() { Text = "English", Value = "en", Selected = true });
            }

            return PartialView("_PerfilUsuario", vmodel);
        }

        [HttpPost]
        public void SetProfileData()
        {
            if (System.Web.HttpContext.Current.Request.Files.AllKeys.Any())
            {
                var pic = System.Web.HttpContext.Current.Request.Files["HelpSectionImages"];

                string spic = Path.GetFileName(pic.FileName);

                using (MemoryStream ms = new MemoryStream())
                {
                    pic.InputStream.CopyTo(ms);
                    byte[] imagen = ms.GetBuffer();
                    int userId = GetUsuarioLogueado();

                    Image image;
                    using (MemoryStream memorystring = new MemoryStream(imagen))
                    {
                        image = Image.FromStream(ms);
                        var path = Path.Combine(Server.MapPath("~/Content/ImagenesDePerfil/"), userId.ToString() + ".jpg");
                        image.Save(path, System.Drawing.Imaging.ImageFormat.Jpeg);
                    }
                }
            }
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult GuardarPerfil(UsuarioPerfilViewModel model)
        {
            if (model.SelectedIdioma == "es")
            {
                model.Idiomas.Add(new SelectListItem() { Text = "Español", Value = "es", Selected = true });
                model.Idiomas.Add(new SelectListItem() { Text = "English", Value = "en" });
            }
            else
            {
                model.Idiomas.Add(new SelectListItem() { Text = "Español", Value = "es" });
                model.Idiomas.Add(new SelectListItem() { Text = "English", Value = "en", Selected = true });
            }

            model.passwordFlag = 0;
            model.Email = model.Email;
            if (string.IsNullOrEmpty(model.PasswordActual) || model.PasswordActual.Length < 6)
            {
                model.passwordFlag = 1;
            }

            if (ModelState.IsValid)
            {
                int userId = usuarioRepository.GetUsuarioPerformance(model.userId);
                int ClienteId = GetClienteSeleccionado();

                Usuario usuario = new Usuario
                {
                    IdUsuario = model.userId,
                    Nombre = model.Nombre,
                    Apellido = model.Apellido,
                    Idioma = model.SelectedIdioma
                };

                if (!string.IsNullOrEmpty(model.Password))
                {
                    if (string.IsNullOrEmpty(model.PasswordActual) || model.PasswordActual.Length < 6)
                    {
                        ModelState.AddModelError("PasswordActualVacia", Resources.Tableros.perfilClaveActualContent);
                        return PartialView("_PerfilUsuario", model);
                    }

                    var userManager = HttpContext.GetOwinContext().GetUserManager<ApplicationUserManager>();
                    var user = userManager.FindById(User.Identity.GetUserId<int>());

                    try
                    {
                        userManager.ChangePassword(user.Id, model.PasswordActual, model.Password);
                    }
                    catch
                    {
                        ModelState.AddModelError("PasswordActualIncorrecta", Resources.Tableros.errClaveIncorrecta);
                        return PartialView("_PerfilUsuario", model);
                    }

                    usuario.Clave = model.Password;
                }

                if (model.SelectedIdioma != null)
                {
                    Thread.CurrentThread.CurrentCulture = CultureInfo.CreateSpecificCulture(model.SelectedIdioma);
                    Thread.CurrentThread.CurrentUICulture = new CultureInfo(model.SelectedIdioma);
                }

                HttpCookie cookie = new HttpCookie("Language")
                {
                    Value = model.SelectedIdioma
                };
                Response.Cookies.Add(cookie);

                usuarioRepository.EdicionUsuarioPerfil(ClienteId, usuario);

                return Json(new { success = true });
            }
            return PartialView("_PerfilUsuario", model);
        }



        [HttpPost]
        public void SetConfiguracionDeObjeto(int tableroId, int objetoId, bool dataLabel, int stackLabel)
        {
            tableroRepository.updateConfiguracionDeTableroObjeto(tableroId, objetoId, dataLabel, stackLabel);
        }

        [HttpPost]
        public PartialViewResult GetTiposDeObjeto(int objetoId)
        {
            ReportingTablero tablero = new ReportingTablero();

            int ClienteId = GetClienteSeleccionado();
            if (ClienteId == 0)
                return PartialView("_TiposDeObjeto", false);

            int userId = GetUsuarioLogueado();
            userId = usuarioRepository.GetUsuarioPerformance(userId);

            var objetos = tableroRepository.GetObjetosDeCliente(ClienteId);
            var ro = tableroRepository.GetObjeto(objetoId);

            EditarTableroViewModel model = new EditarTableroViewModel();

            foreach (var o in objetos)
            {
                if (o.IdFamiliaObjeto == ro.IdFamiliaObjeto)
                {
                    ObjetoTipoViewModel ot = new ObjetoTipoViewModel();
                    TipoGraficosViewModel tg = new TipoGraficosViewModel
                    {
                        Tipo = (int)o.TipoChart,
                        Tooltip = GetTooltipTipoGrafico(o.TipoChart)
                    };
                    ot.TipoGrafico.Add(tg);
                    ot.Id = objetoId;
                    ot.Nombre = o.ReportingFamiliaObjeto.Nombre;
                    ot.Orden = 0;
                    ot.Size = "L";

                    if (o.TipoChart == ro.TipoChart)
                        ot.Selected = true;

                    model.Tipos.Add(ot);
                }
            }
            return PartialView("_TiposDeObjeto", model);
        }

        public ActionResult VistaAmpliarObjeto(int objetoid)
        {
            int clienteId = GetClienteSeleccionado();

            var thisobj = tableroRepository.GetObjeto(objetoid);
            var objetosenfamilia = tableroRepository.GetObjetosDeCliente(clienteId).Where(o => o.IdFamiliaObjeto == thisobj.IdFamiliaObjeto);

            int userId = GetUsuarioLogueado();
            userId = usuarioRepository.GetUsuarioPerformance(userId);

            AmpliarObjetoViewModel model = new AmpliarObjetoViewModel();

            foreach (var t in objetosenfamilia)
            {
                model.tipos.Add(new ObjetoTipoVista() { idtipo = (int)t.TipoChart, descripcion = t.TipoChart.ToString(), selected = t.Id == objetoid, idobjeto = t.Id });
            }

            model.idObjeto = objetoid;
            model.tipoSeleccionado = (int)thisobj.TipoChart;

            var familiacliente = thisobj.ReportingFamiliaObjeto.ReportingFamiliaNombreCliente.FirstOrDefault(o => o.idCliente == clienteId && o.idFamilia == thisobj.IdFamiliaObjeto);

            if (familiacliente != null)
            {
                model.nombre = familiacliente.Nombre;
            }
            else
            {
                model.nombre = tableroRepository.GetNombreObjeto(thisobj.IdFamiliaObjeto, userId);
            }

            if (string.IsNullOrEmpty(model.nombre))
            {
                model.nombre = thisobj.ReportingFamiliaObjeto.Nombre;
            }

            return PartialView("_AmpliarObjeto", model);
        }

        public bool CambiarObjetoDeTablero(int TableroId, int ObjetoIdInicial, int NuevoObjetoSeleccionado)
        {
            if (TableroId > 0 && ObjetoIdInicial > 0 && NuevoObjetoSeleccionado > 0)
            {
                return tableroRepository.CambiarObjetoDeTablero(TableroId, ObjetoIdInicial, NuevoObjetoSeleccionado);
            }
            return false;
        }

        [HttpPost]
        public JsonResult GetObjetoIdByTipoChartAndFamilia(int ObjetoId, int ChartTipo)
        {
            int ClienteId = GetClienteSeleccionado();
            var newObjetoId = 0;
            var currentObjeto = tableroRepository.GetObjeto(ObjetoId);
            var currentFamilia = currentObjeto.IdFamiliaObjeto;
            var objetos = tableroRepository.GetObjetosDeCliente(ClienteId).OrderBy(o => o.IdFamiliaObjeto);
            foreach (var o in objetos)
            {
                if (o.IdFamiliaObjeto == currentFamilia && (int)o.TipoChart == ChartTipo)
                {
                    newObjetoId = o.Id;
                }
            }
            return Json(newObjetoId, JsonRequestBehavior.AllowGet);
        }

        [HttpPost]
        public JsonResult GetFilasAnidadas(int ObjetoId, List<string> Esclave, List<string> EsclaveValue)
        {
            int ClienteId = GetClienteSeleccionado();
            int userId = GetUsuarioLogueado();
            userId = usuarioRepository.GetUsuarioPerformance(userId);

            var filtrosSeleccionados = GetFiltrosAplicadosDeUsuario();

            Chart chart = tableroRepository.GetSPAnidado(filtrosSeleccionados, ClienteId, ObjetoId, Esclave, EsclaveValue, userId);

            return Json(chart, JsonRequestBehavior.AllowGet);
        }

        [HttpPost]
        public PartialViewResult GetFiltrosPartialView(int tableroid)
        {
            var model = GetFiltrosAplicadosPorTablero(IdModulo, tableroid);

            return PartialView("_Filtros", model);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult AplicarFiltros([ModelBinder(typeof(Reporting.Binders.FiltrosModelBinder))] FiltrosViewModel filtros, int TableroId)
        {
            return base.AplicarFiltros(filtros, TableroId, IdModulo);
        }

        [HttpPost]
        public ActionResult SaveFiltrosLock(bool filtrosLock, string tableroId)
        {
            return base.SaveFiltrosLockState(filtrosLock, tableroId, IdModulo);
        }

        public ActionResult MisDatos()
        {
            int Id = GetUsuarioLogueado();
            Id = usuarioRepository.GetUsuarioPerformance(Id);

            int ClienteId = GetClienteSeleccionado();

            Usuario usuario = usuarioRepository.GetUsuarioById(Id);
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
                    PermiteModificarCalendario = usuario.PermiteModificarCalendario,
                    IdiomaId = usuario.Idioma
                };

                var usucliente = usuario.Usuario_Cliente.FirstOrDefault(uc => uc.IdCliente == ClienteId);

                model.Idiomas.Add(new SelectListItem()
                {
                    Text = "Español",
                    Value = "es"
                });

                model.Idiomas.Add(new SelectListItem()
                {
                    Text = "English",
                    Value = "en"
                });

                model.Idiomas.Add(new SelectListItem()
                {
                    Text = "Deutsch",
                    Value = "de"
                });

                model.Idiomas.Add(new SelectListItem()
                {
                    Text = "Italiano",
                    Value = "it"
                });

                model.Idiomas.Add(new SelectListItem()
                {
                    Text = "Français",
                    Value = "fr"
                });

                model.Idiomas.Add(new SelectListItem()
                {
                    Text = "Portugues",
                    Value = "pt"
                });

                if (usucliente != null && usucliente.Rol != null)
                {
                    model.RolId = usucliente.Rol.id;
                }

                model.RoleList.Add(new SelectListItem()
                {
                    Text = Resources.Tableros.lblSeleccioneUnRol,
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

        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult MisDatos(ConfUsuarioVM model)
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
                    ModelState.AddModelError("Err_Imagen_FileType", Resources.Tableros.errFormatosImagen);
                }

                if (model.Imagen != null && model.Imagen.InputStream.Length > 512000)
                {
                    ModelState.AddModelError("Err_Imagen_FileSize", Resources.Tableros.errImagenSize500kb);
                }

                int ClienteId = GetClienteSeleccionado();
                List<ReportingRoles> roles = usuarioRepository.GetRolesDeCliente(ClienteId);

                model.RoleList.Add(new SelectListItem()
                {
                    Text = Resources.Tableros.lblSeleccioneUnRol,
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

                model.Idiomas.Add(new SelectListItem()
                {
                    Text = "Español",
                    Value = "es"
                });

                model.Idiomas.Add(new SelectListItem()
                {
                    Text = "English",
                    Value = "en"
                });

                model.Idiomas.Add(new SelectListItem()
                {
                    Text = "Deutsch",
                    Value = "de"
                });

                model.Idiomas.Add(new SelectListItem()
                {
                    Text = "Italiano",
                    Value = "it"
                });

                model.Idiomas.Add(new SelectListItem()
                {
                    Text = "Français",
                    Value = "fr"
                });

                model.Idiomas.Add(new SelectListItem()
                {
                    Text = "Portugues",
                    Value = "pt"
                });

                if (ModelState.IsValid)
                {
                    Usuario usuario = usuarioRepository.GetUsuarioById(model.Id);

                    usuario.Nombre = model.Nombre;
                    usuario.Apellido = model.Apellido;
                    usuario.Telefono = model.Telefono;
                    usuario.Idioma = model.IdiomaId;

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

                    if (usuarioRepository.EdicionUsuarioPerfil(ClienteId, usuario))
                    {
                        SetCulture(model.IdiomaId);
                        ViewBag.Success = true;
                        return View(model);
                    }
                    else
                    {
                        ViewBag.Error = true;
                        ViewBag.ErrorMessage = Resources.Tableros.reviseSiLosResultadosSonCorrectos;
                        return View(model);
                    }
                }
                else
                {
                    ViewBag.Error = true;
                    ViewBag.ErrorMessage = Resources.Tableros.reviseSiLosResultadosSonCorrectos;
                    return View(model);
                }
            }
            catch
            {
                return View("Error");
            }
        }
        public ActionResult BorrarEsto()
        {
            return View();
        }
    }
}