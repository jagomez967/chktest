using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using Reporting.Domain.Abstract;
using Reporting.Domain.Entities;
using System.Data.SqlClient;
using System.Data;
using ICSharpCode.SharpZipLib.Zip;
using ICSharpCode.SharpZipLib.Core;
using System.Configuration;
using System.Text.RegularExpressions;

namespace Reporting.Domain.Concrete
{
    public class ImagenesRepository : IImagenesRepository
    {
        private static NLog.Logger logger = NLog.LogManager.GetCurrentClassLogger();

        private RepContext context = new RepContext();
        private string _directoryFotos = @"\\checkposdiag742.file.core.windows.net\fotos\CheckposFolder\" + ConfigurationManager.AppSettings["instancia"].ToString() + @"\Fotos\";
        private string _directoryArchivos = @"\\checkposdiag742.file.core.windows.net\fotos\CheckposFolder\" + ConfigurationManager.AppSettings["instancia"].ToString() + @"\Reporting\Content\downloadFotos\";
        public Imagen GetFotoPorId(int clienteId, int idFoto)
        {
            var foto = context.PuntoDeVentaFotos.FirstOrDefault(f => f.IdPuntoDeVentaFoto == idFoto);

            if (foto == null)
            {
                logger.Warn("No existen foto con ID:" + idFoto.ToString() + " , para el cliente:" + clienteId.ToString());
                return null;
            }
                

            var reporte = context.Reporte.First(r => r.IdReporte == foto.IdReporte);
            var pdv = context.PuntoDeVenta.FirstOrDefault(p => p.IdPuntoDeVenta == foto.IdPuntoDeVenta);
            
            string _path = _directoryFotos + foto.IdEmpresa;

            List<String> tagsdeimg;
            try
            {
                tagsdeimg = foto.imagenesTags.Select(t => t.tag.leyenda).ToList<string>();
            }
            catch(Exception ex)
            {
                logger.Error(ex, "Error al cargar tag de imagen:" + idFoto.ToString());
                return null;
            }
            
            Imagen img = new Imagen();
            try
            {
                img.imgb64 = @"data:image/png;base64," + ConvertImagenToB64(_path + @"\" + foto.IdPuntoDeVentaFoto + ".jpg");
                img.id = foto.IdPuntoDeVentaFoto;
                img.comentarios = foto.Comentario;
                img.tags = tagsdeimg;
                img.cantTags = tagsdeimg.Count;
                img.idPuntoDeVenta = int.Parse(string.IsNullOrEmpty(foto.IdPuntoDeVenta.ToString()) ? "0" : foto.IdPuntoDeVenta.ToString());
                img.idReporte = int.Parse(string.IsNullOrEmpty(foto.IdReporte.ToString()) ? "0" : foto.IdReporte.ToString());
                img.fechaCreacion = reporte.FechaCreacion.ToString("dd/MM/yyyy HH:mm");
                img.provincia = pdv.Localidad.Provincia.Nombre;
                img.usuario = context.Usuario.FirstOrDefault(u => u.IdUsuario == foto.IdUsuario).Apellido + ", " + context.Usuario.FirstOrDefault(u => u.IdUsuario == foto.IdUsuario).Nombre;
            }
            catch(Exception ex)
            {
                logger.Error(ex, "Error generar objeto Imagen:" + idFoto.ToString());
                return null;
            }

            Zona zona;

            try
            {
                zona = context.Zona.FirstOrDefault(z => z.IdZona == pdv.IdZona);
            }
            catch(Exception ex)
            {
                logger.Error(ex, "Error al buscar zona:" + pdv.IdZona.ToString());
                return null;
            }


            if (pdv != null)
            {
                img.nombrePuntoDeVenta = pdv.Nombre;
                img.direccion = pdv.Direccion;
                img.zona = zona.Nombre;
            }

            return img;


        }
        public List<Imagen> GetMasFotos(List<FiltroSeleccionado> Filtros, int clienteId, int pageNum)
        {

            List<Imagen> imagenes = new List<Imagen>();

            using (SqlConnection cn = new SqlConnection((new RepContext()).Database.Connection.ConnectionString.ToString()))
            {
                DataTable dtfiltros = new DataTable();
                dtfiltros.Columns.Add(new DataColumn("IdFiltro", typeof(string)));
                dtfiltros.Columns.Add(new DataColumn("Valores", typeof(string)));

                string _path = _directoryFotos;

                SqlCommand cmd = new SqlCommand("reportingGetFotos", cn)
                {
                    CommandType = CommandType.StoredProcedure,
                    CommandTimeout = 240
                };
                cmd.Parameters.Add("@IdCliente", SqlDbType.Int).Value = clienteId;

                if (Filtros != null)
                {
                    foreach (FiltroSeleccionado f in Filtros)
                    {
                        if (f.Valores != null)
                        {
                            DataRow newRow = dtfiltros.NewRow();
                            newRow[0] = f.Filtro;
                            newRow[1] = string.Join(",", f.Valores);

                            dtfiltros.Rows.Add(newRow);
                        }

                    }
                }

                cmd.Parameters.Add("@NumeroDePagina", SqlDbType.Int).Value = pageNum;
                cmd.Parameters.Add("@Filtros", SqlDbType.Structured).Value = dtfiltros;
                cmd.Parameters.Add("@Lenguaje", SqlDbType.VarChar).Value = System.Threading.Thread.CurrentThread.CurrentCulture.Name;

                cn.Open();

                SqlDataReader r = cmd.ExecuteReader();

                if (r.HasRows)
                {
                    while (r.Read())
                    {
                        Imagen img = new Imagen();
                        string idEmpresa = r["idEmpresa"].ToString();
                        string idPuntodeventaf = r["IdPuntoDeVentaFoto"].ToString();
                        var b64 = ConvertImagenToB64(_path + idEmpresa + @"\thumb" + idPuntodeventaf + ".jpg");
                        if (b64 == null)
                        {
                            b64 = ConvertImagenToB64(_path + idEmpresa + @"\thumb" + idPuntodeventaf + ".jpeg");
                        }
                        if (b64 != null)
                        {
                            img.imgb64 = @"data:image/png;base64," + b64;
                            img.nombrePuntoDeVenta = r["nombrePuntoDeVenta"].ToString();
                            img.id = int.Parse(r["IdPuntoDeVentaFoto"].ToString());
                            img.idPuntoDeVenta = int.Parse(r["idPuntoDeVenta"].ToString());
                            img.comentarios = r["comentarios"].ToString();
                            img.fechaCreacion = r["fechaCreacion"].ToString();
                            img.cantTags = int.Parse(r["cantTags"].ToString());
                            imagenes.Add(img);
                        }
                    }
                }
            }

            return imagenes;

        }
        public List<Imagen> GetFotosDias(int clienteId, int dias)
        {

            List<Imagen> imagenes = new List<Imagen>();

            using (SqlConnection cn = new SqlConnection((new RepContext()).Database.Connection.ConnectionString.ToString()))
            {
                SqlCommand cmd = new SqlCommand("reportingGetFotosDias", cn);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.CommandTimeout = 240;
                cmd.Parameters.Add("@IdCliente", SqlDbType.Int).Value = clienteId;
                cmd.Parameters.Add("@Dias", SqlDbType.Int).Value = dias;
                cn.Open();

                SqlDataReader r = cmd.ExecuteReader();

                if (r.HasRows)
                {
                    while (r.Read())
                    {
                        Imagen img = new Imagen
                        {
                            nombrePuntoDeVenta = r["nombrePuntoDeVenta"].ToString(),
                            id = int.Parse(r["IdPuntoDeVentaFoto"].ToString()),
                            idPuntoDeVenta = int.Parse(r["idPuntoDeVenta"].ToString()),
                            comentarios = r["comentarios"].ToString(),
                            fechaCreacion = r["fechaCreacion"].ToString()
                        };
                        imagenes.Add(img);
                    }
                }
            }

            return imagenes;

        }
        private string ConvertImagenToB64(string path)
        {
            try
            {
                Byte[] bytes = File.ReadAllBytes(path);
                return Convert.ToBase64String(bytes);
            }
            catch(Exception e)
            {
                logger.Error(e, "Error al convertir imagen a BASE 64: "+ e.Message);
                return null;
            }
        }
        public int GetIdEmpresaDeCliente(int clienteId)
        {
            try
            {
                var cliente = context.Cliente.FirstOrDefault(c => c.IdCliente == clienteId);
                if (cliente != null)
                {
                    return int.Parse(cliente.IdEmpresa.ToString());
                }
                else
                {
                    return -1;
                }
            }
            catch(Exception ex)
            {
                logger.Error(ex, "Error en GetIdEmpresaDeCliente - ImagenesRepository"); 
                return -1;
            }
        }
        public string GenerarArchivoFotos(int clienteId, int dias)
        {
            int IdEmpresa = GetIdEmpresaDeCliente(clienteId);
            string _path = _directoryArchivos;
            string directoryname = string.Format("{0}{1}{2}{3}{4}{5}{6}{7}", clienteId, DateTime.Now.Year, DateTime.Now.Month, DateTime.Now.Day, DateTime.Now.Hour, DateTime.Now.Minute, DateTime.Now.Second, DateTime.Now.Millisecond);
            string htmlfilename = "fotos.html";

            List<Imagen> fotos = GetFotosDias(clienteId, dias);

            if (fotos == null || fotos.Count == 0)
            { 
                logger.Warn("GenerarArchivoFotos - No se encontraron fotos");
                return null;
            }

            if (!Directory.Exists(Path.Combine(_path, directoryname)))
                Directory.CreateDirectory(Path.Combine(_path, directoryname));

            if (!Directory.Exists(Path.Combine(_path, directoryname, "Fotos")))
                Directory.CreateDirectory(Path.Combine(_path, directoryname, "Fotos"));

            if (!Directory.Exists(Path.Combine(_path, directoryname, "cssjs")))
                Directory.CreateDirectory(Path.Combine(_path, directoryname, "cssjs"));

            foreach (Imagen img in fotos)
            {
                try
                {
                    File.Copy(Path.Combine(_directoryFotos, IdEmpresa.ToString(), img.id.ToString() + ".jpg"), Path.Combine(_path, directoryname, "Fotos", img.id.ToString() + ".jpg"));
                }
                catch(Exception ex)
                {
                    logger.Error(ex, "Error al copiar archivo - GenerarArchivoFotos");
                }
            }

            try
            {
                File.Copy(Path.Combine(_path, "logo.png"), Path.Combine(_path, directoryname, "cssjs", "logo.png"));
                File.Copy(Path.Combine(_path, "style.css"), Path.Combine(_path, directoryname, "cssjs", "style.css"));
            }
            catch (Exception ex)
            {
                logger.Error(ex, "error al copiar logo.png/style.css en GenerarArchivoFotos");
            }

            string htmlFileName = Path.Combine(_path, directoryname, htmlfilename);

            using (FileStream fs = new FileStream(htmlFileName, FileMode.Create))
            {
                using (StreamWriter w = new StreamWriter(fs, Encoding.UTF8))
                {
                    StringBuilder sb = new StringBuilder();
                    sb.Append(@"<!doctype html><html lang='es'><head><meta charset='utf-8'><title>Fotos descargadas CheckPOS</title><meta name='description' content=''><link rel='stylesheet' href='cssjs\style.css'><link href='https://fonts.googleapis.com/css?family=Source+Sans+Pro:400,400italic,700,700italic' rel='stylesheet' type='text/css'><!--[if lt IE 9]><script src='https://oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js'></script><script src='https://oss.maxcdn.com/libs/respond.js/1.3.0/respond.min.js'></script><![endif]--></head><body><img class='logo' src='cssjs\logo.png'/>");
                    sb.Append(string.Format("<h1><strong>&raquo;</strong>  &nbsp;Fotos desde <span>{0}</span> hasta <span>{1}</span></h1>", DateTime.Now.AddDays((-1) * dias).ToString("dd-MM-yyyy"), DateTime.Now.ToString("dd-MM-yyyy")));
                    sb.Append("<ul class='listafotos columas4'>");

                    foreach (Imagen img in fotos)
                    {
                        sb.Append("<li>");
                        sb.Append(string.Format(@"<img src='Fotos\{0}.jpg' />", img.id));
                        sb.Append(string.Format("<h3>{0} - {1}</h3>", img.idPuntoDeVenta, img.nombrePuntoDeVenta));
                        sb.Append(string.Format("<span class='fecha'>Fecha:</span><span id='#'>{0}</span><br />", img.fechaCreacion));
                        sb.Append(string.Format("<span class='id'>ID:</span><span id='#'>{0}</span><br />", img.id));
                        sb.Append(string.Format("<span class='otro-dato'>Comentarios:</span><span id='#'>{0}</span>", img.comentarios));
                        sb.Append("</li>");
                    }

                    sb.Append(@"</ul></body></html>");

                    w.WriteLine(sb);
                }
            }

            ZipOutputStream zip = new ZipOutputStream(File.Create(Path.Combine(_path, directoryname + ".zip")));
            CompressFolder(Path.Combine(_path, directoryname), zip, Path.Combine(_path, directoryname));
            zip.Finish();
            zip.Close();

            Directory.Delete(Path.Combine(_path, directoryname), true);
            return directoryname;
        }
        public string GenerarArchivoFotosResultadoBusqueda(List<FiltroSeleccionado> filtrosSeleccionados, int clienteId)
        {
            int IdEmpresa = GetIdEmpresaDeCliente(clienteId);
            string _path = _directoryArchivos;
            string directoryname = string.Format("{0}{1}{2}{3}{4}{5}{6}{7}", clienteId, DateTime.Now.Year, DateTime.Now.Month, DateTime.Now.Day, DateTime.Now.Hour, DateTime.Now.Minute, DateTime.Now.Second, DateTime.Now.Millisecond);
            string htmlfilename = "fotos.html";

            List<Imagen> fotos = GetMasFotos(filtrosSeleccionados, clienteId, -1);

            if (fotos == null || fotos.Count == 0)
            {
                logger.Warn("No se encontraron fotos - GenerarArchivoFotosResultadoBusqueda");
                return null;
            }
                

            if (!Directory.Exists(Path.Combine(_path, directoryname)))
                Directory.CreateDirectory(Path.Combine(_path, directoryname));

            if (!Directory.Exists(Path.Combine(_path, directoryname, "Fotos")))
                Directory.CreateDirectory(Path.Combine(_path, directoryname, "Fotos"));

            if (!Directory.Exists(Path.Combine(_path, directoryname, "cssjs")))
                Directory.CreateDirectory(Path.Combine(_path, directoryname, "cssjs"));

            foreach (Imagen img in fotos)
            {
                try
                {
                    string fechaFinal = img.fechaCreacion.Replace(@"/", "-");
                    fechaFinal = fechaFinal.Replace(":", "-");
                    fechaFinal = Regex.Replace(fechaFinal, @"\s+", "-");

                    string pdvName = img.nombrePuntoDeVenta.Replace(@"/", "-");
                    pdvName = pdvName.Replace(":", "-");
                    pdvName = pdvName.Replace("*", "-");
                    pdvName = pdvName.Replace("<", "-");
                    pdvName = pdvName.Replace(">", "-");
                    
                    pdvName = Regex.Replace(pdvName, @"\s+", "-");

                    File.Copy(Path.Combine(_directoryFotos, IdEmpresa.ToString(), img.id.ToString() + ".jpg"), Path.Combine(_path, directoryname, "Fotos", img.id.ToString() + '-' + pdvName + '-' + fechaFinal + ".jpg"));
                }
                catch(Exception ex)
                {
                    logger.Error(ex, "Error al copiar archivo - GenerarArchivoFotosResultadoBusqueda");
                }
            }

            try
            {
                File.Copy(Path.Combine(_path, "logo.png"), Path.Combine(_path, directoryname, "cssjs", "logo.png"));
                File.Copy(Path.Combine(_path, "style.css"), Path.Combine(_path, directoryname, "cssjs", "style.css"));
                File.Copy(Path.Combine(_path, "script.js"), Path.Combine(_path, directoryname, "cssjs", "script.js"));
                File.Copy(Path.Combine(_path, "lupa.png"), Path.Combine(_path, directoryname, "cssjs", "lupa.png"));
            }
            catch(Exception ex){
                logger.Error(ex, "Error al copiar archivos para resultadoBusqueda");
            }

            string htmlFileName = Path.Combine(_path, directoryname, htmlfilename);

            using (FileStream fs = new FileStream(htmlFileName, FileMode.Create))
            {
                using (StreamWriter w = new StreamWriter(fs, Encoding.UTF8))
                {
                    StringBuilder sb = new StringBuilder();
                    sb.Append(@"<!doctype html><html lang='es'><head><meta charset='utf-8'><title>Fotos descargadas CheckPOS</title><meta name='description' content=''><link rel='stylesheet' href='cssjs\style.css'><link href='https://fonts.googleapis.com/css?family=Source+Sans+Pro:400,400italic,700,700italic' rel='stylesheet' type='text/css'><!--[if lt IE 9]><script src='https://oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js'></script><script src='https://oss.maxcdn.com/libs/respond.js/1.3.0/respond.min.js'></script><![endif]--></head><body><img class='logo' src='cssjs\logo.png'/>");
                    sb.Append(string.Format("<h1><strong>&raquo;</strong>  &nbsp;Fotos desde <span>{0}</span> hasta <span>{1}</span></h1>", DateTime.Now.AddDays((-1)).ToString("dd-MM-yyyy"), DateTime.Now.ToString("dd-MM-yyyy")));
                    sb.Append(@"<input type='text' style='display:block' class='typeahead' id='typeahead-fotos' placeholder='Search' />");
                    sb.Append("<ul class='listafotos columas4'>");

                    foreach (Imagen img in fotos)
                    {
                        string fechaFinal = img.fechaCreacion.Replace(@"/", "-");
                        fechaFinal = fechaFinal.Replace(":", "-");
                        fechaFinal = Regex.Replace(fechaFinal, @"\s+", "-");

                        sb.Append("<li class='list-group-item'>");
                        sb.Append(string.Format(@"<img src='Fotos\{0}-{1}-{2}.jpg' />", img.id, img.nombrePuntoDeVenta, fechaFinal));
                        sb.Append(string.Format("<h3>{0} - {1}</h3>", img.idPuntoDeVenta, img.nombrePuntoDeVenta));
                        sb.Append(string.Format("<span class='fecha'>Fecha:</span><span id='#'>{0}</span><br />", img.fechaCreacion));
                        sb.Append(string.Format("<span class='id'>ID:</span><span id='#'>{0}</span><br />", img.id));
                        sb.Append(string.Format("<span class='otro-dato'>Comentarios:</span><span id='#'>{0}</span>", img.comentarios));
                        sb.Append("</li>");
                    }

                    sb.Append(@"</ul></body></html>");
                    sb.Append(@"<script src='https://ajax.googleapis.com/ajax/libs/jquery/1.12.4/jquery.min.js'></script>");
                    sb.Append(@"<script type='text/javascript' src='cssjs\script.js'></script>");
                    sb.Append(@"<script type='text/javascript'>");

                    sb.Append(@"</script>");
                    w.WriteLine(sb);
                }
            }

            ZipOutputStream zip = new ZipOutputStream(File.Create(Path.Combine(_path, directoryname + ".zip")));
            CompressFolder(Path.Combine(_path, directoryname), zip, Path.Combine(_path, directoryname));
            zip.Finish();
            zip.Close();

            Directory.Delete(Path.Combine(_path, directoryname), true);
            return directoryname;
        }
        private void CompressFolder(string path, ZipOutputStream zipStream, string root)
        {
            string[] files = Directory.GetFiles(path);

            foreach (string filename in files)
            {

                FileInfo fi = new FileInfo(filename);

                string entryName = filename.Substring(root.Length + 1);

                ZipEntry newEntry = new ZipEntry(entryName);
                newEntry.DateTime = fi.LastWriteTime;

                newEntry.Size = fi.Length;

                zipStream.PutNextEntry(newEntry);

                byte[] buffer = new byte[4096];
                using (FileStream streamReader = File.OpenRead(filename))
                {
                    StreamUtils.Copy(streamReader, zipStream, buffer);
                }
                zipStream.CloseEntry();
            }

            string[] folders = Directory.GetDirectories(path);

            foreach (string folder in folders)
            {
                CompressFolder(folder, zipStream, root);
            }
        }
        public void EliminarZip(string filename)
        {
            File.Delete(Path.Combine(_directoryArchivos, filename));
        }

        public List<string> GetUltimas5Fotos(int IdReporte)
        {
            List<string> imagenes = new List<string>();

            Reporte rep = context.Reporte.FirstOrDefault(r => r.IdReporte == IdReporte);
            if (rep == null)
            {
                logger.Warn("No se obtuvo ninguna de las ultimas 5 fotos");
                return imagenes;
            }

            string _path = _directoryFotos + rep.IdEmpresa.ToString();

            var fotos = context.PuntoDeVentaFotos.Where(p => p.IdReporte == IdReporte).OrderByDescending(p => p.FechaCreacion).Take(4).ToList();
            if (fotos != null && fotos.Count > 0)
            {
                foreach (var f in fotos)
                {
                    var b64 = ConvertImagenToB64(_path + @"\thumb" + f.IdPuntoDeVentaFoto.ToString() + ".jpg");
                    if (b64 != null)
                    {
                        imagenes.Add(@"data:image/png;base64," + b64);
                    }
                }
            }

            return imagenes;
        }


        public List<string> GetLastPhotosPDV(int IdPuntoDeVenta) {
            List<string> imagenes = new List<string>();

            Reporte rep = context.Reporte.FirstOrDefault(r => r.IdPuntoDeVenta == IdPuntoDeVenta);
            string _path = _directoryFotos + rep.IdEmpresa.ToString();
            
            var fotos = context.PuntoDeVentaFotos.Where(p => p.IdPuntoDeVenta == IdPuntoDeVenta).OrderByDescending(p => p.FechaCreacion).Take(5).ToList();


            if (fotos != null && fotos.Count > 0)
            {
                foreach (var f in fotos)
                {
                    var b64 = ConvertImagenToB64(_path + @"\thumb" + f.IdPuntoDeVentaFoto.ToString() + ".jpg");
                    if (b64 != null)
                    {
                        imagenes.Add(@"data:image/png;base64," + b64);
                    }
                }
            }
            return imagenes;
        }

        public List<string> GetPhotosReport(int IdReporte)
        {
            List<string> imagenes = new List<string>();

            Reporte rep = context.Reporte.FirstOrDefault(r => r.IdReporte == IdReporte);
            string _path = _directoryFotos + rep.IdEmpresa.ToString();

            var fotos = context.PuntoDeVentaFotos.Where(p => p.IdReporte == IdReporte).OrderByDescending(p => p.FechaCreacion).ToList();


            if (fotos != null && fotos.Count > 0)
            {
                foreach (var f in fotos)
                {
                    var b64 = ConvertImagenToB64(_path + @"\thumb" + f.IdPuntoDeVentaFoto.ToString() + ".jpg");
                    if (b64 != null)
                    {
                        imagenes.Add(@"data:image/png;base64," + b64);
                    }
                }
            }
            return imagenes;
        }
    }
}