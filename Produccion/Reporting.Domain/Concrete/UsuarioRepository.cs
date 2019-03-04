using System.Linq;
using Reporting.Domain.Abstract;
using Reporting.Domain.Entities;
using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using NPOI.XSSF.UserModel;

namespace Reporting.Domain.Concrete
{
    public class UsuarioRepository : IUsuarioRepository
    {
        private RepContext context = new RepContext();
        public int GetUsuarioPerformance(int UsuarioId)
        {
            var usuario = context.ReportingAspNetUsuario.FirstOrDefault(u => u.IdAspUsuario == UsuarioId);
            if (usuario != null)
                return usuario.IdUsuario;
            return 0;
        }
        public Usuario getPerfilUsuario(int UsuarioId)
        {
            return context.Usuario.FirstOrDefault(u => u.IdUsuario == UsuarioId);
        }

        public string GetImagenUsuario(int UsuarioId)
        {
            var usuario = context.Usuario.FirstOrDefault(u => u.IdUsuario == UsuarioId);
            if (usuario != null)
            {
                return usuario.imagen;
            }
            return null;
        }
        public bool UsuarioPerteneceACheckPos(int idUsuario)
        {
            var user = context.Usuario.FirstOrDefault(u => u.IdUsuario == idUsuario);

            if (user != null)
                return user.esCheckPos;
            else
                return false;
        }
        public List<ReportingAspNetUsuario> GetUsuariosReportingAspByCliente(int clienteId, bool permiteCheckPos)
        {
            return context.ReportingAspNetUsuario.Where(a => a.Usuario.Usuario_Cliente.Any(uc => uc.IdCliente == clienteId) && (permiteCheckPos || !((bool)a.Usuario.esCheckPos))).ToList();
        }
        public List<Usuario> GetUsuariosConReportingByCliente(int clienteId, bool permiteCheckPos)
        {
            return context.Usuario.Where(u => u.ReportingAspNetUsuario.Any(r => r.IdUsuario == u.IdUsuario)
            && u.Usuario_Cliente.Any(uc => uc.IdCliente == clienteId)
            && (permiteCheckPos || !u.esCheckPos)).ToList();
        }
        public List<Usuario> GetUsuariosByCliente(int clienteId, bool permiteCheckPos)
        {
            return context.Usuario.Where(u => u.Usuario_Cliente.Any(uc => uc.IdCliente == clienteId) && (permiteCheckPos || !u.esCheckPos)).ToList();
        }

        public bool EdicionSimpleUsuario(Usuario user)
        {
            try
            {
                Usuario usuario = new Usuario();
                usuario = context.Usuario.FirstOrDefault(u => u.IdUsuario == user.IdUsuario);
                usuario.Nombre = user.Nombre;
                usuario.Apellido = user.Apellido;

                context.Entry(usuario);
                context.SaveChanges();

                return true;
            }
            catch (Exception)
            {
                return false;
            }
        }
        public bool CrearNuevoUsuario(int clienteId, Usuario user, int idAspUser)
        {
            try
            {
                user.esCheckPos = false;
                context.Usuario.Add(user);
                context.SaveChanges();

                Usuario savedUser = new Usuario();
                savedUser = context.Usuario.FirstOrDefault(u => u.Usuario1 == user.Usuario1);

                ReportingAspNetUsuario aspNetusuario = new ReportingAspNetUsuario
                {
                    IdUsuario = savedUser.IdUsuario,
                    IdAspUsuario = idAspUser
                };
                context.ReportingAspNetUsuario.Add(aspNetusuario);

                Usuario_Cliente usuariocliente = new Usuario_Cliente() { filtrojson = null, IdCliente = clienteId, IdUsuario = savedUser.IdUsuario };
                context.Usuario_Cliente.Add(usuariocliente);
                context.SaveChanges();

                return true;
            }
            catch
            {
                return false;
            }
        }
        public bool RegenerarUsuario(int UsuarioId)
        {

            SqlCommand cmd = new SqlCommand("regenerarUsuario")
            {
                CommandType = CommandType.StoredProcedure,
                CommandTimeout = 240
            };

            cmd.Parameters.Add("@IdUsuario", SqlDbType.Int).Value = UsuarioId;
            try
            {
                using (SqlConnection cn = new SqlConnection((new RepContext()).Database.Connection.ConnectionString.ToString()))
                {
                    cmd.Connection = cn;

                    cn.Open();

                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    DataSet ds = new DataSet();
                    da.Fill(ds);

                    if (ds == null)
                        return false;

                    if (ds.Tables.Count == 1)
                        return true;
                }
            }
            catch(Exception e)
            {
                var strErr = e.Message;
                return false;
            }
            return false;
        }


