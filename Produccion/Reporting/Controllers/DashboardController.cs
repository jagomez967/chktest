using System.Collections.Generic;
using System.Linq;
using System.Web.Mvc;
using Reporting.Domain.Abstract;
using Microsoft.AspNet.Identity;
using Reporting.Domain.Entities;
using Reporting.ViewModels;
using System;

namespace Reporting.Controllers
{
    public class DashboardController : Controller
    {
        IDashboardRepository dashboardRepository;
        IClienteRepository clienteRepository;
        IUsuarioRepository usuarioRepository;
        ITableroRepository tableroRepository;
        public DashboardController(IDashboardRepository dashboardRepository, IClienteRepository clienteRepository, IUsuarioRepository usuarioRepository, ITableroRepository tableroRepository)
        {
            this.dashboardRepository = dashboardRepository;
            this.clienteRepository = clienteRepository;
            this.usuarioRepository = usuarioRepository;
            this.tableroRepository = tableroRepository;
        }
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
            int userId = GetUsuarioLogueado();

            var tableroDefault = tableroRepository.GetTableroIdOrDefault(Id, userId, clienteId);
            if (tableroDefault == null)
                return View("NoTieneTableros");
            else
                return View(tableroDefault.Id);
        }
        private int GetClienteSeleccionado()
        {
            if (Session["ClientesUsuarios"] == null)
                SetClienteSeleccionado(0);

            int userId = GetUsuarioLogueado();

            var dict = (Dictionary<int, int>)Session["ClientesUsuarios"];

            if (!dict.ContainsKey(userId))
                SetClienteSeleccionado(0);

            return dict[userId];
        }
        private int GetUsuarioLogueado()
        {
            int userId = User.Identity.GetUserId<int>();
            userId = usuarioRepository.GetUsuarioPerformance(userId);
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
            var dict = (Dictionary<int, int>)Session["ClientesUsuarios"];

            if (dict.ContainsKey(userId))
                dict.Remove(userId);

            if (clienteId == 0)
            {
                var clienteSel = clienteRepository.GetClientes(userId).FirstOrDefault();
                if (clienteSel == null)
                {
                    dict.Add(userId, 0);
                }
                else
                {
                    dict.Add(userId, clienteSel.IdCliente);
                }
            }
            else
            {
                dict.Add(userId, clienteId);
            }
        }
        public ActionResult MostrarTablero(int Id)
        {
            TempData["TableroId"] = Id;
            return RedirectToAction("Index");
        }
        [HttpPost]
        public JsonResult GetTabs()
        {
            int userId = GetUsuarioLogueado();
            int ClienteId = GetClienteSeleccionado();
            IEnumerable<Tab> Tabs = tableroRepository.GetTabs(userId, ClienteId);
            List<TabViewModel> model = new List<TabViewModel>();

            foreach (Tab t in Tabs)
            {
                model.Add(new TabViewModel() { Id = t.Id, Titulo = t.Titulo });
            }
            return Json(model, JsonRequestBehavior.AllowGet);
        }
        [HttpPost]
        public JsonResult GetFiltrosJson()
        {
            int userId = GetUsuarioLogueado();
            int ClienteId = GetClienteSeleccionado();
            IEnumerable<Filtro> filtros = tableroRepository.GetFiltros(0, userId, ClienteId);
            FiltrosViewModel filtrosVM = new FiltrosViewModel();

            foreach (Filtro f in filtros.Where(m => m.TipoFiltro == TipoFiltro.CheckBox))
            {
                var FiltroVM = new FiltroCheckViewModel();
                foreach (Item i in f.Items)
                {
                    FiltroVM.Items.Add(new ItemViewModel() { IdItem = i.IdItem, TipoItem = i.TipoItem, Selected = i.Selected, Descripcion = i.Descripcion.ToUpper() });
                }
                FiltroVM.Id = f.Id;
                FiltroVM.Nombre = f.Nombre;
                filtrosVM.FiltrosChecks.Add(FiltroVM);
            }

            foreach (Filtro f in filtros.Where(m => m.TipoFiltro == TipoFiltro.Fecha))
            {
                var FiltroVM = new FiltroFechaViewModel();

                foreach (Item i in f.Anios)
                {
                    FiltroVM.Anios.Add(new ItemDropDownListViewModel() { Value = i.IdItem, Descripcion = i.Descripcion });
                }
                foreach (Item i in f.Meses)
                {
                    FiltroVM.Meses.Add(new ItemDropDownListViewModel() { Value = i.IdItem, Descripcion = i.Descripcion, ParentValue = i.IdParent });
                }
                foreach (Item i in f.Semanas)
                {
                    FiltroVM.Semanas.Add(new ItemDropDownListViewModel() { Value = i.IdItem, Descripcion = i.Descripcion, ParentValue = i.IdParent });
                }
                foreach (Item i in f.Trimestres)
                {
                    FiltroVM.Trimestres.Add(new ItemDropDownListViewModel() { Value = i.IdItem, Descripcion = i.Descripcion, ParentValue = i.IdParent });
                }
                FiltroVM.Id = f.Id;
                FiltroVM.Nombre = f.Nombre;
                filtrosVM.FiltrosFechas.Add(FiltroVM);
            }
            return Json(filtrosVM, JsonRequestBehavior.AllowGet);
        }
        [HttpPost]
        public PartialViewResult GetObjetos(int TableroId)
        {
            ObjetosDeTableroViewModel model = new ObjetosDeTableroViewModel();
            var objetos = tableroRepository.GetObjetosDeTablero(TableroId);
            List<ObjetoViewModel> objetosVM = new List<ObjetoViewModel>();
            foreach (TableroObjeto o in objetos)
            {
                var objVM = new ObjetoViewModel() { Id = o.ObjetoId, Orden = o.Orden, TextoFooter = o.Objeto.TextoFooter, TextoHeader = o.Objeto.TextoHeader, Tipo = (int)o.Objeto.Tipo, dataLabels = o.dataLabels, stackLabels = o.stackLabels };

                switch (o.Size)
                {
                    case "S":
                        objVM.Size = "col-xs-12 col-sm-4 col-md-4 col-lg-4";
                        break;
                    case "M":
                        objVM.Size = "col-xs-12 col-sm-8 col-md-8 col-lg-8";
                        break;
                    case "L":
                        objVM.Size = "col-xs-12 col-sm-12 col-md-12 col-lg-12";
                        break;
                }

                objetosVM.Add(objVM);
            }

            model.TableroId = TableroId;
            model.Objetos = objetosVM;
            return PartialView("_ObjetosTablero", model);
        }
        private Chart GetDataGrafico(List<FiltroSeleccionadoViewModel> Filtros, int ObjetoId)
        {
            int userId = GetUsuarioLogueado();
            int ClienteId = GetClienteSeleccionado();
            DateTime fechaDesde = DateTime.MinValue;
            DateTime fechaHasta = DateTime.MinValue;

            List<FiltroSeleccionado> filtrosSeleccionados = new List<FiltroSeleccionado>();
            foreach (FiltroSeleccionadoViewModel fsvm in Filtros)
            {
                switch (fsvm.TipoFecha)
                {
                    case "D":
                        if (!string.IsNullOrEmpty(fsvm.Valores[0]))
                            fechaDesde = DateTime.Parse(fsvm.Valores[0]);

                        if (!string.IsNullOrEmpty(fsvm.Valores[1]))
                            fechaHasta = DateTime.Parse(fsvm.Valores[1]);

                        fsvm.Valores = new string[] { fsvm.TipoFecha, fechaDesde.ToString("yyyyMMdd"), fechaHasta.ToString("yyyyMMdd") };
                        break;
                    case "M":
                        if (!string.IsNullOrEmpty(fsvm.Valores[0]) && !string.IsNullOrEmpty(fsvm.Valores[1]) && !string.IsNullOrEmpty(fsvm.Valores[2]) && !string.IsNullOrEmpty(fsvm.Valores[3]))
                        {
                            fechaDesde = new DateTime(int.Parse(fsvm.Valores[0]), int.Parse(fsvm.Valores[2]), 1);
                            fechaHasta = new DateTime(int.Parse(fsvm.Valores[1]), int.Parse(fsvm.Valores[3]), DateTime.DaysInMonth(int.Parse(fsvm.Valores[3]), int.Parse(fsvm.Valores[3])));
                            fsvm.Valores = new string[] { fsvm.TipoFecha, fechaDesde.ToString("yyyyMMdd"), fechaHasta.ToString("yyyyMMdd") };
                        }
                        break;
                    case "S":
                        if (!string.IsNullOrEmpty(fsvm.Valores[0]) && !string.IsNullOrEmpty(fsvm.Valores[1]) && !string.IsNullOrEmpty(fsvm.Valores[2]) && !string.IsNullOrEmpty(fsvm.Valores[3]))
                        {
                            fechaDesde = new DateTime(int.Parse(fsvm.Valores[0]), 1, 1).AddDays(7 * (int.Parse(fsvm.Valores[2]) - 1));
                            fechaHasta = new DateTime(int.Parse(fsvm.Valores[1]), 1, 1).AddDays(7 * (int.Parse(fsvm.Valores[3]) - 1));
                            fsvm.Valores = new string[] { fsvm.TipoFecha, fechaDesde.ToString("yyyyMMdd"), fechaHasta.ToString("yyyyMMdd") };
                        }
                        break;
                    case "T":
                        if (!string.IsNullOrEmpty(fsvm.Valores[0]) && !string.IsNullOrEmpty(fsvm.Valores[1]) && !string.IsNullOrEmpty(fsvm.Valores[2]) && !string.IsNullOrEmpty(fsvm.Valores[3]))
                        {
                            fechaDesde = new DateTime(int.Parse(fsvm.Valores[0]), int.Parse(fsvm.Valores[2]) * 3 - 2, 1);
                            fechaHasta = new DateTime(int.Parse(fsvm.Valores[1]), int.Parse(fsvm.Valores[3]) * 3, DateTime.DaysInMonth(int.Parse(fsvm.Valores[3]), int.Parse(fsvm.Valores[3]) * 3));
                            fsvm.Valores = new string[] { fsvm.TipoFecha, fechaDesde.ToString("yyyyMMdd"), fechaHasta.ToString("yyyyMMdd") };
                        }
                        break;
                }

                filtrosSeleccionados.Add(new FiltroSeleccionado() { Filtro = fsvm.Filtro, Valores = fsvm.Valores, Tipo = fsvm.TipoFecha });
            }

            Chart chart = tableroRepository.GetDataObjeto(filtrosSeleccionados, ObjetoId, ClienteId);

            return chart;
        }
        [HttpPost]
        public JsonResult GetDataGraficoJson(List<FiltroSeleccionadoViewModel> Filtros, int ObjetoId)
        {
            var chart = GetDataGrafico(Filtros, ObjetoId);

            return Json(chart, JsonRequestBehavior.AllowGet);
        }
    }
}