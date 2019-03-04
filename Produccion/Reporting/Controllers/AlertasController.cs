using Reporting.Domain.Abstract;
using Reporting.Domain.Entities;
using Reporting.Filters;
using Reporting.ViewModels;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.Mvc;


namespace Reporting.Controllers
{
    public class AlertasController : BaseController
    {
        private readonly int IdModulo;
        public AlertasController(ITableroRepository tableroRepository, IUsuarioRepository usuarioRepository, IClienteRepository clienteRepository, IFiltroRepository filtroRepository, ICommonRepository commonRepository, IAbmsRepository abmsRepository)
        {
            IdModulo = 7;
            this.usuarioRepository = usuarioRepository;
            this.clienteRepository = clienteRepository;
            this.abmsRepository = abmsRepository;
        }

        public ActionResult Index()
        {
            int clienteId = GetClienteSeleccionado();
            if (clienteId == 0)
                return View("UsuarioSinClientes");

            var model = Buscar(clienteId, string.Empty);

            if (model == null || model.Count == 0)
            {
                ViewBag.Action = "Crear";
                ViewBag.Controller = "Alertas";
                ViewBag.Title = "No ha creado ninguna Alerta";
                ViewBag.SubTitle = "Para crear una Alerta nueva haga click aqui";
                return View("NoDataFound");
            }

            return View(model);
        }

        private List<AlertaItemList> Buscar(int clienteId, string searchtext)
        {
            var alertas = abmsRepository.GetAlertas(clienteId, searchtext);

            if (alertas == null)
                return null;

            var tiposReporte = GetTiposDeReporte();

            var model = new List<AlertaItemList>();

            foreach (var a in alertas)
            {
                try
                {
                    var alerta = new AlertaItemList()
                    {
                        AccionTrigger = a.AccionTriggerSeleccionada,
                        Activo = a.Activo,
                        CantCampos = a.AlertasCampos.Count(),
                        CantProductos = a.AlertasProductos.Count(),
                        CantPdvs = (string.IsNullOrEmpty(a.PuntosDeVenta)) ? 0 : a.PuntosDeVenta.Split(',').Count(),
                        Descripcion = a.Descripcion,
                        Destinatarios = a.Destinatarios,
                        Consolidado = a.Consolidado,
                        TipoReporte = tiposReporte.FirstOrDefault(t => t.Value == a.TipoReporteSeleccionado).Text,
                        Lunes = a.Lunes,
                        Martes = a.Martes,
                        Miercoles = a.Miercoles,
                        Jueves = a.Jueves,
                        Viernes = a.Viernes,
                        Sabado = a.Sabado,
                        Domingo = a.Domingo,
                        Id = a.Id,
                        Hora = a.Hora
                    };

                    model.Add(alerta);
                }
                catch (Exception e) { var str = e.Message; }
            }

            return model;
        }

        private List<PuntoDeVentaAlertaVM> GetPuntosDeVenta()
        {
            int clienteId = GetClienteSeleccionado();
            List<PuntoDeVentaAlertaVM> lista = new List<PuntoDeVentaAlertaVM>();
            var pdvs = abmsRepository.GetPuntosDeVentaAlerta(clienteId);
            foreach (PuntoDeVentaAlerta p in pdvs)
            {
                lista.Add(new PuntoDeVentaAlertaVM() { idZona = p.idZona, idCadena = p.idCadena, idPuntoDeVenta = p.idPuntoDeVenta, ZonaDescr = p.ZonaDescr, CadenaDescr = p.CadenaDescr, PuntoDeVentaDescr = p.PuntoDeVentaDescr, Selected = false ,RazonSocial = p.RazonSocial});
            }
            return lista;
        }
        private List<SelectListItem> GetTiposDeReporte()
        {
            List<SelectListItem> TiposDeReporte = new List<SelectListItem>
            {
                new SelectListItem() { Value = "0", Text = "Elija una opción" },
                new SelectListItem() { Value = "quiebrestock", Text = "Quiebre de Stock" },
                new SelectListItem() { Value = "reportecompleto", Text = "Reporte Completo" },
                new SelectListItem() { Value = "reportepersonalizado", Text = "Reporte Personalizado" },
                new SelectListItem() { Value = "checkin", Text = "Informe de CheckIn" },
                new SelectListItem() { Value = "creacionReporte", Text = "Creacion de reporte" },
                new SelectListItem() { Value = "alertainventario", Text = "Alerta inventario" },
                new SelectListItem() { Value = "alertadistancia", Text = "Alerta por distancia" },
                new SelectListItem() { Value = "alertafrentes", Text = "Reporte por Cantidad Productos" },
                new SelectListItem() { Value = "alertaExcesoMD", Text = "Alerta por exceso en cantidad (%) de MD" },
                new SelectListItem() { Value = "alertaExcesoMDDia", Text = "Alerta por exceso diario de cobertura" },
                new SelectListItem() { Value = "alertaReportePorUsuario", Text = "Alerta de reportes por Usuario" },
                new SelectListItem() { Value = "alertaPrecioCargado", Text = "Alerta por precio cargado" },
                new SelectListItem() { Value = "alertaCheckin", Text = "Alerta de Checkin" },
                new SelectListItem() { Value = "alertaCheckout", Text = "Alerta de Checkout" }

            };

            return TiposDeReporte;
        }