        public List<ReportingRoles> GetRolesDeCliente(int idCliente)
        {
            return context.ReportingRoles.Where(r => r.idCliente == idCliente).ToList();
        }
        public bool CrearRol(int idCliente, string nombre, List<int> permisos)
        {
            try
            {
                var nuevoRol = context.ReportingRoles.Add(new ReportingRoles()
                {
                    nombre = nombre,
                    idCliente = idCliente
                });

                foreach (int i in permisos)
                {
                    nuevoRol.ReportingRolPermisos.Add(new ReportingRolPermisos()
                    {
                        idPermiso = i
                    });
                }

                context.SaveChanges();
                return true;
            }
            catch
            {
                return false;
            }
        }
        public bool ExisteRol(int idCliente, string nombreRol)
        {
            return (context.ReportingRoles.FirstOrDefault(r => r.nombre == nombreRol && r.idCliente == idCliente) != null);
        }
        public List<ReportingRolPermisos> GetPermisosDeRol(int idCliente, int idRol)
        {
            return context.ReportingRolPermisos.Where(p => p.ReportingRoles.id == idRol && p.ReportingRoles.idCliente == idCliente).ToList();
        }
        public List<ReportingPermisos> GetPermisos()
        {
            return context.ReportingPermisos.Where(p => p.activo).ToList();
        }
        public void AsignarPermiso(int idRol, int idPermiso, bool value)
        {
            if (value)
            {
                if (!context.ReportingRolPermisos.Any(r => r.idPermiso == idPermiso && r.idRol == idRol))
                    context.ReportingRolPermisos.Add(new ReportingRolPermisos() { idRol = idRol, idPermiso = idPermiso });
            }
            else
            {
                var permiso = context.ReportingRolPermisos.FirstOrDefault(r => r.idPermiso == idPermiso && r.idRol == idRol);
                if (permiso != null)
                    context.ReportingRolPermisos.Remove(permiso);
            }

            context.SaveChanges();
        }

        public bool IsAuthorized(int clienteId, int userId, string permiso)
        {
            var usuarioCP = context.ReportingAspNetUsuario.FirstOrDefault(u => u.IdAspUsuario == userId);
            if (usuarioCP != null)
                return context.Usuario_Cliente.Any(uc => uc.IdCliente == clienteId && uc.IdUsuario == usuarioCP.IdUsuario && uc.Rol.ReportingRolPermisos.Any(rp => rp.ReportingPermisos.permiso == permiso));
            else
                return false;
        }
        public void saveFiltros(int clienteId, int userId, string jsonFiltros)
        {
            var user = context.Usuario_Cliente.First(u => u.IdUsuario == userId && u.IdCliente == clienteId);
            user.filtrojson = jsonFiltros;

            context.Entry(user);
            context.SaveChanges();
        }
        public string getFiltros(int clienteId, int userId)
        {
            var usucliente = context.Usuario_Cliente.First(uc => uc.IdCliente == clienteId && uc.IdUsuario == userId);
            return usucliente.filtrojson;

        }

