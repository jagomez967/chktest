using System.Collections.Generic;
using System.Web.Mvc;
using Reporting.Domain.Abstract;
using Microsoft.AspNet.Identity;
using Reporting.Domain.Entities;
using System.Linq;
using System.Web.Script.Serialization;
using System;
using Reporting.ViewModels;
using System.Web;

namespace Reporting.Controllers
{
    public class BaseController : Controller
    {
        public IUsuarioRepository usuarioRepository;
        public ITableroRepository tableroRepository;
        public IClienteRepository clienteRepository;
        public IFiltroRepository filtroRepository;
        public IDatosRepository datosRepository;
        public IImagenesRepository imagenesRepository;
        public IGeoRepository geoRepository;
        public ICommonRepository commonRepository;
        public IAbmsRepository abmsRepository;

        public BaseController() { }
        public BaseController(IUsuarioRepository usuarioRepository, IFiltroRepository filtroRepository, IClienteRepository clienteRepository, ITableroRepository tableroRepository)
        {
            this.usuarioRepository = usuarioRepository;
            this.clienteRepository = clienteRepository;
            this.filtroRepository = filtroRepository;
            this.tableroRepository = tableroRepository;
        }
        protected int GetClienteSeleccionado()
        {
            int userId = GetUsuarioLogueado();

            int userIdPerformance = usuarioRepository.GetUsuarioPerformance(userId);

            if (Session["ClientesUsuarios"] == null)
            {
                Session["ClientesUsuarios"] = new Dictionary<int, int>();
            }

            var dict = (Dictionary<int, int>)Session["ClientesUsuarios"];

            if (!dict.ContainsKey(userId))
            {
                var ultimoCliente = usuarioRepository.GetUltimoClienteSeleccionado(userIdPerformance);
                if (ultimoCliente > 0)
                {
                    dict.Add(userId, ultimoCliente);
                }
                else
                {
                    var clienteSel = clienteRepository.GetClientes(userIdPerformance).FirstOrDefault();
                    if (clienteSel == null)
                    {
                        dict.Add(userId, 0);
                    }
                    else
                    {
                        dict.Add(userId, clienteSel.IdCliente);
                    }
                }
            }

            return dict[userId];
        }
        [HttpPost]
        public string GetNombreClienteSeleccionado()
        {
            int ClienteId = GetClienteSeleccionado();
            if (ClienteId == 0)
                return string.Empty;

            var cliente = clienteRepository.GetCliente(ClienteId);
            if (cliente == null)
                return string.Empty;

            return cliente.Nombre;
        }
        protected int GetUsuarioLogueado()
        {
            int userId = User.Identity.GetUserId<int>();
            return userId;
        }
        [HttpPost]
        public void SetClienteSeleccionado(int clienteId)
        {
            if (Session["ClientesUsuarios"] == null)
            {
                Session["ClientesUsuarios"] = new Dictionary<int, int>();
            }

            int userId = GetUsuarioLogueado();
            int userIdPerformance = usuarioRepository.GetUsuarioPerformance(userId);

            var dict = (Dictionary<int, int>)Session["ClientesUsuarios"];

            if (dict.ContainsKey(userId))
                dict.Remove(userId);

            dict.Add(userId, clienteId);
            usuarioRepository.SetUltimoClienteSeleccionado(userIdPerformance, clienteId);
        }
        protected DateTime FirstDateOfWeekISO8601(int year, int weekOfYear)
        {
            DateTime jan1 = new DateTime(year, 1, 1);
            int daysOffset = DayOfWeek.Thursday - jan1.DayOfWeek;

            DateTime firstThursday = jan1.AddDays(daysOffset);
            var cal = System.Globalization.CultureInfo.CurrentCulture.Calendar;
            int firstWeek = cal.GetWeekOfYear(firstThursday, System.Globalization.CalendarWeekRule.FirstFourDayWeek, DayOfWeek.Monday);

            var weekNum = weekOfYear;
            if (firstWeek <= 1)
            {
                weekNum -= 1;
            }
            var result = firstThursday.AddDays(weekNum * 7);
            return result.AddDays(-3);
        }