        public List<SelectListItem> GetAccionesDeTipoReporte(string tiporeporte)
        {
            List<SelectListItem> AccionesTrigger = new List<SelectListItem>();

            switch (tiporeporte)
            {
                case "quiebrestock":
                    AccionesTrigger.Add(new SelectListItem() { Value = "0", Text = "Elija una opción" });
                    AccionesTrigger.Add(new SelectListItem() { Value = "addreporte", Text = "Creación de Reporte" });
                    AccionesTrigger.Add(new SelectListItem() { Value = "updatereporte", Text = "Modificación de Reporte" });
                    AccionesTrigger.Add(new SelectListItem() { Value = "insertupdatereporte", Text = "Creación o Modificación de Reporte" });
                    break;
                case "reportecompleto":
                    AccionesTrigger.Add(new SelectListItem() { Value = "0", Text = "Elija una opción" });
                    AccionesTrigger.Add(new SelectListItem() { Value = "addreporte", Text = "Creación de Reporte" });
                    AccionesTrigger.Add(new SelectListItem() { Value = "updatereporte", Text = "Modificación de Reporte" });
                    AccionesTrigger.Add(new SelectListItem() { Value = "insertupdatereporte", Text = "Creación o Modificación de Reporte" });
                    break;
                case "reportepersonalizado":
                    AccionesTrigger.Add(new SelectListItem() { Value = "0", Text = "Elija una opción" });
                    AccionesTrigger.Add(new SelectListItem() { Value = "addreporte", Text = "Creación de Reporte" });
                    AccionesTrigger.Add(new SelectListItem() { Value = "updatereporte", Text = "Modificación de Reporte" });
                    AccionesTrigger.Add(new SelectListItem() { Value = "insertupdatereporte", Text = "Creación o Modificación de Reporte" });
                    break;
                case "creacionReporte":
                    AccionesTrigger.Add(new SelectListItem() { Value = "0", Text = "Elija una opción" });
                    AccionesTrigger.Add(new SelectListItem() { Value = "addreporte", Text = "Creación de Reporte" });
                    break;
                case "alertainventario":
                    AccionesTrigger.Add(new SelectListItem() { Value = "0", Text = "Elija una opción" });
                    AccionesTrigger.Add(new SelectListItem() { Value = "addreporte", Text = "Creación de Reporte" });
                    AccionesTrigger.Add(new SelectListItem() { Value = "updatereporte", Text = "Modificación de Reporte" });
                    AccionesTrigger.Add(new SelectListItem() { Value = "insertupdatereporte", Text = "Creación o Modificación de Reporte" });
                    break;
                case "alertafrentes":
                    AccionesTrigger.Add(new SelectListItem() { Value = "0", Text = "Elija una opción" });
                    AccionesTrigger.Add(new SelectListItem() { Value = "addreporte", Text = "Creación de Reporte" });
                    AccionesTrigger.Add(new SelectListItem() { Value = "updatereporte", Text = "Modificación de Reporte" });
                    AccionesTrigger.Add(new SelectListItem() { Value = "insertupdatereporte", Text = "Creación o Modificación de Reporte" });
                    break;
                case "alertaExcesoMD":
                    AccionesTrigger.Add(new SelectListItem() { Value = "0", Text = "Elija una opción" });
                    AccionesTrigger.Add(new SelectListItem() { Value = "addreporte", Text = "Creación de Reporte" });
                    AccionesTrigger.Add(new SelectListItem() { Value = "updatereporte", Text = "Modificación de Reporte" });
                    AccionesTrigger.Add(new SelectListItem() { Value = "insertupdatereporte", Text = "Creación o Modificación de Reporte" });
                    break;
                case "alertaExcesoMDDia":
                    AccionesTrigger.Add(new SelectListItem() { Value = "0", Text = "Elija una opción" });
                    AccionesTrigger.Add(new SelectListItem() { Value = "addreporte", Text = "Creación de Reporte" });
                    AccionesTrigger.Add(new SelectListItem() { Value = "updatereporte", Text = "Modificación de Reporte" });
                    AccionesTrigger.Add(new SelectListItem() { Value = "insertupdatereporte", Text = "Creación o Modificación de Reporte" });
                    break;
                case "alertaPrecio":
                    AccionesTrigger.Add(new SelectListItem() { Value = "0", Text = "Elija una opción" });
                    AccionesTrigger.Add(new SelectListItem() { Value = "addreporte", Text = "Creación de Reporte" });
                    AccionesTrigger.Add(new SelectListItem() { Value = "updatereporte", Text = "Modificación de Reporte" });
                    AccionesTrigger.Add(new SelectListItem() { Value = "insertupdatereporte", Text = "Creación o Modificación de Reporte" });
                    break;
                case "alertaCheckin":
                    AccionesTrigger.Add(new SelectListItem() { Value = "0", Text = "Elija una opción" });
                    AccionesTrigger.Add(new SelectListItem() { Value = "addreporte", Text = "Creación de Reporte" });
                    AccionesTrigger.Add(new SelectListItem() { Value = "updatereporte", Text = "Modificación de Reporte" });
                    AccionesTrigger.Add(new SelectListItem() { Value = "insertupdatereporte", Text = "Creación o Modificación de Reporte" });
                    break;
                case "alertaCheckout":
                    AccionesTrigger.Add(new SelectListItem() { Value = "0", Text = "Elija una opción" });
                    AccionesTrigger.Add(new SelectListItem() { Value = "addreporte", Text = "Creación de Reporte" });
                    AccionesTrigger.Add(new SelectListItem() { Value = "updatereporte", Text = "Modificación de Reporte" });
                    AccionesTrigger.Add(new SelectListItem() { Value = "insertupdatereporte", Text = "Creación o Modificación de Reporte" });
                    break;
                case "checkout":
                case "alertadistancia":
                case "alertaReportePorUsuario":
                case "0":
                default:
                    break;
            }

            return AccionesTrigger;
        }
        [HttpPost]
        public JsonResult GetAccionesDisparadoras(string tiporeporte)
        {
            var AccionesTrigger = GetAccionesDeTipoReporte(tiporeporte);

            return Json(AccionesTrigger, JsonRequestBehavior.AllowGet);

        }

