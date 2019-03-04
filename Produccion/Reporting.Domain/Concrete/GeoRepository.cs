using System.Collections.Generic;
using Reporting.Domain.Entities;
using Reporting.Domain.Abstract;
using System.Data.SqlClient;
using System.Data;
using System.Linq;
using System;

namespace Reporting.Domain.Concrete
{
    public class GeoRepository : IGeoRepository
    {
        private readonly RepContext context = new RepContext();

        public List<Usuario> GetUsuariosDeRuteo(string FechaHoy, int ClienteId)
        {
            List<Usuario> lstUsuarios = new List<Usuario>();

            using (SqlConnection cn = new SqlConnection((new RepContext()).Database.Connection.ConnectionString.ToString()))
            {
                DataTable dtfiltros = new DataTable();
                dtfiltros.Columns.Add(new DataColumn("IdFiltro", typeof(string)));
                dtfiltros.Columns.Add(new DataColumn("Valores", typeof(string)));

                SqlCommand cmd = new SqlCommand("GetUsuariosDeRuteo", cn);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add("@IdCliente", SqlDbType.Int).Value = ClienteId;

                var fecha = new string[] { "D", FechaHoy, FechaHoy };

                DataRow newRow = dtfiltros.NewRow();
                newRow[0] = "fltFechaReporte";
                newRow[1] = string.Join(",", fecha);

                dtfiltros.Rows.Add(newRow);

                cmd.Parameters.Add("@Filtros", SqlDbType.Structured).Value = dtfiltros;
                cmd.Parameters.Add("@Lenguaje", SqlDbType.VarChar).Value = System.Threading.Thread.CurrentThread.CurrentCulture.Name;

                cn.Open();

                SqlDataReader r = cmd.ExecuteReader();

                if (r.HasRows)
                {
                    while (r.Read())
                    {
                        lstUsuarios.Add(new Usuario()
                        {
                            Nombre = r["Nombre"].ToString(),
                            Apellido = r["Apellido"].ToString(),
                            imagen = r["Imagen"].ToString(),
                            IdUsuario = int.Parse(r["IdUsuario"].ToString())
                        });
                    }
                }
            }
            return lstUsuarios;
        }
        public GeoRuta GetRutaDeUsuario(string FechaHoy, int IdUsuario, int ClienteId)
        {
            GeoRuta ruta = new GeoRuta();

            using (SqlConnection cn = new SqlConnection((new RepContext()).Database.Connection.ConnectionString.ToString()))
            {
                DataTable dtfiltros = new DataTable();
                dtfiltros.Columns.Add(new DataColumn("IdFiltro", typeof(string)));
                dtfiltros.Columns.Add(new DataColumn("Valores", typeof(string)));

                SqlCommand cmd = new SqlCommand("GetUserTrack", cn);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add("@IdCliente", SqlDbType.Int).Value = ClienteId;

                var fecha = new string[] { "D", FechaHoy, FechaHoy };

                DataRow newRow = dtfiltros.NewRow();
                newRow[0] = "fltFechaReporte";
                newRow[1] = string.Join(",", fecha);
                dtfiltros.Rows.Add(newRow);

                newRow = dtfiltros.NewRow();
                newRow[0] = "IdUsuario";
                newRow[1] = IdUsuario;
                dtfiltros.Rows.Add(newRow);

                cmd.Parameters.Add("@Filtros", SqlDbType.Structured).Value = dtfiltros;
                cmd.Parameters.Add("@Lenguaje", SqlDbType.VarChar).Value = System.Threading.Thread.CurrentThread.CurrentCulture.Name;

                cn.Open();

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataSet ds = new DataSet();
                da.Fill(ds);

                //Marcadores
                DataTable dtMarcadores = ds.Tables[0];
                foreach (DataRow row in dtMarcadores.Rows)
                {
                    ruta.marcadores.Add(new GeoMarker()
                    {
                        lat = decimal.Parse(row["lat"].ToString()),
                        lng = decimal.Parse(row["lng"].ToString()),
                        idUsuario = int.Parse(row["idUsuario"].ToString()),
                        icon = row["icon"].ToString(),
                        idReporte = int.Parse((string.IsNullOrEmpty(row["idReporte"].ToString())) ? "0" : row["idReporte"].ToString()),
                        usuario = row["usuario"].ToString(),
                        fecha = row["fecha"].ToString(),
                        tipo = row["tipo"].ToString(),
                        label = row["id"].ToString(),
                        operacion = row["operacion"].ToString(),
                        categoria = row["categoria"].ToString()
                    });
                }

                //Ruta
                DataTable dtRuta = ds.Tables[1];
                foreach (DataRow row in dtRuta.Rows)
                {
                    ruta.ruta.Add(new GeoPos()
                    {
                        lat = decimal.Parse(row["lat"].ToString()),
                        lng = decimal.Parse(row["lng"].ToString()),
                        label = row["id"].ToString()
                    });
                }
            }
            return ruta;
        }

