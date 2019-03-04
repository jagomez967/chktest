using Reporting.Domain.Abstract;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.Mvc;
using Reporting.ViewModels;
using System.Data;
using Reporting.Domain.Entities;

namespace Reporting.Controllers
{
    public class ForecastingController : BaseController
    {
        private int IdModulo;
        public ForecastingController(ITableroRepository tableroRepository, IUsuarioRepository usuarioRepository, IClienteRepository clienteRepository, IFiltroRepository filtroRepository, ICommonRepository commonRepository, IDatosRepository datosRepository)
        {
            this.IdModulo = 8;
            this.tableroRepository = tableroRepository;
            this.usuarioRepository = usuarioRepository;
            this.clienteRepository = clienteRepository;
            this.filtroRepository = filtroRepository;
            this.commonRepository = commonRepository;
            this.datosRepository = datosRepository;
        }

        public ActionResult SalesInOut()
        {
            int IdCliente = GetClienteSeleccionado();
            int userid = GetUsuarioLogueado();
            userid = usuarioRepository.GetUsuarioPerformance(userid);

            var model = new SalesInOutViewModel();

            DateTime now = new DateTime(DateTime.Now.Year, DateTime.Now.Month, 1);

            int diff = 0;

            if ((now.Month >= 9 && now.Month <= 12) || (now.Month >= 1 && now.Month <= 3))
            {
                DateTime marchTest = new DateTime(now.AddYears(1).Year, 3, 31);
                diff = Convert.ToInt32(Math.Floor((marchTest - now).TotalDays / 30)) - ((now.Month >= 9 && now.Month <= 12) ? 0 : 12);
            }

            model.ShowFuture = (diff != 0 ? true : false);

            model.Canales = clienteRepository.GetTiposDeCadena(IdCliente, userid).Select(c => new SelectListItem() { Text = c.Nombre, Value = c.IdTipoCadena.ToString() }).ToList();

            if (model.Canales.Count == 0)
            {
                return View("PsiSinCanal");
            }

            var cadenas = clienteRepository.GetCadenas(IdCliente, userid).OrderBy(c => c.Nombre).ToList();
            var canalgrupos = new List<SelectListGroup>();
            if (cadenas != null)
            {
                foreach (var c in cadenas.Select(cad => new { cad.TipoCadena.Nombre, cad.TipoCadena.IdTipoCadena }).Distinct())
                {
                    canalgrupos.Add(new SelectListGroup() { Name = c.Nombre });
                }
            }

            foreach (var p in cadenas)
            {
                var g = canalgrupos.FirstOrDefault(gr => gr.Name == p.TipoCadena.Nombre);
                model.Cadenas.Add(new SelectListItem() { Value = p.IdCadena.ToString(), Text = p.Nombre, Group = g });
            }

            model.Categorias = clienteRepository.GetFamilias(IdCliente).Where(f => (f.Grupo == "CISS" || f.Grupo == "IC") && f.IdMarca != 2905).Select(f => new SelectListItem() { Text = f.Nombre, Value = f.IdFamilia.ToString() }).ToList();

            var productos = clienteRepository.GetProductos(IdCliente, "EPSON").Where(p => p.IdMarca != 2905 ).ToList();
            //Esto es provisorio hasta agregar un flag de ActivoCap
            List<int> Excluidos = new List<int> { 19651, 19658, 19652, 19015, 19027, 12522, 19030, 19031 };
            productos = productos.Where(p => !Excluidos.Contains(p.IdProducto)).ToList();

            foreach(Producto p in productos)
            {
                p.CurrentChannelInv = clienteRepository.GetCurrentChannelInv(p.IdProducto);
            }
            productos = productos.OrderByDescending(p => p.CurrentChannelInv).ToList();

            for (int i = 0; i < productos.Count; i++)
            {
                model.Productos.Add(new SelectListProduct() { Value = productos[i].IdProducto.ToString(), Text = productos[i].Nombre, HasInv = (productos[i].CurrentChannelInv==0?false:true)});
            }

            return View(model);
        }

