using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Reporting.Domain.Abstract;
using Reporting.Domain.Entities;
using System.Data.SqlClient;
using System.Data;

namespace Reporting.Domain.Concrete
{
    public class DashboardRepository:IDashboardRepository
    {
        //private string _modulo = "dashboard";
        //private RepContext context = new RepContext();
        //public Objeto GetObjeto(int ObjetoId)
        //{
        //    return context.Objetos.SingleOrDefault(o => o.Id == ObjetoId);
        //}
        //public Chart getInfoDashboardParaCliente(List<FiltroSeleccionado> Filtros, int ObjetoId, int clienteId)
        //{
        //    EncuestaChart chart = new EncuestaChart();
        //    Objeto obj = GetObjeto(ObjetoId);
            
        //    using (SqlConnection cn = new SqlConnection((new RepContext()).Database.Connection.ConnectionString.ToString()))
        //    {
        //        SqlCommand cmd = new SqlCommand(obj.SPDatos, cn);
        //        cmd.CommandType = CommandType.StoredProcedure;
        //        cmd.Parameters.Add("@IdCliente", SqlDbType.Int).Value = clienteId;

        //        foreach (FiltroSeleccionado f in Filtros)
        //        {
        //            if (f.Valores != null)
        //                cmd.Parameters.Add("@" + f.Filtro, SqlDbType.VarChar).Value = string.Join(",", f.Valores);
        //        }

        //        cn.Open();

        //        SqlDataReader r = cmd.ExecuteReader();

        //        if (r.HasRows)
        //        {
        //            while (r.Read())
        //            {
        //               chart.metricas.Add(new MetricaCircular() { id = int.Parse(r["id"].ToString()), color = "#"+r["color"].ToString(), logo = r["logo"].ToString(), parentId = int.Parse(r["parentId"].ToString()), valor = double.Parse(r["valor"].ToString()), varianza = double.Parse(r["varianza"].ToString()), nivel = int.Parse(r["nivel"].ToString()) });
        //            }
        //        }
        //    }

        //    return chart;
        //}
        //public IEnumerable<Tab> GetTabs(int UsuarioId, int ClienteId)
        //{
        //    return context.Tableros.Where(t => t.modulo == _modulo && t.TableroUsuariosClientes.Any(uc => uc.IdCliente == ClienteId && uc.IdUsuario == UsuarioId)).Select(x => new Tab() { Titulo = x.Nombre, Id = x.Id, Active = false });
        //}
        //public Tablero GetTableroIdOrDefault(int TableroId, int UsuarioId, int ClienteId)
        //{
        //    if (TableroId == 0)
        //        return GetTableroDefault(UsuarioId, ClienteId);
        //    else
        //        return GetTablero(TableroId, UsuarioId, ClienteId);
        //}
        //public Tablero GetTablero(int TableroId, int UsuarioId, int ClienteId)
        //{
        //    return context.Tableros.FirstOrDefault(x => x.Id == TableroId && x.TableroUsuariosClientes.Any(uc => uc.IdUsuario == UsuarioId && uc.IdCliente == ClienteId));
        //}
        //public Tablero GetTableroDefault(int UsuarioId, int ClienteId)
        //{
        //    Tablero tablero;

        //    if (ClienteId == 0)
        //        tablero = null;
        //    else
        //        tablero = context.Tableros.FirstOrDefault(t => t.modulo==_modulo && t.TableroUsuariosClientes.Any(uc => uc.IdUsuario == UsuarioId && uc.IdCliente == ClienteId));

        //    return tablero;
        //}
        //public IEnumerable<TableroObjeto> GetObjetosDeTablero(int TableroId)
        //{
        //    return context.Tableros.SingleOrDefault(t => t.Id == TableroId).Objetos.OrderBy(t => t.Orden);
        //}
        //public IEnumerable<Filtro> GetFiltros(int TableroId, int UsuarioId, int ClienteId)
        //{
        //    //Tablero tablero = GetTablero(TableroId, UsuarioId, ClienteId);
        //    List<Filtro> Filtros = new List<Filtro>();

        //    //Tengo que encontrar los posibles rangos de fecha y agregarlo a Filtros
        //    //[-- code here --]
        //    Filtros.Add(GetFechasReporte(ClienteId));
        //    Filtros.Add(GetAllCadenas(ClienteId));
        //    Filtros.Add(GetAllZonas(ClienteId));
        //    Filtros.Add(GetAllLocalidades(ClienteId));
        //    Filtros.Add(GetAllUsuarios(ClienteId));
        //    Filtros.Add(GetAllPuntosDeVenta(ClienteId));

        //    return Filtros;
        //}
    }
}
