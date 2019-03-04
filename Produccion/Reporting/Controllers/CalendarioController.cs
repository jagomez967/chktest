using Reporting.Domain.Abstract;
using Reporting.Domain.Entities;
using Reporting.Filters;
using Reporting.ViewModels;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace Reporting.Controllers
{
    public class CalendarioController : BaseController
    {
        private readonly int IdModulo;
        public CalendarioController(ITableroRepository tableroRepository, IUsuarioRepository usuarioRepository, IClienteRepository clienteRepository, IFiltroRepository filtroRepository, ICommonRepository commonRepository, IAbmsRepository abmsRepository)
        {
            IdModulo = 6;
            this.usuarioRepository = usuarioRepository;
            this.clienteRepository = clienteRepository;
            this.abmsRepository = abmsRepository;
        }

        // GET: Calendario
        [Autorizar(Permiso = "verCalendario")]
        public ActionResult Index()
        {
            return View();
        }

        [HttpPost]
        [Autorizar(Permiso = "verCalendario")]
        public JsonResult GetEventsCalendar(string start, string end)
        {
            int clienteId = GetClienteSeleccionado();
            if (clienteId == 0)
                return Json("", JsonRequestBehavior.AllowGet);


            List<Calendario> eventos = new List<Calendario>();

            eventos = usuarioRepository.GetEventosCalendario(clienteId, DateTime.Parse(start), DateTime.Parse(end));
            
            var modelower = eventos.Select(e => new { id = e.Id, start = e.FechaInicio, stick = true, end = e.FechaInicio, idpdv = e.IdPuntoDeVenta, idusuario = e.IdUsuario, nombreusuario = string.Format("{0}, {1}", e.Usuario.Apellido.Trim(), e.Usuario.Nombre.Trim()), nombrepdv = e.PuntoDeVenta.Nombre });

            return Json(modelower, JsonRequestBehavior.AllowGet);
        }

        [HttpPost]
        [Autorizar(Permiso = "verCalendario")]
        public PartialViewResult GetEventsListado(int idUsuario,string fechaDesde, string fechaHasta)
        {
            int? UserId = idUsuario;
            int clienteId = GetClienteSeleccionado();
            if (clienteId == 0)
                return null;

            if (idUsuario <= 0)
            {
                UserId = null;
            }

            List<Calendario> eventos = new List<Calendario>();

            string cultureName;

            HttpCookie cultureCookie = Request.Cookies["_culture"];
            if (cultureCookie != null)
            {
                cultureName = cultureCookie.Value;
            }
            else
            {
                cultureName = Request.UserLanguages != null && Request.UserLanguages.Length > 0 ? Request.UserLanguages[0] : null;
            }

            if (String.IsNullOrEmpty(fechaDesde))
            {
                fechaDesde = (new DateTime(DateTime.Today.Year, DateTime.Today.Month, 1)).ToString("dd'/'MM'/'yyyy");
            }
            if (String.IsNullOrEmpty(fechaHasta))
            {
                fechaHasta = (DateTime.Today).ToString("dd'/'MM'/'yyyy");
            }

            eventos = usuarioRepository.GetEventosCalendario(clienteId,DateTime.Parse(fechaDesde), DateTime.Parse(fechaHasta).AddDays(1), UserId);
                       
            List<EventoCalendarioVM> model = new List<EventoCalendarioVM>();

            foreach (var c in eventos.OrderBy(e => e.Usuario.Apellido).ThenBy(e => e.FechaInicio))
            {
                model.Add(new EventoCalendarioVM()
                {
                    Id = c.Id,
                    Concepto = (c.Concepto != null) ? c.Concepto.Descripcion : string.Empty,
                    Date = c.FechaInicio,
                    NombreUsuario = c.Usuario.Apellido + " " + c.Usuario.Nombre,
                    NombrePuntoDeVenta = c.PuntoDeVenta.Nombre,
                    DireccionPuntoDeVenta = c.PuntoDeVenta.Direccion,
                    IdPuntoDeVenta = c.IdPuntoDeVenta,
                    Observaciones = c.Observaciones,
                    IdUsuario = c.IdUsuario,
                    Localidad = eventos.Single(cc => cc.Id == c.Id).PuntoDeVenta.Localidad.Nombre
            });
            }

            return PartialView("_TablaListado", model);
        }


        [Autorizar(Permiso = "crearCalendario")]
        public ActionResult Crear()
        {
            EventoVM model = new EventoVM();
            var usuarios = usuarioRepository.GetUsuariosByCliente(GetClienteSeleccionado(), false);

            foreach (var u in usuarios)
            {
                model.Usuarios.Add(new SelectListItem() { Value = u.IdUsuario.ToString(), Text = u.Apellido + ", " + u.Nombre });
            }

            var conceptos = usuarioRepository.GetConceptosCalendario(GetClienteSeleccionado());
            foreach (var c in conceptos)
            {
                model.Conceptos.Add(new SelectListItem() { Value = c.Id.ToString(), Text = c.Descripcion });
            }

            return View(model);
        }


        [Autorizar(Permiso = "verCalendario")]
        public ActionResult Listado()
        {
            int clienteId = GetClienteSeleccionado();
            if (clienteId == 0)
                return Json("", JsonRequestBehavior.AllowGet);

            ListadoEventosVM model = new ListadoEventosVM();

            var usuarios = usuarioRepository.GetUsuariosByCliente(GetClienteSeleccionado(), false);
            model.Usuarios.Add(new SelectListItem() { Value = "0", Text = "Todos los Usuarios" });
            foreach (var u in usuarios)
            {
                model.Usuarios.Add(new SelectListItem() { Value = u.IdUsuario.ToString(), Text = u.Apellido + ", " + u.Nombre });
            }

            return View(model);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        [Autorizar(Permiso = "crearCalendario")]
        public ActionResult Crear(EventoVM model)
        {

            if (model.EventTime == null)
            {
                model.EventTime = new TimeSpan();
            }

            if (!ModelState.IsValid)
            {
                var usuarios = usuarioRepository.GetUsuariosByCliente(GetClienteSeleccionado(), false);
                foreach (var u in usuarios)
                {
                    model.Usuarios.Add(new SelectListItem() { Value = u.IdUsuario.ToString(), Text = u.Apellido + ", " + u.Nombre });
                }

                var conceptos = usuarioRepository.GetConceptosCalendario(GetClienteSeleccionado());
                foreach (var c in conceptos)
                {
                    model.Conceptos.Add(new SelectListItem() { Value = c.Id.ToString(), Text = c.Descripcion });
                }


                return View(model);
            }

            Calendario evento = new Calendario
            {
                IdCliente = GetClienteSeleccionado(),
                FechaInicio = model.EventDate + model.EventTime,
                IdPuntoDeVenta = model.IdPuntoDeVenta,
                IdUsuario = model.IdUsuario,
                ConceptoId = model.ConceptoId,
                Observaciones = model.Observaciones,
                CodigoEvento = model.CodigoEvento
            };

            usuarioRepository.CrearEventoCalendario(evento, GetClienteSeleccionado());

            return RedirectToAction("Index", "Calendario");
        }


        [Autorizar(Permiso = "editarCalendario")]
        public ActionResult Editar(int id)
        {
            if (id <= 0)
            {
                return new HttpNotFoundResult();
            }

            var evento = usuarioRepository.GetEventoById(GetClienteSeleccionado(), id);

            if (evento == null)
            {
                return new HttpNotFoundResult();
            }

            EventoVM model = new EventoVM
            {
                ConceptoId = evento.ConceptoId,
                EventDate = evento.FechaInicio.Date,
                EventTime = evento.FechaInicio.TimeOfDay,
                Id = evento.Id,
                IdPuntoDeVenta = evento.IdPuntoDeVenta,
                IdUsuario = evento.IdUsuario,
                Observaciones = evento.Observaciones,
                CodigoEvento = evento.CodigoEvento
            };

            var usuarios = usuarioRepository.GetUsuariosByCliente(GetClienteSeleccionado(), false);
            foreach (var u in usuarios)
            {
                model.Usuarios.Add(new SelectListItem() { Value = u.IdUsuario.ToString(), Text = u.Apellido + ", " + u.Nombre });
            }

            var puntosdeventa = usuarioRepository.GetPuntosDeVentaDeUsuario(GetClienteSeleccionado(), evento.IdUsuario);
            foreach (var p in puntosdeventa)
            {
                model.PuntosDeVenta.Add(new SelectListItem() { Value = p.IdPuntoDeVenta.ToString(), Text = p.Nombre });
            }

            var conceptos = usuarioRepository.GetConceptosCalendario(GetClienteSeleccionado());
            foreach (var c in conceptos)
            {
                model.Conceptos.Add(new SelectListItem() { Value = c.Id.ToString(), Text = c.Descripcion });
            }

            return View(model);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        [Autorizar(Permiso = "editarCalendario")]
        public ActionResult Editar(EventoVM model)
        {
            if (!ModelState.IsValid)
            {
                var usuarios = usuarioRepository.GetUsuariosByCliente(GetClienteSeleccionado(), false);
                foreach (var u in usuarios)
                {
                    model.Usuarios.Add(new SelectListItem() { Value = u.IdUsuario.ToString(), Text = u.Apellido + ", " + u.Nombre });
                }

                var puntosdeventa = usuarioRepository.GetPuntosDeVentaDeUsuario(GetClienteSeleccionado(), model.IdUsuario);
                foreach (var p in puntosdeventa)
                {
                    model.PuntosDeVenta.Add(new SelectListItem() { Value = p.IdPuntoDeVenta.ToString(), Text = p.Nombre });
                }

                var conceptos = usuarioRepository.GetConceptosCalendario(GetClienteSeleccionado());
                foreach (var c in conceptos)
                {
                    model.Conceptos.Add(new SelectListItem() { Value = c.Id.ToString(), Text = c.Descripcion });
                }

                return View(model);
            }

            Calendario evento = new Calendario
            {
                Id = model.Id,
                IdCliente = GetClienteSeleccionado(),
                FechaInicio = model.EventDate + model.EventTime,
                IdPuntoDeVenta = model.IdPuntoDeVenta,
                IdUsuario = model.IdUsuario,
                ConceptoId = model.ConceptoId,
                Observaciones = model.Observaciones,
                CodigoEvento = model.CodigoEvento
            };

            usuarioRepository.EditarEventoCalendario(evento);

            return RedirectToAction("Index", "Calendario");
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        [Autorizar(Permiso = "eliminarCalendario")]
        public ActionResult Eliminar(int Id)
        {
            usuarioRepository.EliminarEventoCalendario(Id, GetClienteSeleccionado());

            return RedirectToAction("Index");
        }

        [HttpPost]
        public JsonResult GetPuntosDeVentaDeUsuario(int userId)
        {
            int clienteId = GetClienteSeleccionado();
            if (clienteId == 0)
                return Json(null, JsonRequestBehavior.AllowGet);

            List<PuntoDeVenta> puntosdeventa = usuarioRepository.GetPuntosDeVentaDeUsuario(clienteId, userId);
            List<PuntoDeVentaVM> model = new List<PuntoDeVentaVM>();

            foreach (var p in puntosdeventa)
            {
                model.Add(new PuntoDeVentaVM()
                {
                    Id = p.IdPuntoDeVenta,
                    Nombre = p.Nombre
                });
            }
            return Json(model, JsonRequestBehavior.AllowGet);
        }

        [HttpPost]
        public PartialViewResult GetEvento(int id)
        {
            var evento = usuarioRepository.GetEventoById(GetClienteSeleccionado(), id);
            EventoCalendarioVM model = new EventoCalendarioVM
            {
                Id = evento.Id,
                Date = evento.FechaInicio,
                IdPuntoDeVenta = evento.IdPuntoDeVenta,
                IdUsuario = evento.IdUsuario,
                NombrePuntoDeVenta = evento.PuntoDeVenta.Nombre,
                NombreUsuario = evento.Usuario.Apellido + ", " + evento.Usuario.Nombre,
                CodigoEvento = evento.CodigoEvento
            };

            if (evento.Concepto != null)
            {
                model.Concepto = evento.Concepto.Descripcion;
            }
            model.Observaciones = evento.Observaciones;

            return PartialView("_Evento", model);
        }

        [AllowAnonymous]
        [HttpPost]
        public string DownloadCalendar(int idusuario,string fechaDesde, string fechaHasta)
        {
            int clienteId = GetClienteSeleccionado();
            if (String.IsNullOrEmpty(fechaDesde))
            {
                fechaDesde = (new DateTime(DateTime.Today.Year, DateTime.Today.Month, 1)).ToString("dd'/'MM'/'yyyy");
            }
            if (String.IsNullOrEmpty(fechaHasta))
            {
                fechaHasta = (DateTime.Today).ToString("dd'/'MM'/'yyyy");
            }

            string _token = usuarioRepository.GenerarCalendario(clienteId,idusuario,fechaDesde,fechaHasta);
            if (string.IsNullOrEmpty(_token))
                return string.Empty;
            else
                return _token;

        }
    }
}