        private SalesInFormsVM GetDatosFC(string[] lstCanales, string[] lstCadenas, string[] lstCategorias, string[] lstProductos, bool includeTotalRevenue)
        {
            int idCanal = 0;
            int IdCadena = 0;
            int IdCategoria = 0;
            int IdProducto = 0;

            if (lstCanales != null && lstCanales.Count() == 1) idCanal = int.Parse(lstCanales.First());
            if (lstCadenas != null && lstCadenas.Count() == 1) IdCadena = int.Parse(lstCadenas.First());
            if (lstCategorias != null && lstCategorias.Count() == 1) IdCategoria = int.Parse(lstCategorias.First());
            if (lstProductos != null && lstProductos.Count() == 1) IdProducto = int.Parse(lstProductos.First());

            DateTime now = new DateTime(DateTime.Now.Year, DateTime.Now.Month, 1);

            List<DateTime> lastTwelveMonths = Enumerable
               .Range(0, 12)
               .Select(i => now.AddMonths(i - 12)).ToList();

            int diff = 0;
            if ((now.Month >= 9 && now.Month <= 12) || (now.Month >= 1 && now.Month <= 3))
            {
                DateTime marchTest = new DateTime(now.AddYears(1).Year, 3, 31);
                diff = Convert.ToInt32(Math.Floor((marchTest - now).TotalDays / 30)) - ((now.Month >= 9 && now.Month <= 12) ? 0 : 12);
            }

            List<DateTime> nextTwelveMonths = Enumerable
                .Range(0, 12 + diff)
                .Select(i => now.AddMonths(i)).ToList();

            var meses = lastTwelveMonths.Union(nextTwelveMonths).ToList();
            var indicadoresmeses = clienteRepository.GetIndicadoresMesesForecasting();

            int clienteid = GetClienteSeleccionado();
            int userid = GetUsuarioLogueado();
            userid = usuarioRepository.GetUsuarioPerformance(userid);

            double currusd = clienteRepository.GetCurrencyExchangeForecasting(clienteid, DateTime.Now, "USD");
            if (currusd == 0)
            {
                currusd = 1;
            }

            var fc = clienteRepository.GetForecasting(clienteid, lstCanales, lstCadenas, lstCategorias, lstProductos, userid);
            var precios = clienteRepository.GetWholeSalePrices(clienteid, lstCanales, lstCadenas, lstCategorias, lstProductos);

            var model = new SalesInFormsVM();
            model.ShowFuture = (diff != 0 ? true : false);

            //hasta aca tengo todos los datos para trabajar
            //Tengo que armar un formulario por producto y luego un formulario para Revenue
            if (fc != null && fc.Tables != null && fc.Tables.Count == 2 && fc.Tables[0].Rows.Count > 0)
            {
                var listPrecios = new List<EpsonPrices>();
                if (precios != null && precios.Tables != null && precios.Tables.Count > 0)
                {
                    var dt = precios.Tables[0];
                    foreach (DataRow r in dt.Rows)
                    {
                        listPrecios.Add(new EpsonPrices()
                        {
                            Canal = r["Canal"].ToString(),
                            IdCadena = int.Parse(r["IdCadena"].ToString()),
                            IdProducto = int.Parse(r["IdProducto"].ToString()),
                            Fecha = DateTime.Parse(r["Fecha"].ToString()),
                            Precio = double.Parse(r["Precio"].ToString()),
                            Currency = r["Currency"].ToString()
                        });
                    }
                }

                var dtproductos = fc.Tables[0];
                var dtforecasting = fc.Tables[1];

                var listfc = new List<SalesInOutDataViewModel>();
                foreach (DataRow dr in dtforecasting.Rows)
                {
                    listfc.Add(new SalesInOutDataViewModel()
                    {
                        Fecha = DateTime.Parse(dr["Fecha"].ToString()),
                        Id = int.Parse(dr["Id"].ToString()),
                        WholeSalePrice = double.Parse(dr["WholeSalePrice"].ToString()),
                        Revenue = double.Parse(dr["WholeSalePrice"].ToString()) * int.Parse(dr["SalesIn"].ToString()),
                        IdCanal = int.Parse(dr["IdCanal"].ToString()),
                        IdCadena = int.Parse(dr["IdCadena"].ToString()),
                        IdProducto = int.Parse(dr["IdProducto"].ToString()),
                        POSellIn = int.Parse(dr["PlanOriginalSellIn"].ToString()),
                        POSellOut = int.Parse(dr["PlanOriginalSellOut"].ToString()),
                        PVSellIn = int.Parse(dr["PlanVendedorSellIn"].ToString()),
                        PVSellOut = int.Parse(dr["PlanVendedorSellOut"].ToString()),
                        SalesIn = int.Parse(dr["SalesIn"].ToString()),
                        SalesOut = int.Parse(dr["SalesOut"].ToString()),
                        StockInicial = int.Parse(dr["StockInicial"].ToString()),
                        IdCategoria = int.Parse(dr["IdCategoria"].ToString()),
                        Categoria = dr["Categoria"].ToString(),
                        Canal = dr["Canal"].ToString(),
                        ChannelInv = int.Parse(dr["ChannelInv"].ToString()),
                        DOCI = int.Parse(dr["Doci"].ToString()),
                        SORR = double.Parse(dr["Sorr"].ToString()),
                        YoY = 0.0,
                        POVarSellIn = int.Parse(dr["SalesIn"].ToString()) - int.Parse(dr["PlanOriginalSellIn"].ToString()),
                        POVarSellOut = int.Parse(dr["SalesOut"].ToString()) - int.Parse(dr["PlanOriginalSellOut"].ToString()),
                        PVVarSellIn = int.Parse(dr["SalesIn"].ToString()) - int.Parse(dr["PlanVendedorSellIn"].ToString()),
                        PVVarSellOut = int.Parse(dr["SalesOut"].ToString()) - int.Parse(dr["PlanVendedorSellOut"].ToString()),
                        CanalIdentificador = dr["CanalIdentificador"].ToString(),
                        LimiteDoci = int.Parse(dr["LimiteDoci"].ToString())
                    });
                }


                /*********************************************************************************************************************
                 * Transformo las monedas a dolar o peso dependiendo si selecciono mas de un canal o no.
                 * Mas de 1 canal => Todo en dolares (paso Retail a dolares)
                 * 1 solo canal:
                 *      RETAIL: Pesos
                 *      DISTRIBUCION: Dolares
                /* *******************************************************************************************************************/

                //REVISTAR ESTO, Todo el codigo asumia que solo habia dos canales y Chile cago todo

                /*
                var canalesfc = listfc.Select(f => new { f.IdCanal, f.CanalIdentificador }).Distinct();
                string currency = "LC";
                if (canalesfc.Count() > 1)
                {
                    IdCanal = 0;
                    foreach (var f in listfc.Where(f => f.CanalIdentificador == "RET"))
                    {
                        f.Revenue = f.Revenue / currusd;
                        f.WholeSalePrice = f.WholeSalePrice / currusd;
                    }
                    currency = "USD";
                }
                else
                {
                    var cff = canalesfc.FirstOrDefault();
                    if (cff != null)
                    {
                        IdCanal = cff.IdCanal;

                        if (cff.CanalIdentificador.ToUpper() == "RET")
                        {
                            currency = "LC";
                        }
                        else
                        {
                            currency = "USD";
                        }
                    }
                    else
                    {
                        IdCanal = 0;
                    }
                }
                */

                var listprods = new List<SalesInOutFormViewModel>();
                foreach (DataRow dr in dtproductos.Rows)
                {
                    listprods.Add(new SalesInOutFormViewModel()
                    {
                        IdProducto = int.Parse(dr["IdProducto"].ToString()),
                        Producto = dr["Producto"].ToString(),
                        IdExterno = dr["IdExterno"].ToString(),
                        IdCadena = IdCadena,
                        IdCategoria = int.Parse(dr["IdCategoria"].ToString()),
                        Categoria = dr["Categoria"].ToString(),
                        Confirmado = IdCadena == 0 || dr["Confirmado"].ToString() != "0" || string.IsNullOrEmpty(dr["Confirmado"].ToString()),
                        Meses = meses,
                        Indicadores = indicadoresmeses.Select(i => new IndicadorMesFC() { Indicador = i.Indicador, Mes = i.Mes }).ToList(),
                        //Currency = currency,
                        IdCanal = 0
                    });
                }

                //por cada producto armo los datos de meses
                foreach (var prod in listprods)
                {
                    var mesesdefault = new List<SalesInOutDataViewModel>();
                    foreach (var month in meses)
                    {
                        /*
                         * Si hay datos de mas de un canal entonces precio siempre va a ser null por IdCadena. 
                         */
                        var precio = listPrecios.FirstOrDefault(p => p.Fecha.Year == month.Year && p.Fecha.Month == month.Month && p.IdProducto == prod.IdProducto && p.IdCadena == IdCadena);

                        mesesdefault.Add(new SalesInOutDataViewModel()
                        {
                            Fecha = month,
                            Id = 0,
                            WholeSalePrice = precio != null ? precio.Precio : 0,
                            Revenue = 0,
                            IdCadena = IdCadena,
                            IdProducto = prod.IdProducto,
                            POSellIn = 0,
                            POSellOut = 0,
                            PVSellIn = 0,
                            PVSellOut = 0,
                            SalesIn = 0,
                            SalesOut = 0,
                            StockInicial = 0,
                            ChannelInv = 0,
                            DOCI = 0,
                            SORR = 0,
                            YoY = 0,
                            POVarSellIn = 0,
                            PVVarSellIn = 0,
                            PVVarSellOut = 0,
                            POVarSellOut = 0,
                            //IdCanal = IdCanal,
                            Canal = string.Empty,
                            Categoria = string.Empty
                        });
                    }

                    foreach (var datfc in listfc.Where(f => f.IdProducto == prod.IdProducto))
                    {
                        var defm = mesesdefault.FirstOrDefault(m => m.Fecha.Year == datfc.Fecha.Year && m.Fecha.Month == datfc.Fecha.Month);
                        if (defm != null)//aca si defm es null es porque en los datos de GetForecasting vino algun mes que se pasa de los 24a mostrar, por lo tanto no lo tomo en cuenta.
                        {
                            SalesInOutDataViewModel lastYear = mesesdefault.FirstOrDefault(m => m.Fecha.Year == defm.Fecha.AddYears(-1).Year && m.Fecha.Month == defm.Fecha.AddYears(-1).Month);
                            int lastYearSalesOut = lastYear != null ? lastYear.SalesOut : 0;

                            defm.Revenue += datfc.Revenue;
                            if (datfc.WholeSalePrice != 0) defm.WholeSalePrice = datfc.WholeSalePrice;
                            defm.POSellIn += datfc.POSellIn;
                            defm.POSellOut += datfc.POSellOut;
                            defm.POVarSellIn += datfc.POVarSellIn;
                            defm.POVarSellOut += datfc.POVarSellOut;
                            defm.PVSellIn += datfc.PVSellIn;
                            defm.PVSellOut += datfc.PVSellOut;
                            defm.PVVarSellIn += datfc.PVVarSellIn;
                            defm.PVVarSellOut += datfc.PVVarSellOut;
                            defm.SalesIn += datfc.SalesIn;
                            defm.SalesOut += datfc.SalesOut;
                            defm.StockInicial += datfc.StockInicial;
                            defm.ChannelInv += datfc.ChannelInv;
                            defm.SORR += datfc.SORR;
                            defm.YoY = lastYearSalesOut != 0 ? ((Convert.ToDouble(defm.SalesOut) / Convert.ToDouble(lastYearSalesOut)) - 1.0) * 100.0 : 0;
                            defm.DOCI += datfc.DOCI;
                            defm.LimiteDoci = datfc.LimiteDoci;
                        }
                    }

                    if (mesesdefault != null)
                    {
                        foreach (var mes in mesesdefault.Where(mo => (mo.Fecha.Year == DateTime.Now.Year && mo.Fecha.Month >= DateTime.Now.Month) || (mo.Fecha.Year > DateTime.Now.Year)))
                        {
                            var indicadormes = indicadoresmeses.First(mo => mo.Mes == mes.Fecha.Month);
                            var i = mesesdefault.IndexOf(mes);
                            mes.ChannelInv = mesesdefault.ElementAt(i - 1).ChannelInv + mes.SalesIn - mes.SalesOut;
                            mes.SORR = (mes.SalesOut != 0 ? (double)mes.SalesOut : 0) / indicadormes.Indicador;
                            var mesesdoci = mesesdefault.Where(mo => (mo.Fecha == mes.Fecha) || (mo.Fecha == mes.Fecha.AddMonths(1)));
                            var avgSalesOut = 0;
                            foreach(var a in mesesdoci)
                            {
                                avgSalesOut += a.SalesOut;
                            }
                            avgSalesOut /= 2;
                            mes.DOCI = (int)(Math.Round(avgSalesOut == 0 ? 0 : ((mes.ChannelInv != 0 ? (double)mes.ChannelInv : 0) / avgSalesOut) * 30.416));
                            mes.POVarSellIn = mes.SalesIn - mes.POSellIn;
                            mes.POVarSellOut = mes.SalesOut - mes.POSellOut;
                            mes.PVVarSellIn = mes.SalesIn - mes.PVSellIn;
                            mes.PVVarSellOut = mes.SalesOut - mes.PVSellOut;
                        }
                    }

                    prod.SalesInOut = mesesdefault;
                }

                listprods.ForEach(f => f.Orden = string.Format("[{0}/{1}]", listprods.IndexOf(f) + 1, listprods.Count()));

                if (includeTotalRevenue)
                {
                    // A PEDIDO DE MARIANO/FERNANDO DESACTIVO MOMENTANEAMENTE TODO LO QUE TENGA QUE VER CON FACTURACION
                    //REVENUE
                    var revenue = new RevenueTotal()
                    {
                        Meses = meses,
                        Indicadores = indicadoresmeses.Select(i => new IndicadorMesFC() { Indicador = i.Indicador, Mes = i.Mes }).ToList()
                        //Titulo = string.Format("{0} {1}", Reporting.Resources.Forecasting.revenue_total, currency),
                        //Currency = currency
                    };

                    var total = new RevenueRow()
                    {
                        IdCanal = 0,
                        OrdenFila = 0,
                        Nombre = string.Format("{0} {1}", Reporting.Resources.Forecasting.facturacion, Reporting.Resources.Forecasting.total) 
                    };

                    foreach (var f in listfc)
                    {
                        var revtot = total.Meses.FirstOrDefault(m => m.Fecha.Year == f.Fecha.Year && m.Fecha.Month == f.Fecha.Month);
                        if (revtot != null)
                        {
                            revtot.Valor += f.Revenue;
                            revtot.SalesIn += f.SalesIn;
                            revtot.SalesOut += f.SalesOut;
                        }
                        else
                        {
                            total.Meses.Add(new RevenueMes()
                            {
                                Fecha = f.Fecha,
                                Valor = f.Revenue,
                                SalesIn = f.SalesIn,
                                SalesOut = f.SalesOut
                            });
                        }

                        //Para separar los totales por canal se usaba asi en revenue:
                        //var revcanal = revenue.Rows.FirstOrDefault(r => r.IdCanal == f.IdCanal);

                        var revcanal = revenue.Rows.FirstOrDefault();
                        if (revcanal != null)
                        {
                            var revmes = revcanal.Meses.FirstOrDefault(m => m.Fecha.Year == f.Fecha.Year && m.Fecha.Month == f.Fecha.Month);
                            if (revmes != null)
                            {
                                revmes.Valor += f.Revenue;
                                revmes.SalesIn += f.SalesIn;
                                revmes.SalesOut += f.SalesOut;
                            }
                            else
                            {
                                revcanal.Meses.Add(new RevenueMes()
                                {
                                    Fecha = f.Fecha,
                                    Valor = f.Revenue,
                                    SalesIn = f.SalesIn,
                                    SalesOut = f.SalesOut
                                });
                            }
                        }
                        else
                        {
                            revenue.Rows.Add(new RevenueRow()
                            {
                                IdCanal = f.IdCanal,
                                Nombre = string.Format("{0} {1}", Reporting.Resources.Forecasting.facturacion, f.CanalIdentificador),
                                OrdenFila = 1,
                                Meses = new List<RevenueMes>{
                                        new RevenueMes(){
                                            Fecha=f.Fecha,
                                            Valor=f.Revenue,
                                            SalesIn = f.SalesIn,
                                            SalesOut = f.SalesOut
                                        }
                                    }
                            });
                        }
                    }

                    if (revenue.Rows.Count != 1)
                    {
                        revenue.Rows.Insert(0, total);
                    }

                    model.Revenue = revenue;
                    

                    // TOTALES
                    // Por cada canal creo un total, por ultimo agrego uno mas que es la suma de todos los subtotales y le pongo el titulo que corresponda.
                    var canales = listfc.Select(f => new { f.IdCanal, f.Canal }).Distinct();
                    if (canales != null && canales.Count() > 1)
                    {
                        foreach (var c in canales)
                        {
                            var newtot = new SalesInOutFormViewModel()
                            {
                                Canal = c.Canal,
                                Confirmado = true,
                                IdCanal = c.IdCanal,
                                IdProducto = 0,
                                Meses = meses,
                                Indicadores = indicadoresmeses.Select(i => new IndicadorMesFC() { Indicador = i.Indicador, Mes = i.Mes }).ToList(),
                                IsTotal = true,
                                Orden = "TTL",
                                Producto = c.Canal,
                                //Currency = currency
                            };

                            model.Totales.Add(newtot);
                        }
                    }

                    var categorias = listfc.Select(f => new { f.IdCategoria, f.Categoria }).Distinct();
                    if (categorias != null && categorias.Count() > 1)
                    {
                        foreach (var c in categorias)
                        {
                            var newtot = new SalesInOutFormViewModel()
                            {
                                Canal = string.Empty,
                                Confirmado = true,
                                IdCanal = 0,
                                IdProducto = 0,
                                Meses = meses,
                                Indicadores = indicadoresmeses.Select(i => new IndicadorMesFC() { Indicador = i.Indicador, Mes = i.Mes }).ToList(),
                                IsTotal = true,
                                Orden = "TTL",
                                Producto = c.Categoria,
                                //Currency = currency,
                                IdCategoria = c.IdCategoria,
                                Categoria = c.Categoria
                            };

                            model.Totales.Add(newtot);
                        }
                    }

                    string titulott = string.Empty;

                    if (lstCanales == null) lstCanales = new string[] { };

                    if (lstCanales.Count() == 0)
                    {
                        var cliente = clienteRepository.GetCliente(clienteid);
                        titulott = cliente.Nombre;
                    }
                    else if (IdCadena == 0)
                    {
                        titulott = Reporting.Resources.Forecasting.varios;
                    }
                    else
                    {
                        var cadena = clienteRepository.GetCadena(IdCadena);
                        if (cadena != null)
                        {
                            titulott = cadena.Nombre;
                        }
                    }

                    var totalgeneral = new SalesInOutFormViewModel()
                    {
                        Canal = titulott,//Aca va el titulo que tiene que cambiar de leyenda dependiendo lo que selecciono el usuario
                        Confirmado = true,
                        IdCanal = 0,
                        IdProducto = 0,
                        Meses = meses,
                        Indicadores = indicadoresmeses.Select(i => new IndicadorMesFC() { Indicador = i.Indicador, Mes = i.Mes }).ToList(),
                        IsTotal = true,
                        Orden = "TTL",
                        Producto = titulott,
                        //Currency = currency,
                        IdCadena = 0,
                        IdCategoria = 0
                    };

                    model.Totales.Insert(0, totalgeneral);

                    //Por cada Total generado tengo que realizar la carga de datos en 0 y luego sumar lo que corresponda dentro de listfc
                    foreach (var t in model.Totales)
                    {
                        foreach (var m in t.Meses)
                        {
                            t.SalesInOut.Add(new SalesInOutDataViewModel()
                            {
                                Fecha = m,
                                Id = 0,
                                WholeSalePrice = 0,
                                Revenue = 0,
                                IdCadena = 0,
                                IdProducto = 0,
                                POSellIn = 0,
                                POSellOut = 0,
                                PVSellIn = 0,
                                PVSellOut = 0,
                                SalesIn = 0,
                                SalesOut = 0,
                                StockInicial = 0,
                                ChannelInv = 0,
                                DOCI = 0,
                                SORR = 0,
                                YoY = 0,
                                POVarSellIn = 0,
                                PVVarSellIn = 0,
                                PVVarSellOut = 0,
                                POVarSellOut = 0,
                                IdCanal = t.IdCanal,
                                Canal = t.Canal,
                                Categoria = t.Categoria,
                                IdCategoria = t.IdCategoria
                            });
                        }

                        foreach (var f in listfc)
                        {
                            if ((t.IdCanal == 0 && t.IdCategoria == 0)|| (t.IdCanal == 0 && t.IdCategoria > 0 && t.IdCategoria == f.IdCategoria)|| (t.IdCanal > 0 && t.IdCategoria == 0 && t.IdCanal == f.IdCanal))
                            {
                                var monthint = t.SalesInOut.FirstOrDefault(tt => tt.Fecha.Year == f.Fecha.Year && tt.Fecha.Month == f.Fecha.Month);
                                var prevmonthint = t.SalesInOut.FirstOrDefault(tt => tt.Fecha == f.Fecha.AddMonths(-1));
                                if (monthint != null)
                                {
                                    monthint.POSellIn += f.POSellIn;
                                    monthint.POSellOut += f.POSellOut;
                                    monthint.POVarSellIn += f.POVarSellIn;
                                    monthint.POVarSellOut += f.POVarSellOut;
                                    monthint.PVSellIn += f.PVSellIn;
                                    monthint.PVSellOut += f.PVSellOut;
                                    monthint.PVVarSellIn += f.PVVarSellIn;
                                    monthint.PVVarSellOut += f.PVVarSellOut;
                                    monthint.Revenue += f.Revenue;
                                    monthint.SalesIn += f.SalesIn;
                                    monthint.SalesOut += f.SalesOut;
                                    monthint.SORR += f.SORR;
                                    monthint.YoY += f.YoY;
                                    monthint.ChannelInv += f.ChannelInv;
                                    monthint.DOCI += f.DOCI;
                                }
                            }
                        }

                        
                        if (t.SalesInOut.Count() != 0)
                        {
                            //Parche para presentacion de EPSON (Febrero 2019)
                            //Esto deberia irse cuando EPSON decida/defina que quieren hacer con el ChannelInv.
                            for (int i = 0; i < t.SalesInOut.Count(); i++)
                            {
                                List<SalesInOutDataViewModel> mesesInv = t.SalesInOut.Where(mo => (mo.Fecha == t.SalesInOut.ElementAt(i).Fecha) || (mo.Fecha == t.SalesInOut.ElementAt(i).Fecha.AddMonths(-1))).ToList();
                                if (mesesInv.Count() == 2)
                                {
                                    SalesInOutDataViewModel monthint = mesesInv.ElementAt(1) == null ? null : mesesInv.ElementAt(1);
                                    SalesInOutDataViewModel prevmonthint = mesesInv.ElementAt(0) == null ? null : mesesInv.ElementAt(0);
                                    int Inv = prevmonthint.ChannelInv + monthint.SalesIn - monthint.SalesOut;
                                    t.SalesInOut.ElementAt(i).ChannelInv = Inv;
                                }
                            }

                            for (int i = 0; i < t.SalesInOut.Count(); i++)
                            {
                                List<SalesInOutDataViewModel> mesesdoci = t.SalesInOut.Where(mo => (mo.Fecha == t.SalesInOut.ElementAt(i).Fecha) || (mo.Fecha == t.SalesInOut.ElementAt(i).Fecha.AddMonths(1))).ToList();
                                if (mesesdoci.Count() == 2)
                                {
                                    var avgSalesOut = 0;
                                    foreach (var a in mesesdoci)
                                    {
                                        avgSalesOut += a.SalesOut;
                                    }
                                    avgSalesOut /= 2;
                                    t.SalesInOut.ElementAt(i).DOCI = (int)(Math.Round(avgSalesOut == 0 ? 0 : ((t.SalesInOut.ElementAt(i).ChannelInv != 0 ? (double)t.SalesInOut.ElementAt(i).ChannelInv : 0) / avgSalesOut) * 30.416));
                                }
                            }
                            //FIN Parche para presentacion de EPSON (Febrero 2019)

                            //Yoy Totales
                            for (int i = 0; i < t.SalesInOut.Count(); i++)
                            {
                                SalesInOutDataViewModel lastYear = t.SalesInOut.FirstOrDefault(m => m.Fecha.Year == t.SalesInOut.ElementAt(i).Fecha.AddYears(-1).Year && m.Fecha.Month == t.SalesInOut.ElementAt(i).Fecha.AddYears(-1).Month);
                                int lastYearSalesOut = lastYear != null ? lastYear.SalesOut : 0;
                                t.SalesInOut.ElementAt(i).YoY = lastYearSalesOut != 0 ? ((Convert.ToDouble(t.SalesInOut.ElementAt(i).SalesOut) / Convert.ToDouble(lastYearSalesOut)) - 1.0) * 100.0 : 0;
                            }
                        }
                        

                        List<SalesInOutDataViewModel> mesesdefault = t.SalesInOut.Where(mo => (mo.Fecha.Year == DateTime.Now.Year && mo.Fecha.Month >= DateTime.Now.Month) || (mo.Fecha.Year > DateTime.Now.Year)).ToList();

                        foreach (var mes in mesesdefault)
                        {
                            var indicadormes = indicadoresmeses.First(mo => mo.Mes == mes.Fecha.Month);
                            mes.SORR = (mes.SalesOut != 0 ? (double)mes.SalesOut : 0) / indicadormes.Indicador;
                            /*
                            var mesesdoci = mesesdefault.Where(mo => (mo.Fecha == mes.Fecha) || (mo.Fecha == mes.Fecha.AddMonths(1)));
                            var avgSalesOut = 0;
                            foreach (var a in mesesdoci)
                            {
                                avgSalesOut += a.SalesOut;
                            }
                            avgSalesOut /= 2;
                            mes.DOCI = (int)(Math.Round(avgSalesOut == 0 ? 0 : ((mes.ChannelInv != 0 ? (double)mes.ChannelInv : 0) / avgSalesOut) * 30.416));
                            */
                        }
                    }
                }

                model.Forms = listprods;
                return model;
            }
            else
            {
                return new SalesInFormsVM();
            }
        }

