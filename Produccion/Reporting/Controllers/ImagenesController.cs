using System.Collections.Generic;
using System.Web.Mvc;
using Reporting.Domain.Abstract;
using Reporting.Domain.Entities;
using Reporting.ViewModels;
using System.IO;
using System.Configuration;
using Reporting.Filters;

namespace Reporting.Controllers
{
    [Autorizar(Permiso = "verImagenes")]
    public class ImagenesController : BaseController
    {
        private readonly int IdModulo;
        public ImagenesController(IClienteRepository clienteRepository, IUsuarioRepository usuarioRepository, IImagenesRepository imagenesRepository, IFiltroRepository filtroRepository, ICommonRepository commonRepository)
        {
            IdModulo = 3;
            this.clienteRepository = clienteRepository;
            this.usuarioRepository = usuarioRepository;
            this.imagenesRepository = imagenesRepository;
            this.filtroRepository = filtroRepository;
            this.commonRepository = commonRepository;
        }

        public ActionResult Index()
        {
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

            int tableroId = -1;
            FiltrosViewModel model = new FiltrosViewModel();
            model = GetFiltrosAplicadosPorTablero(IdModulo, tableroId);

            return View(model);
        }

        [HttpPost]
        public PartialViewResult GetFotosThumb(int pageNum)
        {
            int userId = GetUsuarioLogueado();
            userId = usuarioRepository.GetUsuarioPerformance(userId);
            int ClienteId = GetClienteSeleccionado();
            var filtrosSeleccionados = GetFiltrosAplicadosDeUsuario();

            List<Imagen> imagenes = imagenesRepository.GetMasFotos(filtrosSeleccionados, ClienteId, --pageNum);
            List<ImagenViewModel> model = new List<ImagenViewModel>();

            if (imagenes != null)
            {
                foreach (Imagen img in imagenes)
                {
                    model.Add(new ImagenViewModel()
                    {
                        comentarios = img.comentarios,
                        fechaCreacion = img.fechaCreacion,
                        id = img.id,
                        idPuntoDeVenta = img.idPuntoDeVenta,
                        idReporte = img.idReporte,
                        imgb64 = img.imgb64,
                        cantTags = img.cantTags,
                        nombrePuntoDeVenta = img.nombrePuntoDeVenta
                    });
                }
            }

            return PartialView("_imagenes", model);
        }

        [HttpPost]
        public PartialViewResult GetFotoPorId(int idFoto)
        {
            int ClienteId = GetClienteSeleccionado();
            if (ClienteId == 0)
                return null;

            Imagen img = imagenesRepository.GetFotoPorId(ClienteId, idFoto);

            ImagenViewModel model = new ImagenViewModel()
            {
                id = img.id,
                comentarios = img.comentarios,
                cantTags = img.cantTags,
                fechaCreacion = img.fechaCreacion,
                idPuntoDeVenta = img.idPuntoDeVenta,
                idReporte = img.idReporte,
                imgb64 = img.imgb64,
                nombrePuntoDeVenta = img.nombrePuntoDeVenta,
                tags = img.tags,
                direccionPuntoDeVenta = img.direccion,
                provincia = img.provincia,
                Usuario = img.usuario
            };

            return PartialView("_imagenPreview", model);
        }

        [HttpPost]
        public string GetFotosResultadoBusqueda()
        {
            int userId = GetUsuarioLogueado();
            userId = usuarioRepository.GetUsuarioPerformance(userId);
            int ClienteId = GetClienteSeleccionado();
            var filtrosSeleccionados = GetFiltrosAplicadosDeUsuario();

            string _token = imagenesRepository.GenerarArchivoFotosResultadoBusqueda(filtrosSeleccionados, ClienteId);
            if (string.IsNullOrEmpty(_token))
                return null;
            else
                return _token;
        }

        [Autorizar(Permiso = "descargarImagenes")]
        [HttpPost]
        public string GenerarArchivoFotos()
        {

            int ClienteId = GetClienteSeleccionado();

            string _token = imagenesRepository.GenerarArchivoFotos(ClienteId, 30);
            if (string.IsNullOrEmpty(_token))
                return null;
            else
                return _token;

        }

        [Autorizar(Permiso = "descargarImagenes")]
        public void DownloadFileByToken(string token)
        {
            string _directoryArchivos = @"\\checkposdiag742.file.core.windows.net\fotos\CheckposFolder\" + ConfigurationManager.AppSettings["instancia"].ToString() + @"\Reporting\Content\downloadFotos\";

            string _path = Path.Combine(_directoryArchivos, token + ".zip");
            string strFileName = Path.GetFileName(_path);

            if (System.IO.File.Exists(_path) == false)
            {
                Response.Close();
                return;
            }

            System.IO.Stream oStream = null;

            try
            {
                oStream = new FileStream
                        (path: _path,
                        mode: FileMode.Open,
                        share: FileShare.Read,
                        access: FileAccess.Read);

                Response.Buffer = false;

                Response.ContentType = "application/octet-stream";

                Response.AddHeader("Content-Disposition", "attachment; filename=" + strFileName);

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
                imagenesRepository.EliminarZip(strFileName);
            }
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult AplicarFiltros([ModelBinder(typeof(Reporting.Binders.FiltrosModelBinder))] FiltrosViewModel filtros)
        {
            return base.AplicarFiltros(filtros, -1, IdModulo);
        }

        [HttpPost]
        public PartialViewResult GetFiltrosPartialView()
        {
            var model = GetFiltrosAplicadosPorTablero(IdModulo, -1);

            return PartialView("_Filtros", model);
        }
    }
}