        [Autorizar(Permiso = "crearAlertas")]
        public ActionResult Crear()
        {
            int clienteId = GetClienteSeleccionado();
            if (clienteId == 0)
                return View("UsuarioSinClientes");

            AlertaVM model = new AlertaVM();

            ViewData["TiposDeReporte"] = GetTiposDeReporte();

            var camposreporte = abmsRepository.GetCamposAlerta(clienteId);

            var productosreporte = abmsRepository.GetProductosAlerta(clienteId);

            var modulosReporte = abmsRepository.GetModulosAlerta(clienteId);

            List<CampoAlerta> campos = new List<CampoAlerta>();

            List<ProductoAlerta> productos = new List<ProductoAlerta>();

            List<ModuloAlerta> modulos = new List<ModuloAlerta>();

            foreach (var al in camposreporte)
            {
                campos.Add(new CampoAlerta()
                {
                    IdMarca = al.IdMarca,
                    IdSeccion = al.IdSeccion,
                    IdCampo = al.IdCampo,
                    MarcaDescr = al.MarcaDescr,
                    SeccionDescr = al.SeccionDescr,
                    CampoDescr = al.CampoDescr,
                    Selected = false
                });
            }


            foreach (var pr in productosreporte)
            {
                productos.Add(new ProductoAlerta()
                {
                    IdMarca = pr.IdMarca,
                    IdProducto = pr.IdProducto,
                    MarcaDescr = pr.MarcaDescr,
                    ProductoDescr = pr.ProductoDescr,
                    Selected = false
                });
            }

            foreach (var m in modulosReporte)
            {
                modulos.Add(new ModuloAlerta()
                {
                    idModuloClienteItem = m.Id,
                    idModuloItem = m.IdModuloItem,
                    leyenda = m.Leyenda,
                    esIgual = false,
                    esMayor = false,
                    esMenor = false,
                    valor = Decimal.MinValue
                });
            }

            model.Activo = true;
            model.Campos = campos;

            model.Productos = productos;
            model.Modulos = modulos;
            model.AccionTriggerSeleccionada = "insertupdatereporte";

            var pdvs = GetPuntosDeVenta();
            model.PuntosDeVenta = pdvs;

            return View(model);
        }