        public List<ReportingVisibilidadEntreUsuario> GetVisibilidadEntreUsuarios(int clienteId, int idUsuarioPadre)
        {
            return context.ReportingVisibilidadEntreUsuario.Where(m => m.IdUsuario == idUsuarioPadre && m.IdCliente == clienteId).ToList();
        }
        public Usuario GetUsuarioById(int idusuario)
        {
            return context.Usuario.FirstOrDefault(u => u.IdUsuario == idusuario);
        }
        public Usuario GetUsuarioInClientById(int idusuario, int ClienteId)
        {
            return context.Usuario.FirstOrDefault(u => u.IdUsuario == idusuario && u.Usuario_Cliente.Any(uc => uc.IdCliente == ClienteId));
        }
        public List<Usuario> GetUsuarios(int clienteId, bool permiteCheckPos)
        {
            return context.Usuario_Cliente.Where(uc => uc.IdCliente == clienteId && (permiteCheckPos || !((bool)uc.Usuario.esCheckPos))).Select(uc => uc.Usuario).ToList();
        }
        public List<Usuario> GetUsuariosDeUsuario(int idcliente, int userId)
        {
            return context.ReportingVisibilidadEntreUsuario.Where(r => r.IdCliente == idcliente && r.IdUsuario == userId && r.IdUsuarioHijo != userId).Select(r => r.Hijo).ToList();
        }
        public void GuardarVisibilidadUsuarios(int userPadre, int clienteId, List<int> hijos)
        {
            var listaactual = context.ReportingVisibilidadEntreUsuario.Where(r => r.IdUsuario == userPadre);
            context.ReportingVisibilidadEntreUsuario.RemoveRange(listaactual);
            foreach (int h in hijos)
            {
                var nuevo = new ReportingVisibilidadEntreUsuario() { IdCliente = clienteId, IdUsuario = userPadre, IdUsuarioHijo = h };
                context.ReportingVisibilidadEntreUsuario.Add(nuevo);
            }
            context.SaveChanges();
        }
        public void AsignarPermisosARol(int idRol, List<ReportingRolPermisos> permisos)
        {
            var permisosexistentes = context.ReportingRolPermisos.Where(p => p.idRol == idRol);
            context.ReportingRolPermisos.RemoveRange(permisosexistentes);
            context.SaveChanges();

            foreach (var p in permisos)
            {
                context.ReportingRolPermisos.Add(p);
            }
            context.SaveChanges();
        }

        public int GetUltimoClienteSeleccionado(int idUsuario)
        {
            Usuario u = context.Usuario.Where(x => x.IdUsuario == idUsuario).FirstOrDefault();
            if (u != null)
                return u.UltimoClienteSeleccionado;
            else
                return 0;
        }
        public void SetUltimoClienteSeleccionado(int idUsuario, int idCliente)
        {
            Usuario u = context.Usuario.Where(x => x.IdUsuario == idUsuario).FirstOrDefault();
            u.UltimoClienteSeleccionado = idCliente;
            context.SaveChanges();
        }