        [HttpPost]
        public PartialViewResult GetForecastingForms(string[] lstCanales, string[] lstCadenas, string[] lstCategorias, string[] lstProductos)
        {

            var model = GetDatosFC(lstCanales, lstCadenas, lstCategorias, lstProductos, true);

            if (model != null && model.Forms.Count > 0)
                return PartialView("_ListSalesInOut", model);
            else
                return null;
        }

        [HttpPost]
        public JsonResult GetProductosFC(int[] lstCategorias)
        {
            int IdCliente = GetClienteSeleccionado();
            List<SelectListProduct> list = new List<SelectListProduct>();
            List<Producto> productos = new List<Producto>();
            if(lstCategorias != null) { 
                if (lstCategorias.Count() > 0)
                {
                    productos = clienteRepository.GetProductos(IdCliente, lstCategorias, "EPSON").ToList();//.Select(p => new SelectListItem() { Value = p.IdProducto.ToString(), Text = p.Nombre }).OrderBy(i => i.Text).ToList();
                }
                else
                {
                    productos = clienteRepository.GetProductos(IdCliente, "EPSON").ToList();//.Select(p => new SelectListItem() { Value = p.IdProducto.ToString(), Text = p.Nombre }).OrderBy(i => i.Text).ToList();
                }
            }
            else
            {
                productos = clienteRepository.GetProductos(IdCliente, "EPSON").ToList();//.Select(p => new SelectListItem() { Value = p.IdProducto.ToString(), Text = p.Nombre }).OrderBy(i => i.Text).ToList();
            }

            //Esto es provisorio hasta agregar un flag de ActivoCap
            List<int> Excluidos = new List<int> { 19651, 19658, 19652, 19015, 19027, 12522, 19030, 19031 };
            productos = productos.Where(p => !Excluidos.Contains(p.IdProducto)).ToList();

            foreach (Producto p in productos)
            {
                p.CurrentChannelInv = clienteRepository.GetCurrentChannelInv(p.IdProducto);
            }
            productos = productos.OrderByDescending(p => p.CurrentChannelInv).ToList();

            for (int i = 0; i < productos.Count; i++)
            {
                list.Add(new SelectListProduct() { Value = productos[i].IdProducto.ToString(), Text = productos[i].Nombre.ToUpper().Replace("EPSON ",""), HasInv = (productos[i].CurrentChannelInv == 0 ? false : true) });
            }

            return Json(list, JsonRequestBehavior.AllowGet);
        }

