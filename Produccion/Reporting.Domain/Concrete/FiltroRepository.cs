using System.Collections.Generic;
using System.Linq;
using Reporting.Domain.Abstract;
using Reporting.Domain.Entities;
using System.Data.SqlClient;
using System.Data;

namespace Reporting.Domain.Concrete
{
    public class FiltroRepository : IFiltroRepository
    {
        private RepContext context = new RepContext();
        public Filtros GetFiltros(int UsuarioId, int ClienteId, int IdModulo)
        {
            Filtros Filtros = new Filtros();

            using (SqlConnection cn = new SqlConnection((new RepContext()).Database.Connection.ConnectionString.ToString()))
            {
                SqlCommand cmd = new SqlCommand("GetFiltros", cn)
                {
                    CommandType = CommandType.StoredProcedure
                };
                cmd.Parameters.Add("@IdCliente", SqlDbType.Int).Value = ClienteId;
                cmd.Parameters.Add("@IdModulo", SqlDbType.Int).Value = IdModulo;
                cn.Open();

                SqlDataReader r = cmd.ExecuteReader();

                if (r.HasRows)
                {
                    while (r.Read())
                    {

                        ReportingFiltros f = new ReportingFiltros()
                        {
                            id = int.Parse(r["id"].ToString())
                        ,
                            identificador = r["identificador"].ToString()
                        ,
                            nombre = r["nombre"].ToString()
                        ,
                            storedProcedure = r["storedProcedure"].ToString()
                        ,
                            tipoFiltro = (int)r["tipoFiltro"]
                        };

                        switch ((TipoFiltro)f.tipoFiltro)
                        {
                            case TipoFiltro.Fecha:
                                Filtros.FiltrosFechas.Add(GetFiltroFecha(ClienteId, f));
                                break;
                            case TipoFiltro.CheckBox:
                                Filtros.FiltrosChecks.Add(GetFiltroCheck(ClienteId, f,IdModulo));
                                break;
                        }
                    }
                }
            }

            return Filtros;
        }



        private FiltroFecha GetFiltroFecha(int clienteId, ReportingFiltros reportingFiltro)
        {
            FiltroFecha filtro = new FiltroFecha();
            filtro.Id = reportingFiltro.identificador;
            filtro.Nombre = reportingFiltro.nombre;

            return filtro;
        }


        private Dictionary<string, string> GetSpFiltro(int idFiltro)
        {

            Dictionary<string, string> SpData = new Dictionary<string, string>();

            using (SqlConnection cn = new SqlConnection((new RepContext()).Database.Connection.ConnectionString.ToString()))
            {
                SqlCommand cmd = new SqlCommand("GetFiltroSpName", cn);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add("@IdFiltro", SqlDbType.Int).Value = idFiltro;

                cn.Open();

                SqlDataReader r = cmd.ExecuteReader();

                if (r.HasRows)
                {
                    while (r.Read()) //SIEMPRE DEBERIA SER 1 ROW- CORREGIR ESTO
                    {
                        SpData.Add("Identificador", r["id"].ToString());
                        SpData.Add("Nombre", r["nombre"].ToString());
                        SpData.Add("Sp", r["storedProcedure"].ToString());
                        SpData.Add("TipoFiltro", r["tipoFiltro"].ToString());
                    }
                }
            }
            return SpData;
        }

        public FiltroCheck GetTopFiltro(int ClienteId, string identificador, string texto)
        {
            List<ItemFiltro> lst = new List<ItemFiltro>();
            FiltroCheck filtro = new FiltroCheck();
            //Dictionary<string, string> SpFiltro = GetSpFiltro(idFiltro);

            //if (SpFiltro.Count > 0)
            //{
            using (SqlConnection cn = new SqlConnection((new RepContext()).Database.Connection.ConnectionString.ToString()))
            {
                SqlCommand cmd = new SqlCommand("GetFiltroSpName", cn)
                {
                    CommandType = CommandType.StoredProcedure
                };
                cmd.Parameters.Add("@IdCliente", SqlDbType.Int).Value = ClienteId;
                cmd.Parameters.Add("@identificador", SqlDbType.VarChar).Value = identificador; //HARCODEO EL TOP 10, 
                cmd.Parameters.Add("@texto", SqlDbType.VarChar).Value = texto;
                cn.Open();

                SqlDataReader r = cmd.ExecuteReader();

                if (r.HasRows)
                {
                    while (r.Read())
                    {
                        lst.Add(new ItemFiltro()
                        {
                            IdItem = r["IdItem"].ToString(),
                            Descripcion = r["Descripcion"].ToString(),
                            TipoItem = string.Format("itm-{0}", 1),
                            Selected = false
                        });
                    }
                }
            }
            filtro = new FiltroCheck() { Id = identificador, Nombre = identificador, Items = lst };
            //}
            return filtro;
        }