        [Autorizar(Permiso = "crearAlertas")]
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Crear(AlertaVM model)
        {
            ViewData["TiposDeReporte"] = GetTiposDeReporte();

            int idcliente = GetClienteSeleccionado();
            int userId = GetUsuarioLogueado();
            userId = usuarioRepository.GetUsuarioPerformance(userId);

            if (ModelState.IsValid)
            {
                Alertas a = new Alertas()
                {
                    Activo = model.Activo,
                    Descripcion = model.Descripcion,
                    Destinatarios = model.Destinatarios,
                    Hora = model.Hora,
                    IdCliente = idcliente,
                    AccionTriggerSeleccionada = (model.AccionTriggerSeleccionada == "0") ? null : model.AccionTriggerSeleccionada,
                    Lunes = model.Lunes,
                    Martes = model.Martes,
                    Miercoles = model.Miercoles,
                    Jueves = model.Jueves,
                    Viernes = model.Viernes,
                    Sabado = model.Sabado,
                    Domingo = model.Domingo,
                    IdUsuario = userId,
                    Consolidado = model.Consolidado,
                    TipoReporteSeleccionado = model.TipoReporteSeleccionado,
                    FechaCreacion = DateTime.Today,
                    Distancia = model.Distancia,
                    HoraInicio = model.HoraInicio,
                    HoraFin = model.HoraFin
                };

                foreach (var campo in model.Campos.Where(c => c.Selected))
                {
                    a.AlertasCampos.Add(new AlertasCampos()
                    {
                        IdMarca = campo.IdMarca,
                        IdModulo = campo.IdSeccion,
                        IdItem = campo.IdCampo
                    });
                }


                foreach (var producto in model.Productos.Where(p => p.Selected))
                {
                    a.AlertasProductos.Add(new AlertasProductos()
                    {
                        IdMarca = producto.IdMarca,
                        IdProducto = producto.IdProducto
                    });
                }

                foreach (var modulo in model.Modulos.Where(p => p.valor > 0))
                {
                    a.AlertasModulos.Add(new AlertasModulos()
                    {
                        IdModuloClienteItem = modulo.idModuloClienteItem,
                        IdModuloItem = modulo.idModuloItem,
                        Leyenda = modulo.leyenda,
                        EsMayor = (modulo.esMayor == true) ? 1 : 0,
                        EsMenor = (modulo.esMenor == true) ? 1 : 0,
                        EsIgual = (modulo.esIgual == true) ? 1 : 0,
                        Valor = modulo.valor
                    }
                    );
                }

                a.PuntosDeVenta = string.Join(",", model.PuntosDeVenta.Where(p => p.Selected).Select(p => p.idPuntoDeVenta).ToArray());

                if (abmsRepository.CrearAlerta(a))
                {
                    return RedirectToAction("Index");
                }
                else
                {
                    return View(model);
                }

            }
            else
            {
                return View(model);
            }
        }