        [HttpPost]
        public JsonResult GetCuentasFC(string[] Canales)
        {
            int IdCliente = GetClienteSeleccionado();
            int userid = GetUsuarioLogueado();
            userid = usuarioRepository.GetUsuarioPerformance(userid);

            List<SelectListItem> cuentas = new List<SelectListItem>();

            if (Canales.Length != 0)
            {
                foreach(string Canal in Canales)
                {
                    cuentas.AddRange(clienteRepository.GetCadenas(IdCliente, Convert.ToInt32(Canal), userid).Select(p => new SelectListItem() { Value = p.IdCadena.ToString(), Text = p.Nombre.ToUpper() }).OrderBy(i => i.Text).ToList());
                }
            }

            return Json(cuentas, JsonRequestBehavior.AllowGet);
        }

        [HttpPost]
        public JsonResult GuardarForecastingform(SalesInOutFormViewModel model)
        {
            int clienteid = GetClienteSeleccionado();
            int userid = GetUsuarioLogueado();
            userid = usuarioRepository.GetUsuarioPerformance(userid);

            if (model.SalesInOut.Any(d => d.ChannelInv < 0 && !((d.Fecha.Month < DateTime.Now.Month && d.Fecha.Year == DateTime.Now.Year) || d.Fecha.Year < DateTime.Now.Year)))
            {
                return Json("false", JsonRequestBehavior.AllowGet);
            }

            DataTable datos = new DataTable();
            datos.Columns.Add(new DataColumn("Fecha", typeof(DateTime)));
            datos.Columns.Add(new DataColumn("SalesIn", typeof(int)));
            datos.Columns.Add(new DataColumn("SalesOut", typeof(int)));
            datos.Columns.Add(new DataColumn("ChannelInv", typeof(int)));
            datos.Columns.Add(new DataColumn("StockInicial", typeof(int)));
            datos.Columns.Add(new DataColumn("Doci", typeof(int)));
            datos.Columns.Add(new DataColumn("Sorr", typeof(double)));

            var listfc = model.SalesInOut.Where(f => (f.Fecha.Month >= DateTime.Now.Month && f.Fecha.Year == DateTime.Now.Year) || f.Fecha.Year > DateTime.Now.Year || (f.Fecha.Year == DateTime.Now.Year && f.Fecha.Month == DateTime.Now.AddMonths(-1).Month));

            if (model.SalesInOut != null && model.SalesInOut.Count > 0)
            {
                foreach (var s in listfc)
                {
                    DataRow newRow = datos.NewRow();
                    newRow[0] = new DateTime(s.Fecha.Year, s.Fecha.Month, 1);
                    newRow[1] = s.SalesIn;
                    newRow[2] = s.SalesOut;
                    newRow[3] = s.ChannelInv;
                    newRow[4] = s.StockInicial;
                    newRow[5] = s.DOCI;
                    newRow[6] = s.SORR;

                    datos.Rows.Add(newRow);
                }
            }

            var StockInicial = model.SalesInOut.First().StockInicial;
            var FechaStockInicial = model.SalesInOut.First().Fecha;
            clienteRepository.GuardarForecasting(clienteid, userid, model.IdCadena, model.IdProducto, FechaStockInicial, StockInicial, datos, true);

            return Json("true", JsonRequestBehavior.AllowGet);
        }

