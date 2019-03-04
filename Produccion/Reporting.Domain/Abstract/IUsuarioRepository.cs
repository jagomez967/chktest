using Reporting.Domain.Entities;
using System;
using System.Collections.Generic;

namespace Reporting.Domain.Abstract
{
    public interface IUsuarioRepository
    {
        int GetUsuarioPerformance(int UsuarioId);
        Usuario getPerfilUsuario(int UsuarioId);
        string GetImagenUsuario(int UsuarioId);
        List<ReportingAspNetUsuario> GetUsuariosReportingAspByCliente(int clienteId, bool permiteCheckPos);
        List<Usuario> GetUsuariosConReportingByCliente(int clienteId, bool permiteCheckPos);
        List<Usuario> GetUsuariosByCliente(int clienteId, bool permiteCheckPos);
        bool EdicionSimpleUsuario(Usuario user);
        bool CrearNuevoUsuario(int clienteId, Usuario user, int idAspUser);
        bool RegenerarUsuario(int clienteId);
        List<ReportingRoles> GetRolesDeCliente(int idCliente);
        bool CrearRol(int idCliente, string nombre, List<int> permisos);
        bool ExisteRol(int idCliente, string nombreRol);
        List<ReportingRolPermisos> GetPermisosDeRol(int idCliente, int idRol);
        List<ReportingPermisos> GetPermisos();
        void AsignarPermiso(int idRol, int idPermiso, bool value);
        bool IsAuthorized(int clienteId, int userId, string permiso);
        void saveFiltros(int clienteId, int userId, string jsonFiltros);
        string getFiltros(int clienteId, int userId);
        List<ReportingVisibilidadEntreUsuario> GetVisibilidadEntreUsuarios(int clienteId, int idUsuarioPadre);
        Usuario GetUsuarioById(int idusuario);
        Usuario GetUsuarioInClientById(int idusuario, int ClienteId);
        List<Usuario> GetUsuarios(int clienteId, bool permiteCheckPos);
        bool UsuarioPerteneceACheckPos(int idUsuario);
        List<Usuario> GetUsuariosDeUsuario(int idcliente, int userId);
        void GuardarVisibilidadUsuarios(int userPadre, int clienteId, List<int> hijos);
        void AsignarPermisosARol(int idRol, List<ReportingRolPermisos> permisos);
        int GetUltimoClienteSeleccionado(int idUsuario);
        void SetUltimoClienteSeleccionado(int idUsuario, int idCliente);
        bool EdicionUsuarioPerfil(int ClienteId, Usuario user);
        bool EdicionUsuarioPerfil(int ClienteId, Usuario user, int RolId);
        List<PuntoDeVenta> GetPuntosDeVentaDeUsuario(int clienteId, int userId);
        int CrearEventoCalendario(Calendario evento, int clienteId);
        bool EliminarEventoCalendario(int id, int clienteId);
        PuntoDeVenta GetPuntDeVentaById(int idPuntoDeVenta);
        ReportingRoles GetRolById(int RolId, int ClienteId);
        bool EditarRol(int ClienteId, ReportingRoles Rol, List<int> Permisos);
        bool IsUsuarioInCliente(int ClienteId, int UsuarioId);
        bool AsignarUsuarioPerfConUsuReporting(int IdUsuarioPerf, int IdUsuarioRep);
        List<CalendarioConcepto> GetConceptosCalendario(int clienteid);

        List<Calendario> GetEventosCalendario(int clientId, DateTime? start = null, DateTime? end = null, int? userId = null);
        Calendario GetEventoById(int clienteid, int id);
        int EditarEventoCalendario(Calendario evento);
        string GetModuloDisponible(int idUsuario, int idCliente);
        string GenerarCalendario(int idCliente, int idusuario, string fechaDesde, string fechaHasta);
    }
}
