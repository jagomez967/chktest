using System;
using System.Collections.Generic;
using System.Linq;
using Reporting.Domain.Abstract;
using Reporting.Domain.Entities;
using System.Data.SqlClient;
using System.Data;
using System.IO;
using System.Drawing;
using NPOI.SS.UserModel;
using NPOI.XSSF.UserModel;
using HtmlAgilityPack;

namespace Reporting.Domain.Concrete
{
    public class DatosRepository : IDatosRepository
    {
        private RepContext context = new RepContext();
        public IEnumerable<Tab> GetTabs(int ClienteId)
        {
            return context.ReportingTablero.Where(t => t.IdModulo == 2 && t.IdCliente == ClienteId).Select(x => new Tab() { Titulo = x.Nombre, Id = x.Id, Active = false });
        }
        public ReportingTablero GetTablero(int TableroId, int UsuarioId, int ClienteId)
        {
            return context.ReportingTablero.FirstOrDefault(x => x.IdModulo == 2 && x.IdCliente == ClienteId);
        }
        public ReportingTablero GetTableroDefault(int UsuarioId, int ClienteId)
        {
            ReportingTablero tablero;

            if (ClienteId == 0)
                tablero = null;
            else
                tablero = context.ReportingTablero.FirstOrDefault(t => t.IdModulo == 2 && t.IdCliente == ClienteId);

            return tablero;
        }
        public int GetTableroIdDefault(int userId, int clienteId)
        {
            var tablero = context.ReportingTablero.FirstOrDefault(t => t.IdModulo == 2 && t.IdCliente == clienteId);

            if (tablero != null)
                return tablero.Id;
            else
                return 0;
        }
        //Solo va a ser usado por tablero, no por "datos", no puedo explicar porque tengo que arrastrar este error
        public int GetIdTableroByObjetoUser(int objetoId, int userId)
        {

            var Tablero = context.ReportingTablero.FirstOrDefault(rt => rt.ReportingTableroObjeto.Any(rto => rto.IdObjeto == objetoId) &&
                                                               rt.ReportingTableroUsuario.Any(rtu => rtu.IdUsuario == userId));

            if (Tablero != null)
            {
                return Tablero.Id;
            }
            else
                return 0;
        }


        public int GetIdTableroByObjetoUser2(int objetoId, int userId)
        {

            var Tablero = context.ReportingTablero.FirstOrDefault(rt => rt.ReportingTableroObjeto.Any(rto => rto.IdObjeto == objetoId) &&
                                                               rt.IdUsuario == userId);

            if (Tablero != null)
            {
                return Tablero.Id;
            }
            else
                return 0;
        }

        public bool ExistsFiltroPorTablero(int tableroid)
        {
            var tablero = context.ReportingTablero.FirstOrDefault(rt => rt.Id == tableroid);
            if (tablero != null)
            {
                if (tablero.filtrosBloqueados != null)
                {
                    if (tablero.filtrosBloqueados.Trim() != "")
                        return true;
                }
            }
            return false;
        }