        public ActionResult Confirmados()
        {
            int clienteid = GetClienteSeleccionado();
            int userid = GetUsuarioLogueado();
            userid = usuarioRepository.GetUsuarioPerformance(userid);

            List<ForcesatingConfirmadosViewModel> model = new List<ForcesatingConfirmadosViewModel>();

            DataSet ds = clienteRepository.GetForecastingConfirmados(clienteid);
            if (ds != null && ds.Tables != null && ds.Tables.Count > 0)
            {
                var dt = ds.Tables[0];

                foreach (DataRow r in dt.Rows)
                {
                    var idcanal = int.Parse(r["IdCanal"].ToString());
                    var canal = r["Canal"].ToString();
                    var idcadena = int.Parse(r["IdCadena"].ToString());
                    var cadena = r["Cadena"].ToString();
                    var s_idusuario = r["IdUsuario"].ToString();
                    var apellido = r["Apellido"].ToString();
                    var nombre = r["Nombre"].ToString();
                    var s_fecha = r["Fecha"].ToString();
                    int? idusuario = null;
                    DateTime? fecha = null;

                    if (!string.IsNullOrEmpty(s_idusuario))
                        idusuario = int.Parse(s_idusuario);

                    if (!string.IsNullOrEmpty(s_fecha))
                        fecha = DateTime.Parse(s_fecha);

                    var item = model.FirstOrDefault(m => m.IdCanal == idcanal);
                    if (item != null)
                    {
                        item.Items.Add(new ForecastingConfirmadosItemViewModel()
                        {
                            Apellido = apellido,
                            Nombre = nombre,
                            Cadena = cadena,
                            Fecha = fecha,
                            IdCadena = idcadena,
                            IdUsuario = idusuario
                        });
                    }
                    else
                    {
                        model.Add(new ForcesatingConfirmadosViewModel()
                        {
                            IdCanal = idcanal,
                            Canal = canal,
                            Items = new List<ForecastingConfirmadosItemViewModel>() {
                                   new ForecastingConfirmadosItemViewModel(){
                                        Apellido = apellido,
                                        Nombre = nombre,
                                        Cadena = cadena,
                                        Fecha = fecha,
                                        IdCadena = idcadena,
                                        IdUsuario = idusuario
                                   }
                               }
                        });
                    }
                }
            }

            return View(model);
        }

