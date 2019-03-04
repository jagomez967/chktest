using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.Mvc;
using Reporting.ViewModels;
using Reporting.Domain.Abstract;
using Reporting.Domain.Entities;
using Reporting.Filters;

namespace Reporting.Controllers
{
    [Autorizar(Permiso = "verMapas")]
    public class GeoController : BaseController
    {
        private readonly int IdModulo;
        public GeoController(IGeoRepository geoRepository, IUsuarioRepository usuarioRepository, IClienteRepository clienteRepository, IFiltroRepository filtroRepository, ICommonRepository commonRepository, ITableroRepository tableroRepository, IImagenesRepository imagenesRepository)
        {
            IdModulo = 4;
            this.geoRepository = geoRepository;
            this.usuarioRepository = usuarioRepository;
            this.clienteRepository = clienteRepository;
            this.filtroRepository = filtroRepository;
            this.commonRepository = commonRepository;
            this.tableroRepository = tableroRepository;
            this.imagenesRepository = imagenesRepository;
        }
        public ActionResult Index()
        {
            int tableroId = -1;
            int clienteId = GetClienteSeleccionado();
            if (clienteId == 0)
                return PartialView("UsuarioSinClientes");

            if (!commonRepository.tieneFiltrosAsignados(IdModulo, clienteId))
                return View("_NoTieneFiltros");

            FiltrosViewModel model = GetFiltrosAplicadosPorTablero(IdModulo, tableroId);

            if (model.FiltrosFechas.Count > 0)
            {
                model.FiltrosFechas.First().DiaDesde = DateTime.Now.ToString("yyyy-MM-01");
                model.FiltrosFechas.First().DiaHasta = DateTime.Now.ToString("yyyy-MM-dd");
            }

            return View("UnifiedMap", model);
        }

        [HttpPost]
        public JsonResult GetPDVsCliente()
        {
            MarkersViewModel model = new MarkersViewModel
            {
                Markers = geoRepository.GetMarkersCoberturaCliente(
                                        GetFiltrosAplicadosDeUsuario(),
                                        GetClienteSeleccionado())
                            .Select(m => new GeoMarkerViewModel()
                            {
                                position = new GeoPosViewModel(m.lat, m.lng),
                                icon = m.icon,
                                visitado = m.visitado,
                                ultimoReporte = m.ultimoReporte,
                                idPuntoDeVenta = m.idPuntoDeVenta,
                                usuario = m.usuario,
                            }).ToList()
            };

            return Json(model, JsonRequestBehavior.AllowGet);
        }

        [HttpPost]
        public JsonResult GetRutaDeUsuario(int idUsuario, string FechaHoy)
        {
            GeoRuta datos = geoRepository.GetRutaDeUsuario(FechaHoy, idUsuario, GetClienteSeleccionado());

            var _geoRuta = datos.ruta
                           .Select(r => new GeoPosViewModel(r.lat, r.lng, r.label))
                           .ToList();

            var _geoMarker = datos.marcadores
                            .Select(m => new GeoMarkerViewModel() {
                                position = new GeoPosViewModel(m.lat, m.lng),
                                icon = m.icon,
                                visitado = m.visitado,
                                label = m.label,
                                idReporte = m.idReporte,
                                fecha = m.fecha,
                                operacion = m.operacion,
                                categoria = m.categoria,
                            }).ToList();

            GeoRutaViewModel model = new GeoRutaViewModel()
            {
                marcadores = _geoMarker,
                ruta = _geoRuta
            };
            return Json(model, JsonRequestBehavior.AllowGet);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult AplicarFiltros([ModelBinder(typeof(Binders.FiltrosModelBinder))] FiltrosViewModel filtros)
        {
            return AplicarFiltros(filtros, -1, IdModulo);
        }

        [HttpPost]
        public PartialViewResult GetFiltrosPartialSimpleLayout()
        {
            return PartialView("_FiltroSimple", GetFiltrosAplicadosPorTablero(IdModulo, -1));
        }

        [HttpPost]
        public JsonResult GetUsuariosCliente()
        {
            List<UsuarioSeguimientoViewModel> model = geoRepository.GetUsuariosCliente(GetFiltrosAplicadosDeUsuario(), GetClienteSeleccionado())
                        .Select(m => new UsuarioSeguimientoViewModel(m.IdUsuario, m.Apellido + ", " + m.Nombre, m.imagen))
                        .ToList();

            return Json(model, JsonRequestBehavior.AllowGet);
        }

        [HttpPost]
        public JsonResult GetClienteDifHora()
        {
            int diferenciaHoraria = geoRepository.GetDiferenciaHorariaCliente(GetClienteSeleccionado());
            return Json(diferenciaHoraria, JsonRequestBehavior.AllowGet);
        }

        [HttpPost]
        public PartialViewResult GetInfoWindowReporte(int idReporte)
        {
            GeoInfoReport model = new GeoInfoReport(geoRepository.GetInfoReporte(idReporte)); 
            return PartialView("_InfoWindowDetailReport", model);
        }

        [HttpPost]
        public PartialViewResult GetInfoPuntoDeVenta(int idPuntoDeVenta, string ultimoReporte = "", string usuarioReporte = "")
        {
            GeoInfoPdvVM model = new GeoInfoPdvVM(geoRepository.GetInfoPDV(idPuntoDeVenta))
            {
                IdPDV = idPuntoDeVenta,
                LastReportUser = usuarioReporte,
                LastReportDate = ultimoReporte
            };

            return PartialView("_InfoWindowDetailPDV", model);
        }

        [HttpPost]
        public PartialViewResult GetLastImagesFromPDV(int idPuntoDeVenta)
        {
            return PartialView("_InfoWindowsPhotosPDV", imagenesRepository.GetLastPhotosPDV(idPuntoDeVenta));
        }

        [HttpPost]
        public PartialViewResult GetImagesFromReport(int idReporte)
        {
            return PartialView("_InfoWindowsPhotosPDV", imagenesRepository.GetPhotosReport(idReporte));
        }

        [HttpPost]
        public PartialViewResult GetLastReportsFromPDV(int idPuntoDeVenta)
        {
            List<ReportDetailVM> model = geoRepository.GetDetailsReportsPDV(GetFiltrosAplicadosDeUsuario(), idPuntoDeVenta)
                                            .Select(m => 
                                                 new ReportDetailVM(m.UserName, 
                                                        (m.UserIMG == string.Empty ? string.Empty : "data:image;base64," + m.UserIMG),
                                                        m.ReportId,
                                                        m.Date))
                                            .ToList();

            return PartialView("_InfoWindowListReport", model);
        }

        [HttpPost]
        public PartialViewResult GetListUserTracking(string date)
        {
            Dictionary<int, string> model = geoRepository.GetUsuariosDeRuteo(date, GetClienteSeleccionado())
                                            .Select(u => new KeyValuePair<int, string>(u.IdUsuario, u.Nombre + ' ' + u.Apellido))
                                            .ToDictionary(x => x.Key, x => x.Value);

            return PartialView("_ListClientUserMap", model);
        }

        public PartialViewResult GetSignatureFromReport(int idReporte)
        {
            return PartialView("_ReportSignatureImage", geoRepository.GetSignatureReport(idReporte));
        }
    }
}