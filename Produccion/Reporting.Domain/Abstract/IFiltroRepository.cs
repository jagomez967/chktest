using Reporting.Domain.Entities;
using System.Collections.Generic;

namespace Reporting.Domain.Abstract
{
    public interface IFiltroRepository
    {
        Filtros GetFiltros(int UsuarioId, int ClienteId, int IdModulo);
        FiltroCheck GetTopFiltro(int ClienteId, string identificador, string texto);
        List<ReportingFiltroNombreCliente> getFiltroNombreCliente(int clienteId);
        bool IsFiltrosLocked(int tableroId);
        string GetFiltrosBloqueados(int tableroId);
        void SaveFiltrosTablero(int tableroId, string json);
        void SaveFiltrosLockState(int tableroId, string filtros);
        void ClearFiltrosAplicados(int userId, int clienteId);
    }

}