        //GetModuloTablero TOSCO
        public int GetModuloTablero(int idTablero)
        {

            var Tablero = context.ReportingTablero.FirstOrDefault(rt => rt.Id == idTablero);

            if (Tablero != null)
            {
                return Tablero.IdModulo.Value;
            }
            else
                return 0;
        }
        public IEnumerable<ReportingTableroObjeto> GetObjetosDeTablero(int TableroId)
        {
            return context.ReportingTablero.SingleOrDefault(t => t.Id == TableroId).ReportingTableroObjeto.OrderBy(t => t.Orden);
        }
        public Chart GetDataObjeto(List<FiltroSeleccionado> filtros, int clienteId, int objetoId, int numeroPagina, int usuarioConsultaId, int tamanioPagina)
        {
            Chart chart = null;
            ReportingObjeto obj = GetObjeto(objetoId);

            chart = GetTableData(filtros, clienteId, objetoId, numeroPagina, usuarioConsultaId, tamanioPagina);

            chart.Tipo = obj.TipoChart;
            return chart;
        }
        public ReportingObjeto GetObjeto(int ObjetoId)
        {
            return context.ReportingObjeto.SingleOrDefault(o => o.Id == ObjetoId);
        }
        public Chart GetTableData(List<FiltroSeleccionado> filtros, int clienteId, int objetoId, int numeroPagina, int usuarioConsultaId, int tamanioPagina)
        {
            TableChart chart = new TableChart();
            ReportingObjeto obj = GetObjeto(objetoId);
            DataTable dtfiltros = new DataTable();
            dtfiltros.Columns.Add(new DataColumn("IdFiltro", typeof(string)));
            dtfiltros.Columns.Add(new DataColumn("Valores", typeof(string)));

            using (SqlConnection cn = new SqlConnection((new RepContext()).Database.Connection.ConnectionString.ToString()))
            {
                SqlCommand cmd = new SqlCommand(obj.SpDatos, cn);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.CommandTimeout = 240;

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

                cn.Open();

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataSet ds = new DataSet();
                da.Fill(ds);

                if (ds == null)
                    return chart;

                if (ds.Tables.Count != 3 && obj.TipoChart != TipoChart.ClassicTable)
                    return chart;

                //Cantidad de paginas
                //si no existe nada... (solucion "temporal?" para los T9 /20/25/30 Pivoteados que no traen nada o no tienen un manejo adecuado para el caso vacio
                if (ds.Tables.Count == 0) { 
                chart.pages = 0;
                return chart;
                }

                DataTable dt = ds.Tables[0];
                if (dt.Rows.Count <= 0)
                    return chart;


                if (obj.TipoChart != TipoChart.ClassicTable)
                {
                    chart.pages = int.Parse(dt.Rows[0][0].ToString());

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
        public string GenerarArchivo(List<FiltroSeleccionado> Filtros, int ClienteId, int ObjetoId, int UsuarioConsultaId)
        {
            const string chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
            var random = new Random();
            string token = new string(Enumerable.Repeat(chars, 30).Select(s => s[random.Next(s.Length)]).ToArray());
            string path = AppDomain.CurrentDomain.BaseDirectory;
            string filename = token + ".csv";
            string newfilepath = Path.Combine(path, "Temp", filename);
     

            try
            {
                TableChart ch = (TableChart)GetDataObjeto(Filtros, ClienteId, ObjetoId, -1, UsuarioConsultaId, 0);

                XSSFWorkbook wbExcel = new XSSFWorkbook();
                XSSFSheet eSheet = (XSSFSheet)wbExcel.CreateSheet("Tabla");
                XSSFRow rTitulos = (XSSFRow)eSheet.CreateRow(0);
                XSSFRow rCurrent;
                XSSFCell cCurrent;
                XSSFCellStyle csEstilo;
                XSSFFont fFuente;
                XSSFColor cColor;

                int iCell = 0;
                int iRow = 1;
                if (ch.Tipo != TipoChart.ClassicTable)
                {
                    foreach (var c in ch.Columns)
                    {
                        cCurrent = (XSSFCell)rTitulos.CreateCell(iCell);
                        cCurrent.SetCellValue(c.title.ToString());
                        iCell++;
                    }
                }
                else
                {
                    foreach (var c in ch.Valores[0])
                    {
                        cCurrent = (XSSFCell)rTitulos.CreateCell(iCell);
                        cCurrent.SetCellValue(c.Key.ToString());
                        iCell++;
                    }
                }
                foreach (var v in ch.Valores)
                {
                    iCell = 0;
                    rCurrent = (XSSFRow)eSheet.CreateRow(iRow++);
                    foreach (var vc in v)
                    {
                        cCurrent = (XSSFCell)rCurrent.CreateCell(iCell);
                        if (vc.Value.ToString().Length != 0)
                        {
                            if (vc.Value.ToString().Substring(0, 1) == "●")
                            {
                                csEstilo = (XSSFCellStyle)wbExcel.CreateCellStyle();
                                fFuente = (XSSFFont)wbExcel.CreateFont();
                                cColor = new XSSFColor(ColorTranslator.FromHtml(vc.Value.ToString().Replace("●", "")));

                                fFuente.IsBold = true;
                                fFuente.SetColor(cColor);
                                fFuente.FontHeightInPoints = 16;

                                csEstilo.SetFont(fFuente);
                                csEstilo.Alignment = HorizontalAlignment.Center;

                                cCurrent.CellStyle = csEstilo;
                                cCurrent.SetCellValue(vc.Value.ToString().Substring(0, 1));

                            }
                            else
                            {
                                cCurrent.SetCellValue(vc.Value.ToString());
                            }
                        }

                        iCell++;
                    }
                }

                filename = token + ".xlsx";
                FileStream File = new FileStream(Path.Combine(path, "Temp", filename), FileMode.Create, FileAccess.Write);
                wbExcel.Write(File);
                File.Close();

                return token;
            }
            catch (System.IO.IOException ex)
            {
                throw ex;
            }
            catch (Exception e)
            {
                throw e;
            }

        }
        public void EliminarArchivo(string filename, bool fc = false)
        {
            string path = AppDomain.CurrentDomain.BaseDirectory;
            string newfilepath = Path.Combine(path, "Temp", filename + (fc ? ".xlsx" : ".csv"));
            File.Delete(newfilepath);
        }

        public string ExportacionCAP(string HtmlDoc, bool Soar)
        {

            var random = new Random();
            string token = new string(Enumerable.Repeat("ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789", 30).Select(s => s[random.Next(s.Length)]).ToArray());

            XSSFWorkbook xwb = new XSSFWorkbook();
            XSSFSheet xs = (XSSFSheet)xwb.CreateSheet("CAP");
            XSSFRow xcr = (XSSFRow)xs.CreateRow(0);
            XSSFCell xcc;

            XSSFCellStyle cstl;
            XSSFFont cfnt;
            XSSFColor ccol;

            int iCell = 0;
            int iRow = 1;

           HtmlDocument ht = new HtmlDocument();
            ht.LoadHtml(HtmlDoc);

            HtmlNodeCollection Tables = ht.DocumentNode.SelectNodes("//body/table");
            HtmlNodeCollection HeaderRows;
            HtmlNodeCollection Rows;
            HtmlNodeCollection ValueRows;

            for (int t=0;t<Tables.Count;t++)
            {
                if ((Soar && t == 0) || !Soar) { 
                    iCell = 0;
                    if (Tables.IndexOf(Tables[t]) != 0) iRow += Soar?1:2;
                    xcr = (XSSFRow)xs.CreateRow(iRow - 1);
                    xcc = (XSSFCell)xcr.CreateCell(iCell);

                    HeaderRows = Tables[t].SelectNodes("./thead/tr/th");
                
                    foreach (HtmlNode TableHeader in HeaderRows)
                    {
                        xcc = (XSSFCell)xcr.CreateCell(iCell);
                        string[] arr = TableHeader.Attributes["style"].Value.ToString().Split(';');

                        int[] BackRgb = new int[3];
                        string[] BackRgbStr;
                        int[] FrontRgb = new int[3];
                        string[] FrontRgbStr;

                        foreach (string style in arr)
                        {    
                            if (style.Trim().StartsWith("background-color:")) {
                                BackRgbStr = style.Split(':')[1].Split(',');
                                for(int i=0;i< BackRgbStr.Length;i++)
                                {
                                    BackRgb[i]=int.Parse(BackRgbStr[i].Replace("rgb(", "").Replace(")", ""));
                                }
                            }
                        
                            if (style.Trim().StartsWith("color:"))
                            {
                                FrontRgbStr = style.Split(':')[1].Split(',');
                                for (int i = 0; i < FrontRgbStr.Length; i++)
                                {
                                    FrontRgb[i] = int.Parse(FrontRgbStr[i].Replace("rgb(", "").Replace(")", ""));
                                }
                            }

                            for (int i = 0; i < 3; i++)
                            {
                                if (BackRgb[i] == 0) BackRgb[i] = 255;
                            }

                            cstl = (XSSFCellStyle)xwb.CreateCellStyle();
                            cfnt = (XSSFFont)xwb.CreateFont();
                            ccol = (!Soar? new XSSFColor(Color.FromArgb(BackRgb[0], BackRgb[1], BackRgb[2])): new XSSFColor((iCell!=0 && iCell!=1?Color.FromArgb(253, 234, 218): Color.FromArgb(255, 255, 255))));
                            cstl.SetFillForegroundColor(ccol);
                            cstl.FillPattern = FillPattern.SolidForeground;
                            ccol = (!Soar? new XSSFColor(Color.FromArgb(FrontRgb[0], FrontRgb[1], FrontRgb[2])): new XSSFColor(Color.FromArgb(0, 0, 255)));
                            cfnt.SetColor(ccol);
                            cfnt.IsBold = true;
                            cfnt.FontHeightInPoints = (short)(!Soar?14:10);
                            cstl.SetFont(cfnt);
                            if (Soar) cstl.BorderBottom = BorderStyle.Thin;
                            if(!Soar) cstl.Alignment = HorizontalAlignment.Center;
                        
                            xcc.CellStyle = cstl;

                            xs.AutoSizeColumn(xcc.ColumnIndex);
                        }
                        xcc.SetCellValue(Soar ? TableHeader.InnerHtml.Split('(')[0] : TableHeader.InnerHtml);
                        
                        iCell++;
                    }
                }
                Rows = Tables[t].SelectNodes("./tbody/tr");
                iCell = 0;
                
                foreach (HtmlNode Row in Rows)
                {
                    xcr = (XSSFRow)xs.CreateRow(iRow++);
                    ValueRows = Row.SelectNodes("./td");
                    iCell = 0;
                    foreach (HtmlNode RowData in ValueRows)
                    {
                        string[] arr = RowData.Attributes["style"].Value.ToString().Split(';');

                        int[] BackRgb = new int[3];
                        string[] BackRgbStr;
                        int[] FrontRgb = new int[3];
                        string[] FrontRgbStr;
                        bool bRightBorder = false;

                        xcc = (XSSFCell)xcr.CreateCell(iCell++);

                        foreach (string style in arr)
                        {

                            if (style.Trim().StartsWith("background-color:"))
                            {
                                BackRgbStr = style.Split(':')[1].Split(',');
                                for (int i = 0; i < BackRgbStr.Length; i++)
                                {
                                    BackRgb[i] = int.Parse(BackRgbStr[i].Replace("rgb(", "").Replace(")", ""));
                                }
                            }
                            
                            if (style.Trim().StartsWith("color:"))
                            {
                                FrontRgbStr = style.Split(':')[1].Split(',');
                                for (int i = 0; i < FrontRgbStr.Length; i++)
                                {
                                    FrontRgb[i] = int.Parse(FrontRgbStr[i].Replace("rgb(", "").Replace(")", ""));
                                }
                            }

                            if (style.Trim().StartsWith("border-right: 1px dashed black")) bRightBorder = true;

                            for (int i = 0; i < 3; i++)
                            {
                                if (BackRgb[i] == 0) BackRgb[i] = 255;
                            }

                            cstl = (XSSFCellStyle)xwb.CreateCellStyle();
                            cfnt = (XSSFFont)xwb.CreateFont();
                            ccol = new XSSFColor(Color.FromArgb(BackRgb[0], BackRgb[1], BackRgb[2]));
                            cstl.SetFillForegroundColor(ccol);
                            cstl.FillPattern = FillPattern.SolidForeground;
                            if (bRightBorder) cstl.BorderRight = BorderStyle.DashDot;
                            ccol = new XSSFColor(Color.FromArgb(FrontRgb[0], FrontRgb[1], FrontRgb[2]));
                            cfnt.SetColor(ccol);
                            cfnt.FontHeightInPoints = (short)(!Soar ? 12 : 11);
                            cstl.SetFont(cfnt);
                            if (!Soar) cstl.Alignment = HorizontalAlignment.Center;

                            xcc.CellStyle = cstl;

                            xs.AutoSizeColumn(xcc.ColumnIndex);
                        }

                        int val = int.MinValue;
                        bool bVal = int.TryParse(RowData.InnerHtml, out val);
                        if (bVal) {
                            xcc.SetCellType(CellType.Numeric);
                            xcc.SetCellValue(Convert.ToInt32(RowData.InnerHtml));
                        }
                        else{
                            xcc.SetCellValue(RowData.InnerHtml.ToUpper());
                        }

                    }
                }
            }


            FileStream File = new FileStream(Path.Combine(AppDomain.CurrentDomain.BaseDirectory, "Temp", token + ".xlsx"), FileMode.Create, FileAccess.Write);
            xwb.Write(File);
            File.Close();

            return token;
        }
    }
}