        public List<Usuario> GetUsuariosCliente(List<FiltroSeleccionado> Filtros, int ClienteId)
        {
            List<Usuario> lstUsuarios = new List<Usuario>();

            using (SqlConnection cn = new SqlConnection((new RepContext()).Database.Connection.ConnectionString.ToString()))
            {
                DataTable dtfiltros = new DataTable();
                dtfiltros.Columns.Add(new DataColumn("IdFiltro", typeof(string)));
                dtfiltros.Columns.Add(new DataColumn("Valores", typeof(string)));

                SqlCommand cmd = new SqlCommand("GetUsuariosCliente", cn)
                {
                    CommandType = CommandType.StoredProcedure
                };
                cmd.Parameters.Add("@IdCliente", SqlDbType.Int).Value = ClienteId;


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
                cmd.Parameters.Add("@Filtros", SqlDbType.Structured).Value = dtfiltros;


                cn.Open();

                SqlDataReader r = cmd.ExecuteReader();

                if (r.HasRows)
                {
                    while (r.Read())
                    {
                        lstUsuarios.Add(new Usuario()
                        {
                            Nombre = r["Nombre"].ToString(),
                            Apellido = r["Apellido"].ToString(),
                            IdUsuario = int.Parse(r["IdUsuario"].ToString()),
                            imagen = r["Imagen"].ToString()
                        });
                    }
                }
            }

            return lstUsuarios;
        }


        public int GetDiferenciaHorariaCliente(int IdCliente)
        {
            int difHoraria = 0;
            using (SqlConnection cn = new SqlConnection((new RepContext()).Database.Connection.ConnectionString.ToString()))
            {
                SqlCommand cmd = new SqlCommand("GetDifereciaHorariaCliente", cn)
                {
                    CommandType = CommandType.StoredProcedure
                };
                cmd.Parameters.Add("@IdCliente", SqlDbType.Int).Value = IdCliente;
                cn.Open();

                SqlDataReader r = cmd.ExecuteReader();

                if (r.HasRows)
                {
                    while (r.Read())
                    {
                        difHoraria = int.Parse(r["DiferenciaHoararia"].ToString());
                    }
                }
            }
            return difHoraria;
        }

        public GeoInfoPdv GetInfoPDV(int idPuntoDeVenta)
        {
            GeoInfoPdv infoPDV = null;

            using (SqlConnection cn = new SqlConnection((new RepContext()).Database.Connection.ConnectionString.ToString()))
            {
                SqlCommand cmd = new SqlCommand("GetInfoPDV", cn)
                {
                    CommandType = CommandType.StoredProcedure
                };
                cmd.Parameters.Add("@IdPuntoDeVenta", SqlDbType.Int).Value = idPuntoDeVenta;

                cn.Open();

                SqlDataReader r = cmd.ExecuteReader();

                if (r.HasRows && r.Read())
                {
                    infoPDV = new GeoInfoPdv
                    {
                        BusinessName = r["RazonSocial"].ToString(),
                        Categorie = r["Categoria"].ToString(),
                        Chain = r["Cadena"].ToString(),
                        Direction = r["Direccion"].ToString(),
                        Name = r["Nombre"].ToString(),
                        Phone = r["Telefono"].ToString(),
                        PlaceID = r["PlaceID"].ToString(),
                        PostalCode = r["CodigoPostal"].ToString(),
                        Contact = r["Contacto"].ToString(),
                        Email = r["Email"].ToString(),
                    };
                }
            }
            return infoPDV;
        }

