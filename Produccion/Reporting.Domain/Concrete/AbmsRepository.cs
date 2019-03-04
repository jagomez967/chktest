using System;
using System.Collections.Generic;
using System.Linq;
using Reporting.Domain.Abstract;
using Reporting.Domain.Entities;
using System.Data.SqlClient;
using System.Data;
using System.Data.Entity;

namespace Reporting.Domain.Concrete
{
    public class AbmsRepository : IAbmsRepository
    {
        private RepContext context = new RepContext();
        public List<Alertas> GetAlertas(int clienteId, string searchtext)
        {
            if (string.IsNullOrEmpty(searchtext))
            {
                return context.Alertas.Where(a => a.IdCliente == clienteId && !a.Eliminado).ToList();
            }
            else
            {
                List<Alertas> alertas = context.Alertas.Where(a => a.IdCliente == clienteId && !a.Eliminado).ToList();

                List<Alertas> alertasbysearch = alertas.Where(a =>
                        a.Descripcion.ToLower().Contains(searchtext.ToLower())
                        || a.Destinatarios.ToLower().Contains(searchtext.ToLower())
                        || a.PuntosDeVenta.ToLower().Contains(searchtext.ToLower())).ToList();

                List<string> puntosdeventaid = context.PuntoDeVenta.Where(p =>
                    p.IdCliente == clienteId
                    &&
                    (
                        p.Nombre.ToLower().Contains(searchtext.ToLower())
                        || p.IdPuntoDeVenta.ToString().Contains(searchtext.ToLower())
                    )).Select(p => p.IdPuntoDeVenta.ToString()).ToList<string>();

                List<Alertas> alertasbypdv = alertas.Where(a => a.PuntosDeVenta.Replace(";", "").Split(',').ToList().Intersect(puntosdeventaid).ToList().Count > 0).ToList();

                List<Alertas> ret = alertasbysearch.Union(alertasbypdv).Distinct().ToList();

                return ret;
            }
        }
        public bool CrearAlerta(Alertas alerta)
        {
            try
            {
                context.Alertas.Add(alerta);

                context.SaveChanges();
                return true;
            }
            catch (Exception e)
            {
                e.ToString();
                return false;
            }
        }
        public string EditarAlerta(Alertas alerta)
        {
            try
            {
                if (!context.Alertas.Any(a => a.Id == alerta.Id && a.IdCliente == alerta.IdCliente))
                    return "no existe alerta";

                var original = context.Alertas.Find(alerta.Id);

                context.AlertasCampos.RemoveRange(original.AlertasCampos);
                context.AlertasProductos.RemoveRange(original.AlertasProductos);
                context.AlertasModulos.RemoveRange(original.AlertasModulos);

                if (original != null)
                {
                    original.AccionTriggerSeleccionada = alerta.AccionTriggerSeleccionada;
                    original.Activo = alerta.Activo;
                    original.Descripcion = alerta.Descripcion;
                    original.Destinatarios = alerta.Destinatarios;
                    original.Lunes = alerta.Lunes;
                    original.Martes = alerta.Martes;
                    original.Miercoles = alerta.Miercoles;
                    original.Jueves = alerta.Jueves;
                    original.Viernes = alerta.Viernes;
                    original.Sabado = alerta.Sabado;
                    original.Domingo = alerta.Domingo;
                    original.Hora = alerta.Hora;
                    original.Consolidado = alerta.Consolidado;
                    original.TipoReporteSeleccionado = alerta.TipoReporteSeleccionado;
                    original.IdUsuario = alerta.IdUsuario;
                    original.PuntosDeVenta = alerta.PuntosDeVenta;
                    original.Distancia = alerta.Distancia;
                    original.HoraInicio = alerta.HoraInicio;
                    original.HoraFin = alerta.HoraFin;
                }

                foreach (var a in alerta.AlertasCampos)
                {
                    context.AlertasCampos.Add(a);
                }

                foreach (var p in alerta.AlertasProductos)
                {
                    context.AlertasProductos.Add(p);
                }

                foreach (var m in alerta.AlertasModulos)
                {
                    context.AlertasModulos.Add(m);
                }

                context.Entry(original);

                context.SaveChanges();
                return "true";
            }
            catch (Exception e)
            {
                return e.Message;
            }
        }

        public List<AlertaCampo> GetCamposAlerta(int clienteId)
        {
            List<AlertaCampo> ret = new List<AlertaCampo>();

            using (SqlConnection cn = new SqlConnection((new RepContext()).Database.Connection.ConnectionString.ToString()))
            {
                SqlCommand cmd = new SqlCommand("GetCamposAlerta")
                {
                    CommandType = CommandType.StoredProcedure,
                    CommandTimeout = 30
                };
                cmd.Parameters.Add("@IdCliente", SqlDbType.Int).Value = clienteId;

                cmd.Connection = cn;

                cn.Open();

                SqlDataReader r = cmd.ExecuteReader();

                if (r.HasRows)
                {
                    while (r.Read())
                    {
                        ret.Add(new AlertaCampo() { IdMarca = int.Parse(r["IdMarca"].ToString()), IdSeccion = int.Parse(r["IdSeccion"].ToString()), IdCampo = int.Parse(r["IdCampo"].ToString()), MarcaDescr = r["MarcaDescr"].ToString(), SeccionDescr = r["SeccionDescr"].ToString(), CampoDescr = r["CampoDescr"].ToString() });
                    }
                }
            }

            return ret;
        }

