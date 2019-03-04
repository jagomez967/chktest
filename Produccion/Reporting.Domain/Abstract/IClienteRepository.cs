using System.Collections.Generic;
using Reporting.Domain.Entities;
using System.Data;
using System.Linq;
using System;

namespace Reporting.Domain.Abstract
{
    public interface IClienteRepository
    {
        List<Cliente> GetClientes(int UsuarioId);
        Cliente GetCliente(int ClienteId);
        Cliente GetClienteByReporte(int ReporteId);
        bool TieneMarcaBlanca(int clienteId);
        Cliente GetDatosMarcaBlanca(int clienteId);
        bool SaveMarcaBlanca(int clienteId, bool flgMarcaBlanca, string link);
        IQueryable<Producto> GetProductos(int clienteId);
        IQueryable<Producto> GetProductos(int clienteId, int[] lstFamilias, string textinname);
        DataSet GetForecasting(int clienteId, string[] lstCanales, string[] lstCadenas, string[] lstCategorias, string[] lstProductos, int IdUsuario);
        DataSet GetWholeSalePrices(int clienteId, string[] lstCanales, string[] lstCadenas, string[] lstCategorias, string[] lstProductos);
        void ForecastingUpdate(Forecasting entity);
        int ForecastingAdd(Forecasting entity);
        Cadena GetCadena(int IdCadena);
        Producto GetProducto(int IdProducto);
        DataSet GetForecastingConfirmados(int IdCliente);
        bool ConfirmarForecasting(int IdCliente, int IdCadena, int IdUsuario, string Observaciones);
        List<Forecasting> ForecastingAddOrUpdate(List<Forecasting> data, int IdCliente);
        IQueryable<ForecastingMesIndicador> GetIndicadoresMesesForecasting();
        IQueryable<Producto> GetProductos(int clienteId, string textinname);
        bool DesbloquearForecasting(int IdCliente, int id, int IdUsuario);
        IQueryable<Familia> GetFamilias(int clienteId);
        IQueryable<Producto> GetProductos(int clienteId, int IdFamilia, string textinname);
        List<TipoCadena> GetTiposDeCadena(int IdCliente, int IdUsuario);
        void GuardarForecasting(int IdCliente, int IdUsuario, int IdCadena, int IdProducto, DateTime FechaStockInicial, int StockInicial, DataTable datos, bool audit);
        IQueryable<ForecastingConfirmStatusLog> GetForecastingHistory(int IdCliente, int IdCadena, int mes, int anio);
        IQueryable<Cadena> GetCadenas(int clienteId);
        IQueryable<Cadena> GetCadenas(int clienteId, int userId);
        IQueryable<Cadena> GetCadenas(int clienteId, int IdTipoCuenta, int userId);
        List<Usuario> GetUsuariosByPerfilId(int perfilId, int IdCliente);
        ForecastingConfirmStatus GetForecastingStatus(int IdCliente, int Id);
        double GetCurrencyExchangeForecasting(int idcliente, DateTime fecha, string currtype);
        int GetCurrentChannelInv(int idProducto);
    }
}
