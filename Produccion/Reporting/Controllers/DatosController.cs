using System.Collections.Generic;
using System.Linq;
using System.Web.Mvc;
using Reporting.Domain.Abstract;
using Reporting.ViewModels;
using Reporting.Domain.Entities;
using System;
using System.Web;
using System.IO;
using Reporting.Filters;

namespace Reporting.Controllers
{
    [Autorizar(Permiso = "verDatos")]
    public class DatosController : BaseController
    {
        private readonly int IdModulo;
        public DatosController(IUsuarioRepository usuarioRepository, IDatosRepository datosRepository, IClienteRepository clienteRepository, IFiltroRepository filtroRepository, ICommonRepository commonRepository, ITableroRepository tableroRepository)
        {
            this.IdModulo = 2;
            this.usuarioRepository = usuarioRepository;
            this.datosRepository = datosRepository;
            this.clienteRepository = clienteRepository;
            this.filtroRepository = filtroRepository;
            this.commonRepository = commonRepository;
            this.tableroRepository = tableroRepository;
        }

        public ActionResult Mostrar(int Id)
        {
            TempData["TablaId"] = Id;
            return RedirectToAction("Index");
        }
        public ActionResult Index()
        {
            int Id;
            try
            {
                Id = int.Parse(TempData["TablaId"].ToString());
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
                int tableroDefault = datosRepository.GetTableroIdDefault(userId, clienteId);
                if (tableroDefault == 0)
                {
                    return View("NoTieneTablas");
                }
                else
                {
                    Id = tableroDefault;
                }
            }

            DatosViewModel model = new DatosViewModel();
            List<Tab> tabs = datosRepository.GetTabs(clienteId).ToList();

            if (tabs.Count == 0)
            {
                return View("NoTieneTablas");
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
        public JsonResult GetTabs()
        {
            int ClienteId = GetClienteSeleccionado();
            IEnumerable<Tab> Tabs = datosRepository.GetTabs(ClienteId);
            List<TabViewModel> model = new List<TabViewModel>();
            foreach (Tab t in Tabs)
            {
                model.Add(new TabViewModel() { Id = t.Id, Titulo = t.Titulo });
            }
            return Json(model, JsonRequestBehavior.AllowGet);
        }
        public PartialViewResult GetObjetos(int TableroId)
        {
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

            ObjetosDeTableroViewModel model = new ObjetosDeTableroViewModel();
            var objetos = datosRepository.GetObjetosDeTablero(TableroId);
            List<ObjetoViewModel> objetosVM = new List<ObjetoViewModel>();
            foreach (ReportingTableroObjeto o in objetos)
            {
                var objVM = new ObjetoViewModel() { Id = o.IdObjeto, Orden = o.Orden, TextoFooter = o.ReportingObjeto.ReportingFamiliaObjeto.Nombre, TextoHeader = o.ReportingObjeto.ReportingFamiliaObjeto.Nombre, Tipo = (int)o.ReportingObjeto.TipoChart, dataLabels = o.FlgDataLabel, stackLabels = o.StackLabel };
                objVM.Size = "col-xs-12 col-sm-12 col-md-12 col-lg-12";
                objVM.Descripcion = tableroRepository.GetDescripcionObjeto(o.IdObjeto, cultureName.Split('-')[0]);
                objetosVM.Add(objVM);
            }

            model.TableroId = TableroId;
            model.Objetos = objetosVM;
            return PartialView("_tabla", model);
        }
        public JsonResult GetDataTablaJson(int ObjetoId, int Page = 0)
        {
            var chart = GetDataGrafico(ObjetoId, Page);

            var jsonData = Json(chart, JsonRequestBehavior.AllowGet);
            jsonData.MaxJsonLength = Int32.MaxValue;

            return jsonData;
        }
        private Chart GetDataGrafico(int ObjetoId, int page = 0)
        {
            int userId = GetUsuarioLogueado();
            userId = usuarioRepository.GetUsuarioPerformance(userId);

            int ClienteId = GetClienteSeleccionado();

            var filtrosSeleccionados = GetFiltrosAplicadosDeUsuario();

            Chart chart = datosRepository.GetDataObjeto(filtrosSeleccionados, ClienteId, ObjetoId, page, userId, 24);

            return chart;
        }

        [AllowAnonymous]
        [HttpPost]
        public string DescargarDatos(int ObjetoId)
        {

            var filtrosSeleccionados = new List<FiltroSeleccionado>();


            int userId = GetUsuarioLogueado();
            userId = usuarioRepository.GetUsuarioPerformance(userId);

            int ClienteId = GetClienteSeleccionado();

            int tableroid = datosRepository.GetIdTableroByObjetoUser(ObjetoId, userId);
            if(tableroid == 0)
            {
                tableroid = datosRepository.GetIdTableroByObjetoUser2(ObjetoId, userId);
            }
            int IdModulo = datosRepository.GetModuloTablero(tableroid);
            bool filtroBloqueado = datosRepository.ExistsFiltroPorTablero(tableroid);
            if (tableroid != 0 && filtroBloqueado)
            {                
                filtrosSeleccionados = GetListFiltrosAplicadosPorTablero(IdModulo, tableroid);
                var filtros = GetFiltrosAplicadosPorTablero(IdModulo, tableroid);

                
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

                        if (nfiltro.Valores.Length > 0 && !filtrosSeleccionados.Any(f => f.TipoFiltro == nfiltro.TipoFiltro && f.Filtro == nfiltro.Filtro))
                            filtrosSeleccionados.Add(nfiltro);
                        
                    }
                }
            }
            else
            {
                filtrosSeleccionados = GetFiltrosAplicadosDeUsuario();
            }

            string _token = datosRepository.GenerarArchivo(filtrosSeleccionados, ClienteId, ObjetoId, userId);
            if (string.IsNullOrEmpty(_token))
                return string.Empty;
            else
                return _token;

        }
        [AllowAnonymous]
        public void DownloadFileByToken(string token, bool fc = false)
        {
            string path = AppDomain.CurrentDomain.BaseDirectory;
            string filename = token + (fc?".xlsx":".csv");
            string newfilepath = Path.Combine(path, "Temp", filename);

            if (System.IO.File.Exists(newfilepath) == false)
            {
                filename = token + ".xlsx";
                newfilepath = Path.Combine(path, "Temp", filename);
                if (System.IO.File.Exists(newfilepath) == false)
                {
                    Response.Close();
                    return;
                }
            }
            
            Stream oStream = null;

            try
            {
                oStream = new FileStream
                        (path: newfilepath,
                        mode: FileMode.Open,
                        share: FileShare.Read,
                        access: FileAccess.Read);

                Response.Buffer = false;

                Response.ContentType = "application/octet-stream";

                Response.AddHeader("Content-Disposition", "");

                long lngFileLength = oStream.Length;

                Response.AddHeader("Content-Length", lngFileLength.ToString());

                long lngDataToRead = lngFileLength;

                while (lngDataToRead > 0)
                {
                    if (Response.IsClientConnected)
                    {
                        int intBufferSize = 8 * 1024;

                        byte[] bytBuffers =
                            new System.Byte[intBufferSize];

                        int intTheBytesThatReallyHasBeenReadFromTheStream =
                            oStream.Read(buffer: bytBuffers, offset: 0, count: intBufferSize);

                        Response.OutputStream.Write
                            (buffer: bytBuffers, offset: 0,
                            count: intTheBytesThatReallyHasBeenReadFromTheStream);

                        Response.Flush();

                        lngDataToRead =
                            lngDataToRead - intTheBytesThatReallyHasBeenReadFromTheStream;
                    }
                    else
                    {
                        lngDataToRead = -1;
                    }
                }
            }
            catch { }
            finally
            {
                if (oStream != null)
                {
                    oStream.Close();
                    oStream.Dispose();
                    oStream = null;
                }
                Response.Close();
                datosRepository.EliminarArchivo(token,fc);
            }
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


        [HttpPost]
        public JsonResult GetFiltroAutocomplete(string identificador, string texto, int ClienteId = 0)
        {
            if (ClienteId == 0)
            {
                ClienteId = GetClienteSeleccionado();
            }

            FiltroCheck filtro = new FiltroCheck();
            
            filtro = filtroRepository.GetTopFiltro(ClienteId, identificador, texto);

            return Json(filtro.Items, JsonRequestBehavior.AllowGet);
        }
    }
}