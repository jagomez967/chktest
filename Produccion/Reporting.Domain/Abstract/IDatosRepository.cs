using System.Collections.Generic;
using Reporting.Domain.Entities;

namespace Reporting.Domain.Abstract
{
    public interface IDatosRepository
    {
        IEnumerable<Tab> GetTabs(int ClienteId);
        int GetTableroIdDefault(int userId, int clienteId);
        ReportingTablero GetTablero(int TableroId, int UsuarioId, int ClienteId);
        ReportingTablero GetTableroDefault(int UsuarioId, int ClienteId);
        IEnumerable<ReportingTableroObjeto> GetObjetosDeTablero(int TableroId);
        Chart GetDataObjeto(List<FiltroSeleccionado> filtros, int clienteId, int objetoId, int numeroPagina, int usuarioConsultaId, int tamanioPagina);
        ReportingObjeto GetObjeto(int ObjetoId);
        Chart GetTableData(List<FiltroSeleccionado> filtros, int clienteId, int objetoId, int numeroPagina, int usuarioConsultaId, int tamanioPagina);
        string GenerarArchivo(List<FiltroSeleccionado> Filtros, int ClienteId, int ObjetoId, int UsuarioConsultaId);
        void EliminarArchivo(string filename, bool fc = false);
        int GetIdTableroByObjetoUser(int objetoId, int userId);
        int GetIdTableroByObjetoUser2(int objetoId, int userId);
        int GetModuloTablero(int tableroid);
        bool ExistsFiltroPorTablero(int tableroid);
        string ExportacionCAP(string HtmlDoc, bool Soar);
    }
}
