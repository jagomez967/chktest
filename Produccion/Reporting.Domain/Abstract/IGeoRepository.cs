using System.Collections.Generic;
using Reporting.Domain.Entities;

namespace Reporting.Domain.Abstract
{
    public interface IGeoRepository
    {
        List<GeoMarkerSimple> GetMarkersCoberturaCliente(List<FiltroSeleccionado> Filtros, int ClienteId);
        List<Usuario> GetUsuariosDeRuteo(string FechaHoy, int ClienteId);
        List<Usuario> GetUsuariosCliente(List<FiltroSeleccionado> Filtros, int ClienteId);
        GeoRuta GetRutaDeUsuario(string FechaHoy, int IdUsuario, int ClienteId);
        GeoInfoPdv GetInfoPDV(int idPuntoDeVenta);
        List<ReportDetailModel> GetDetailsReportsPDV(List<FiltroSeleccionado> Filtros,int idPuntoDeVenta);
        GeoInfoReportModel GetInfoReporte(int idReporte);
        string GetSignatureReport(int idReporte);
        int GetDiferenciaHorariaCliente(int IdCliente);
    }
}