        [Autorizar(Permiso = "editarAlertas")]
        public ActionResult Editar(int id)
        {
            Alertas alerta;
            if (id > 0)
                alerta = abmsRepository.GetAlerta(id);
            else
                return View("Error404");

            if (alerta == null)
                return View("Error404");

            int clienteId = GetClienteSeleccionado();
            if (clienteId == 0)
                return View("UsuarioSinClientes");

            AlertaVM model = new AlertaVM
            {
                Id = alerta.Id,
                Descripcion = alerta.Descripcion,
                Destinatarios = alerta.Destinatarios,
                Activo = alerta.Activo,
                AccionTriggerSeleccionada = (string.IsNullOrEmpty(alerta.AccionTriggerSeleccionada) ? "0" : alerta.AccionTriggerSeleccionada),
                Lunes = alerta.Lunes,
                Martes = alerta.Martes,
                Miercoles = alerta.Miercoles,
                Jueves = alerta.Jueves,
                Viernes = alerta.Viernes,
                Sabado = alerta.Sabado,
                Domingo = alerta.Domingo,
                Hora = alerta.Hora,
                Consolidado = alerta.Consolidado,
                TipoReporteSeleccionado = alerta.TipoReporteSeleccionado,
                Distancia = alerta.Distancia,
                HoraInicio = alerta.HoraInicio,
                HoraFin = alerta.HoraFin
            };

            ViewData["TiposDeReporte"] = GetTiposDeReporte();

            var campos = abmsRepository.GetCamposAlerta(clienteId);

            var productos = abmsRepository.GetProductosAlerta(clienteId);

            var modulos = abmsRepository.GetItemsModulosAlerta(clienteId, alerta.Id);

            List<CampoAlerta> listacampos = new List<CampoAlerta>();

            List<ProductoAlerta> listaproductos = new List<ProductoAlerta>();

            List<ModuloAlerta> listamodulos = new List<ModuloAlerta>();

            foreach (var al in campos)
            {
                listacampos.Add(new CampoAlerta()
                {
                    Id = al.Id,
                    IdMarca = al.IdMarca,
                    IdSeccion = al.IdSeccion,
                    IdCampo = al.IdCampo,
                    MarcaDescr = al.MarcaDescr,
                    SeccionDescr = al.SeccionDescr,
                    CampoDescr = al.CampoDescr,
                    Selected = alerta.AlertasCampos.Any(a => a.IdMarca == al.IdMarca && a.IdModulo == al.IdSeccion && a.IdItem == al.IdCampo)
                });
            }


            foreach (var pr in productos)
            {
                listaproductos.Add(new ProductoAlerta()
                {
                    Id = pr.Id,
                    IdMarca = pr.IdMarca,
                    IdProducto = pr.IdProducto,
                    MarcaDescr = pr.MarcaDescr,
                    ProductoDescr = pr.ProductoDescr,
                    Selected = alerta.AlertasProductos.Any(a => a.IdMarca == pr.IdMarca && a.IdProducto == pr.IdProducto)
                });
            }

            foreach (var lm in modulos)
            {
                listamodulos.Add(new ModuloAlerta()
                {
                    idModuloClienteItem = lm.IdModuloClienteItem,
                    idModuloItem = lm.IdModuloItem,
                    esIgual = (lm.EsIgual == 1) ? true : false,
                    esMayor = (lm.EsMayor == 1) ? true : false,
                    esMenor = (lm.EsMenor == 1) ? true : false,
                    leyenda = lm.Leyenda,
                    valor = lm.Valor
                });
            }

            var pdvs = GetPuntosDeVenta();

            foreach (var pdv in alerta.PuntosDeVenta.Split(','))
            {
                var p = pdvs.FirstOrDefault(m => m.idPuntoDeVenta.ToString() == pdv);
                if (p != null)
                {
                    p.Selected = true;
                }
            }

            model.PuntosDeVenta = pdvs;

            model.Campos = listacampos;

            model.Productos = listaproductos;

            model.Modulos = listamodulos;

            return View(model);
        }