        private FiltroCheck GetFiltroCheck(int clienteId, ReportingFiltros reportingFiltro, int idModulo = 0)
        {

            List<ItemFiltro> lst = new List<ItemFiltro>();

            using (SqlConnection cn = new SqlConnection((new RepContext()).Database.Connection.ConnectionString.ToString()))
            {
                SqlCommand cmd = new SqlCommand(reportingFiltro.storedProcedure, cn);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add("@IdCliente", SqlDbType.Int).Value = clienteId;
                if(idModulo == 4 && reportingFiltro.storedProcedure == "GetFiltrosPuntosDeVenta")  //JARCOOOOR
                {
                    cmd.Parameters.Add("@IdModulo", SqlDbType.Int).Value = idModulo;
                }

                //Pregunto si tiene dependencia de algun filtro, le paso los parametros adicionales

                cn.Open();

                SqlDataReader r = cmd.ExecuteReader();

                if (r.HasRows)
                {
                    while (r.Read())
                    {
                        lst.Add(new ItemFiltro() { IdItem = r["IdItem"].ToString(), Descripcion = r["Descripcion"].ToString(), TipoItem = string.Format("itm-{0}", reportingFiltro.identificador), Selected = false });
                    }
                }
            }

            FiltroCheck filtro = new FiltroCheck() { Id = reportingFiltro.identificador, Nombre = reportingFiltro.nombre, Items = lst };

            return filtro;
        }

        private string MesATexto(int mes)
        {
            string mesRetorno = "";
            switch (mes)
            {
                case 1:
                    mesRetorno = "Enero";
                    break;
                case 2:
                    mesRetorno = "Febrero";
                    break;
                case 3:
                    mesRetorno = "Marzo";
                    break;
                case 4:
                    mesRetorno = "Abril";
                    break;
                case 5:
                    mesRetorno = "Mayo";
                    break;
                case 6:
                    mesRetorno = "Junio";
                    break;
                case 7:
                    mesRetorno = "Julio";
                    break;
                case 8:
                    mesRetorno = "Agosto";
                    break;
                case 9:
                    mesRetorno = "Septiembre";
                    break;
                case 10:
                    mesRetorno = "Octubre";
                    break;
                case 11:
                    mesRetorno = "Noviembre";
                    break;
                case 12:
                    mesRetorno = "Diciembre";
                    break;
            }
            return mesRetorno;
        }
        private string TrimestreATexto(int trimestre)
        {
            string triRetorno = "";
            switch (trimestre)
            {
                case 1:
                    triRetorno = "Primero";
                    break;
                case 2:
                    triRetorno = "Segundo";
                    break;
                case 3:
                    triRetorno = "Tercero";
                    break;
                case 4:
                    triRetorno = "Cuarto";
                    break;
            }
            return triRetorno;
        }
        public List<ReportingFiltroNombreCliente> getFiltroNombreCliente(int clienteId)
        {
            return context.ReportingFiltroNombreCliente.Where(f => f.idCliente == clienteId).ToList();
        }

        public bool IsFiltrosLocked(int tableroId)
        {
            var tablero = context.ReportingTablero.First(x => x.Id == tableroId);
            return !string.IsNullOrEmpty(tablero.filtrosBloqueados);
        }
        public string GetFiltrosBloqueados(int tableroId)
        {
            if (tableroId > -1)
            {
                var tablero = context.ReportingTablero.First(x => x.Id == tableroId);
                return tablero.filtrosBloqueados;
            }
            else return null;
        }
        public void SaveFiltrosTablero(int tableroId, string json)
        {
            var tablero = context.ReportingTablero.First(x => x.Id == tableroId);
            tablero.filtrosBloqueados = json;

            context.Entry(tablero);
            context.SaveChanges();
        }
        public void SaveFiltrosLockState(int tableroId, string filtros)
        {
            var tablero = context.ReportingTablero.First(x => x.Id == tableroId);
            tablero.filtrosBloqueados = filtros;

            context.SaveChanges();
        }
        public void ClearFiltrosAplicados(int userId, int clienteId)
        {
            var uc = context.Usuario_Cliente.FirstOrDefault(u => u.IdCliente == clienteId && u.IdUsuario == userId);
            if (uc != null)
            {
                uc.filtrojson = null;
                context.Entry(uc);
                context.SaveChanges();
            }
        }
    }
}
