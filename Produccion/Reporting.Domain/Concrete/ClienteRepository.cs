using System.Collections.Generic;
using System.Linq;
using Reporting.Domain.Abstract;
using Reporting.Domain.Entities;
using System;
using System.Data.SqlClient;
using System.Data;
using System.Data.Entity;


namespace Reporting.Domain.Concrete
{
    public class ClienteRepository : IClienteRepository
    {
        private RepContext context = new RepContext();
        public List<Cliente> GetClientes(int UsuarioId)
        {
            return context.Cliente.Where(c => c.Usuario_Cliente.Any(u => u.IdUsuario == UsuarioId)).ToList();
        }
        public Cliente GetCliente(int ClienteId)
        {
            return context.Cliente.FirstOrDefault(c => c.IdCliente == ClienteId);
        }
        public Cliente GetClienteByReporte(int ReporteId)
        {
            var EmpresaId = context.Reporte.FirstOrDefault(r => r.IdReporte == ReporteId).IdEmpresa;
            return context.Cliente.FirstOrDefault(c => c.IdEmpresa == EmpresaId);
        }
        public bool TieneMarcaBlanca(int clienteId)
        {
            Cliente cliente = context.Cliente.FirstOrDefault(c => c.IdCliente == clienteId);
            if (cliente != null)
                return cliente.flgMarcaBlanca;
            else
                return false;
        }
        public Cliente GetDatosMarcaBlanca(int clienteId)
        {
            return context.Cliente.First(m => m.IdCliente == clienteId);
        }
        public IQueryable<Cadena> GetCadenas(int clienteId)
        {
            return context.Cliente.Where(c => c.IdCliente == clienteId).SelectMany(c => c.Empresa.Negocio.Cadena).OrderBy(c => c.Nombre).Distinct();
        }
        public IQueryable<Cadena> GetCadenas(int clienteId, int userId)
        {
            return context.Usuario_PuntoDeVenta.Where(up => up.PuntoDeVenta.IdCliente == clienteId && up.IdUsuario == userId && up.PuntoDeVenta.IdCadena != null).Select(up => up.PuntoDeVenta.Cadena).OrderBy(c => c.Nombre).Distinct();
        }
        public IQueryable<Cadena> GetCadenas(int clienteId, int IdTipoCuenta, int userId)
        {
            if (IdTipoCuenta == 0)
                return context.Usuario_PuntoDeVenta.Where(up => up.PuntoDeVenta.IdCliente == clienteId && up.IdUsuario == userId && up.PuntoDeVenta.IdCadena != null).Select(up => up.PuntoDeVenta.Cadena).OrderBy(c => c.Nombre).Distinct();
            else
                return context.Usuario_PuntoDeVenta.Where(up => up.PuntoDeVenta.IdCliente == clienteId && up.IdUsuario == userId && up.PuntoDeVenta.IdCadena != null && up.PuntoDeVenta.Cadena.IdTipoCadena == IdTipoCuenta).Select(up => up.PuntoDeVenta.Cadena).OrderBy(c => c.Nombre).Distinct();
        }
        public IQueryable<Familia> GetFamilias(int clienteId)
        {
            return context.Cliente.Where(c => c.IdCliente == clienteId).SelectMany(c => c.Empresa.Marcas).SelectMany(m => m.Familias).OrderBy(c => c.Nombre).Distinct();
        }
        public bool SaveMarcaBlanca(int clienteId, bool flgMarcaBlanca, string link)
        {
            try
            {
                Cliente cliente = GetCliente(clienteId);
                cliente.flgMarcaBlanca = flgMarcaBlanca;
                cliente.link = link;
                context.Entry(cliente);
                context.SaveChanges();
                return true;
            }
            catch
            {
                return false;
            }

        }
        public IQueryable<Producto> GetProductos(int clienteId)
        {
            return context.Producto
                .Include(p => p.Familia)
                .Where(p => p.Marca.Empresa.Cliente.Any(c => c.IdCliente == clienteId)).OrderBy(p => new { p.Familia.Nombre, p.Orden });
        }
        public IQueryable<Producto> GetProductos(int clienteId, string textinname)
        {
            return context.Producto
                .Include(p => p.Familia)
                .Where(p => p.Marca.Empresa.Cliente.Any(c => c.IdCliente == clienteId) && p.Nombre.Contains(textinname)).OrderBy(p => new { p.Familia.Nombre, p.Orden });
        }
        public IQueryable<Producto> GetProductos(int clienteId, int IdFamilia, string textinname)
        {
            return context.Producto
                .Include(p => p.Familia)
                .Where(p => p.Marca.Empresa.Cliente.Any(c => c.IdCliente == clienteId) && p.IdFamilia == IdFamilia && p.Nombre.Contains(textinname)).OrderBy(p => new { p.Familia.Nombre, p.Orden });
        }
        public IQueryable<Producto> GetProductos(int clienteId, int[] lstFamilias, string textinname)
        {
            var productos = context.Producto
                .Include(p => p.Familia)
                .Where(p => p.Marca.Empresa.Cliente.Any(c => c.IdCliente == clienteId) && p.Nombre.Contains(textinname));
            return productos.Where(p => lstFamilias.Any(f => f == p.IdFamilia)).OrderBy(p => new { p.Familia.Nombre, p.Orden });
        }

