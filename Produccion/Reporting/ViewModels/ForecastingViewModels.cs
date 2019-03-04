using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace Reporting.ViewModels
{
    public class SalesInOutViewModel
    {
        public SalesInOutViewModel()
        {
            Cadenas = new List<SelectListItem>();
            Categorias = new List<SelectListItem>();
            Productos = new List<SelectListProduct>();
            Canales = new List<SelectListItem>();
        }
        public List<SelectListItem> Cadenas { get; set; }
        public List<SelectListItem> Categorias { get; set; }
        public List<SelectListProduct> Productos { get; set; }
        public List<SelectListItem> Canales { get; set; }
        public bool ShowFuture { get; set; }

    }

    public class SelectListProduct
    {
        public string Value { get; set; }
        public string Text { get; set; }
        public bool HasInv { get; set; }
    }

    public class SalesInFormsVM
    {
        public SalesInFormsVM()
        {
            Forms = new List<SalesInOutFormViewModel>();
            Revenue = new RevenueTotal();
            Totales = new List<SalesInOutFormViewModel>();
        }
        public List<SalesInOutFormViewModel> Forms { get; set; }
        public List<SalesInOutFormViewModel> Totales { get; set; }
        public RevenueTotal Revenue { get; set; }
        public bool ShowFuture { get; set; }
    }

    public class SalesInOutFormViewModel
    {
        public SalesInOutFormViewModel()
        {
            Meses = new List<DateTime>();
            SalesInOut = new List<SalesInOutDataViewModel>();
            Indicadores = new List<IndicadorMesFC>();
        }

        //IdCanal lo uso en los totales
        public int IdCanal { get; set; }
        public string Canal { get; set; }

        public string Currency { get; set; }
        public int IdCategoria { get; set; }
        public string Categoria { get; set; }
        public int IdCadena { get; set; }
        public int IdProducto { get; set; }
        public string IdExterno { get; set; }
        public string Producto { get; set; }
        public bool Confirmado { get; set; }
        public string Orden { get; set; }
        public bool IsTotal { get; set; }
        public List<IndicadorMesFC> Indicadores { get; set; }
        public List<DateTime> Meses { get; set; }
        public List<SalesInOutDataViewModel> SalesInOut { get; set; }
    }

    public class IndicadorMesFC
    {
        public int Mes { get; set; }
        public int Indicador { get; set; }
    }

    public class SalesInOutDataViewModel
    {
        public int Id { get; set; }
        public int IdCanal { get; set; }
        public string Canal { get; set; }
        public int IdCategoria { get; set; }
        public string Categoria { get; set; }
        public DateTime Fecha { get; set; }
        public double WholeSalePrice { get; set; }
        public double Revenue { get; set; }
        public int IdCadena { get; set; }
        public int IdProducto { get; set; }
        public int POSellIn { get; set; }
        public int POSellOut { get; set; }
        public int POVarSellIn { get; set; }
        public int POVarSellOut { get; set; }
        public int PVSellIn { get; set; }
        public int PVSellOut { get; set; }
        public int PVVarSellIn { get; set; }
        public int PVVarSellOut { get; set; }
        public int SalesIn { get; set; }
        public int SalesOut { get; set; }
        public int StockInicial { get; set; }
        public int ChannelInv { get; set; }
        public double SORR { get; set; }
        public double YoY { get; set; }
        public int DOCI { get; set; }
        public string CanalIdentificador { get; set; }
        public int LimiteDoci { get; set; }
    }

    public class ForcesatingConfirmadosViewModel
    {
        public ForcesatingConfirmadosViewModel()
        {
            Items = new List<ForecastingConfirmadosItemViewModel>();
        }
        public int IdCanal { get; set; }
        public string Canal { get; set; }
        public List<ForecastingConfirmadosItemViewModel> Items { get; set; }
    }

    public class ForecastingConfirmadosItemViewModel
    {
        public int IdCadena { get; set; }
        public string Cadena { get; set; }
        public int? IdUsuario { get; set; }
        public string Apellido { get; set; }
        public string Nombre { get; set; }
        public DateTime? Fecha { get; set; }
    }

    public class ForecastingConfirmStatusLogViewModel
    {
        public int Id { get; set; }
        public DateTime Fecha { get; set; }
        public int IdCadena { get; set; }
        public int IdCliente { get; set; }
        public int? IdProducto { get; set; }
        public int IdUsuario { get; set; }
        public string OperationType { get; set; }
        public string Cadena { get; set; }
        public string Producto { get; set; }
        public string UsuarioNombre { get; set; }
        public string Observaciones { get; set; }
    }

    public class EpsonPrices
    {
        public string Canal { get; set; }
        public int IdCadena { get; set; }
        public int IdProducto { get; set; }
        public DateTime Fecha { get; set; }
        public double Precio { get; set; }
        public string Currency { get; set; }
    }

    public class RevenueTotal
    {
        public RevenueTotal()
        {
            Meses = new List<DateTime>();
            Rows = new List<RevenueRow>();
            Indicadores = new List<IndicadorMesFC>();
        }
        public string Titulo { get; set; }
        public string Currency { get; set; }
        public List<DateTime> Meses { get; set; }
        public List<RevenueRow> Rows { get; set; }
        public List<IndicadorMesFC> Indicadores { get; set; }
    }

    public class RevenueRow
    {
        public RevenueRow()
        {
            Meses = new List<RevenueMes>();
        }
        public int IdCanal { get; set; }
        public string Nombre { get; set; }
        public int OrdenFila { get; set; }
        public List<RevenueMes> Meses { get; set; }
    }

    public class RevenueMes
    {
        public DateTime Fecha { get; set; }
        public double Valor { get; set; }
        public double SalesIn { get; set; }
        public double SalesOut { get; set; }
    }
}