        public string GetModuloDisponible(int idUsuario, int idCliente)
        {
            Usuario_Cliente user_client = context.Usuario_Cliente.Where(uc => (uc.IdCliente == idCliente) && (uc.IdUsuario == idUsuario)).FirstOrDefault();
            var rol = user_client.RolId;
            List<ReportingRolPermisos> permiso_usuario = context.ReportingRolPermisos.Where(rp => rp.idRol == rol).ToList();
            List<int> idPermiso = new List<int>();
            foreach (ReportingRolPermisos p in permiso_usuario)
            {
                idPermiso.Add(p.idPermiso);
            }
            ReportingPermisos permiso;
            try
            {
                permiso = context.ReportingPermisos.Where(rp => idPermiso.Contains(rp.id) && rp.permiso.StartsWith("ver")).FirstOrDefault();
            }
            catch
            {
                permiso = new ReportingPermisos();
            }

            //PASAR ESTO A UNA TABLA DE EQUIVALENCIAS, tambien esta harcodeado al momento de iniciar el programa y seleccionar un modulo
            //Lo hago con CASE's para salir del apuro
            if (permiso == null) { return ""; }

            string txtPermiso = permiso.permiso.ToString();
            string txtModulo = string.Empty;

            switch (txtPermiso)
            {
                case "verTablero":
                    txtModulo = "Tableros";
                    break;
                case "verImagenes":
                    txtModulo = "Imagenes";
                    break;
                case "verDatos":
                    txtModulo = "Datos";
                    break;
                case "verMapas":
                    txtModulo = "Geo";
                    break;
                case "verAlertas":
                    txtModulo = "Alertas";
                    break;
                case "verCalendario":
                    txtModulo = "Calendario";
                    break;
                default:
                    txtModulo = "";
                    break;
            }

            return txtModulo;
        }


        public bool EdicionUsuarioPerfil(int ClienteId, Usuario user, int RolId)
        {
            try
            {
                if (context.Usuario_Cliente.Any(uc => uc.IdUsuario == user.IdUsuario && uc.IdCliente == ClienteId))
                {
                    context.Entry(user).State = EntityState.Modified;

                    var ucliente = context.Usuario_Cliente.FirstOrDefault(uc => uc.IdCliente == ClienteId && uc.IdUsuario == user.IdUsuario);

                    if (RolId > 0)
                    {
                        if (ucliente != null)
                        {
                            ucliente.RolId = RolId;
                            context.Entry(ucliente).State = EntityState.Modified;
                        }
                    }
                    else
                    {
                        if (ucliente != null)
                        {
                            ucliente.RolId = null;
                            context.Entry(ucliente).State = EntityState.Modified;
                        }
                    }

                    context.SaveChanges();
                    return true;
                }
                else
                {
                    return false;
                }
            }
            catch
            {
                return false;
            }
        }

        public bool EdicionUsuarioPerfil(int ClienteId, Usuario user)
        {
            try
            {
                if (context.Usuario_Cliente.Any(uc => uc.IdUsuario == user.IdUsuario && uc.IdCliente == ClienteId))
                {
                    context.Entry(user).State = EntityState.Modified;
                    context.SaveChanges();
                }

                return true;
            }
            catch
            {
                return false;
            }
        }

        public List<PuntoDeVenta> GetPuntosDeVentaDeUsuario(int clienteId, int userId)
        {
            if (context.Usuario_Cliente.Any(uc => uc.IdCliente == clienteId && uc.IdUsuario == userId))
            {
                return context.Usuario_PuntoDeVenta.Where(uc => uc.IdUsuario == userId && uc.Activo == true && uc.PuntoDeVenta.IdCliente == clienteId).Select(uc => uc.PuntoDeVenta).ToList();
            }
            else
            {
                return null;
            }
        }

        public int CrearEventoCalendario(Calendario evento, int clienteId)
        {
            if (context.Usuario_Cliente.Any(uc => uc.IdCliente == clienteId && uc.IdUsuario == evento.IdUsuario))
            {
                if (context.Usuario_PuntoDeVenta.Any(up => up.IdUsuario == evento.IdUsuario && up.IdPuntoDeVenta == evento.IdPuntoDeVenta))
                {
                    context.Calendario.Add(evento);
                    context.SaveChanges();
                }
            }

            return evento.Id;
        }

        public int EditarEventoCalendario(Calendario evento)
        {
            if (context.Usuario_Cliente.Any(uc => uc.IdCliente == evento.IdCliente && uc.IdUsuario == evento.IdUsuario))
            {
                if (context.Usuario_PuntoDeVenta.Any(up => up.IdUsuario == evento.IdUsuario && up.IdPuntoDeVenta == evento.IdPuntoDeVenta))
                {
                    context.Entry(evento).State = EntityState.Modified;
                    context.SaveChanges();
                }
            }

            return evento.Id;
        }