        //ACA FALTA AUTORIZACION
        [Autorizar(Permiso = "editarAlertas")]
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Editar(AlertaVM model)
        {
            ViewData["TiposDeReporte"] = GetTiposDeReporte();

            int idcliente = GetClienteSeleccionado();
            int userId = GetUsuarioLogueado();
            userId = usuarioRepository.GetUsuarioPerformance(userId);

            if (ModelState.IsValid)
            {
                Alertas a = new Alertas()
                {
                    Activo = model.Activo,
                    Descripcion = model.Descripcion,
                    Destinatarios = model.Destinatarios,
                    Hora = model.Hora,
                    IdCliente = idcliente,
                    AccionTriggerSeleccionada = (model.AccionTriggerSeleccionada == "0") ? null : model.AccionTriggerSeleccionada,
                    Lunes = model.Lunes,
                    Martes = model.Martes,
                    Miercoles = model.Miercoles,
                    Jueves = model.Jueves,
                    Viernes = model.Viernes,
                    Sabado = model.Sabado,
                    Domingo = model.Domingo,
                    IdUsuario = userId,
                    Consolidado = model.Consolidado,
                    TipoReporteSeleccionado = model.TipoReporteSeleccionado,
                    FechaCreacion = DateTime.Today,
                    Id = model.Id,
                    Distancia = model.Distancia,
                    HoraInicio = model.HoraInicio,
                    HoraFin = model.HoraFin
                };

                foreach (var campo in model.Campos.Where(c => c.Selected))
                {
                    a.AlertasCampos.Add(new AlertasCampos()
                    {
                        IdMarca = campo.IdMarca,
                        IdModulo = campo.IdSeccion,
                        IdItem = campo.IdCampo,
                        IdAlerta = model.Id
                    });
                }


                foreach (var producto in model.Productos.Where(p => p.Selected))
                {
                    a.AlertasProductos.Add(new AlertasProductos()
                    {
                        IdMarca = producto.IdMarca,
                        IdProducto = producto.IdProducto,
                        IdAlerta = model.Id
                    });
                }

                foreach (var modulo in model.Modulos)
                {
                    a.AlertasModulos.Add(new AlertasModulos()
                    {
                        IdModuloClienteItem = modulo.idModuloClienteItem,
                        IdModuloItem = modulo.idModuloItem,
                        Leyenda = modulo.leyenda,
                        EsIgual = (modulo.esIgual == true) ? 1 : 0,
                        EsMayor = (modulo.esMayor == true) ? 1 : 0,
                        EsMenor = (modulo.esMenor == true) ? 1 : 0,
                        Valor = modulo.valor,
                        IdAlerta = model.Id
                    });
                }


                a.PuntosDeVenta = string.Join(",", model.PuntosDeVenta.Where(p => p.Selected).Select(p => p.idPuntoDeVenta).ToArray());

                string resultadoEditar = abmsRepository.EditarAlerta(a);

                if (resultadoEditar == "true")
                {
                    return RedirectToAction("Index");
                }
                else
                {
                    return Content("<script language='javascript' type='text/javascript'>alert     ('OCURRIO UN ERROR AL PROCESAR " + resultadoEditar + " ');</script>");
                    //return View(model);
                }
            }
            else
            {
                return View(model);
            }
        }
        //ACA FALTA AUTORIZACION
        [Autorizar(Permiso = "eliminarAlertas")]
        public ActionResult Eliminar(int id)
        {
            Alertas alerta;
            if (id > 0)
                alerta = abmsRepository.GetAlerta(id);
            else
                return View("Error404");

            if (alerta == null)
                return View("Error404");

            int clienteId = GetClienteSeleccionado();
            if (clienteId == 0)
                return View("UsuarioSinClientes");

            AlertaVM model = new AlertaVM()
            {
                Id = alerta.Id,
                Descripcion = alerta.Descripcion,
                Activo = alerta.Activo,
                Destinatarios = alerta.Destinatarios
            };

            return View(model);
        }
        //ACA FALTA AUTORIZACION
        [Autorizar(Permiso = "eliminarAlertas")]
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Eliminar(AlertaVM model, FormCollection collection)
        {
            int clienteId = GetClienteSeleccionado();
            abmsRepository.EliminarAlerta(clienteId, model.Id);
            return RedirectToAction("Index");
        }

