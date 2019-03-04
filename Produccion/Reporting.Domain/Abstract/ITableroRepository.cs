using System.Collections.Generic;
using Reporting.Domain.Entities;

namespace Reporting.Domain.Abstract
{
    public interface ITableroRepository
    {
        List<ReportingTablero> GetTableros(int UsuarioId, int ClienteId);
        int AddTablero(ReportingTablero t, int UsuarioId, int ClienteId);
        ReportingTablero GetTablero(int TableroId, int UsuarioId, int ClienteId);
        ReportingTablero GetTableroDefault(int UsuarioId, int ClienteId);
        List<Tab> GetTabs(int UsuarioId, int ClienteId);
        List<ReportingTableroObjeto> GetObjetosDeTablero(int TableroId);
        ReportingObjeto GetObjeto(int ObjetoId);
        Chart GetDataObjeto(List<FiltroSeleccionado> filtros, int clienteId, int objetoId, int numeroPagina, int usuarioConsultaId, int tamanioPagina);
        List<ReportingObjeto> GetObjetosDeCliente(int ClienteId);
        bool DeleteTablero(int TableroId);
        bool UpdateOrdenTablero(int TableroID, int Orden, bool esPropio,int idUsuario);
        bool ExisteTableroUsuario(int TableroID, int IdUsuario);
        bool EditarTablero(ReportingTablero tablero);
        List<ReportingObjetoCategoria> GetCategoriasObjetoDeCliente(int idCliente);
        bool updateConfiguracionDeTableroObjeto(int tableroId, int objetoId, bool dataLabel, int stackLabel);
        bool CambiarObjetoDeTablero(int tableroId, int objetoId, int tipoSeleccionado);
        List<ReportingTablero> GetMisTableros(int usuarioId);
        List<ReportingTableroUsuario> GetUsuariosDeTablero(int IdTablero);
        bool QuitarPermisos(int idTablero);
        bool AgregarPermisos(ReportingTableroUsuario permiso);
        List<TableroPermiso> GetPermisosDeTablero(int idCliente, int idUsuario);
        bool PermiteCambiarPermisosDeTablero(int tableroId, int usuarioId, int clienteId);
        bool PermiteEditarTablero(int tableroId, int usuarioId, int clienteId);
        List<ReportingFamiliaObjeto> GetFamiliasObjetoDeCliente(int clienteId);
        bool SetObjectName(int id, int clienteId, string nombre);
        List<ReportingFamiliaNombreCliente> GetFamiliasNombreCliente(int clienteId);
        bool ResetObjectName(int id, int clienteId);
        List<ReportingModulos> GetModulos(bool UsaFiltros);
        List<ReportingFiltros> GetFiltrosDeModulo(int modulo, int ClienteId);
        List<ReportingFiltros> GetFiltros();
        List<ReportingFiltros> GetFiltrosDeCliente(int ClienteId);
        bool SetFiltroName(int id, int clienteId, string nombre);
        bool ResetFiltroName(int id, int clienteId);
        bool SetFiltroActivo(int id, int clienteId, int modulo, bool check);
        int GetTableroIdDefault(int userId, int clienteId);
        List<ReportingFamiliaObjeto> GetAllFamilias();
        bool SetObjetoSeleccionado(int clienteId, int objetoId, bool value);
        List<ReportingObjeto> GetAllObjetos();
        Chart GetSPAnidado(List<FiltroSeleccionado> filtros, int ClienteId, int ObjetoId, List<string> Esclave, List<string> EsclaveValue, int UsuarioConsultaId);
        string GetReportingFamiliaObjetoIdentificador(int id);
        ReportingTablero GetTableroById(int tableroId);
        int GetModuloByTableroId(int tableroId);
        List<ReportingClienteObjeto> GetObjetosAsignadosACliente(int clienteId);
        List<ReportingClienteObjeto> GetRelObjetoCliente(int ClienteId);
        bool AsignarFamiliaACliente(int ClienteId, int FamiliaId);
        bool QuitarFamiliaDeCliente(int ClienteId, int FamiliaId);
        bool ActivarFiltroParaCliente(int filtroid, int clienteid);
        bool DesactivarFiltroParaCliente(int filtroid, int clienteid);
        Reporte GetReporte(int ClienteId, int IdReporte);
        PuntoDeVenta GetPuntoDeVenta(int ClienteId, int IdPuntoDeVenta);
        List<ReporteSimple> GetDataReporteT22(int clienteId, string producto, string fecha, string precio, int tipoPrecio, List<FiltroSeleccionado> filtros, string anio);
        List<ReportePaisSimple> GetDataPaisesT22(int clienteId, string producto, List<FiltroSeleccionado> filtros, string fecha);
        string GetDescripcionObjeto(int idObjeto, string CultureName);
        string GetNombreObjeto(int idFamiliaObjeto, int idUsuario);
    }
}