        public Calendario GetEventoById(int clienteid, int id)
        {
            return context.Calendario.Where(c => c.Id == id && c.IdCliente == clienteid).FirstOrDefault();
        }

        public bool EliminarEventoCalendario(int id, int clienteId)
        {
            try
            {
                if (id > 0)
                {
                    var ent = context.Calendario.FirstOrDefault(c => c.Id == id && c.IdCliente == clienteId);
                    if (ent != null)
                    {
                        context.Calendario.Remove(ent);
                        context.SaveChanges();
                    }
                    return true;
                }
                else
                {
                    return false;
                }
            }
            catch
            {
                return false;
            }
        }

        public List<Calendario> GetEventosCalendario(int clientId, DateTime? start = null, DateTime? end = null, int? userId = null)
        {
            return context.Calendario.Where(c => c.IdCliente == clientId
                                                && c.FechaInicio >= (start?? c.FechaInicio)
                                                && c.FechaInicio <= (end?? c.FechaInicio)
                                                && c.IdUsuario == (userId?? c.IdUsuario))
                                                .Include("Usuario")
                                                .Include("PuntoDeVenta")
                                                .ToList();
        }
        public PuntoDeVenta GetPuntDeVentaById(int idPuntoDeVenta)
        {
            return context.PuntoDeVenta.FirstOrDefault(p => p.IdPuntoDeVenta == idPuntoDeVenta);
        }

        public ReportingRoles GetRolById(int RolId, int ClienteId)
        {
            return context.ReportingRoles.FirstOrDefault(r => r.id == RolId && r.idCliente == ClienteId);
        }
        public bool EditarRol(int ClienteId, ReportingRoles Rol, List<int> Permisos)
        {
            try
            {
                ReportingRoles rol = context.ReportingRoles.FirstOrDefault(r => r.idCliente == ClienteId && r.id == Rol.id);
                if (rol == null)
                {
                    return false;
                }

                context.ReportingRolPermisos.RemoveRange(rol.ReportingRolPermisos);

                foreach (var p in Permisos)
                {
                    rol.ReportingRolPermisos.Add(new ReportingRolPermisos()
                    {
                        idPermiso = p,
                        idRol = rol.id
                    });
                }

                context.Entry(rol).State = EntityState.Modified;
                context.SaveChanges();

                return true;
            }
            catch
            {
                return false;
            }
        }