        public List<GeoMarkerSimple> GetMarkersCoberturaCliente(List<FiltroSeleccionado> Filtros, int ClienteId)
        {
            List<GeoMarkerSimple> lstMarcadores = new List<GeoMarkerSimple>();

            using (SqlConnection cn = new SqlConnection((new RepContext()).Database.Connection.ConnectionString.ToString()))
            {
                DataTable dtfiltros = new DataTable();
                dtfiltros.Columns.Add(new DataColumn("IdFiltro", typeof(string)));
                dtfiltros.Columns.Add(new DataColumn("Valores", typeof(string)));

                SqlCommand cmd = new SqlCommand("GetMarkersCoberturaCliente", cn)
                {
                    CommandType = CommandType.StoredProcedure
                };

                cmd.Parameters.Add("@IdCliente", SqlDbType.Int).Value = ClienteId;

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
                cmd.Parameters.Add("@Filtros", SqlDbType.Structured).Value = dtfiltros;
                cmd.Parameters.Add("@Lenguaje", SqlDbType.VarChar).Value = System.Threading.Thread.CurrentThread.CurrentCulture.Name;

                cn.Open();

                SqlDataReader r = cmd.ExecuteReader();

                if (r.HasRows)
                {
                    while (r.Read())
                    {
                        lstMarcadores.Add(new GeoMarkerSimple()
                        {
                            lat = decimal.Parse(r["latitud"].ToString()),
                            lng = decimal.Parse(r["longitud"].ToString()),
                            visitado = r["visitado"].ToString(),
                            icon = r["icon"].ToString(),
                            idPuntoDeVenta = int.Parse(r["idPuntoDeVenta"].ToString()),
                            ultimoReporte = r["FechaUltimoReporte"].ToString(),
                            usuario = r["Usuario"].ToString()
                        });
                    }
                }

            }

            return lstMarcadores;
        }

        public List<ReportDetailModel> GetDetailsReportsPDV(List<FiltroSeleccionado> Filtros, int idPuntoDeVenta)
        {
            List<ReportDetailModel> listReport = new List<ReportDetailModel>();

            using (SqlConnection cn = new SqlConnection((new RepContext()).Database.Connection.ConnectionString.ToString()))
            {
                DataTable dtfiltros = new DataTable();
                dtfiltros.Columns.Add(new DataColumn("IdFiltro", typeof(string)));
                dtfiltros.Columns.Add(new DataColumn("Valores", typeof(string)));

                SqlCommand cmd = new SqlCommand("GetDetailReportPDV", cn)
                {
                    CommandType = CommandType.StoredProcedure
                };
                cmd.Parameters.Add("@IdPuntoDeVenta", SqlDbType.Int).Value = idPuntoDeVenta;

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
                cmd.Parameters.Add("@Filtros", SqlDbType.Structured).Value = dtfiltros;


                cn.Open();

                SqlDataReader r = cmd.ExecuteReader();

                if (r.HasRows)
                {
                    while (r.Read())
                    {
                        listReport.Add(new ReportDetailModel
                        {
                            Date = r["Fecha"].ToString(),
                            ReportId = r["IdReporte"].ToString(),
                            UserIMG = r["FotoUsuario"].ToString(),
                            UserName = r["NombreUsuario"].ToString()
                        });
                    }
                }
            }
            return listReport;
        }

        public GeoInfoReportModel GetInfoReporte(int idReporte)
        {
            GeoInfoReportModel infoRep = null;

            using (SqlConnection cn = new SqlConnection((new RepContext()).Database.Connection.ConnectionString.ToString()))
            {
                SqlCommand cmd = new SqlCommand("GetInfoReporteGeo", cn)
                {
                    CommandType = CommandType.StoredProcedure
                };
                cmd.Parameters.Add("@IdReporte", SqlDbType.Int).Value = idReporte;

                cn.Open();

                SqlDataReader r = cmd.ExecuteReader();

                if (r.HasRows && r.Read())
                {
                    infoRep = new GeoInfoReportModel
                    {
                        idReporte = int.Parse(r["idReporte"].ToString()),
                        Name = r["puntoDeVenta"].ToString(),
                        Categorie = r["categoria"].ToString(),
                        Chain = r["cadena"].ToString(),
                        BusinessName = r["razonSocial"].ToString(),
                        Direction = r["direccion"].ToString(),
                        UserName = r["usuario"].ToString(),
                        IdPDV = int.Parse(r["idPuntoDeVenta"].ToString()),
                        CreationDate = r["fechaCreacion"].ToString(),
                        CloseDate = r["fechaCierre"].ToString(),
                        SendDate = r["fechaEnvio"].ToString(),
                        ReceptionDate = r["fechaRecepcion"].ToString(),
                        UpdateDate = r["fechaActualizacion"].ToString(),
                        Signature = (r["firma"].ToString() == "1")
                    };
                }
            }
            return infoRep;
        }

        public string GetSignatureReport(int idReporte)
        {
            Reporte report = context.Reporte.FirstOrDefault(f => f.IdReporte == idReporte);
            if (report.Firma != string.Empty)
            {
                return "data:image/png;base64" + report.Firma;
            }
            return string.Empty;
        }
    }
}