        public List<AlertaModulo> GetModulosAlerta(int clienteId)
        {
            List<AlertaModulo> res = new List<AlertaModulo>();

            using (SqlConnection cn = new SqlConnection((new RepContext()).Database.Connection.ConnectionString.ToString()))
            {
                SqlCommand cmd = new SqlCommand("GetModulosAlerta")
                {
                    CommandType = CommandType.StoredProcedure,
                    CommandTimeout = 30
                };
                cmd.Parameters.Add("@IdCliente", SqlDbType.Int).Value = clienteId;

                cmd.Connection = cn;

                cn.Open();

                SqlDataReader r = cmd.ExecuteReader();

                if (r.HasRows)
                {
                    while (r.Read())
                    {
                        res.Add(new AlertaModulo()
                        {
                            Id = int.Parse(r["Id"].ToString()),
                            IdModuloItem = int.Parse(r["IdModuloItem"].ToString()),
                            Leyenda = r["Leyenda"].ToString()
                        });
                    }

                }
            }
            return res;
        }

        public List<AlertasModulos> GetItemsModulosAlerta(int clienteId, int alertaId)
        {
            List<AlertasModulos> res = new List<AlertasModulos>();

            using (SqlConnection cn = new SqlConnection((new RepContext()).Database.Connection.ConnectionString.ToString()))
            {
                SqlCommand cmd = new SqlCommand("GetItemsModulosAlerta")
                {
                    CommandType = CommandType.StoredProcedure,
                    CommandTimeout = 30
                };
                cmd.Parameters.Add("@IdCliente", SqlDbType.Int).Value = clienteId;
                cmd.Parameters.Add("@IdAlerta", SqlDbType.Int).Value = alertaId;
                cmd.Connection = cn;

                cn.Open();

                SqlDataReader r = cmd.ExecuteReader();

                if (r.HasRows)
                {
                    while (r.Read())
                    {
                        res.Add(new AlertasModulos()
                        {
                            Id = int.Parse(r["Id"].ToString()),
                            IdAlerta = int.Parse(r["IdAlerta"].ToString()),
                            IdModuloItem = int.Parse(r["IdModuloItem"].ToString()),
                            IdModuloClienteItem = int.Parse(r["IdModuloClienteItem"].ToString()),
                            Leyenda = r["Leyenda"].ToString(),
                            EsMayor = int.Parse(r["EsMayor"].ToString()),
                            EsMenor = int.Parse(r["EsMenor"].ToString()),
                            EsIgual = int.Parse(r["EsIgual"].ToString()),
                            Valor = Decimal.Parse(r["Valor"].ToString())
                        });
                    }

                }
            }
            return res;
        }



        public List<AlertaProducto> GetProductosAlerta(int clienteId)
        {
            List<AlertaProducto> ret = new List<AlertaProducto>();

            using (SqlConnection cn = new SqlConnection((new RepContext()).Database.Connection.ConnectionString.ToString()))
            {
                SqlCommand cmd = new SqlCommand("GetProductosAlerta")
                {
                    CommandType = CommandType.StoredProcedure,
                    CommandTimeout = 30
                };
                cmd.Parameters.Add("@IdCliente", SqlDbType.Int).Value = clienteId;

                cmd.Connection = cn;

                cn.Open();

                SqlDataReader r = cmd.ExecuteReader();

                if (r.HasRows)
                {
                    while (r.Read())
                    {
                        ret.Add(new AlertaProducto()
                        {
                            IdMarca = int.Parse(r["IdMarca"].ToString()),
                            IdProducto = int.Parse(r["IdProducto"].ToString()),
                            ProductoDescr = r["ProductoDescr"].ToString(),
                            MarcaDescr = r["MarcaDescr"].ToString(),
                        });
                    }
                }
            }

            return ret;
        }

        public Alertas GetAlerta(int id)
        {
            return context.Alertas.FirstOrDefault(a => a.Id == id);
        }
        public void EliminarAlerta(int clienteId, int id)
        {
            var mailsnoenviados = context.EmpresaMail.Where(e => e.IdAlerta == id && !e.Enviado);
            context.EmpresaMail.RemoveRange(mailsnoenviados);

            var alerta = context.Alertas.FirstOrDefault(a => a.IdCliente == clienteId && a.Id == id);
            if (alerta != null)
            {
                alerta.Eliminado = true;
                context.Entry(alerta).State = EntityState.Modified;
            }

            context.SaveChanges();

        }
        public List<PuntoDeVentaAlerta> GetPuntosDeVentaAlerta(int clienteId)
        {
            List<PuntoDeVentaAlerta> lst = new List<PuntoDeVentaAlerta>();

            using (SqlConnection cn = new SqlConnection((new RepContext()).Database.Connection.ConnectionString.ToString()))
            {
                SqlCommand cmd = new SqlCommand("GetPuntosDeVentaAlerta", cn)
                {
                    CommandType = CommandType.StoredProcedure
                };
                cmd.Parameters.Add("@IdCliente", SqlDbType.Int).Value = clienteId;

                cn.Open();

                SqlDataReader r = cmd.ExecuteReader();
                DataTable dt = new DataTable();
                dt.Load(r);


                if (dt != null && dt.Rows != null && dt.Rows.Count > 0)
                {
                    foreach (DataRow dr in dt.Rows)
                    {
                        lst.Add(new PuntoDeVentaAlerta()
                        {
                            idZona = int.Parse(dr["idZona"].ToString()),
                            ZonaDescr = dr["ZonaDescr"].ToString(),
                            idCadena = (!string.IsNullOrEmpty(dr["idCadena"].ToString())) ? int.Parse(dr["idCadena"].ToString()) : 0,
                            CadenaDescr = dr["CadenaDescr"].ToString(),
                            idPuntoDeVenta = int.Parse(dr["idPuntoDeVenta"].ToString()),
                            PuntoDeVentaDescr = dr["PuntoDeVentaDescr"].ToString(),
                            RazonSocial = dr["razonSocial"].ToString()
                        });
                    }
                }
            }
            return lst;
        }
    }
}