        public bool IsUsuarioInCliente(int ClienteId, int UsuarioId)
        {
            return context.Usuario_Cliente.Any(uc => uc.IdCliente == ClienteId && uc.IdUsuario == UsuarioId);
        }
        public bool AsignarUsuarioPerfConUsuReporting(int IdUsuarioPerf, int IdUsuarioRep)
        {
            try
            {
                var uc = context.ReportingAspNetUsuario.FirstOrDefault(u => u.IdUsuario == IdUsuarioPerf && u.IdAspUsuario == IdUsuarioRep);
                if (uc != null)
                {
                    context.Entry(uc).State = EntityState.Deleted;
                }

                context.ReportingAspNetUsuario.Add(new ReportingAspNetUsuario()
                {
                    IdUsuario = IdUsuarioPerf,
                    IdAspUsuario = IdUsuarioRep
                });

                context.SaveChanges();

                return true;
            }
            catch
            {
                return false;
            }
        }
        public List<CalendarioConcepto> GetConceptosCalendario(int clienteid)
        {
            return context.CalendarioConceptos.Where(c => c.IdCliente == clienteid && c.Activo).ToList();
        }
        public string GenerarCalendario(int idCliente, int idusuario, string fechaDesde, string fechaHasta)
        {
            const string chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
            var random = new Random();
            string token = new string(Enumerable.Repeat(chars, 30).Select(s => s[random.Next(s.Length)]).ToArray());
            string path = AppDomain.CurrentDomain.BaseDirectory;
            string filename = token + ".xlsx";
            string newfilepath = Path.Combine(path, "Temp", filename);
            List<Calendario> calendar;
            try
            {
                if (idusuario == 0)
                {
                    calendar = GetEventosCalendario(idCliente, DateTime.Parse(fechaDesde), DateTime.Parse(fechaHasta));
                }
                else
                {
                    calendar = GetEventosCalendario(idCliente, DateTime.Parse(fechaDesde), DateTime.Parse(fechaHasta), idusuario);
                }

                XSSFWorkbook wbExcel = new XSSFWorkbook();
                XSSFSheet eSheet = (XSSFSheet)wbExcel.CreateSheet("Tabla");
                XSSFRow rTitulos = (XSSFRow)eSheet.CreateRow(0);
                XSSFRow rCurrent;
                XSSFCell cCurrentUser;
                XSSFCell cCurrentDate;
                XSSFCell cCurrentIdPDV;
                XSSFCell cCurrentPDV;
                XSSFCell cCurrentDirection;
                XSSFCell cCurrentCity;
                XSSFCell cCurrentConcept;
                XSSFCell cCurrentObs;
                XSSFCell cCurrent;
                string[] Titles = { "Usuario", "Fecha", "IdPuntoDeVenta", "Punto de Venta", "Ciudad", "Direccion","Concepto", "Observaciones" };
                int iCell = 0;
                int iRow = 1;
                //TITULO
                foreach (string cTitle in Titles)
                {
                    cCurrent = (XSSFCell)rTitulos.CreateCell(iCell);
                    cCurrent.SetCellValue(cTitle);
                    iCell++;
                }
                
                foreach (Calendario v in calendar)
                {
                    iCell = 0;
                    rCurrent = (XSSFRow)eSheet.CreateRow(iRow++);

                    cCurrentUser = (XSSFCell)rCurrent.CreateCell(iCell++);
                    cCurrentDate = (XSSFCell)rCurrent.CreateCell(iCell++);
                    cCurrentIdPDV = (XSSFCell)rCurrent.CreateCell(iCell++);
                    cCurrentPDV = (XSSFCell)rCurrent.CreateCell(iCell++);
                    cCurrentCity = (XSSFCell)rCurrent.CreateCell(iCell++);
                    cCurrentDirection = (XSSFCell)rCurrent.CreateCell(iCell++);
                    cCurrentConcept = (XSSFCell)rCurrent.CreateCell(iCell++);
                    cCurrentObs = (XSSFCell)rCurrent.CreateCell(iCell++);

                    cCurrentUser.SetCellValue(v.Usuario.Apellido + " " + v.Usuario.Nombre);
                    cCurrentDate.SetCellValue(v.FechaInicio.ToString());
                    cCurrentIdPDV.SetCellValue(v.IdPuntoDeVenta.ToString());
                    cCurrentPDV.SetCellValue(v.PuntoDeVenta.Nombre);
                    cCurrentDirection.SetCellValue(v.PuntoDeVenta.Direccion);
                    cCurrentCity.SetCellValue(v.PuntoDeVenta.Localidad.Nombre);
                    if (v.Concepto != null)
                    {
                        cCurrentConcept.SetCellValue(v.Concepto.Descripcion);
                    }
                    else
                    {
                        cCurrentConcept.SetCellValue(" ");
                    }
                    if (!String.IsNullOrEmpty(v.Observaciones))
                    {
                        cCurrentObs.SetCellValue(v.Observaciones);
                    }
                    else
                    {
                        cCurrentObs.SetCellValue(" ");
                    }
                }
                FileStream File = new FileStream(Path.Combine(path, "Temp", filename), FileMode.Create, FileAccess.Write);
                wbExcel.Write(File);
                File.Close();

                return token;
            }
            catch (Exception e)
            {
                throw e;
            }

        }
    }
}

