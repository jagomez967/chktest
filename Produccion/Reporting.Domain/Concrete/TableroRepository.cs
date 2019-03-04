using Reporting.Domain.Abstract;
using Reporting.Domain.Entities;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Entity;
using System.Data.SqlClient;
using System.Linq;

namespace Reporting.Domain.Concrete
{
    public class TableroRepository : ITableroRepository
    {
        private RepContext context = new RepContext();
        public List<ReportingTablero> GetTableros(int UsuarioId, int ClienteId)
        {
            return context.ReportingTablero.Where(t =>
                t.IdModulo == 1 &&
                    (
                        (t.IdCliente == ClienteId && t.ReportingTableroUsuario.Any(uc => uc.IdUsuario == UsuarioId))
                        || (t.IdCliente == ClienteId && t.IdUsuario == UsuarioId)
                    )
                ).ToList();
        }
        public int AddTablero(ReportingTablero t, int UsuarioId, int ClienteId)
        {
            context.ReportingTablero.Add(t);
            context.SaveChanges();

            return t.Id;
        }
        public ReportingTablero GetTablero(int TableroId, int UsuarioId, int ClienteId)
        {
            return context.ReportingTablero.FirstOrDefault(x =>
                x.IdModulo == 1 &&
                ((x.Id == TableroId && x.IdCliente == ClienteId && x.ReportingTableroUsuario.Any(uc => uc.IdUsuario == UsuarioId))
                || (x.Id == TableroId && x.IdUsuario == UsuarioId)
                ));
        }
        public ReportingTablero GetTableroDefault(int UsuarioId, int ClienteId)
        {
            ReportingTablero tablero;

            if (ClienteId == 0)
                tablero = null;
            else
                tablero = context.ReportingTablero.FirstOrDefault(t =>
                    t.IdModulo == 1 &&
                    ((t.IdCliente == ClienteId && t.ReportingTableroUsuario.Any(uc => uc.IdUsuario == UsuarioId))
                    || (t.IdCliente == ClienteId && t.IdUsuario == UsuarioId)
                    ));

            return tablero;
        }
        public int GetTableroIdDefault(int userId, int clienteId)
        {
            List<OrderTab> Tableros = ObtenerTablerosOrdenados(userId, clienteId);

            int idTablero = 0;
            if (Tableros.Count > 0)
            {
                idTablero = Tableros.OrderBy(t => t.Order).FirstOrDefault().Id;
            }

            return idTablero;
        }
        public List<Tab> GetTabs(int UsuarioId, int ClienteId)
        {
            List<OrderTab> Tableros = ObtenerTablerosOrdenados(UsuarioId, ClienteId);

            return Tableros.OrderBy(t => t.Order).Select(t => new Tab()
            {
                Titulo = t.Titulo,
                Id = t.Id,
                Active = false
            }).ToList();
        }
        public List<OrderTab> ObtenerTablerosOrdenados(int UsuarioId, int ClienteId)
        {
            List<OrderTab> Propios = context.ReportingTablero.Where(t => t.IdModulo == 1
                                                    && t.IdUsuario == UsuarioId
                                                    && t.IdCliente == ClienteId)
                        .Select(x => new OrderTab()
                        {
                            Titulo = x.Nombre,
                            Id = x.Id,
                            Active = false,
                            Order = x.orden
                        })
                        .ToList();
            List<OrderTab> Compartidos = context.ReportingTableroUsuario.Where(t => t.IdUsuario == UsuarioId
                                                && t.ReportingTablero.IdCliente == ClienteId
                                                && t.ReportingTablero.IdModulo == 1)
                                            .Select(y => new OrderTab()
                                            {
                                                Titulo = y.ReportingTablero.Nombre,
                                                Id = y.IdTablero,
                                                Active = false,
                                                Order = y.orden
                                            })
                                            .ToList();

            List<OrderTab> Tableros = new List<OrderTab>();
            Tableros.AddRange(Propios);
            Tableros.AddRange(Compartidos);
            Tableros = Tableros.OrderBy(x => x.Order ?? 9999).ToList(); //Si es null reemplazo por 9999
            return Tableros;
        }
        public List<ReportingTableroObjeto> GetObjetosDeTablero(int TableroId)
        {
            try
            {
                return context.ReportingTablero.SingleOrDefault(t => t.Id == TableroId).ReportingTableroObjeto.OrderBy(t => t.Orden).ToList();
            }
            catch
            {
                return new List<ReportingTableroObjeto>();
            }
        }
        public ReportingObjeto GetObjeto(int ObjetoId)
        {
            return context.ReportingObjeto.SingleOrDefault(o => o.Id == ObjetoId);
        }
        public List<ReportePaisSimple> GetDataPaisesT22(int clienteId, string producto, List<FiltroSeleccionado> filtros, string fecha)
        {
            List<ReportePaisSimple> reporteList = new List<ReportePaisSimple>();

            DataTable dtfiltros = new DataTable();
            dtfiltros.Columns.Add(new DataColumn("IdFiltro", typeof(string)));
            dtfiltros.Columns.Add(new DataColumn("Valores", typeof(string)));


            if (filtros != null)
            {
                foreach (FiltroSeleccionado f in filtros)
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

            SqlCommand cmd = new SqlCommand("spGetPrecioPaisProductoFecha")
            {
                CommandType = CommandType.StoredProcedure,
                CommandTimeout = 240
            };

            cmd.Parameters.Add("@Filtros", SqlDbType.Structured).Value = dtfiltros;
            cmd.Parameters.Add("@IdCliente", SqlDbType.Int).Value = clienteId;
            cmd.Parameters.Add("@nombreProducto", SqlDbType.VarChar).Value = producto;
            cmd.Parameters.Add("@fecha", SqlDbType.VarChar).Value = fecha;

            using (SqlConnection cn = new SqlConnection((new RepContext()).Database.Connection.ConnectionString.ToString()))
            {
                cmd.Connection = cn;

                cn.Open();

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataSet ds = new DataSet();
                da.Fill(ds);

                if (ds == null)
                {
                    return reporteList;
                }


                DataTable dtData = ds.Tables[0];

                if (dtData.Rows.Count > 0)
                {
                    foreach (DataRow dr in dtData.Rows)
                    {
                        reporteList.Add(new ReportePaisSimple()
                        {
                            Pais = dr["pais"].ToString(),
                            Valor = dr["valor"].ToString()
                        });
                    }
                }
            }
            return reporteList;
        }
        public List<ReporteSimple> GetDataReporteT22(int clienteId, string producto, string fecha, string precio, int tipoPrecio, List<FiltroSeleccionado> filtros, string anio = "2018")
        {
            List<ReporteSimple> reporteList = new List<ReporteSimple>();

            DataTable dtfiltros = new DataTable();
            dtfiltros.Columns.Add(new DataColumn("IdFiltro", typeof(string)));
            dtfiltros.Columns.Add(new DataColumn("Valores", typeof(string)));

            if (filtros != null)
            {
                foreach (FiltroSeleccionado f in filtros)
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
          
            SqlCommand cmd = new SqlCommand("spGetReportePrecioProductoFecha")
            {
                CommandType = CommandType.StoredProcedure,
                CommandTimeout = 240
            };

            precio = precio.Replace(",", ".");

            cmd.Parameters.Add("@Filtros", SqlDbType.Structured).Value = dtfiltros;
            cmd.Parameters.Add("@IdCliente", SqlDbType.Int).Value = clienteId;
            cmd.Parameters.Add("@nombreProducto", SqlDbType.VarChar).Value = producto;
            cmd.Parameters.Add("@fecha", SqlDbType.VarChar).Value = fecha;
            cmd.Parameters.Add("@precio", SqlDbType.VarChar).Value = precio;
            cmd.Parameters.Add("@TipoPrecio", SqlDbType.Int).Value = tipoPrecio;
            cmd.Parameters.Add("@anio", SqlDbType.VarChar).Value = anio;

            using (SqlConnection cn = new SqlConnection((new RepContext()).Database.Connection.ConnectionString.ToString()))
            {
                cmd.Connection = cn;

                cn.Open();

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataSet ds = new DataSet();
                da.Fill(ds);

                if (ds == null)
                {
                    return reporteList;
                }


                DataTable dtData = ds.Tables[0];

                if (dtData.Rows.Count > 0)
                {
                    foreach (DataRow dr in dtData.Rows)
                    {
                        reporteList.Add(new ReporteSimple()
                        {
                            IdReporte = int.Parse(dr["idreporte"].ToString()),
                            PuntoDeVenta = dr["puntodeventa"].ToString(),
                            Usuario = dr["usuario"].ToString(),
                            Fecha = fecha
                        });
                    }
                }
            }
            return reporteList;
        }
        public Chart GetDataObjeto(List<FiltroSeleccionado> filtros, int clienteId, int objetoId, int numeroPagina, int usuarioConsultaId, int tamanioPagina)
        {
            Chart chart = null;
            ReportingObjeto obj = GetObjeto(objetoId);

            DataTable dtfiltros = new DataTable();
            dtfiltros.Columns.Add(new DataColumn("IdFiltro", typeof(string)));
            dtfiltros.Columns.Add(new DataColumn("Valores", typeof(string)));

            SqlCommand cmd = new SqlCommand(obj.SpDatos)
            {
                CommandType = CommandType.StoredProcedure,
                CommandTimeout = 240
            };

            cmd.Parameters.Add("@IdCliente", SqlDbType.Int).Value = clienteId;

            if (filtros != null)
            {
                foreach (FiltroSeleccionado f in filtros)
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
            cmd.Parameters.Add("@NumeroDePagina", SqlDbType.Int).Value = numeroPagina;
            cmd.Parameters.Add("@Lenguaje", SqlDbType.VarChar).Value = System.Threading.Thread.CurrentThread.CurrentCulture.Name;
            cmd.Parameters.Add("@IdUsuarioConsulta", SqlDbType.Int).Value = usuarioConsultaId;
            cmd.Parameters.Add("@TamañoPagina", SqlDbType.Int).Value = tamanioPagina;
            try
            {

                switch (obj.TipoChart)
                {
                    case TipoChart.Column:
                        chart = GetColumnChart(cmd);
                        break;
                    case TipoChart.Pie:
                        chart = GetPieChart(cmd);
                        break;
                    case TipoChart.StackedColumn:
                        chart = GetStackedColumnChart(cmd);
                        break;
                    case TipoChart.PieLineCol:
                        chart = GetPieLineColChart(cmd);
                        break;
                    case TipoChart.StackedColumnDrillDown:
                        chart = GetStackedColumnDrillDownChart(cmd);
                        //OVERRIDE, TEMPORAL, esta mierda la debe estar haciendo por el graficos.js, hay que unificarlos 
                        chart.Tipo = TipoChart.StackedColumnDrillDown;
                        break;
                    case TipoChart.ColumnDrillDown:
                        chart = GetStackedColumnDrillDownChart(cmd);
                        //OVERRIDE
                        chart.Tipo = TipoChart.ColumnDrillDown;
                        break;
                    case TipoChart.StackedPercentColumnDrillDown:
                        chart = GetStackedColumnDrillDownChart(cmd);
                        //OVERRIDE
                        chart.Tipo = TipoChart.StackedPercentColumnDrillDown;
                        break;
                    case TipoChart.Tabla:
                        chart = GetTableData(cmd);
                        //OVERRIDE, no es necesario pero por las dudas lo meto
                        chart.Tipo = TipoChart.Tabla;
                        break;
                    case TipoChart.LineChart:
                        chart = GetLineChart(cmd);
                        break;
                    case TipoChart.PieDrillDown:
                        chart = GetPieDrillDownChart(cmd);
                        break;
                    case TipoChart.MetEncuestas:
                        chart = GetMetricasEncuestasChart(cmd);
                        break;
                    case TipoChart.SpiderWebChart:
                        chart = GetSpiderWebChart(cmd);
                        break;
                    case TipoChart.Imagenes:
                        chart = GetImagenesChart(cmd, clienteId);
                        break;
                    case TipoChart.EtiquetaLayout:
                        chart = GetEtiquetaLayout(cmd);
                        break;
                    case TipoChart.Timeline:
                        chart = GetTimelineChart(cmd);
                        break;
                    case TipoChart.PieSemiCircle:
                        chart = GetPieSemiCircleChart(cmd);
                        break;
                    case TipoChart.MultiTendencia:
                        chart = GetMultiTendenciaChart(cmd);
                        break;
                    case TipoChart.TablaOrden:
                        chart = GetTableData(cmd);
                        //Override, son T9 con cosas
                        chart.Tipo = TipoChart.TablaOrden;
                        break;
                    case TipoChart.Scatter:
                        chart = GetScatterChart(cmd);
                        break;
                    case TipoChart.Spiline:
                        chart = GetLineGroupChart(cmd);
                        break;
                    case TipoChart.SimpleKPI:
                        chart = GetSimpleKPIChart(cmd);
                        break;
                    case TipoChart.Measure:
                        chart = GetMeasureChart(cmd);
                        break;
                    case TipoChart.TableWithTotals:
                        chart = GetTableWithTotals(cmd);
                        //OVERRIDE, LO MISMO, misma bosta
                        chart.Tipo = TipoChart.TableWithTotals;
                        break;
                    case TipoChart.CircleWithDetail:
                        chart = GetCircleWithDetails(cmd);
                        break;
                    case TipoChart.PieWheel:
                        chart = GetPieWheel(cmd);
                        break;
                    case TipoChart.FlatStackedColumn:
                        chart = GetFlatStackedColumn(cmd);
                        break;
                    case TipoChart.SolidGauge:
                        chart = GetSolidGauge(cmd);
                        break;
                    case TipoChart.ClassicTable:
                        chart = GetClassicTable(cmd);
                        break;
                    case TipoChart.SparkLine:
                        chart = GetSparkLine(cmd);
                        break;
                    case TipoChart.BigKPI:
                        chart = GetBigKPIChart(cmd);
                        break;
                    default:
                        chart = new Chart();
                        break;
                }
                chart.SpDatos = obj.SpDatos;
            }
            catch (Exception e) { return new ChartError(e.Message); }
            return chart;
        }
        public Chart GetCircleWithDetails(SqlCommand cmd)
        {
            CircleDetailChart chart = new CircleDetailChart();

            using (SqlConnection cn = new SqlConnection((new RepContext()).Database.Connection.ConnectionString.ToString()))
            {
                cmd.Connection = cn;
                cn.Open();

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataSet ds = new DataSet();
                da.Fill(ds);

                if (ds == null)
                    return chart;

                if (ds.Tables.Count != 2)
                    return chart;

                DataTable dt1 = ds.Tables[0];
                DataTable dt2 = ds.Tables[1];

                foreach (DataRow row in dt1.Rows)
                {
                    var newItem = new CircleDetailItem()
                    {
                        Title = row["ItemText"].ToString(),
                        SubTitle = row["ItemSubText"].ToString(),
                        Unidad = row["ItemUnit"].ToString(),
                        Valor = int.Parse(row["ItemValue"].ToString()),
                        Imagen = row["Imagen"].ToString(),
                        LabelValor = row["LabelValor"].ToString(),
                        Color = row["Color"].ToString(),
                        AlwaysFull =  dt1.Columns.Contains("AlwaysFull")?1:0
                };

                    foreach (DataRow row2 in dt2.Rows)
                    {
                        if (row["IdItem"].ToString() == row2["IdItem"].ToString())
                        {
                            newItem.SubItems.Add(new CircleDetailSubItem()
                            {
                                Valor = int.Parse(row2["SubItemValue"].ToString()),
                                Unidad = row2["SubItemUnit"].ToString(),
                                Text = row2["SubItemText"].ToString(),
                                Imagen = row2["Imagen"].ToString(),
                            });
                        }
                    }
                    chart.Valores.Add(newItem);
                }
            }
            return chart;
        }
        public Chart GetTableWithTotals(SqlCommand cmd)
        {
            TableChart chart = new TableChart();

            using (SqlConnection cn = new SqlConnection((new RepContext()).Database.Connection.ConnectionString.ToString()))
            {
                cmd.Connection = cn;
                cn.Open();

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataSet ds = new DataSet();
                da.Fill(ds);

                if (ds == null)
                    return chart;

                foreach (DataColumn Col in ds.Tables[0].Columns)
                {
                    chart.Columns.Add(new TableChartColumn() { name = Col.ColumnName.ToString(), title = Col.ColumnName.ToString(), width = 10 });
                }

                DataTable dt = new DataTable();

                //Totalizadores
                if (ds.Tables.Count > 1)
                {
                    dt = ds.Tables[1];
                    if (dt.Rows.Count != 1)
                        return chart;

                    foreach (DataRow row in dt.Rows)
                    {
                        foreach (DataColumn col in dt.Columns)
                        {
                            chart.Totales += "<b>" + col.Caption + ": </b>" + row[col].ToString() + ", ";
                        }
                    }

                    chart.Totales = chart.Totales.Substring(0, (chart.Totales.Length) - 2);
                }


                //Datos
                dt = ds.Tables[0];
                if (dt.Rows.Count == 0)
                {
                    return chart;
                }

                List<Dictionary<string, object>> parentRow = new List<Dictionary<string, object>>();
                Dictionary<string, object> childRow;

                foreach (DataRow row in dt.Rows)
                {
                    childRow = new Dictionary<string, object>();
                    foreach (DataColumn col in dt.Columns)
                    {
                        childRow.Add(col.Caption, row[col].ToString());
                    }
                    parentRow.Add(childRow);
                }

                chart.Valores = parentRow;

            }

            return chart;
        }
        public Chart GetMeasureChart(SqlCommand cmd)
        {
            MeasureChart chart = new MeasureChart();

            using (SqlConnection cn = new SqlConnection((new RepContext()).Database.Connection.ConnectionString.ToString()))
            {
                cmd.Connection = cn;

                cn.Open();

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataSet ds = new DataSet();
                da.Fill(ds);

                if (ds == null)
                    return chart;

                if (ds.Tables.Count < 2)
                    return chart;

                DataTable dtData = ds.Tables[0];

                if (dtData.Rows.Count > 0)
                {
                    DataRow dr = dtData.Rows[0];
                    chart.Valor = Int32.Parse(dr["valor"].ToString());
                    chart.MinValor = Int32.Parse(dr["minvalor"].ToString());
                    chart.MaxValor = Int32.Parse(dr["maxvalor"].ToString());
                    try
                    {
                        chart.Producto = dr["producto"].ToString();
                        chart.Competencia = dr["competencia"].ToString();
                    }
                    catch
                    {

                    }
                    if (dtData.Columns.Contains("ExplicitValues"))
                    {
                        chart.Texto = dr["texto"].ToString();
                    }

                    if (dtData.Columns.Contains("ExplicitValues"))
                    {
                        chart.ExplicitValues = true;
                    }
                }

                DataTable dtLabels = ds.Tables[1];

                if (dtLabels.Rows.Count > 0)
                {
                    foreach (DataRow dr in dtLabels.Rows)
                    {
                        try
                        {
                            chart.Etiquetas.Add(new MeasureLabel()
                            {
                                Valor = Int32.Parse(dr["valor"].ToString()),
                                Label = dr["label"].ToString()
                            });
                        }
                        catch
                        {

                            chart.Etiquetas.Add(new MeasureLabel()
                            {
                                Valor = Int32.Parse(dr["valor"].ToString()),
                                Label = string.Empty
                            });
                        }
                    }
                }
            }
            return chart;
        }
        public Chart GetSimpleKPIChart(SqlCommand cmd)
        {
            SimpleKPIChart chart = new SimpleKPIChart();

            using (SqlConnection cn = new SqlConnection((new RepContext()).Database.Connection.ConnectionString.ToString()))
            {
                cmd.Connection = cn;

                cn.Open();

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataSet ds = new DataSet();
                da.Fill(ds);

                if (ds == null)
                    return chart;

                if (ds.Tables.Count < 1)
                    return chart;

                DataTable dtData = ds.Tables[0];



                if (dtData.Rows.Count > 0)
                {
                    foreach (DataRow dr in dtData.Rows)
                    {
                        chart.Valores.Add(new KPISeries()
                        {
                            Valor = dr["valor"].ToString(),
                            Titulo = dr["titulo"].ToString(),
                            Icono = dr["icono"].ToString(),
                            Color = dr["color"].ToString(),
                            Descripcion = dtData.Columns.Contains("descripcion") ? dr["descripcion"].ToString() : string.Empty
                        });
                    }
                }
            }

            return chart;
        }
        public Chart GetMultiTendenciaChart(SqlCommand cmd)
        {
            MultiTendenciaChart chart = new MultiTendenciaChart();

            using (SqlConnection cn = new SqlConnection((new RepContext()).Database.Connection.ConnectionString.ToString()))
            {
                cmd.Connection = cn;

                cn.Open();

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataSet ds = new DataSet();
                da.Fill(ds);

                if (ds == null)
                    return chart;

                if (ds.Tables.Count < 1)
                    return chart;

                DataTable dtConf = ds.Tables[0];
                DataTable dtData = ds.Tables[1];

                if (dtConf.Rows.Count > 0 && dtData.Rows.Count > 0)
                {
                    foreach (DataRow dr in dtConf.Rows)
                    {
                        if (ds.Tables[dtConf.Rows.IndexOf(dr) + 1] != null && ds.Tables[dtConf.Rows.IndexOf(dr) + 1].Rows.Count > 0)
                        {
                            if (dr["unit"].ToString() == "0")
                            {
                                chart.YAxis.Add(new MultiTendenciaYAxis()
                                {
                                    labels = new YAxisLabels() { format = string.Format("{{value}}{0}", dr["unit"].ToString()), enabled = "false" },
                                    opposite = dr["opposite"].ToString() != "0",
                                    title = new YAxisTitle() { text = dr["title"].ToString(), enabled = "false" }
                                });
                            }
                            else
                            {
                                chart.YAxis.Add(new MultiTendenciaYAxis());
                            }

                            chart.Valores.Add(new MultiTendenciaSerie()
                            {
                                name = dr["title"].ToString(),
                                type = dr["type"].ToString(),
                                Unit = dr["unit"].ToString(),
                                tooltip = new ToolTipSerie() { valueSuffix = dr["unit"].ToString() },
                                yAxis = int.Parse(dr["yaxis"].ToString()),
                                color = dr["color"].ToString(),
                                data = ds.Tables[dtConf.Rows.IndexOf(dr) + 1].AsEnumerable().Select(x => double.Parse(x[1].ToString())).ToList()
                            });
                        }
                    }

                    chart.Categories = dtData.AsEnumerable().Select(x => x[0].ToString()).ToList();
                }
            }

            return chart;
        }
        public Chart GetTimelineChart(SqlCommand cmd)
        {
            TimelineChart chart = new TimelineChart();

            using (SqlConnection cn = new SqlConnection((new RepContext()).Database.Connection.ConnectionString.ToString()))
            {
                cmd.Connection = cn;

                cn.Open();

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataSet ds = new DataSet();
                da.Fill(ds);

                if (ds == null)
                    return chart;

                if (ds.Tables.Count < 1)
                    return chart;

                DataTable dtData = ds.Tables[0];

                if (dtData.Rows.Count > 0)
                {
                    foreach (DataRow dr in dtData.Rows)
                    {
                        chart.Valores.Add(new TimeLineSeries()
                        {
                            AccionTipo = dr["AccionTipo"].ToString(),
                            ApellidoUsuario = dr["Apellido"].ToString(),
                            NombreUsuario = dr["Nombre"].ToString(),
                            Descripcion = dr["Descripcion"].ToString(),
                            IdUsuario = int.Parse(dr["IdUsuario"].ToString()),
                            FechaCreacion = dr["Fecha"].ToString(),
                            Cliente = dr["Cliente"].ToString()
                        });
                    }
                }
            }

            return chart;
        }
        public Chart GetEtiquetaLayout(SqlCommand cmd)
        {
            EtiquetaLayoutChart chart = new EtiquetaLayoutChart();

            using (SqlConnection cn = new SqlConnection((new RepContext()).Database.Connection.ConnectionString.ToString()))
            {
                cmd.Connection = cn;
                cn.Open();

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataSet ds = new DataSet();
                da.Fill(ds);

                DataTable dt = ds.Tables[0];

                foreach (DataRow dr in dt.Rows)
                {
                    chart.Valores.Add(new EtiquetaLayoutItem()
                    {
                        Label = dr["Label"].ToString(),
                        Cantidad = Int32.Parse(dr["Cantidad"].ToString()),
                        IdCliente = Int32.Parse(dr["IdCliente"].ToString()),
                        IdExhibidor = Int32.Parse(dr["idExhibidor"].ToString()),
                        NombreExhibidor = dr["NombreExhibidor"].ToString(),
                        PosX = Int32.Parse(dr["posx"].ToString()),
                        PosY = Int32.Parse(dr["posy"].ToString()),
                        PosxHover = Int32.Parse(dr["posxHover"].ToString()),
                        PosyHover = Int32.Parse(dr["posyHover"].ToString()),
                        PosxPorcentaje = Int32.Parse(dr["posxPorcentaje"].ToString()),
                        PosyPorcentaje = Int32.Parse(dr["posyPorcentaje"].ToString())
                    });
                }
            }

            return chart;
        }
        public Chart GetImagenesChart(SqlCommand cmd, int ClienteId)
        {
            ImagenesChart chart = new ImagenesChart();

            using (SqlConnection cn = new SqlConnection((new RepContext()).Database.Connection.ConnectionString.ToString()))
            {
                cmd.Connection = cn;

                cn.Open();

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataSet ds = new DataSet();
                da.Fill(ds);

                if (ds == null)
                {
                    return chart;
                }

                if (ds.Tables.Count == 0)
                {
                    return chart;
                }
                DataTable dtTotalPages = ds.Tables[0];

                if (dtTotalPages.Rows.Count <= 0)
                {
                    return chart;
                }

                chart.pages = int.Parse(dtTotalPages.Rows[0][0].ToString());

                DataTable dt = ds.Tables[1];

                foreach (DataRow dr in dt.Rows)
                {
                    var IdPuntoDeVentaFoto = Int32.Parse(dr["IdPdvFoto"].ToString());

                    ImagenesRepository imgFromHD = new ImagenesRepository();
                    Imagen imgToRender = new Imagen();

                    imgToRender = imgFromHD.GetFotoPorId(ClienteId, IdPuntoDeVentaFoto);

                    chart.Valores.Add(imgToRender);
                }

                try
                {
                    DataTable dtMarca = ds.Tables[2];
                    chart.marcaBase64 = dtMarca.Rows[0][0].ToString();
                }
                catch
                {

                }

            }

            return chart;
        }
        public Chart GetMetricasEncuestasChart(SqlCommand cmd)
        {
            EncuestaChart chart = new EncuestaChart();

            using (SqlConnection cn = new SqlConnection((new RepContext()).Database.Connection.ConnectionString.ToString()))
            {
                cmd.Connection = cn;
                cn.Open();

                SqlDataReader r = cmd.ExecuteReader();
                DataTable dt = new DataTable();

                dt.Load(r);

                if (dt.Rows.Count > 0)
                {
                    int nivelActual = 0;
                    int i = 0;

                    while (i < dt.Rows.Count)
                    {
                        nivelActual = int.Parse(dt.Rows[i]["nivel"].ToString());
                        MetricasNivel nivel = new MetricasNivel() { usaTotal = false, nivel = nivelActual };

                        while (i < dt.Rows.Count && nivelActual == int.Parse(dt.Rows[i]["nivel"].ToString()))
                        {
                            if (dt.Columns.Contains("Max"))
                            {
                                nivel.data.Add(new MetricaData() { color = dt.Rows[i]["color"].ToString(), id = int.Parse(dt.Rows[i]["id"].ToString()), logo = dt.Rows[i]["logo"].ToString(), parentId = int.Parse(dt.Rows[i]["parentId"].ToString()), valor = double.Parse(dt.Rows[i]["valor"].ToString()), varianza = double.Parse(dt.Rows[i]["varianza"].ToString()), info = dt.Rows[i]["nombre"].ToString(), max = int.Parse(dt.Rows[i]["Max"].ToString()) });
                            }
                            else
                            {
                                nivel.data.Add(new MetricaData() { color = dt.Rows[i]["color"].ToString(), id = int.Parse(dt.Rows[i]["id"].ToString()), logo = dt.Rows[i]["logo"].ToString(), parentId = int.Parse(dt.Rows[i]["parentId"].ToString()), valor = double.Parse(dt.Rows[i]["valor"].ToString()), varianza = double.Parse(dt.Rows[i]["varianza"].ToString()), info = dt.Rows[i]["nombre"].ToString(), max = int.Parse(100.ToString()) });
                            }

                            i++;
                        }
                        chart.Valores.Add(nivel);
                    }
                }
            }
            return chart;
        }
        public Chart GetSpiderWebChart(SqlCommand cmd)
        {
            SpiderWebChart chart = new SpiderWebChart();

            using (SqlConnection cn = new SqlConnection((new RepContext()).Database.Connection.ConnectionString.ToString()))
            {
                cmd.Connection = cn;
                cn.Open();

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataSet ds = new DataSet();
                da.Fill(ds);

                if (ds == null)
                    return chart;

                if (ds.Tables.Count <= 0)
                    return chart;

                //Columnas
                DataTable dt = ds.Tables[0];
                if (dt.Rows.Count <= 0)
                    return chart;

                List<string> categories = new List<string>();
                List<SpiderWebChartSerie> valores = new List<SpiderWebChartSerie>();

                foreach (DataRow row in dt.Rows)
                {
                    if (!chart.Categories.Contains(row[3].ToString()))
                    {
                        chart.Categories.Add(row[3].ToString());
                    }
                }

                string ctectrol = dt.Rows[0][1].ToString();
                int i = 0;
                while (i < dt.Rows.Count)
                {
                    ctectrol = dt.Rows[i][1].ToString();
                    var serie = new SpiderWebChartSerie
                    {
                        name = ctectrol,
                        pointPlacement = "on"
                    };
                    while (i < dt.Rows.Count && ctectrol == dt.Rows[i][1].ToString())
                    {
                        serie.data.Add(double.Parse(dt.Rows[i][4].ToString()));
                        i++;
                    }
                    chart.Valores.Add(serie);
                }
            }

            return chart;
        }
        public Chart GetColumnChart(SqlCommand cmd)
        {
            ColumnChart chart = new ColumnChart();

            using (SqlConnection cn = new SqlConnection((new RepContext()).Database.Connection.ConnectionString.ToString()))
            {
                cmd.Connection = cn;

                cn.Open();

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataSet ds = new DataSet();
                da.Fill(ds);

                if (ds == null)
                    return chart;

                if (ds.Tables.Count < 2)
                    return chart;

                DataTable dtCols = ds.Tables[0];//Nombre a mostrar de columnas
                DataTable dtData = ds.Tables[1];

                if (dtCols.Columns.Contains("IsInverted"))
                {
                    chart.IsInverted = true;
                }

                if (dtCols.Columns.Contains("ShowLegend"))
                {
                    chart.ShowLegend = false;
                }

                if (dtCols.Columns.Contains("IsPercentage"))
                {
                    chart.IsPercentage = true;
                }

                if (dtCols.Columns.Contains("LabelsEnabled"))
                {
                    chart.LabelsEnabled = true;
                }

                if (dtCols.Columns.Contains("HideTitle"))
                {
                    chart.ShowTitle = false;
                }

                if(dtCols.Columns.Contains("Height"))
                {
                    try {
                        chart.Height = int.Parse(dtCols.Rows[0]["Height"].ToString());
                    } catch { chart.Height = 0; }
                }

                if (ds.Tables.Count >= 3)
                {
                    DataTable dtTotales = ds.Tables[2];
                    if (dtTotales.Rows.Count != 1)
                        return chart;

                    foreach (DataRow row in dtTotales.Rows)
                    {
                        foreach (DataColumn col in dtTotales.Columns)
                        {
                            chart.Totales += "<b>" + col.Caption + ": </b>" + row[col].ToString() + ", ";
                        }
                    }

                    chart.Totales = chart.Totales.Substring(0, (chart.Totales.Length) - 2);
                }

                if (ds.Tables.Count == 4)
                {
                    DataTable dtShowLabel = ds.Tables[3];
                    if (Convert.ToInt32(dtShowLabel.Rows[0][0]) == 1)
                    {
                        chart.ShowValues = true;
                    }
                }



                if (dtData.Rows.Count > 0)
                {
                    foreach (DataRow dr in dtData.Rows)
                    {
                        chart.Categories.Add(dr[0].ToString());
                    }

                    for (int i = 1; i < dtData.Columns.Count; i++)
                    {
                        var Serie = new ColumnChartSerie
                        {
                            name = dtCols.Rows[i][1].ToString(),
                            pointPadding = dtCols.Columns.Contains("pointpadding") && dtCols.Rows[i]["pointpadding"] != null ? dtCols.Rows[i]["pointpadding"].ToString() : "0",
                            color = dtCols.Columns.Contains("color") && dtCols.Rows[i]["color"] != null ? dtCols.Rows[i]["color"].ToString() : null

                        };

                        for (int j = 0; j < dtData.Rows.Count; j++)
                        {
                            Serie.data.Add(double.Parse(dtData.Rows[j][i].ToString()));
                        }

                        chart.Valores.Add(Serie);
                    }
                }
            }

            return chart;
        }
        public Chart GetPieChart(SqlCommand cmd)
        {
            PieChart chart = new PieChart();

            using (SqlConnection cn = new SqlConnection((new RepContext()).Database.Connection.ConnectionString.ToString()))
            {
                cmd.Connection = cn;
                cn.Open();

                SqlDataReader r = cmd.ExecuteReader();
                DataTable dt = new DataTable();

                dt.Load(r);

                if (dt.Rows.Count > 0)
                {
                    foreach (DataRow row in dt.Rows)
                    {
                        chart.Valores.Add(new PieChartSerie() { name = row[0].ToString(), y = double.Parse(row[1].ToString()), color = (dt.Columns.Contains("sColor") ? row["sColor"].ToString() : "") });
                    }
                }
            }

            return chart;
        }
        public Chart GetStackedColumnChart(SqlCommand cmd)
        {
            StackedColumnChart chart = new StackedColumnChart();

            using (SqlConnection cn = new SqlConnection((new RepContext()).Database.Connection.ConnectionString.ToString()))
            {
                cmd.Connection = cn;
                cn.Open();

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataSet ds = new DataSet();
                da.Fill(ds);

                if (ds == null)
                    return chart;

                if (ds.Tables.Count < 1)
                    return chart;

                DataTable dtData = ds.Tables[0];
                if (dtData.Rows.Count <= 0) return chart;

                List<StackedColumnChartSerie> listSerie = new List<StackedColumnChartSerie>();
                foreach (DataRow row in dtData.Rows)
                {
                    if (!chart.Categories.Contains(row[0].ToString()))
                        chart.Categories.Add(row[0].ToString());

                    var nodo = listSerie.FirstOrDefault(s => s.name == row[1].ToString());

                    if (nodo != null)
                    {
                        StackedColumnChartSerieData d = new StackedColumnChartSerieData
                        {
                            y = double.Parse(row[2].ToString()),
                            texto = row.Table.Columns.Count >= 5 ? row[4].ToString() : ""
                        };
                        nodo.data.Add(d);
                    }
                    else
                    {
                        var serie = new StackedColumnChartSerie
                        {
                            name = row[1].ToString(),
                            color = row.Table.Columns.Count >= 4 && row.Table.Columns[3].ColumnName == "Color" ? row[3].ToString() : ""
                        };
                        StackedColumnChartSerieData d = new StackedColumnChartSerieData
                        {
                            y = double.Parse(row[2].ToString()),
                            texto = row.Table.Columns.Count >= 5 ? row[4].ToString() : ""
                        };
                        serie.data.Add(d);
                        listSerie.Add(serie);
                    }

                    if (row.Table.Columns.Contains("Visiblelabel"))
                    {
                        chart.Visiblelabel = true;
                    }
                }
                chart.Valores = listSerie;
                chart.IsPercentage = false;

                if (ds.Tables.Count > 1)
                {
                    DataTable dt = ds.Tables[1];
                    DataRow rw = dt.Rows[0];
                    chart.IsPercentage = rw[0].ToString() == "1" ? true : false;
                }
            }

            return chart;
        }
        public Chart GetStackedColumnPercentChart(SqlCommand cmd)
        {
            StackedColumnChart chart = new StackedColumnChart();

            using (SqlConnection cn = new SqlConnection((new RepContext()).Database.Connection.ConnectionString.ToString()))
            {
                cmd.Connection = cn;
                cn.Open();

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataSet ds = new DataSet();
                da.Fill(ds);

                if (ds == null)
                    return chart;

                if (ds.Tables.Count < 1)
                    return chart;

                DataTable dtData = ds.Tables[0];
                if (dtData.Rows.Count <= 0) return chart;

                List<StackedColumnChartSerie> listSerie = new List<StackedColumnChartSerie>();
                foreach (DataRow row in dtData.Rows)
                {
                    if (!chart.Categories.Contains(row[0].ToString()))
                        chart.Categories.Add(row[0].ToString());

                    var nodo = listSerie.FirstOrDefault(s => s.name == row[1].ToString());

                    if (nodo != null)
                    {
                        StackedColumnChartSerieData d = new StackedColumnChartSerieData
                        {
                            y = double.Parse(row[2].ToString()),
                            texto = row.Table.Columns.Count >= 5 ? row[4].ToString() : ""
                        };
                        nodo.data.Add(d);
                    }
                    else
                    {
                        var serie = new StackedColumnChartSerie
                        {
                            name = row[1].ToString()
                        };
                        StackedColumnChartSerieData d = new StackedColumnChartSerieData
                        {
                            y = double.Parse(row[2].ToString()),
                            texto = row.Table.Columns.Count >= 5 ? row[4].ToString() : ""
                        };
                        serie.data.Add(d);
                        listSerie.Add(serie);
                    }
                }
                chart.Valores = listSerie;
                chart.IsPercentage = false;
            }

            return chart;
        }
        public Chart GetStackedColumnDrillDownChart(SqlCommand cmd)
        {
            StackedColumnDrillDownChart chart = new StackedColumnDrillDownChart();

            using (SqlConnection cn = new SqlConnection((new RepContext()).Database.Connection.ConnectionString.ToString()))
            {
                cmd.Connection = cn;
                cn.Open();

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataSet ds = new DataSet();

                da.Fill(ds);

                if (ds == null || ds.Tables == null || ds.Tables.Count == 0)
                {
                    return chart;
                }

                DataTable SeriePrincipal = ds.Tables[0];


                if (SeriePrincipal.Columns.Contains("IsInverted"))
                {
                    chart.IsInverted = true;
                }

                if (SeriePrincipal.Columns.Contains("ShowLegend"))
                {
                    chart.ShowLegend = false;
                }

                foreach (DataRow row in SeriePrincipal.Rows)
                {
                    StackedColumnDrillDownChartSerie nodo = chart.Valores.FirstOrDefault(s => s.name == row[2].ToString());//fecha

                    if (nodo != null)
                    {
                        StackedColumnDrillDownChartSerieData newNode;

                        if (SeriePrincipal.Columns.Contains("ExtraText"))
                        {
                            newNode =
                            new StackedColumnDrillDownChartSerieData()
                            {
                                name = row[1].ToString(),
                                y = double.Parse(row[3].ToString()),
                                drilldown = "L1_" + row[0].ToString() + row[2].ToString(),
                                ExtraText = row["ExtraText"].ToString(),
                                color = SeriePrincipal.Columns.Contains("Color") ? row["Color"].ToString() : null
                            };
                        }
                        else
                        {
                            newNode =
                            new StackedColumnDrillDownChartSerieData()
                            {
                                name = row[1].ToString(),
                                y = double.Parse(row[3].ToString()),
                                drilldown = "L1_" + row[0].ToString() + row[2].ToString(),
                                color = SeriePrincipal.Columns.Contains("Color") ? row["Color"].ToString() : null
                            };
                        }

                        nodo.data.Add(newNode);
                    }
                    else
                    {
                        var nuevonodo = new StackedColumnDrillDownChartSerie
                        {
                            name = row[2].ToString(),
                            color = SeriePrincipal.Columns.Contains("Color") ? null : (row.Table.Columns.Count == 5 ? row[4].ToString() : "")
                        };
                        StackedColumnDrillDownChartSerieData nodeTemp;
                        if (!SeriePrincipal.Columns.Contains("ExtraText"))
                        {
                            nodeTemp = new StackedColumnDrillDownChartSerieData()
                            {
                                name = row[1].ToString(),
                                y = double.Parse(row[3].ToString()),
                                drilldown = "L1_" + row[0].ToString() + row[2].ToString(),
                                color = SeriePrincipal.Columns.Contains("Color") ? row["Color"].ToString() : null
                            };
                        }
                        else
                        {
                            nodeTemp = new StackedColumnDrillDownChartSerieData()
                            {
                                name = row[1].ToString(),
                                y = double.Parse(row[3].ToString()),
                                drilldown = "L1_" + row[0].ToString() + row[2].ToString(),
                                ExtraText = row["ExtraText"].ToString(),
                                color = SeriePrincipal.Columns.Contains("Color") ? row["Color"].ToString() : null
                            };
                        }

                        nuevonodo.data.Add(nodeTemp);
                        chart.Valores.Add(nuevonodo);
                    }
                }
                if (SeriePrincipal.Columns.Contains("EsPorcentaje")) //esto esta mal, quizas deba validarlo por cada fila
                {
                    chart.IsPercentage = true;
                }
                else
                {
                    chart.IsPercentage = false; //Por default es FALSO
                }
                if (SeriePrincipal.Columns.Contains("ExtraText"))
                {
                    chart.ShowText = true;
                }

                //por cada DataTable en ds con index > 0 tengo los distintos niveles de drilldown
                if (ds.Tables.Count > 1)
                {
                    DataTable nivel2 = ds.Tables[1];

                    foreach (DataRow row in nivel2.Rows)
                    {


                        var nodo = chart.DrillDown.FirstOrDefault(s => s.id == string.Format("L1_{0}{1}", row[0].ToString(), row[4].ToString()));

                        if (nodo != null)
                        {
                            nodo.data.Add(new StackedColumnDrillDownChartSerieData() { name = row[3].ToString(), y = double.Parse(row[5].ToString()), drilldown = string.Format("L2_{0}{1}{2}", row[0].ToString(), row[2].ToString(), row[4].ToString()) });
                        }
                        else
                        {
                            var nuevonodo = new StackedColumnDrillDownChartDrillDown
                            {
                                name = row[4].ToString(),
                                id = string.Format("L1_{0}{1}", row[0].ToString(), row[4].ToString())
                            };
                            nuevonodo.data.Add(new StackedColumnDrillDownChartSerieData() { name = row[3].ToString(), y = double.Parse(row[5].ToString()), drilldown = string.Format("L2_{0}{1}{2}", row[0].ToString(), row[2].ToString(), row[4].ToString()) });
                            chart.DrillDown.Add(nuevonodo);
                        }

                        if (row.Table.Columns.Contains("Visiblelabel"))
                        {
                            chart.Visiblelabel = true;
                        }
                    }
                }

                if (ds.Tables.Count > 2 && ds.Tables[2].Columns.Count != 1)
                {
                    DataTable nivel3 = ds.Tables[2];

                    foreach (DataRow row in nivel3.Rows)
                    {
                        var nodo = chart.DrillDown.FirstOrDefault(s => s.id == string.Format("L2_{0}{1}{2}", row[0].ToString(), row[2].ToString(), row[4].ToString()));

                        if (nodo != null)
                        {
                            nodo.data.Add(new StackedColumnDrillDownChartSerieData() { name = row[6].ToString(), y = double.Parse(row[7].ToString()), drilldown = string.Format("L3_{0}{1}{2}", row[0].ToString(), row[2].ToString(), row[4].ToString()) });
                        }
                        else
                        {
                            var nuevonodo = new StackedColumnDrillDownChartDrillDown
                            {
                                name = row[4].ToString(),
                                id = string.Format("L2_{0}{1}{2}", row[0].ToString(), row[2].ToString(), row[4].ToString())
                            };
                            nuevonodo.data.Add(new StackedColumnDrillDownChartSerieData() { name = row[6].ToString(), y = double.Parse(row[7].ToString()), drilldown = string.Format("L3_{0}{1}{2}", row[0].ToString(), row[2].ToString(), row[4].ToString()) });
                            chart.DrillDown.Add(nuevonodo);
                        }

                        if (row.Table.Columns.Contains("Visiblelabel"))
                        {
                            chart.Visiblelabel = true;
                        }
                    }


                }

                if (ds.Tables.Count > 2 && ds.Tables[2].Columns.Count == 2)
                {
                    chart.VisibleLegend = false;
                }


            }


            return chart;
        }
        public Chart GetAreaChart(SqlCommand cmd)
        {
            AreaChart chart = new AreaChart();

            using (SqlConnection cn = new SqlConnection((new RepContext()).Database.Connection.ConnectionString.ToString()))
            {
                cmd.Connection = cn;
                cn.Open();

                SqlDataReader r = cmd.ExecuteReader();
                DataTable dt = new DataTable();

                dt.Load(r);

                if (dt.Rows.Count > 0)
                {

                    for (int i = 0; i < dt.Rows.Count; i++)
                    {
                        chart.Categories.Add(dt.Rows[i][0].ToString());
                    }

                    for (int i = 1; i < dt.Columns.Count; i++)
                    {
                        var Serie = new AreaChartSerie
                        {
                            name = dt.Columns[i].Caption
                        };

                        for (int j = 0; j < dt.Rows.Count; j++)
                        {
                            Serie.data.Add(double.Parse(dt.Rows[j][i].ToString()));
                        }

                        chart.Valores.Add(Serie);
                    }
                }
            }

            return chart;
        }
        public Chart GetPieLineColChart(SqlCommand cmd)
        {
            PieLineColChart chart = new PieLineColChart();

            using (SqlConnection cn = new SqlConnection((new RepContext()).Database.Connection.ConnectionString.ToString()))
            {
                cmd.Connection = cn;
                cn.Open();

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataSet ds = new DataSet();
                da.Fill(ds);


                if (ds == null)
                    return chart;

                if (ds.Tables.Count < 4)
                    return chart;

                //Columnas
                DataTable dtCols1 = ds.Tables[0];
                if (dtCols1.Rows.Count <= 0) return chart;
                DataTable dtData1 = ds.Tables[1];
                if (dtData1.Rows.Count <= 0) return chart;
                DataTable dtCols2 = ds.Tables[2];
                if (dtCols2.Rows.Count <= 0) return chart;
                DataTable dtData2 = ds.Tables[3];
                if (dtData2.Rows.Count <= 0) return chart;

                for (int i = 0; i < dtData1.Rows.Count; i++)
                {
                    chart.Categories.Add(dtData1.Rows[i][0].ToString());
                }

                for (int i = 1; i < dtData1.Columns.Count; i++)
                {
                    var Serie = new PieLineColChartSerie
                    {
                        name = dtCols1.Rows[i][1].ToString()
                    };
                    for (int j = 0; j < dtData1.Rows.Count; j++)
                    {
                        Serie.data.Add(double.Parse(dtData1.Rows[j][i].ToString()));
                    }

                    chart.Valores.Add(Serie);
                }

                //Line
                if (ds.Tables.Count <= 1)
                    return chart;

                dtData2 = ds.Tables[3];
                if (dtData2.Rows.Count > 0)
                {
                    var SerieLine = new PieLineColChartSerie
                    {
                        name = dtCols2.Rows[0][1].ToString(),
                        type = "spline"
                    };
                    for (int j = 0; j < dtData2.Rows.Count; j++)
                    {
                        SerieLine.data.Add(double.Parse(dtData2.Rows[j][0].ToString()));
                    }

                    chart.Valores.Add(SerieLine);
                }
            }

            return chart;
        }
        public Chart GetTableData(SqlCommand cmd)
        {
            TableChart chart = new TableChart();

            using (SqlConnection cn = new SqlConnection((new RepContext()).Database.Connection.ConnectionString.ToString()))
            {
                cmd.Connection = cn;
                cn.Open();

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataSet ds = new DataSet();
                da.Fill(ds);

                if (ds == null)
                    return chart;

                if (ds.Tables.Count != 3)
                    return chart;

                //Cantidad de paginas
                DataTable dt = ds.Tables[0];
                if (dt.Rows.Count <= 0)
                    return chart;

                chart.pages = int.Parse(dt.Rows[0][0].ToString());

                //Configuracion de columnas
                dt = ds.Tables[1];
                foreach (DataRow r in dt.Rows)
                {
                    if (dt.Columns.Contains("esagrupador") && dt.Columns.Contains("esclave") && dt.Columns.Contains("mostrar"))
                    {
                        chart.Columns.Add(new TableChartColumn() { esAgrupador = r["esagrupador"].ToString(), esclave = r["esclave"].ToString(), mostrar = r["mostrar"].ToString(), name = r["name"].ToString(), title = r["title"].ToString(), width = int.Parse(r["width"].ToString()) });
                    }
                    else if (dt.Columns.Contains("esclave") && dt.Columns.Contains("mostrar"))
                    {
                        chart.Columns.Add(new TableChartColumn() { esclave = r["esclave"].ToString(), mostrar = r["mostrar"].ToString(), name = r["name"].ToString(), title = r["title"].ToString(), width = int.Parse(r["width"].ToString()) });
                    }
                    else
                    {
                        chart.Columns.Add(new TableChartColumn() { name = r["name"].ToString(), title = r["title"].ToString(), width = int.Parse(r["width"].ToString()) });
                    }
                }

                //Datos
                dt = ds.Tables[2];
                if (dt.Rows.Count == 0)
                {
                    chart.pages = 0;
                    return chart;
                }

                List<Dictionary<string, object>> parentRow = new List<Dictionary<string, object>>();
                Dictionary<string, object> childRow;

                foreach (DataRow row in dt.Rows)
                {
                    childRow = new Dictionary<string, object>();
                    foreach (DataColumn col in dt.Columns)
                    {
                        childRow.Add(col.Caption, row[col].ToString());
                    }
                    parentRow.Add(childRow);
                }

                chart.Valores = parentRow;

            }

            return chart;
        }
        public Chart GetScatterChart(SqlCommand cmd)
        {
            ScatterChart chart = new ScatterChart();

            using (SqlConnection cn = new SqlConnection((new RepContext()).Database.Connection.ConnectionString.ToString()))
            {
                cmd.Connection = cn;

                cn.Open();
                DataSet ds = new DataSet();
                try
                {
                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    da.Fill(ds);
                }
                catch
                {

                }

                if (ds == null)
                    return chart;

                if (ds.Tables.Count < 4)
                    return chart;

                DataTable dtPlotBand = ds.Tables[0];
                DataTable dtPlotLine = ds.Tables[1];
                DataTable dtConfig = ds.Tables[2];
                DataTable dtData = ds.Tables[3];

                if (dtData.Rows.Count > 0)
                {
                    foreach (DataRow dr in dtData.Rows)
                    {
                        DataScatter Sdata = new DataScatter
                        {
                            y = double.Parse(dr["valor"].ToString()),
                            z = dr["producto"].ToString(),
                            name = dr["marca"].ToString(),
                            color = dr["colorMarca"].ToString(),
                            drilldown = dr["drilldown"].ToString()
                        };

                        chart.Valores.Add(Sdata);
                    }
                }

                if (dtConfig.Rows.Count > 0)
                {
                    foreach (DataRow dr in dtConfig.Rows)
                    {
                        chart.xTitulo = dr["xTitulo"].ToString();
                        chart.yTitulo = dr["yTitulo"].ToString();
                    }
                }

                if (dtPlotLine.Rows.Count > 0)
                {
                    foreach (DataRow dr in dtPlotLine.Rows)
                    {
                        PlotLinesSeries pl = new PlotLinesSeries
                        {
                            value = Int32.Parse(dr["valor"].ToString()),
                            color = dr["color"].ToString(),
                            dashStyle = dr["estilo"].ToString(),
                            width = Int32.Parse(dr["grosor"].ToString())
                        };

                        labelSeriesStyle label = new labelSeriesStyle
                        {
                            text = dr["texto"].ToString(),
                            align = dr["align"].ToString(),
                            x = Int32.Parse(dr["x"].ToString())
                        };

                        styleLabel styLab = new styleLabel
                        {
                            color = dr["colorLabel"].ToString(),
                            fontSize = dr["fontSize"].ToString(),
                            fontWeight = dr["fontWeight"].ToString()
                        };

                        label.style = styLab;

                        pl.label = label;


                        chart.PlotLines.Add(pl);
                    }

                }



                if (dtPlotBand.Rows.Count > 0)
                {
                    foreach (DataRow dr in dtPlotBand.Rows)
                    {
                        PlotBandsSeries pl = new PlotBandsSeries
                        {
                            from = Int32.Parse(dr["inicio"].ToString()),
                            to = Int32.Parse(dr["fin"].ToString()),
                            color = dr["color"].ToString()
                        };

                        labelSeries lab = new labelSeries
                        {
                            text = dr["label"].ToString()
                        };

                        pl.label = lab;

                        chart.PlotBands.Add(pl);
                    }

                }
                DataTable dtDataImagen;
                try
                {
                    dtDataImagen = ds.Tables[4];
                    if (dtData.Rows.Count > 0)
                    {
                        Dictionary<string, string> dicImagenes = new Dictionary<string, string>();

                        foreach (DataRow drI in dtDataImagen.Rows)
                        {
                            chart.imagenes.Add(drI["marca"].ToString(), drI["imagenMarca"].ToString());
                        }
                    }
                }
                catch
                {

                }
                DataTable dtDataDetail;
                try
                { //LA PUTA MADRE x 2 dataDrillDown
                    dtDataDetail = ds.Tables[5];
                    if (dtDataDetail.Rows.Count > 0)
                    {
                        foreach (DataRow dr in dtDataDetail.Rows)
                        {
                            DataScatter Sdata = new DataScatter
                            {
                                y = double.Parse(dr["valor"].ToString()),
                                z = dr["producto"].ToString(),
                                name = dr["pais"].ToString(),
                                color = dr["colorMarca"].ToString()
                            };

                            var nodo = chart.dataDrillDown.FirstOrDefault(d => d.id == dr["marca"].ToString());
                            if (nodo != null)
                            {
                                nodo.data.Add(Sdata);
                            }
                            else
                            {
                                var nuevoNodo = new DataScatterWithId
                                {
                                    id = dr["marca"].ToString()
                                };
                                nuevoNodo.data.Add(Sdata);
                                chart.dataDrillDown.Add(nuevoNodo);
                            }
                        }
                    }
                }
                catch
                {

                }
            }
            return chart;
        }
        public Chart GetLineGroupChart(SqlCommand cmd)
        {
            LineGroupChart chart = new LineGroupChart();

            using (SqlConnection cn = new SqlConnection((new RepContext()).Database.Connection.ConnectionString.ToString()))
            {
                cmd.Connection = cn;
                cn.Open();

                DataSet ds = new DataSet();
                new SqlDataAdapter(cmd).Fill(ds);

                if (ds == null)
                    return chart;

                if (ds.Tables.Count < 4)
                    return chart;

                //Columnas
                DataTable dt = ds.Tables[0];
                DataTable dtPlotBand = ds.Tables[1];
                DataTable dtPlotLine = ds.Tables[2];
                DataTable dtConfig = ds.Tables[3];


                if (dt.Rows.Count <= 0)
                    return chart;
                //Esto es una mentira 
                if (dt.Columns.Contains("TipoPrecio"))
                {
                    chart.TipoPrecio = 2;
                }

                chart.LabelFullName = dt.Columns.Contains("LabelFullName");


                LineGroupChartTemp charttemp = new LineGroupChartTemp();
                foreach (DataRow r in dt.Rows)
                {
                    try
                    {
                        if (!charttemp.Categories.ContainsKey(r[2].ToString()))
                        {
                            if (r.Table.Columns.Contains("Cat"))
                            {
                                charttemp.Categories.Add(r[2].ToString(), r["Cat"].ToString());
                            }
                            else
                            {
                                charttemp.Categories.Add(r[2].ToString(), r[3].ToString());
                            }

                        }

                        int iReportes = int.MinValue;
                        if (r.Table.Columns.Contains("reportes"))
                        {
                            iReportes = int.Parse(r["reportes"].ToString());
                        }
                        string valorFecha = string.Empty;
                        if (r.Table.Columns.Contains("fecha"))
                        {
                            valorFecha = r["fecha"].ToString();
                        }

                        var serie = charttemp.Valores.FirstOrDefault(v => v.keycol == r[0].ToString());
                        if (serie != null)
                        {


                            SerieTempData newdata = new SerieTempData()
                            {
                                name = r[2].ToString(),
                                y = double.Parse(r[4].ToString()),
                                reportes = iReportes,
                                valorFecha = valorFecha
                            };
                            serie.data.Add(newdata);
                        }
                        else
                        {
                            SerieTempData newdata = new SerieTempData()
                            {
                                name = r[2].ToString(),
                                y = double.Parse(r[4].ToString()),
                                reportes = iReportes,
                                valorFecha = valorFecha
                            };
                            LineGroupChartSerieTemp newGroupChart = new LineGroupChartSerieTemp()
                            {
                                keycol = r[0].ToString(),
                                name = r[1].ToString(),
                                color = r["color"].ToString(),
                                dashStyle = r["dashStyle"].ToString()
                            };

                            newGroupChart.data.Add(newdata);

                            charttemp.Valores.Add(newGroupChart);
                        }
                    }
                    catch
                    {

                    }
                }

                List<string> categoriesKeysOrdered = charttemp.Categories.Select(c => c.Key).OrderBy(c => c).ToList();
                chart.Categories = charttemp.Categories.OrderBy(c => c.Key).Select(c => c.Value).ToList();

                foreach (var serie in charttemp.Valores)
                {
                    var valor = new LineGroupChartSerie()
                    {
                        name = serie.name,
                        color = serie.color,
                        dashStyle = serie.dashStyle
                    };
                    foreach (var s in categoriesKeysOrdered)
                    {
                        if (serie.data.Exists(d => d.name == s))
                        {

                            valor.data.Add(new DataLineGroup()
                            {
                                y = serie.data.FirstOrDefault(dd => dd.name == s).y,
                                name = serie.name,
                                reportes = serie.data.FirstOrDefault(dd => dd.name == s).reportes,
                                valorFecha = serie.data.FirstOrDefault(dd => dd.name == s).valorFecha
                            });
                        }
                        else
                        {
                            valor.data.Add(new DataLineGroup()
                            {
                                y = 0,
                                reportes = 0,
                                valorFecha = string.Empty
                            });
                        }
                    }
                    chart.Valores.Add(valor);
                }

                if (dtPlotLine.Rows.Count > 0)
                {
                    foreach (DataRow dr in dtPlotLine.Rows)
                    {
                        PlotLinesSeriesL pl = new PlotLinesSeriesL
                        {
                            value = Int32.Parse(dr["valor"].ToString()),
                            color = dr["color"].ToString(),
                            dashStyle = dr["estilo"].ToString(),
                            width = Int32.Parse(dr["grosor"].ToString())
                        };

                        styleLabelSeriesL label = new styleLabelSeriesL
                        {
                            text = dr["texto"].ToString(),
                            align = dr["align"].ToString(),
                            x = Int32.Parse(dr["x"].ToString())
                        };

                        styleLabelL styLab = new styleLabelL
                        {
                            color = dr["colorLabel"].ToString(),
                            fontSize = dr["fontSize"].ToString(),
                            fontWeight = dr["fontWeight"].ToString()
                        };

                        label.style = styLab;

                        pl.label = label;

                        chart.PlotLines.Add(pl);
                    }

                }

                if (dtPlotBand.Rows.Count > 0)
                {
                    foreach (DataRow dr in dtPlotBand.Rows)
                    {
                        PlotBandsSeriesL pl = new PlotBandsSeriesL
                        {
                            from = Int32.Parse(dr["inicio"].ToString()),
                            to = Int32.Parse(dr["fin"].ToString()),
                            color = dr["color"].ToString()
                        };

                        labelSeriesL lab = new labelSeriesL
                        {
                            text = dr["label"].ToString()
                        };

                        pl.label = lab;

                        chart.PlotBands.Add(pl);
                    }

                }
            }

            return chart;
        }
        public Chart GetLineChart(SqlCommand cmd)
        {
            LineChart chart = new LineChart();

            using (SqlConnection cn = new SqlConnection((new RepContext()).Database.Connection.ConnectionString.ToString()))
            {
                cmd.Connection = cn;
                cn.Open();

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataSet ds = new DataSet();
                da.Fill(ds);

                if (ds == null)
                    return chart;

                if (ds.Tables.Count <= 0)
                    return chart;

                //Columnas
                DataTable dt = ds.Tables[0];
                if (dt.Rows.Count <= 0)
                    return chart;


                if (ds.Tables.Count > 1)
                {
                    DataTable dt2 = ds.Tables[1];
                    DataRow rw = dt.Rows[0];
                    chart.showText = rw[0].ToString() == "1";
                }

                LineChartTemp charttemp = new LineChartTemp();
                foreach (DataRow r in dt.Rows)
                {
                    if (!charttemp.Categories.ContainsKey(r[2].ToString()))
                    {
                        charttemp.Categories.Add(r[2].ToString(), r[3].ToString());
                    }

                    var serie = charttemp.Valores.FirstOrDefault(v => v.keycol == r[0].ToString());
                    if (serie != null)
                    {
                        LineChartSerieData d = new LineChartSerieData()
                        {
                            y = double.Parse(r[4].ToString()),
                            texto = chart.showText ? r[5].ToString() : "",
                            color = r.Table.Columns.Contains("sColor") ? r["sColor"].ToString() : ""
                        };
                        serie.texto = r.Table.Columns.Count >= 5 && ds.Tables.Count >= 2 ? r[5].ToString() : "";

                        serie.data.Add(r[2].ToString(), d);
                    }
                    else
                    {
                        LineChartSerieData d = new LineChartSerieData()
                        {
                            y = double.Parse(r[4].ToString()),
                            texto = chart.showText ? r[5].ToString() : "",
                            color = r.Table.Columns.Contains("sColor") ? r["sColor"].ToString() : ""
                        };
                        charttemp.Valores.Add(new LineChartSerieTemp()
                        {
                            keycol = r[0].ToString(),
                            name = r[1].ToString(),
                            data = new Dictionary<string, LineChartSerieData>(){
                               {r[2].ToString(), d}
                            },
                            texto = chart.showText ? r[5].ToString() : ""
                        });
                    }

                    if (r.Table.Columns.Contains("Visibletooltip"))
                    {
                        chart.Visibletooltip = true;
                    }
                }

                List<string> categoriesKeysOrdered = charttemp.Categories.Select(c => c.Key).ToList();
                chart.Categories = charttemp.Categories.Select(c => c.Value).ToList();

                foreach (var serie in charttemp.Valores)
                {
                    var valor = new LineChartSerie()
                    {
                        name = serie.name
                    };

                    foreach (var s in categoriesKeysOrdered)
                    {
                        if (serie.data.ContainsKey(s))
                        {
                            LineChartSerieData d = new LineChartSerieData()
                            {
                                y = serie.data[s].y,
                                texto = serie.data[s].texto,
                                color = serie.data[s].color
                            };
                            valor.color = d.color;
                            valor.data.Add(d);
                        }
                        else
                        {
                            LineChartSerieData d = new LineChartSerieData()
                            {
                                y = 0,
                                texto = ""
                            };
                            valor.data.Add(d);
                        }
                    }

                    chart.Valores.Add(valor);

                }
            }

            return chart;
        }
        public Chart GetPieDrillDownChart(SqlCommand cmd)
        {
            PieDrillDownChart chart = new PieDrillDownChart();

            using (SqlConnection cn = new SqlConnection((new RepContext()).Database.Connection.ConnectionString.ToString()))
            {
                cmd.Connection = cn;
                cn.Open();

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataSet ds = new DataSet();
                da.Fill(ds);

                if (ds == null)
                    return chart;

                if (ds.Tables.Count <= 0)
                    return chart;

                DataTable dt = new DataTable();

                dt = ds.Tables[0];

                List<PieDrillDownChartSerie> listSerie = new List<PieDrillDownChartSerie>();
                foreach (DataRow row in dt.Rows)
                {
                    chart.showVal = row.Table.Columns.Contains("showVal") && Convert.ToBoolean(row["showVal"]);
                    listSerie.Add(new PieDrillDownChartSerie()
                    {
                        name = row[1].ToString(),
                        y = double.Parse(row[2].ToString()),
                        drilldown = row[0].ToString() + row[1].ToString(),
                        color = row.Table.Columns.Contains("sColor") ? row["sColor"].ToString() : string.Empty,
                        showVal = row.Table.Columns.Contains("showVal") && Convert.ToBoolean(row["showVal"])
                    });
                }

                chart.Valores = listSerie;

                if (ds.Tables.Count <= 1)
                    return chart;

                dt = ds.Tables[1];

                List<PieDrillDownChartDrillDown> listDrillDown = new List<PieDrillDownChartDrillDown>();
                foreach (DataRow row in dt.Rows)
                {
                    var nodo = listDrillDown.FirstOrDefault(s => s.id == row[0].ToString() + row[1].ToString());

                    if (nodo != null)
                    {
                        nodo.data.Add(new PieDrillDownChartDrillDownData() { name = row[3].ToString(), y = double.Parse(row[4].ToString()) });
                    }
                    else
                    {
                        var nuevonodo = new PieDrillDownChartDrillDown
                        {
                            name = row[0].ToString() + row[1].ToString(),
                            id = row[0].ToString() + row[1].ToString()
                        };
                        nuevonodo.data.Add(new PieDrillDownChartDrillDownData() { name = row[3].ToString(), y = double.Parse(row[4].ToString()) });
                        listDrillDown.Add(nuevonodo);
                    }
                }

                chart.DrillDown = listDrillDown;
            }

            return chart;
        }
        public Chart GetBigKPIChart(SqlCommand cmd)
        {
            BigKPIChart chart = new BigKPIChart();

            using (SqlConnection cn = new SqlConnection((new RepContext()).Database.Connection.ConnectionString.ToString()))
            {
                cmd.Connection = cn;

                cn.Open();

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataSet ds = new DataSet();
                da.Fill(ds);

                if (ds == null)
                    return chart;

                if (ds.Tables.Count < 1)
                    return chart;

                DataTable dtData = ds.Tables[0];

                if (dtData.Rows.Count > 0)
                {
                    chart.Valores.Add(new KPISeries()
                    {
                        Valor = dtData.Rows[0][1].ToString(),
                        Titulo = dtData.Rows[0][2].ToString(),
                        Icono = dtData.Rows[0][3].ToString(),
                        Color = dtData.Rows[0][4].ToString()
                    });
                }
            }

            return chart;
        }
        public Chart GetPieSemiCircleChart(SqlCommand cmd)
        {
            PieSemiCircleChart chart = new PieSemiCircleChart();

            using (SqlConnection cn = new SqlConnection((new RepContext()).Database.Connection.ConnectionString.ToString()))
            {
                cmd.Connection = cn;
                cn.Open();

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataSet ds = new DataSet();

                da.Fill(ds);

                if (ds == null)
                    return chart;

                if (ds.Tables.Count != 2)
                    return chart;

                //Tabla con valores maximos y minimos 
                DataTable dt = ds.Tables[0];
                if (dt.Rows.Count > 0)
                {
                    foreach (DataRow r in dt.Rows)
                    {
                        var rango = new PieChartColorLimit
                        {
                            HexColor = r["codigoRGB"].ToString(),
                            min = double.Parse(r["minimo"].ToString()),
                            max = double.Parse(r["maximo"].ToString()),
                            name = r["descripcion"].ToString()
                        };
                        chart.Limites.Add(rango);
                    }
                }

                //Tabla con valor porcentual 
                dt = ds.Tables[1];

                if (dt.Rows.Count > 0)
                {
                    chart.Valor = double.Parse(dt.Rows[0].ToString());
                }
            }
            return chart;
        }

        public Chart GetPieWheel(SqlCommand cmd)
        {
            PieWheelChart chart = new PieWheelChart();

            using (SqlConnection cn = new SqlConnection((new RepContext()).Database.Connection.ConnectionString.ToString()))
            {
                cmd.Connection = cn;
                cn.Open();

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataSet ds = new DataSet();

                da.Fill(ds);

                if (ds == null)
                    return chart;

                if (ds.Tables.Count != 2)
                    return chart;

                DataTable dt = ds.Tables[0];
                if (dt.Rows.Count > 0)
                {
                    foreach (DataRow r in dt.Rows)
                    {
                        chart.SerieName = r["SerieName"].ToString();
                        chart.SubTitle = dt.Columns.Contains("SubTitle") ? r["SubTitle"].ToString() : "";
                        chart.LegendFontSize = dt.Columns.Contains("LegendFontSize") ? r["LegendFontSize"].ToString() : "0px";
                        chart.Total = r["Total"].ToString();
                        chart.Target = dt.Columns.Contains("Target") ? r["Target"].ToString() : "";
                        if (dt.Columns.Contains("FullPie")) chart.FullPie = int.Parse(r["FullPie"].ToString());
                        if (dt.Columns.Contains("ShowText")) chart.showText = int.Parse(r["ShowText"].ToString());
                    }
                }

                dt = ds.Tables[1];

                if (dt.Rows.Count > 0)
                {
                    foreach (DataRow r in dt.Rows)
                    {
                        var value = new PieWheelChartValues
                        {
                            name = r["Point"].ToString(),
                            y = double.Parse(r["Value"].ToString()),
                            color = r["Color"].ToString(),
                            text = r["Texto"].ToString()
                        };

                        chart.Valores.Add(value);

                    }
                }
            }

            return chart;

        }

        public Chart GetFlatStackedColumn(SqlCommand cmd)
        {
            FlatStackedColumn chart = new FlatStackedColumn();

            using (SqlConnection cn = new SqlConnection((new RepContext()).Database.Connection.ConnectionString.ToString()))
            {
                cmd.Connection = cn;
                cn.Open();

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataSet ds = new DataSet();

                da.Fill(ds);

                if (ds == null)
                    return chart;

                if (ds.Tables.Count < 2)
                    return chart;

                DataTable dt = ds.Tables[0];
                if (dt.Rows.Count > 0)
                {
                    foreach (DataRow r in dt.Rows)
                    {
                        chart.SerieName = r["SerieName"].ToString();
                        chart.Percent = r["Perc"].ToString();
                        if (dt.Columns.Contains("minY")) chart.minY = double.Parse(r["minY"].ToString());
                        if (dt.Columns.Contains("maxY")) chart.maxY = double.Parse(r["maxY"].ToString());
                        if (dt.Columns.Contains("Stack")) chart.stack = int.Parse(r["Stack"].ToString());
                        if (dt.Columns.Contains("ShowText")) chart.showText = int.Parse(r["ShowText"].ToString());
                        if (dt.Columns.Contains("PersistTooltip")) chart.PersistTooltip = int.Parse(r["PersistTooltip"].ToString());
                        if (dt.Columns.Contains("ShowYAxisLabels")) chart.ShowYAxisLabels = int.Parse(r["ShowYAxisLabels"].ToString());
                    }
                }

                dt = ds.Tables[1];

                if (dt.Rows.Count > 0)
                {
                    List<FlatStackedColumnSeries> serie = new List<FlatStackedColumnSeries>();
                    List<string> cat = new List<string>();

                    foreach (DataRow r in dt.Rows)
                    {
                        bool add = true;

                        for (int i = 0; i < serie.Count; i++)
                        {
                            if (serie[i].name == r["SerieName"].ToString())
                            {
                                add = false;
                                break;
                            }
                        }

                        if (add || serie.Count == 0)
                        {
                            var s = new FlatStackedColumnSeries
                            {
                                name = r["SerieName"].ToString(),
                                color = r["Color"].ToString(),
                                size = "80%",
                                type = int.Parse(r["Line"].ToString()) == 1 ? "line" : "column",
                                zIndex = int.Parse(r["Line"].ToString()) == 1 ? 1 : 0
                            };

                            serie.Add(s);
                        }
                    }

                    foreach (DataRow r in dt.Rows)
                    {
                        for (int i = 0; i < serie.Count; i++)
                        {
                            if (serie[i].name == r["SerieName"].ToString())
                            {
                                var v = new FlatStackedColumnValues
                                {
                                    name = r["Point"].ToString(),
                                    y = Double.Parse(r["value"].ToString()),
                                    text = r["Text"].ToString(),
                                    perc = r["ShowPerc"].ToString()
                                };

                                if (serie[i].data == null) serie[i].data = new List<FlatStackedColumnValues>();
                                serie[i].data.Add(v);

                                break;
                            }
                        }

                        bool add = true;

                        for (int i = 0; i < cat.Count; i++)
                        {
                            if (cat[i] == r["Point"].ToString())
                            {
                                add = false;
                                break;
                            }
                        }

                        if (add || cat.Count == 0)
                        {
                            cat.Add(r["Point"].ToString());
                        }

                    }

                    chart.Valores = serie;
                    chart.Categories = cat;
                }

                if (ds.Tables.Count >= 3)
                {

                    dt = ds.Tables[2];

                    if (dt.Rows.Count > 0)
                    {
                        List<FlatStackedColumnPlotLine> plotLines = new List<FlatStackedColumnPlotLine>();

                        foreach (DataRow r in dt.Rows)
                        {
                            var plotLine = new FlatStackedColumnPlotLine
                            {
                                color = r["Color"].ToString(),
                                dashStyle = r["DashStyle"].ToString(),
                                width = double.Parse(r["Width"].ToString()),
                                value = double.Parse(r["value"].ToString()),
                                label = new FlatStackedColumnPlotLineLabel { text = r["label"].ToString() }
                            };

                            plotLines.Add(plotLine);
                        }

                        chart.PlotLines = plotLines;
                    }
                }

                if (ds.Tables.Count == 4)
                {
                    dt = ds.Tables[3];

                    if (dt.Rows.Count > 0)
                    {
                        List<FlatStackedColumnPlotBand> plotBands = new List<FlatStackedColumnPlotBand>();

                        foreach (DataRow r in dt.Rows)
                        {
                            var plotBand = new FlatStackedColumnPlotBand
                            {
                                color = r["Color"].ToString(),
                                from = int.Parse(r["From"].ToString()),
                                to = int.Parse(r["To"].ToString()),
                            };

                            plotBands.Add(plotBand);
                        }

                        chart.PlotBands = plotBands;
                    }
                }
                return chart;
            }
        }

        public Chart GetSolidGauge(SqlCommand cmd)
        {
            SolidGauge chart = new SolidGauge();

            using (SqlConnection cn = new SqlConnection((new RepContext()).Database.Connection.ConnectionString.ToString()))
            {
                cmd.Connection = cn;
                cn.Open();

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataSet ds = new DataSet();

                da.Fill(ds);

                if (ds == null)
                    return chart;

                if (ds.Tables.Count != 1)
                    return chart;

                DataTable dt = ds.Tables[0];
                if (dt.Rows.Count > 0)
                {
                    foreach (DataRow r in dt.Rows)
                    {
                        chart.SerieName = r["SerieName"].ToString();
                        chart.AxisLabel = r["AxisLabel"].ToString();
                        chart.Value = double.Parse(r["value"].ToString());
                        chart.Color = r["Color"].ToString();
                        chart.MinY = double.Parse(r["minY"].ToString());
                        chart.MaxY = double.Parse(r["maxY"].ToString());
                        chart.Target = double.Parse(r["Target"].ToString());
                        chart.TargetLabel = r["TargetLabel"].ToString();
                    }
                }

            }

            return chart;
        }

        public Chart GetClassicTable(SqlCommand cmd)
        {
            ClassicTable chart = new ClassicTable();

            using (SqlConnection cn = new SqlConnection((new RepContext()).Database.Connection.ConnectionString.ToString()))
            {
                cmd.Connection = cn;
                cn.Open();

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataSet ds = new DataSet();

                da.Fill(ds);

                if (ds == null)
                    return chart;

                if (ds.Tables.Count != 1)
                    return chart;

                DataTable dt = ds.Tables[0];

                if (dt.Rows.Count > 0)
                {
                    for (int i = 0; i < dt.Columns.Count; i++)
                    {
                        chart.Headers.Add(dt.Columns[i].ToString());
                    }

                    List<string> row = new List<string>();

                    foreach (DataRow r in dt.Rows)
                    {
                        row = new List<string>();

                        for (int i = 0; i < dt.Columns.Count; i++)
                        {
                            row.Add(r[i].ToString());
                        }

                        chart.Valores.Add(row);
                    }
                }

            }

            return chart;
        }
        public Chart GetSparkLine(SqlCommand cmd)
        {
            SparkLineChart chart = new SparkLineChart();

            using (SqlConnection cn = new SqlConnection((new RepContext()).Database.Connection.ConnectionString.ToString()))
            {
                cmd.Connection = cn;
                cn.Open();

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataSet ds = new DataSet();

                da.Fill(ds);

                if (ds == null)
                    return chart;

                if (ds.Tables.Count != 1)
                    return chart;

                DataTable dt = ds.Tables[0];

                chart.Categories = dt.Rows.OfType<DataRow>().Select(dr => dr[2].ToString()).Distinct().ToList();

                int i = 0;// dt.Rows.Count;
                while (i < dt.Rows.Count)
                {
                    var idx = dt.Rows[i][0].ToString();
                    var serie = new SparkLineSerie() { name = dt.Rows[i][1].ToString() };
                    while (i < dt.Rows.Count && idx == dt.Rows[i][0].ToString())
                    {
                        SparkLineData newData = new SparkLineData();
                        newData.y = double.Parse(dt.Rows[i][3].ToString());
                        newData.dateFrom = dt.Rows[i][4].ToString();
                        newData.dateTo = dt.Rows[i][5].ToString();

                        serie.data.Add(newData);
                        i++;
                    }
                    chart.Valores.Add(serie);
                }
            }

            return chart;
        }

        public List<ReportingObjeto> GetObjetosDeCliente(int ClienteId)
        {
            return context.ReportingObjeto.Where(o => o.ReportingClienteObjeto.Any(c => c.IdCliente == ClienteId && c.IdObjeto == o.Id) && o.ReportingFamiliaObjeto.ReportingFamiliaObjetoCliente.Any(fo => fo.IdCliente == ClienteId)).ToList();
        }
        public List<ReportingClienteObjeto> GetRelObjetoCliente(int ClienteId)
        {
            return context.ReportingClienteObjeto.Where(o => o.IdCliente == ClienteId).ToList();
        }
        public bool DeleteTablero(int TableroId)
        {
            try
            {
                var objTablero = context.ReportingTableroObjeto.Where(to => to.IdTablero == TableroId);
                context.ReportingTableroObjeto.RemoveRange(objTablero);

                var usuTablero = context.ReportingTableroUsuario.Where(to => to.IdTablero == TableroId);
                context.ReportingTableroUsuario.RemoveRange(usuTablero);

                ReportingTablero t = context.ReportingTablero.FirstOrDefault(x => x.Id == TableroId);
                context.ReportingTablero.Remove(t);

                context.SaveChanges();

                return true;
            }
            catch
            {
                return false;
            }
        }
        public bool UpdateOrdenTablero(int TableroID, int Orden, bool esPropio, int idUsuario)
        {
            try
            {
                ReportingTableroUsuario usuTablero;
                ReportingTablero objTablero;
                if (esPropio)
                {
                    objTablero = context.ReportingTablero.SingleOrDefault(to => to.Id == TableroID);
                    objTablero.orden = Orden;
                }
                else
                {
                    usuTablero = context.ReportingTableroUsuario.SingleOrDefault(to => to.IdTablero == TableroID && to.IdUsuario == idUsuario);
                    usuTablero.orden = Orden;
                }

                context.SaveChanges();

                return true;
            }
            catch (Exception e)
            {
                string Estring = e.Message;
                return false;
            }
        }
        public bool ExisteTableroUsuario(int TableroID, int IdUsuario)
        {
            return context.ReportingTablero.Any(t => t.Id == TableroID && t.IdUsuario == IdUsuario);
        }
        public bool EditarTablero(ReportingTablero tablero)
        {
            try
            {
                List<ReportingTableroObjeto> eliminar = new List<ReportingTableroObjeto>();
                var objetosEnDB = context.ReportingTablero.FirstOrDefault(t => t.Id == tablero.Id).ReportingTableroObjeto;
                foreach (ReportingTableroObjeto to in objetosEnDB)
                {
                    if (!tablero.ReportingTableroObjeto.Any(o => o.IdObjeto == to.IdObjeto))
                    {
                        eliminar.Add(to);
                    }
                }

                context.ReportingTableroObjeto.RemoveRange(eliminar);

                var tab = context.ReportingTablero.FirstOrDefault(t => t.Id == tablero.Id);
                if (tab != null)
                {
                    tab.Nombre = tablero.Nombre;
                    context.Entry(tab);
                }

                foreach (ReportingTableroObjeto o in tablero.ReportingTableroObjeto)
                {
                    var tobjDB = context.ReportingTableroObjeto.FirstOrDefault(to => to.IdTablero == o.IdTablero && to.IdObjeto == o.IdObjeto);
                    if (tobjDB != null)
                    {
                        tobjDB.FlgDataLabel = o.FlgDataLabel;
                        tobjDB.Orden = o.Orden;
                        tobjDB.Size = o.Size;
                        tobjDB.StackLabel = o.StackLabel;
                        tobjDB.Altura = o.Altura;
                        context.Entry(tobjDB);
                    }
                    else
                    {
                        context.ReportingTableroObjeto.Add(o);
                    }
                }

                context.SaveChanges();

                return true;
            }
            catch
            {

                return false;
            }
        }
        public List<ReportingObjetoCategoria> GetCategoriasObjetoDeCliente(int idCliente)
        {
            return context.ReportingObjetoCategoria.Where(oc => oc.ReportingFamiliaObjeto.Any(f => f.ReportingObjeto.Any(o => o.ReportingClienteObjeto.Any(c => c.IdCliente == idCliente)))).OrderBy(m => m.Nombre).ToList();
        }
        public bool updateConfiguracionDeTableroObjeto(int tableroId, int objetoId, bool dataLabel, int stackLabel)
        {
            try
            {
                ReportingTableroObjeto obj = context.ReportingTableroObjeto.FirstOrDefault(to => to.IdTablero == tableroId && to.IdObjeto == objetoId);
                if (obj != null)
                {
                    obj.StackLabel = stackLabel;
                    obj.FlgDataLabel = dataLabel;

                    context.Entry(obj);
                    context.SaveChanges();
                }
                return true;
            }
            catch
            {

                return false;
            }
        }
        public bool CambiarObjetoDeTablero(int tableroId, int objetoIdInicial, int objetoIdNuevo)
        {
            try
            {
                var tabObj = context.ReportingTableroObjeto.FirstOrDefault(t => t.IdObjeto == objetoIdInicial && t.IdTablero == tableroId);
                if (tabObj == null)
                    return false;

                tabObj.IdObjeto = objetoIdNuevo;
                context.Entry(tabObj);
                context.SaveChanges();

                return true;
            }
            catch
            {

                return false;
            }
        }
        public List<ReportingTablero> GetMisTableros(int usuarioId)
        {
            return context.ReportingTablero.Where(t => t.IdModulo == 1 && t.IdUsuario == usuarioId).ToList();
        }
        public List<ReportingTableroUsuario> GetUsuariosDeTablero(int IdTablero)
        {
            return context.ReportingTableroUsuario.Where(r => r.IdTablero == IdTablero).ToList();
        }
        public bool QuitarPermisos(int idTablero)
        {
            try
            {
                var permisos = context.ReportingTableroUsuario.Where(p => p.IdTablero == idTablero);
                context.ReportingTableroUsuario.RemoveRange(permisos);
                context.SaveChanges();
                return true;
            }
            catch
            {

                return false;
            }
        }
        public bool AgregarPermisos(ReportingTableroUsuario permiso)
        {
            try
            {
                context.ReportingTableroUsuario.Add(permiso);
                context.SaveChanges();
                return true;
            }
            catch
            {

                return false;
            }
        }
        public List<TableroPermiso> GetPermisosDeTablero(int idCliente, int idUsuario)
        {
            List<ReportingTablero> tableros = context.ReportingTablero.Where(t => t.IdModulo == 1 && t.IdUsuario == idUsuario && t.IdCliente == idCliente).ToList();
            List<ReportingTableroUsuario> datos = context.ReportingTableroUsuario.Where(p => p.IdUsuario == idUsuario && p.ReportingTablero.IdCliente == idCliente && p.ReportingTablero.IdModulo == 1).ToList();
            List<TableroPermiso> permisos = new List<TableroPermiso>();

            foreach (ReportingTablero tab in tableros)
            {
                permisos.Add(new TableroPermiso() { tableroId = tab.Id, propio = true, permiteEscritura = true, tableroNombre = tab.Nombre, propietario = string.Empty, orden = tab.orden });
            }

            foreach (ReportingTableroUsuario rtu in datos)
            {
                permisos.Add(new TableroPermiso() { tableroId = rtu.IdTablero, propio = false, permiteEscritura = (rtu.PermiteEscritura.HasValue) ? (bool)rtu.PermiteEscritura : false, tableroNombre = rtu.ReportingTablero.Nombre, propietario = context.Usuario.FirstOrDefault(u => u.IdUsuario == rtu.ReportingTablero.IdUsuario).Apellido + ',' + context.Usuario.FirstOrDefault(u => u.IdUsuario == rtu.ReportingTablero.IdUsuario).Nombre, orden = rtu.orden });
            }

            return permisos;
        }
        public bool PermiteCambiarPermisosDeTablero(int tableroId, int usuarioId, int clienteId)
        {
            ReportingTablero tablero = context.ReportingTablero.FirstOrDefault(t => t.IdModulo == 1 && t.Id == tableroId && t.IdUsuario == usuarioId && t.IdCliente == clienteId);
            if (tablero != null)
                return true;
            else
                return false;
        }
        public bool PermiteEditarTablero(int tableroId, int usuarioId, int clienteId)
        {
            ReportingTablero tablero = context.ReportingTablero.FirstOrDefault(x =>
                x.IdModulo == 1 &&
                ((x.Id == tableroId && x.IdCliente == clienteId && x.ReportingTableroUsuario.Any(uc => uc.IdUsuario == usuarioId && (uc.PermiteEscritura.HasValue) ? (bool)uc.PermiteEscritura : false))
                || (x.Id == tableroId && x.IdUsuario == usuarioId)
                ));

            if (tablero != null)
                return true;
            else
                return false;
        }
        public List<ReportingFamiliaObjeto> GetFamiliasObjetoDeCliente(int clienteId)
        {
            return context.ReportingFamiliaObjeto.Where(f => f.ReportingFamiliaObjetoCliente.Any(fc => fc.IdCliente == clienteId && fc.IdFamilia == f.Id)).ToList();
        }
        public List<ReportingClienteObjeto> GetObjetosAsignadosACliente(int clienteId)
        {
            return context.ReportingClienteObjeto.Where(o => o.IdCliente == clienteId).ToList();
        }
        public List<ReportingFamiliaObjeto> GetAllFamilias()
        {
            return context.ReportingFamiliaObjeto.ToList();
        }
        public List<ReportingObjeto> GetAllObjetos()
        {
            return context.ReportingObjeto.ToList();
        }
        public bool SetObjectName(int id, int clienteId, string nombre)
        {
            try
            {
                ReportingFamiliaNombreCliente familia = context.ReportingFamiliaNombreCliente.SingleOrDefault(f => f.idCliente == clienteId && f.idFamilia == id);

                if (familia == null)
                {
                    context.ReportingFamiliaNombreCliente.Add(new ReportingFamiliaNombreCliente() { idCliente = clienteId, idFamilia = id, Nombre = nombre });
                }
                else
                {
                    familia.Nombre = nombre;
                    context.Entry(familia);
                }

                context.SaveChanges();

                return true;
            }
            catch
            {
                return false;
            }

        }
        public List<ReportingFamiliaNombreCliente> GetFamiliasNombreCliente(int clienteId)
        {
            return context.ReportingFamiliaNombreCliente.Where(c => c.idCliente == clienteId).ToList();
        }
        public bool ResetObjectName(int id, int clienteId)
        {
            try
            {

                ReportingFamiliaNombreCliente familia = context.ReportingFamiliaNombreCliente.SingleOrDefault(f => f.idCliente == clienteId && f.idFamilia == id);


                if (familia != null)
                {
                    context.ReportingFamiliaNombreCliente.Remove(familia);
                }

                context.SaveChanges();

                return true;
            }
            catch
            {

                return false;
            }
        }
        public List<ReportingModulos> GetModulos(bool UsaFiltros)
        {
            return context.ReportingModulos.Where(m => m.UsaFiltros == UsaFiltros).ToList();
        }
        public List<ReportingFiltros> GetFiltrosDeModulo(int modulo, int ClienteId)
        {
            return context.ReportingFiltros.Where(f => f.ReportingFiltrosModulo.Any(rf => rf.idCliente == ClienteId && rf.idModulo == modulo) && f.ReportingFiltrosCliente.Any(rfc => rfc.IdCliente == ClienteId)).ToList();
        }
        public List<ReportingFiltros> GetFiltros()
        {
            return context.ReportingFiltros.ToList();
        }
        public List<ReportingFiltros> GetFiltrosDeCliente(int ClienteId)
        {
            return context.ReportingFiltros.Where(f => f.ReportingFiltrosCliente.Any(rfc => rfc.IdCliente == ClienteId)).ToList();
        }
        public bool SetFiltroName(int id, int clienteId, string nombre)
        {
            try
            {
                ReportingFiltroNombreCliente filtro = context.ReportingFiltroNombreCliente.SingleOrDefault(f => f.idCliente == clienteId && f.idFiltro == id);

                if (filtro == null)
                {
                    context.ReportingFiltroNombreCliente.Add(new ReportingFiltroNombreCliente() { idCliente = clienteId, idFiltro = id, Nombre = nombre });
                }
                else
                {
                    filtro.Nombre = nombre;
                    context.Entry(filtro);
                }

                context.SaveChanges();

                return true;
            }
            catch
            {

                return false;
            }
        }
        public bool ResetFiltroName(int id, int clienteId)
        {
            try
            {

                ReportingFiltroNombreCliente filtro = context.ReportingFiltroNombreCliente.SingleOrDefault(f => f.idCliente == clienteId && f.idFiltro == id);


                if (filtro != null)
                {
                    context.ReportingFiltroNombreCliente.Remove(filtro);
                }

                context.SaveChanges();

                return true;
            }
            catch
            {

                return false;
            }
        }
        public bool SetFiltroActivo(int id, int clienteId, int modulo, bool check)
        {
            try
            {
                if (!check)
                {
                    ReportingFiltrosModulo fm = context.ReportingFiltrosModulo.SingleOrDefault(f => f.idFiltro == id && f.idCliente == clienteId && f.idModulo == modulo);
                    if (fm != null)
                    {
                        context.ReportingFiltrosModulo.Remove(fm);
                    }
                }
                else
                {
                    ReportingFiltrosModulo fm = context.ReportingFiltrosModulo.SingleOrDefault(f => f.idFiltro == id && f.idCliente == clienteId && f.idModulo == modulo);
                    if (fm == null)
                    {
                        context.ReportingFiltrosModulo.Add(new ReportingFiltrosModulo() { idCliente = clienteId, idFiltro = id, idModulo = modulo });
                    }
                }

                context.SaveChanges();

                return true;
            }
            catch
            {

                return false;
            }

        }
        public bool SetObjetoSeleccionado(int clienteId, int objetoId, bool value)
        {
            try
            {
                bool ret = false;
                var existeRegistro = context.ReportingClienteObjeto.FirstOrDefault(m => m.IdCliente == clienteId && m.IdObjeto == objetoId);

                if (existeRegistro == null)
                {
                    if (value)
                    {
                        context.ReportingClienteObjeto.Add(new ReportingClienteObjeto() { IdCliente = clienteId, IdObjeto = objetoId });
                        ret = context.SaveChanges() > 0;
                    }
                }
                else
                {
                    if (!value)
                    {
                        context.ReportingClienteObjeto.Remove(existeRegistro);
                        ret = context.SaveChanges() > 0;
                    }
                }

                return ret;
            }
            catch
            {

                return false;
            }
        }

        public Chart GetSPAnidado(List<FiltroSeleccionado> filtros, int ClienteId, int ObjetoId, List<string> Esclave, List<string> EsclaveValue, int UsuarioConsultaId)
        {
            TableChart chart = new TableChart();

            using (SqlConnection cn = new SqlConnection((new RepContext()).Database.Connection.ConnectionString.ToString()))
            {
                ReportingObjeto obj = GetObjeto(ObjetoId);
                DataTable dtfiltros = new DataTable();
                dtfiltros.Columns.Add(new DataColumn("IdFiltro", typeof(string)));
                dtfiltros.Columns.Add(new DataColumn("Valores", typeof(string)));

                SqlCommand cmd = new SqlCommand(obj.SpAnidado)
                {
                    CommandType = CommandType.StoredProcedure,
                    CommandTimeout = 240,
                    Connection = cn
                };

                cmd.Parameters.Add("@IdCliente", SqlDbType.Int).Value = ClienteId;

                if (filtros != null)
                {
                    foreach (FiltroSeleccionado f in filtros)
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

                if (Esclave != null)
                {
                    foreach (var f in Esclave)
                    {
                        DataRow newRow = dtfiltros.NewRow();
                        newRow[0] = f;
                        newRow[1] = string.Join(",", EsclaveValue[Esclave.IndexOf(f)]);

                        dtfiltros.Rows.Add(newRow);
                    }
                }

                cmd.Parameters.Add("@Filtros", SqlDbType.Structured).Value = dtfiltros;
                cmd.Parameters.Add("@NumeroDePagina", SqlDbType.Int).Value = -1;
                cmd.Parameters.Add("@Lenguaje", SqlDbType.VarChar).Value = System.Threading.Thread.CurrentThread.CurrentCulture.Name;
                cmd.Parameters.Add("@IdUsuarioConsulta", SqlDbType.Int).Value = UsuarioConsultaId;
                cmd.Parameters.Add("@TamañoPagina", SqlDbType.Int).Value = 0;

                // ----------------------------------------------------------------------------------------------------------------




                cn.Open();

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataSet ds = new DataSet();
                da.Fill(ds);

                if (ds == null)
                    return chart;

                if (ds.Tables.Count != 3)
                    return chart;

                //Cantidad de paginas
                DataTable dt = ds.Tables[0];
                if (dt.Rows.Count <= 0)
                    return chart;

                //Configuracion de columnas
                dt = ds.Tables[1];
                foreach (DataRow r in dt.Rows)
                {
                    chart.Columns.Add(new TableChartColumn() { name = r["name"].ToString(), title = r["title"].ToString(), width = int.Parse(r["width"].ToString()) });
                }

                //Datos
                dt = ds.Tables[2];
                if (dt.Rows.Count == 0)
                {
                    chart.pages = 0;
                    return chart;
                }

                List<Dictionary<string, object>> parentRow = new List<Dictionary<string, object>>();
                Dictionary<string, object> childRow;

                foreach (DataRow row in dt.Rows)
                {
                    childRow = new Dictionary<string, object>();
                    foreach (DataColumn col in dt.Columns)
                    {
                        childRow.Add(col.Caption, row[col].ToString());
                    }
                    parentRow.Add(childRow);
                }

                chart.Valores = parentRow;

            }

            return chart;
        }
        public string GetReportingFamiliaObjetoIdentificador(int id)
        {
            var familiaObjeto = context.ReportingFamiliaObjeto.Where(x => x.Id == id).FirstOrDefault();

            return familiaObjeto.Identificador;
        }
        public ReportingTablero GetTableroById(int tableroId)
        {
            return context.ReportingTablero.First(x => x.Id == tableroId);
        }
        public int GetModuloByTableroId(int tableroId)
        {
            return context.ReportingTablero.First(x => x.Id == tableroId).IdModulo.Value;
        }
        public bool AsignarFamiliaACliente(int ClienteId, int FamiliaId)
        {
            try
            {
                if (!context.ReportingFamiliaObjetoCliente.Any(f => f.IdCliente == ClienteId && f.IdFamilia == FamiliaId))
                {
                    context.ReportingFamiliaObjetoCliente.Add(new ReportingFamiliaObjetoCliente() { IdCliente = ClienteId, IdFamilia = FamiliaId });
                    context.SaveChanges();
                }

                return true;
            }
            catch
            {

                return false;
            }
        }
        public bool QuitarFamiliaDeCliente(int ClienteId, int FamiliaId)
        {
            try
            {
                var r = context.ReportingFamiliaObjetoCliente.FirstOrDefault(f => f.IdCliente == ClienteId && f.IdFamilia == FamiliaId);
                if (r != null)
                {
                    context.Entry(r).State = EntityState.Deleted;
                    context.SaveChanges();
                }
                return true;
            }
            catch
            {

                return false;
            }
        }
        public bool ActivarFiltroParaCliente(int filtroid, int clienteid)
        {
            try
            {
                if (!context.ReportingFiltrosCliente.Any(r => r.IdCliente == clienteid && r.IdFiltro == filtroid))
                {
                    context.ReportingFiltrosCliente.Add(new ReportingFiltrosCliente()
                    {
                        IdCliente = clienteid,
                        IdFiltro = filtroid
                    });
                    context.SaveChanges();
                }

                return true;
            }
            catch
            {

                return false;
            }
        }
        public bool DesactivarFiltroParaCliente(int filtroid, int clienteid)
        {
            try
            {
                var r = context.ReportingFiltrosCliente.FirstOrDefault(f => f.IdCliente == clienteid && f.IdFiltro == filtroid);
                if (r != null)
                {
                    context.Entry(r).State = EntityState.Deleted;
                    context.SaveChanges();
                }
                return true;
            }
            catch
            {

                return false;
            }
        }
        public Reporte GetReporte(int ClienteId, int IdReporte)
        {
            if (ClienteId == 147)
            {
                return context.Reporte.FirstOrDefault(r => r.IdReporte == IdReporte);
            }
            else
            {
                return context.Reporte.FirstOrDefault(r => r.IdReporte == IdReporte && r.Empresa.Cliente.Any(e => e.IdCliente == ClienteId));
            }
        }
        public PuntoDeVenta GetPuntoDeVenta(int ClienteId, int IdPuntoDeVenta)
        {
            if (ClienteId == 147)
            {
                return context.PuntoDeVenta.FirstOrDefault(p => p.IdPuntoDeVenta == IdPuntoDeVenta);
            }
            else
            {
                return context.PuntoDeVenta.FirstOrDefault(p => p.IdPuntoDeVenta == IdPuntoDeVenta && p.IdCliente == ClienteId);
            }

        }
        public string GetNombreObjeto(int idFamiliaObjeto, int idUsuario)
        {
            SqlCommand cmd = new SqlCommand("GetNombreFamiliaObjeto")
            {
                CommandType = CommandType.StoredProcedure,
                CommandTimeout = 240
            };

            cmd.Parameters.Add("@idFamilia", SqlDbType.Int).Value = idFamiliaObjeto;
            cmd.Parameters.Add("@idUsuario", SqlDbType.Int).Value = idUsuario;

            using (SqlConnection cn = new SqlConnection((new RepContext()).Database.Connection.ConnectionString.ToString()))
            {
                cmd.Connection = cn;
                cn.Open();

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataSet ds = new DataSet();
                da.Fill(ds);

                if (ds == null)
                {
                    return "";
                }

                DataTable dtData = ds.Tables[0];

                if (dtData.Rows.Count > 0)
                {
                    return dtData.Rows[0]["Nombre"].ToString();
                }
            }
            return "";
        }



        public string GetDescripcionObjeto(int idObjeto, string CultureName)
        {
            SqlCommand cmd = new SqlCommand("GetDescripcionObjeto")
            {
                CommandType = CommandType.StoredProcedure,
                CommandTimeout = 240
            };

            cmd.Parameters.Add("@idObjeto", SqlDbType.Int).Value = idObjeto;
            cmd.Parameters.Add("@CultureName", SqlDbType.VarChar).Value = CultureName;

            using (SqlConnection cn = new SqlConnection((new RepContext()).Database.Connection.ConnectionString.ToString()))
            {
                cmd.Connection = cn;

                cn.Open();

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataSet ds = new DataSet();
                da.Fill(ds);

                if (ds == null)
                {
                    return "";
                }


                DataTable dtData = ds.Tables[0];

                if (dtData.Rows.Count > 0)
                {
                    return dtData.Rows[0]["Desc"].ToString();
                }
            }

            return "";
        }
    }
}