        [HttpPost]
        public PartialViewResult GetFcHistory(int idcadena)
        {
            int idcliente = GetClienteSeleccionado();
            var fcstatus = clienteRepository.GetForecastingStatus(idcliente, idcadena);
            var fchistory = clienteRepository.GetForecastingHistory(idcliente, fcstatus.IdCadena, fcstatus.Fecha.Month, fcstatus.Fecha.Year);

            var model = new List<ForecastingConfirmStatusLogViewModel>();
            foreach (var f in fchistory)
            {
                model.Add(new ForecastingConfirmStatusLogViewModel()
                {
                    Id = f.Id,
                    Fecha = f.Fecha,
                    IdCadena = f.IdCadena,
                    IdCliente = f.IdCliente,
                    IdProducto = f.IdProducto,
                    IdUsuario = f.IdUsuario,
                    OperationType = f.OperationType,
                    Cadena = f.Cadena.Nombre,
                    Producto = f.Producto != null ? f.Producto.Nombre : string.Empty,
                    UsuarioNombre = f.Usuario.Apellido + ", " + f.Usuario.Nombre,
                    Observaciones = f.Observaciones
                });
            }

            return PartialView("_fchistory", model);
        }

        [HttpPost]
        public JsonResult DesbloquearFC(int idcadena)
        {
            int clienteid = GetClienteSeleccionado();
            int userid = GetUsuarioLogueado();
            userid = usuarioRepository.GetUsuarioPerformance(userid);
            var ret = clienteRepository.DesbloquearForecasting(clienteid, idcadena, userid);
            return Json(ret, JsonRequestBehavior.AllowGet);
        }

        [HttpPost]
        public ActionResult ConfirmarPSI(int IdCadena, string Observaciones)
        {
            if (string.IsNullOrEmpty(Observaciones) || IdCadena == 0)
            {
                return Json(false, JsonRequestBehavior.AllowGet);
            }

            int clienteid = GetClienteSeleccionado();
            int userid = GetUsuarioLogueado();
            userid = usuarioRepository.GetUsuarioPerformance(userid);

            var res = clienteRepository.ConfirmarForecasting(clienteid, IdCadena, userid, Observaciones);
            return Json(res, JsonRequestBehavior.AllowGet);
        }

        [HttpPost]
        public ActionResult ExportacionCAP(string HtmlDoc, bool Soar)
        {
            string a = datosRepository.ExportacionCAP(HtmlDoc, Soar);
            return Json(a);
        }
    }
}