        private string GetFiltrosAplicadosJsonString(int clienteid, int useridperformance)
        {
            return usuarioRepository.getFiltros(clienteid, useridperformance);
        }

        private Filtros GetFiltrosAplicadosObj(int clienteid, int useridperformance)
        {
            var serializer = new JavaScriptSerializer();
            string jsonfiltros = usuarioRepository.getFiltros(clienteid, useridperformance);
            Filtros filtros = new Filtros();
            if (jsonfiltros != null)
                return serializer.Deserialize<Filtros>(jsonfiltros);
            else
                return null;
        }

        private string GetFiltrosBloqueadosJsonString(int tableroId)
        {
            return filtroRepository.GetFiltrosBloqueados(tableroId);
        }

        private Filtros GetFiltrosBloqueadosObj(int tableroId)
        {
            var serializer = new JavaScriptSerializer();
            string jsonfiltros = filtroRepository.GetFiltrosBloqueados(tableroId);
            Filtros filtros = new Filtros();
            if (jsonfiltros != null)
                return serializer.Deserialize<Filtros>(jsonfiltros);
            else
                return null;
        }

        protected List<FiltroSeleccionado> GetFiltrosAplicadosDeUsuario()
        {
            //Obtengo los Filtros aplicados del usuario
            int clienteId = GetClienteSeleccionado();
            int userId = GetUsuarioLogueado();
            userId = usuarioRepository.GetUsuarioPerformance(userId);

            var filtros = GetFiltrosAplicadosObj(clienteId, userId);

            List<FiltroSeleccionado> filtrosSeleccionados = new List<FiltroSeleccionado>();
            if (filtros != null)
            {
                foreach (FiltroFecha ff in filtros.FiltrosFechas)
                {
                    var nfiltro = new FiltroSeleccionado();
                    nfiltro.TipoFecha = ff.TipoFechaSeleccionada;
                    nfiltro.Filtro = ff.Id;
                    nfiltro.TipoFiltro = TipoFiltro.Fecha;

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
                                mesDesde = System.DateTime.Parse(ff.MesDesde).ToString("yyyyMMdd");

                            if (ff.MesHasta != null)
                                mesHasta = System.DateTime.Parse(ff.MesHasta).AddMonths(1).AddDays(-1).ToString("yyyyMMdd");

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

                foreach (FiltroCheck fc in filtros.FiltrosChecks)
                {
                    var nfiltro = new FiltroSeleccionado();
                    nfiltro.Filtro = fc.Id;
                    nfiltro.TipoFiltro = TipoFiltro.CheckBox;
                    nfiltro.Valores = fc.Items.Where(f => f.Selected).Select(f => f.IdItem).ToArray<string>();

                    if (nfiltro.Valores.Length > 0)
                        filtrosSeleccionados.Add(nfiltro);
                }
            }

            return filtrosSeleccionados;
        }
        protected FiltrosViewModel GetFiltrosAplicadosYBloqueados(int IdModulo, int tableroId)
        {
            int userId = GetUsuarioLogueado();
            userId = usuarioRepository.GetUsuarioPerformance(userId);

            int ClienteId = GetClienteSeleccionado();

            //traigo todos los posibles filtros
            Filtros filtros = filtroRepository.GetFiltros(userId, ClienteId, IdModulo);
            FiltrosViewModel filtrosVM = new FiltrosViewModel();
            foreach (FiltroCheck f in filtros.FiltrosChecks)
            {
                var FiltroVM = new FiltroCheckViewModel();
                foreach (ItemFiltro i in f.Items)
                {
                    FiltroVM.Items.Add(new ItemViewModel() { IdItem = i.IdItem, TipoItem = i.TipoItem, Selected = i.Selected, Descripcion = i.Descripcion.ToUpper() });
                }
                FiltroVM.Id = f.Id;
                FiltroVM.Nombre = Reporting.Resources.Filtros.ResourceManager.GetString(string.Format("{0}", f.Id));
                filtrosVM.FiltrosChecks.Add(FiltroVM);
            }

            foreach (FiltroFecha f in filtros.FiltrosFechas)
            {
                var FiltroVM = new FiltroFechaViewModel();
                FiltroVM.Id = f.Id;
                FiltroVM.Nombre = Reporting.Resources.Filtros.ResourceManager.GetString(string.Format("{0}", f.Id));
                FiltroVM.TipoFechaSeleccionada = "D";
                filtrosVM.FiltrosFechas.Add(FiltroVM);
            }

            List<ReportingFiltroNombreCliente> filtrosConNombre = filtroRepository.getFiltroNombreCliente(ClienteId);
            foreach (ReportingFiltroNombreCliente fnc in filtrosConNombre)
            {
                var filtro = filtrosVM.FiltrosFechas.SingleOrDefault(f => f.Id == fnc.ReportingFiltros.identificador);
                if (filtro != null)
                    filtro.Nombre = fnc.Nombre;
            }
            foreach (ReportingFiltroNombreCliente fnc in filtrosConNombre)
            {
                var filtro = filtrosVM.FiltrosChecks.SingleOrDefault(f => f.Id == fnc.ReportingFiltros.identificador);
                if (filtro != null)
                    filtro.Nombre = fnc.Nombre;
            }

            //Filtros aplicados por el usuario y actualizo dentro de los filtros generales el estado que tienen
            Filtros filtrosSeleccionados = GetFiltrosAplicadosObj(ClienteId, userId);

            if (filtrosSeleccionados != null)
            {
                foreach (FiltroFecha fl in filtrosSeleccionados.FiltrosFechas)
                {
                    var ff = filtrosVM.FiltrosFechas.FirstOrDefault(f => f.Id == fl.Id);
                    if (ff != null)
                    {
                        ff.TipoFechaSeleccionada = fl.TipoFechaSeleccionada;

                        if (fl.DiaDesde != null) ff.DiaDesde = fl.DiaDesde;
                        if (fl.DiaHasta != null) ff.DiaHasta = fl.DiaHasta;

                        if (fl.MesDesde != null) ff.MesDesde = fl.MesDesde;
                        if (fl.MesHasta != null) ff.MesHasta = fl.MesHasta;

                        if (fl.SemanaDesde != null) ff.SemanaDesde = fl.SemanaDesde;
                        if (fl.SemanaHasta != null) ff.SemanaHasta = fl.SemanaHasta;

                        if (fl.TrimestreDesde != null) ff.TrimestreDesde = fl.TrimestreDesde;
                        if (fl.TrimestreHasta != null) ff.TrimestreHasta = fl.TrimestreHasta;
                    }
                }
                foreach (FiltroCheck fl in filtrosSeleccionados.FiltrosChecks)
                {
                    var fc = filtrosVM.FiltrosChecks.FirstOrDefault(f => f.Id == fl.Id);
                    if (fc != null)
                    {
                        foreach (ItemFiltro s in fl.Items)
                        {
                            var itm = fc.Items.FirstOrDefault(i => i.IdItem == s.IdItem);
                            if (itm != null)
                            {
                                itm.Selected = true;
                            }
                        }
                    }
                }
            }
            //Traigo los filtros bloqueados del usuario, si esta en la estructura de filtros generales lo marco como bloqueado
            if (IdModulo == 1 || IdModulo == 2)
            {
                filtrosVM.permitebloquearfiltros = true;
                Filtros filtrosBloqueados = GetFiltrosBloqueadosObj(tableroId);
                if (filtrosBloqueados != null)
                {
                    filtrosVM.isLocked = true;
                    foreach (FiltroCheck fl in filtrosBloqueados.FiltrosChecks)
                    {
                        var fc = filtrosVM.FiltrosChecks.FirstOrDefault(f => f.Id == fl.Id);
                        if (fc != null)
                        {
                            foreach (ItemFiltro s in fl.Items)
                            {
                                var itm = fc.Items.FirstOrDefault(i => i.IdItem == s.IdItem);
                                if (itm != null)
                                {
                                    itm.Selected = true;
                                    itm.isLocked = true;
                                }
                            }
                        }
                    }
                }
            }

            return filtrosVM;
        }

        protected ActionResult AplicarFiltros(FiltrosViewModel filtros, int TableroId, int IdModulo)
        {
            int userId = GetUsuarioLogueado();
            int clienteId = GetClienteSeleccionado();
            userId = usuarioRepository.GetUsuarioPerformance(userId);

            var filtrostotal = new FiltrosViewModel();

            foreach (var ff in filtros.FiltrosFechas)
            {
                if (ff.DiaDesde != null || ff.DiaHasta != null
                    || ff.MesDesde != null || ff.MesHasta != null
                    || ff.SemanaDesde != null || ff.SemanaHasta != null
                    || ff.TrimestreDesde != null || ff.TrimestreHasta != null)
                {
                    filtrostotal.FiltrosFechas.Add(ff);
                }
            }

            if (IdModulo == 1 || IdModulo == 1)
            {
                var filtrosbloqueados = GetFiltrosBloqueadosObj(TableroId);


                if (filtrosbloqueados != null)
                {
                    foreach (var fb in filtrosbloqueados.FiltrosChecks)
                    {
                        var flt = new FiltroCheckViewModel()
                        {
                            Id = fb.Id,
                            Nombre = fb.Nombre
                        };

                        foreach (var itm in fb.Items)
                        {
                            flt.Items.Add(new ItemViewModel()
                            {
                                Descripcion = itm.Descripcion,
                                IdItem = itm.IdItem,
                                isLocked = itm.isLocked,
                                Selected = itm.Selected,
                                TipoItem = itm.TipoItem
                            });
                        }

                        filtrostotal.FiltrosChecks.Add(flt);
                    }
                }
            }

            foreach (var fc in filtros.FiltrosChecks)
            {
                if (fc.Items.Any(i => i.Selected))
                {
                    if (!filtrostotal.FiltrosChecks.Any(f => f.Id == fc.Id))
                    {
                        var newf = new FiltroCheckViewModel(){
                         Id=fc.Id,
                          Nombre=fc.Nombre
                        };

                        foreach (var itm in fc.Items.Where(fcitm => fcitm.Selected))
                        {
                            newf.Items.Add(itm);
                        }

                        filtrostotal.FiltrosChecks.Add(newf);
                    }
                    else
                    {
                        var fd = filtrostotal.FiltrosChecks.FirstOrDefault(fdd => fdd.Id == fc.Id);

                        if (fd != null)
                        {
                            foreach (var itm in fc.Items)
                            {
                                if (!fd.Items.Any(it => it.IdItem == itm.IdItem))
                                {
                                    fd.Items.Add(itm);
                                }
                            }
                        }
                    }
                }
            }


            var serializer = new JavaScriptSerializer();
            string json = new JavaScriptSerializer().Serialize(filtrostotal);
            usuarioRepository.saveFiltros(clienteId, userId, json);

            bool isLocked = false;
            int tabId = -1;

            if (IdModulo == 1 || IdModulo == 2)
            {
                tabId = TableroId;
                isLocked = filtroRepository.IsFiltrosLocked(tabId);
            }

            FiltrosViewModel model = GetFiltrosAplicadosYBloqueados(IdModulo, tabId);
            model.isLocked = isLocked;

            return PartialView("_Filtros", model);
        }

        //public PartialViewResult GetPartialFiltros(int IdModulo, int TableroId)
        //{
        //    FiltrosViewModel model = GetFiltrosAplicadosYBloqueados(IdModulo, TableroId);
        //    bool isLocked = filtroRepository.IsFiltrosLocked(TableroId);
        //    model.isLocked = isLocked;

        //    return PartialView("_FiltrosAplicados", model);
        //}
        protected ActionResult SaveFiltrosLockState(bool filtrosLock, string tableroId, int IdModulo)
        {
            if (User.IsInRole("Administrador") || User.IsInRole("ClienteAdmin"))
            {
                if (tableroId != null)
                {
                    int userId = GetUsuarioLogueado();
                    int clienteId = GetClienteSeleccionado();
                    userId = usuarioRepository.GetUsuarioPerformance(userId);

                    if (filtrosLock)
                    {
                        var filtrosjsonstring = GetFiltrosAplicadosJsonString(clienteId, userId);
                        filtroRepository.SaveFiltrosLockState(int.Parse(tableroId), filtrosjsonstring);
                        filtroRepository.ClearFiltrosAplicados(userId, clienteId);
                    }
                    else
                    {
                        filtroRepository.SaveFiltrosLockState(int.Parse(tableroId), null);
                    }
                }
            }

            var filtros = GetFiltrosAplicadosYBloqueados(IdModulo, int.Parse(tableroId));
            filtros.isLocked = filtrosLock;
            return PartialView("_Filtros", filtros);
        }
        //private JsonResult IsFiltrosLocked(string tableroId)
        //{
        //    int tabId = -1;
        //    bool isLocked = false;

        //    if (tableroId != null)
        //    {
        //        tabId = Int32.Parse(tableroId);
        //        isLocked = filtroRepository.IsFiltrosLocked(tabId);
        //    }

        //    return Json(isLocked, JsonRequestBehavior.AllowGet);
        //}

        //[HttpPost]
        //public bool TienePermisos()
        //{
        //    int ClienteId = GetClienteSeleccionado();
        //    int userId = GetUsuarioLogueado();
        //    userId = usuarioRepository.GetUsuarioPerformance(userId);
        //    var rolesUsuario = usuarioRepository.getRolesDeUsuario(ClienteId, userId);
        //    var tienePermisos = false;

        //    foreach (var roles in rolesUsuario)
        //    {
        //        tienePermisos = roles.ReportingRolPermisos.Any(a => a.idPermiso == 2 || a.idPermiso == 9);
        //    }

        //    return tienePermisos;
        //}

        public PartialViewResult GetLogo()
        {
            int clienteId = GetClienteSeleccionado();
            string model = "images/logo.png";

            if (clienteId != 0 && clienteRepository.TieneMarcaBlanca(clienteId))
            {
                Cliente cliente = clienteRepository.GetDatosMarcaBlanca(clienteId);

                ViewBag.marcaBlanca = true;
                ViewBag.marcaBlancaToken = cliente.hashCliente;
                ViewBag.marcaBlancaLink = cliente.link;

                if (System.IO.File.Exists(Server.MapPath(string.Format("~/ContentClientes/{0}/MarcaBlanca/logo.jpg", cliente.hashCliente))))
                {
                    model = string.Format("ContentClientes/{0}/MarcaBlanca/logo.jpg", cliente.hashCliente);
                }
            }

            return PartialView("_Logo", model);
        }
        public PartialViewResult GetEncabezadoMarcaBlanca()
        {
            int clienteId = GetClienteSeleccionado();
            bool model = false;

            if (clienteId != 0 && clienteRepository.TieneMarcaBlanca(clienteId))
            {
                Cliente cliente = clienteRepository.GetDatosMarcaBlanca(clienteId);

                ViewBag.marcaBlanca = true;
                ViewBag.marcaBlancaToken = cliente.hashCliente;
                ViewBag.marcaBlancaLink = cliente.link;

                if (System.IO.File.Exists(Server.MapPath(string.Format("~/ContentClientes/{0}/MarcaBlanca/fondo.jpg", cliente.hashCliente))))
                {
                    model = true;
                }
            }

            return PartialView("_EncabezadoMarcaBlanca", model);
        }
        public PartialViewResult GetFooterMarcaBlanca()
        {
            int clienteId = GetClienteSeleccionado();
            bool model = false;

            if (clienteId != 0 && clienteRepository.TieneMarcaBlanca(clienteId))
            {
                Cliente cliente = clienteRepository.GetDatosMarcaBlanca(clienteId);

                ViewBag.marcaBlanca = true;
                ViewBag.marcaBlancaToken = cliente.hashCliente;
                ViewBag.marcaBlancaLink = cliente.link;

                if (System.IO.File.Exists(Server.MapPath(string.Format("~/ContentClientes/{0}/MarcaBlanca/footer.jpg", cliente.hashCliente))))
                {
                    model = true;
                }
            }

            return PartialView("_FooterMarcaBlanca", model);
        }

        [OutputCache(Duration = 1800, Location = System.Web.UI.OutputCacheLocation.Client, NoStore = true)]
        public PartialViewResult GetImgPerfil()
        {
            int userId = GetUsuarioLogueado();
            string imagen = usuarioRepository.GetImagenUsuario(userId);
            
            return PartialView("_ImagenPerfil", imagen);
            //return PartialView("_ImagenPerfil", userId.ToString());
        }
    }
}