        public int GetCurrentChannelInv (int idProducto)
        {
            int cInvTotal = 0;
            var cInv = context.Forecasting.Where(p => p.IdProducto == idProducto && p.Fecha.Month == DateTime.Now.Month && p.Fecha.Year == DateTime.Now.Year).OrderBy(p => p.Id).ToList();
            if (cInv.Count() == 0) return 0;
            for (int i = 0; i < cInv.Count(); i++) cInvTotal += cInv[i].ChannelInv;
            return cInvTotal;
        }

        public DataSet GetForecasting(int clienteId, string[] lstCanales, string[] lstCadenas, string[] lstCategorias, string[] lstProductos, int IdUsuario)
        {
            try
            {
                List<Forecasting> data = new List<Forecasting>();

                using (SqlConnection cn = new SqlConnection((new RepContext()).Database.Connection.ConnectionString.ToString()))
                {
                    SqlCommand cmd = new SqlCommand("dbo.GetForecasting");
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandTimeout = 240;
                    cmd.Connection = cn;

                    DataTable canales = new DataTable();
                    canales.Columns.Add(new DataColumn("Value", typeof(int)));
                    canales.Columns.Add(new DataColumn("Text", typeof(string)));

                    if (lstCanales != null && lstCanales.Count() > 0)
                    {
                        foreach (string s in lstCanales)
                        {
                            DataRow newRow = canales.NewRow();
                            newRow[0] = int.Parse(s);

                            canales.Rows.Add(newRow);
                        }
                    }

                    DataTable cadenas = new DataTable();
                    cadenas.Columns.Add(new DataColumn("Value", typeof(int)));
                    cadenas.Columns.Add(new DataColumn("Text", typeof(string)));

                    if (lstCadenas != null && lstCadenas.Count() > 0)
                    {
                        foreach (string s in lstCadenas)
                        {
                            DataRow newRow = cadenas.NewRow();
                            newRow[0] = int.Parse(s);

                            cadenas.Rows.Add(newRow);
                        }
                    }

                    DataTable categorias = new DataTable();
                    categorias.Columns.Add(new DataColumn("Value", typeof(int)));
                    categorias.Columns.Add(new DataColumn("Text", typeof(string)));

                    if (lstCategorias != null && lstCategorias.Count() > 0)
                    {
                        foreach (string s in lstCategorias)
                        {
                            DataRow newRow = categorias.NewRow();
                            newRow[0] = int.Parse(s);

                            categorias.Rows.Add(newRow);
                        }
                    }

                    DataTable productos = new DataTable();
                    productos.Columns.Add(new DataColumn("Value", typeof(int)));
                    productos.Columns.Add(new DataColumn("Text", typeof(string)));

                    if (lstProductos != null && lstProductos.Count() > 0)
                    {
                        foreach (string s in lstProductos)
                        {
                            DataRow newRow = productos.NewRow();
                            newRow[0] = int.Parse(s);

                            productos.Rows.Add(newRow);
                        }
                    }

                    cmd.Parameters.Add("@IdCliente", SqlDbType.Int).Value = clienteId;
                    cmd.Parameters.Add("@LstCanales", SqlDbType.Structured).Value = canales;
                    cmd.Parameters.Add("@LstCadenas", SqlDbType.Structured).Value = cadenas;
                    cmd.Parameters.Add("@LstFamilias", SqlDbType.Structured).Value = categorias;
                    cmd.Parameters.Add("@LstProductos", SqlDbType.Structured).Value = productos;
                    cmd.Parameters.Add("@IdUsuario", SqlDbType.Int).Value = IdUsuario;
                    cmd.Parameters.Add("@Fecha", SqlDbType.DateTime).Value = DateTime.Now;

                    cn.Open();

                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    DataSet ds = new DataSet();
                    da.Fill(ds);

                    return ds;
                }
            }
            catch (Exception e)
            {
                throw e;
            }
        }
        public DataSet GetWholeSalePrices(int clienteId, string[] lstCanales, string[] lstCadenas, string[] lstCategorias, string[] lstProductos)
        {
            try
            {
                List<Forecasting> data = new List<Forecasting>();

                using (SqlConnection cn = new SqlConnection((new RepContext()).Database.Connection.ConnectionString.ToString()))
                {
                    SqlCommand cmd = new SqlCommand("dbo.GetWholeSalePrices");
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandTimeout = 240;
                    cmd.Connection = cn;

                    DataTable canales = new DataTable();
                    canales.Columns.Add(new DataColumn("Value", typeof(int)));
                    canales.Columns.Add(new DataColumn("Text", typeof(string)));

                    if (lstCanales != null && lstCanales.Count() > 0)
                    {
                        foreach (string s in lstCanales)
                        {
                            DataRow newRow = canales.NewRow();
                            newRow[0] = int.Parse(s);

                            canales.Rows.Add(newRow);
                        }
                    }

                    DataTable cadenas = new DataTable();
                    cadenas.Columns.Add(new DataColumn("Value", typeof(int)));
                    cadenas.Columns.Add(new DataColumn("Text", typeof(string)));

                    if (lstCadenas != null && lstCadenas.Count() > 0)
                    {
                        foreach (string s in lstCadenas)
                        {
                            DataRow newRow = cadenas.NewRow();
                            newRow[0] = int.Parse(s);

                            cadenas.Rows.Add(newRow);
                        }
                    }

                    DataTable categorias = new DataTable();
                    categorias.Columns.Add(new DataColumn("Value", typeof(int)));
                    categorias.Columns.Add(new DataColumn("Text", typeof(string)));

                    if (lstCategorias != null && lstCategorias.Count() > 0)
                    {
                        foreach (string s in lstCategorias)
                        {
                            DataRow newRow = categorias.NewRow();
                            newRow[0] = int.Parse(s);

                            categorias.Rows.Add(newRow);
                        }
                    }

                    DataTable productos = new DataTable();
                    productos.Columns.Add(new DataColumn("Value", typeof(int)));
                    productos.Columns.Add(new DataColumn("Text", typeof(string)));

                    if (lstProductos != null && lstProductos.Count() > 0)
                    {
                        foreach (string s in lstProductos)
                        {
                            DataRow newRow = productos.NewRow();
                            newRow[0] = int.Parse(s);

                            productos.Rows.Add(newRow);
                        }
                    }

                    cmd.Parameters.Add("@IdCliente", SqlDbType.Int).Value = clienteId;
                    cmd.Parameters.Add("@LstCanales", SqlDbType.Structured).Value = canales;
                    cmd.Parameters.Add("@LstCadenas", SqlDbType.Structured).Value = cadenas;
                    cmd.Parameters.Add("@LstCategorias", SqlDbType.Structured).Value = categorias;
                    cmd.Parameters.Add("@LstProductos", SqlDbType.Structured).Value = productos;

                    cn.Open();

                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    DataSet ds = new DataSet();
                    da.Fill(ds);

                    return ds;
                }
            }
            catch (Exception e)
            {
                throw e;
            }
        }
        public void ForecastingUpdate(Forecasting entity)
        {
            context.Entry<Forecasting>(entity).State = EntityState.Modified;
            context.SaveChanges();
        }
        public int ForecastingAdd(Forecasting entity)
        {
            context.Forecasting.Add(entity);
            context.SaveChanges();
            return entity.Id;
        }
        public Cadena GetCadena(int IdCadena)
        {
            return context.Cadena.First(c => c.IdCadena == IdCadena);
        }
        public Producto GetProducto(int IdProducto)
        {
            return context.Producto.First(c => c.IdProducto == IdProducto);
        }
        public List<Usuario> GetUsuariosByPerfilId(int perfilId, int IdCliente)
        {
            return context.Usuario.Where(u => u.Usuario_Cliente.Any(uc => uc.IdCliente == IdCliente) && u.Perfiles.Any(up => up.IdPerfil == 110)).ToList();
        }
        public DataSet GetForecastingConfirmados(int IdCliente)
        {
            try
            {
                using (SqlConnection cn = new SqlConnection((new RepContext()).Database.Connection.ConnectionString.ToString()))
                {
                    SqlCommand cmd = new SqlCommand("dbo.GetForecastingConfirmados");
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandTimeout = 240;
                    cmd.Connection = cn;

                    cmd.Parameters.Add("@IdCliente", SqlDbType.Int).Value = IdCliente;
                    cmd.Parameters.Add("@Fecha", SqlDbType.DateTime).Value = DateTime.Now;

                    cn.Open();

                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    DataSet ds = new DataSet();
                    da.Fill(ds);

                    return ds;
                }
            }
            catch (Exception e)
            {
                throw e;
            }
        }
        public bool ConfirmarForecasting(int IdCliente, int IdCadena, int IdUsuario, string Observaciones)
        {
            try
            {
                var conf = context.ForecastingConfirmStatus.FirstOrDefault(fc => fc.IdCliente == IdCliente && fc.IdCadena == IdCadena && fc.Fecha.Month == DateTime.Now.Month && fc.Fecha.Year == DateTime.Now.Year);
                if (conf == null)
                {
                    context.ForecastingConfirmStatus.Add(new ForecastingConfirmStatus()
                    {
                        IdCliente = IdCliente,
                        IdUsuario = IdUsuario,
                        IdCadena = IdCadena,
                        Fecha = DateTime.Now
                    });

                    context.ForecastingConfirmStatusLog.Add(new ForecastingConfirmStatusLog()
                    {
                        Fecha = DateTime.Now,
                        IdCliente = IdCliente,
                        IdUsuario = IdUsuario,
                        IdCadena = IdCadena,
                        OperationType = "CONFIRM",
                        Observaciones = Observaciones
                    });

                    context.SaveChanges();
                }
                else
                {
                    return false;
                }

                return true;
            }
            catch
            {
                return false;
            }
        }
        public List<Forecasting> ForecastingAddOrUpdate(List<Forecasting> data, int IdCliente)
        {
            foreach (var f in data)
            {
                var fdb = context.Forecasting.FirstOrDefault(fc => fc.IdCliente == IdCliente && fc.Id == f.Id);
                if (fdb != null)
                {
                    fdb.SalesIn = f.SalesIn;
                    fdb.SalesOut = f.SalesOut;
                    fdb.PlanVendedorSellIn = f.PlanVendedorSellIn;
                    fdb.PlanVendedorSellOut = f.PlanVendedorSellOut;

                    context.Entry<Forecasting>(fdb).State = EntityState.Modified;
                    context.SaveChanges();
                }
                else
                {
                    context.Forecasting.Add(f);
                    context.SaveChanges();
                }
            }

            return data;
        }
        public IQueryable<ForecastingMesIndicador> GetIndicadoresMesesForecasting()
        {
            return context.ForecastingMesIndicador.Select(f => f);
        }
        public bool DesbloquearForecasting(int IdCliente, int IdCadena, int IdUsuario)
        {
            try
            {
                var fs = context.ForecastingConfirmStatus.FirstOrDefault(f => f.IdCadena == IdCadena && f.IdCliente == IdCliente && f.Fecha.Month == DateTime.Now.Month && f.Fecha.Year == DateTime.Now.Year);
                if (fs != null)
                {
                    context.ForecastingConfirmStatus.Remove(fs);
                }
                else
                {
                    return false;
                }

                context.ForecastingConfirmStatusLog.Add(new ForecastingConfirmStatusLog()
                {
                    Fecha = DateTime.Now,
                    IdCliente = IdCliente,
                    IdUsuario = IdUsuario,
                    IdCadena = fs.IdCadena,
                    OperationType = "UNBLOCK"
                });

                context.SaveChanges();
                return true;
            }
            catch (Exception e)
            {
                throw e;
            }
        }
        public List<TipoCadena> GetTiposDeCadena(int IdCliente, int IdUsuario)
        {
            try
            {
                List<TipoCadena> ret = new List<TipoCadena>();

                using (SqlConnection cn = new SqlConnection((new RepContext()).Database.Connection.ConnectionString.ToString()))
                {
                    SqlCommand cmd = new SqlCommand("dbo.EpsonGetCanales");
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandTimeout = 240;
                    cmd.Connection = cn;

                    cmd.Parameters.Add("@IdCliente", SqlDbType.Int).Value = IdCliente;
                    cmd.Parameters.Add("@IdUsuario", SqlDbType.Int).Value = IdUsuario;

                    cn.Open();

                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    DataSet ds = new DataSet();
                    da.Fill(ds);

                    if (ds != null && ds.Tables != null && ds.Tables.Count > 0)
                    {
                        foreach (DataRow r in ds.Tables[0].Rows)
                        {
                            ret.Add(new TipoCadena()
                            {
                                IdCliente = IdCliente,
                                Identificador = r["Identificador"].ToString(),
                                IdTipoCadena = int.Parse(r["IdTipoCadena"].ToString()),
                                Nombre = r["Nombre"].ToString()
                            });
                        }
                    }
                }

                return ret;
            }
            catch (Exception e)
            {
                throw e;
            }

        }
        public void GuardarForecasting(int IdCliente, int IdUsuario, int IdCadena, int IdProducto, DateTime FechaStockInicial, int StockInicial, DataTable datos, bool audit)
        {
            try
            {
                List<Forecasting> data = new List<Forecasting>();

                using (SqlConnection cn = new SqlConnection((new RepContext()).Database.Connection.ConnectionString.ToString()))
                {
                    SqlCommand cmd = new SqlCommand("dbo.GuardarForecasting");
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandTimeout = 240;
                    cmd.Connection = cn;

                    cmd.Parameters.Add("@IdCliente", SqlDbType.Int).Value = IdCliente;
                    cmd.Parameters.Add("@IdCadena", SqlDbType.Int).Value = IdCadena;
                    cmd.Parameters.Add("@IdProducto", SqlDbType.Int).Value = IdProducto;
                    cmd.Parameters.Add("@IdUsuario", SqlDbType.Int).Value = IdUsuario;
                    cmd.Parameters.Add("@Data", SqlDbType.Structured).Value = datos;

                    cn.Open();

                    cmd.ExecuteNonQuery();

                    var fsi = context.Forecasting.FirstOrDefault(f => f.IdCliente == IdCliente && f.IdCadena == IdCadena && f.IdProducto == IdProducto && f.Fecha.Year == FechaStockInicial.Year && f.Fecha.Month == FechaStockInicial.Month);
                    if (fsi != null)
                    {
                        fsi.StockInicial = StockInicial;

                        context.SaveChanges();
                    }

                    if (audit)
                    {
                        context.ForecastingConfirmStatusLog.Add(new ForecastingConfirmStatusLog()
                        {
                            Fecha = DateTime.Now,
                            IdCadena = IdCadena,
                            IdCliente = IdCliente,
                            IdProducto = IdProducto,
                            IdUsuario = IdUsuario,
                            OperationType = "SAVE"
                        });

                        context.SaveChanges();
                    }
                }
            }
            catch (Exception e)
            {
                throw e;
            }
        }
        public IQueryable<ForecastingConfirmStatusLog> GetForecastingHistory(int IdCliente, int IdCadena, int mes, int anio)
        {
            return context.ForecastingConfirmStatusLog
                .Include("Usuario")
                .Include("Cadena")
                .Include("Producto")
                .Where(f => f.IdCliente == IdCliente && f.IdCadena == IdCadena && f.Fecha.Month == mes && f.Fecha.Year == anio);
        }
        public ForecastingConfirmStatus GetForecastingStatus(int IdCliente, int IdCadena)
        {
            return context.ForecastingConfirmStatus.FirstOrDefault(f => f.IdCliente == IdCliente && f.IdCadena == IdCadena && f.Fecha.Year == DateTime.Now.Year && f.Fecha.Month == DateTime.Now.Month);
        }

        public double GetCurrencyExchangeForecasting(int idcliente, DateTime fecha, string currtype)
        {
            try
            {
                using (SqlConnection cn = new SqlConnection((new RepContext()).Database.Connection.ConnectionString.ToString()))
                {
                    SqlCommand cmd = new SqlCommand("dbo.GetCurrencyExchangeForecasting");
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandTimeout = 240;
                    cmd.Connection = cn;

                    cmd.Parameters.Add("@IdCliente", SqlDbType.Int).Value = idcliente;
                    cmd.Parameters.Add("@Fecha", SqlDbType.DateTime).Value = fecha;
                    cmd.Parameters.Add("@CurrType", SqlDbType.VarChar).Value = currtype;

                    cn.Open();

                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    DataSet ds = new DataSet();
                    da.Fill(ds);

                    if (ds != null && ds.Tables != null && ds.Tables.Count == 1 && ds.Tables[0].Rows.Count > 0)
                    {
                        return double.Parse(ds.Tables[0].Rows[0][0].ToString());
                    }

                    return 1;
                }
            }
            catch (Exception e)
            {
                throw e;
            }
        }
    }
}