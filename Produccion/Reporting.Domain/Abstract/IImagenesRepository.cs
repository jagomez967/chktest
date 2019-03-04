using System.Collections.Generic;
using Reporting.Domain.Entities;

namespace Reporting.Domain.Abstract
{
    public interface IImagenesRepository
    {
        Imagen GetFotoPorId(int clienteId, int idFoto);
        int GetIdEmpresaDeCliente(int clienteId);
        List<Imagen> GetMasFotos(List<FiltroSeleccionado> Filtros, int clienteId, int pageNum);
        string GenerarArchivoFotos(int clienteId, int dias);
        string GenerarArchivoFotosResultadoBusqueda(List<FiltroSeleccionado> Filtros, int clienteId);
        List<Imagen> GetFotosDias(int clienteId, int dias);
        void EliminarZip(string filename);
        List<string> GetUltimas5Fotos(int IdReporte);
        List<string> GetLastPhotosPDV(int IdPuntoDeVenta);
        List<string> GetPhotosReport(int IdReporte);
    }
}