        [Autorizar(Permiso = "verAlertas")]
        public ActionResult Ver(int id)
        {
            Alertas alerta;
            if (id > 0)
                alerta = abmsRepository.GetAlerta(id);
            else
                return View("Error404");

            if (alerta == null)
                return View("Error404");

            int clienteId = GetClienteSeleccionado();
            if (clienteId == 0)
                return View("UsuarioSinClientes");

            AlertaVM model = new AlertaVM
            {
                Id = alerta.Id,
                Descripcion = alerta.Descripcion,
                Destinatarios = alerta.Destinatarios,
                Activo = alerta.Activo,
                Lunes = alerta.Lunes,
                Martes = alerta.Martes,
                Miercoles = alerta.Miercoles,
                Jueves = alerta.Jueves,
                Viernes = alerta.Viernes,
                Sabado = alerta.Sabado,
                Domingo = alerta.Domingo,
                Hora = alerta.Hora,
                Consolidado = alerta.Consolidado,
                Distancia = alerta.Distancia,
                HoraInicio = alerta.HoraInicio,
                HoraFin = alerta.HoraFin
            };


            var tiposReporte = GetTiposDeReporte();
            model.TipoReporteSeleccionado = tiposReporte.First(t => t.Value == alerta.TipoReporteSeleccionado).Text;

            var acciones = GetAccionesDeTipoReporte(alerta.TipoReporteSeleccionado);

            if (alerta.AccionTriggerSeleccionada != null)
            {
                model.AccionTriggerSeleccionada = acciones.First(a => a.Value == alerta.AccionTriggerSeleccionada).Text;
            }


            var pdvs = GetPuntosDeVenta();

            foreach (var pdv in alerta.PuntosDeVenta.Split(','))
            {
                var p = pdvs.FirstOrDefault(m => m.idPuntoDeVenta.ToString() == pdv);
                if (p != null)
                {
                    p.Selected = true;
                }
            }

            model.PuntosDeVenta = pdvs.Where(p => p.Selected).ToList();

            var campos = abmsRepository.GetCamposAlerta(clienteId);

            var productos = abmsRepository.GetProductosAlerta(clienteId);

            var modulos = abmsRepository.GetItemsModulosAlerta(clienteId, alerta.Id);

            List<CampoAlerta> listacampos = new List<CampoAlerta>();

            List<ProductoAlerta> listaproductos = new List<ProductoAlerta>();

            List<ModuloAlerta> listamodulos = new List<ModuloAlerta>();

            foreach (var al in campos)
            {
                if (alerta.AlertasCampos.Any(a => a.IdMarca == al.IdMarca && a.IdModulo == al.IdSeccion && a.IdItem == al.IdCampo))
                    listacampos.Add(new CampoAlerta()
                    {
                        Id = al.Id,
                        IdMarca = al.IdMarca,
                        IdSeccion = al.IdSeccion,
                        IdCampo = al.IdCampo,
                        MarcaDescr = al.MarcaDescr,
                        SeccionDescr = al.SeccionDescr,
                        CampoDescr = al.CampoDescr,
                        Selected = true
                    });
            }


            foreach (var pr in productos)
            {
                if (alerta.AlertasProductos.Any(a => a.IdMarca == pr.IdMarca && a.IdProducto == pr.IdProducto))
                    listaproductos.Add(new ProductoAlerta()
                    {
                        Id = pr.Id,
                        IdMarca = pr.IdMarca,
                        IdProducto = pr.IdProducto,
                        MarcaDescr = pr.MarcaDescr,
                        ProductoDescr = pr.ProductoDescr,
                        Selected = true
                    });
            }

            foreach (var ml in modulos)
            {
                listamodulos.Add(new ModuloAlerta()
                {
                    idModuloClienteItem = ml.IdModuloClienteItem,
                    idModuloItem = ml.IdModuloItem,
                    leyenda = ml.Leyenda,
                    esIgual = (ml.EsIgual == 1),
                    esMayor = (ml.EsMayor == 1),
                    esMenor = (ml.EsMenor == 1),
                    valor = ml.Valor
                });
            }
            model.Campos = listacampos;
            model.Productos = listaproductos;
            model.Modulos = listamodulos;

            return View(model);
        }


        [Autorizar(Permiso = "verAlertas")]
        [HttpPost]
        public PartialViewResult GetAlertasBySearch(string searchtext)
        {
            int clienteId = GetClienteSeleccionado();
            if (clienteId == 0)
                return PartialView("_Alertas_Tabla", new List<AlertaItemList>());

            List<AlertaItemList> model = Buscar(clienteId, searchtext);
            return PartialView("_Alertas_Tabla", model);
        }
    }
}