using System.Collections.Generic;
using Reporting.Domain.Entities;

namespace Reporting.Domain.Abstract
{
    public interface IAbmsRepository
    {
        List<Alertas> GetAlertas(int clienteId, string searchtext);
        bool CrearAlerta(Alertas alerta);
        string EditarAlerta(Alertas alerta);
        List<AlertaCampo> GetCamposAlerta(int clienteId);
        List<AlertaProducto> GetProductosAlerta(int clienteId);
        List<AlertaModulo> GetModulosAlerta(int clienteId);
        List<AlertasModulos> GetItemsModulosAlerta(int clienteId, int alertaId);
        Alertas GetAlerta(int id);
        void EliminarAlerta(int clienteId, int id);
        List<PuntoDeVentaAlerta> GetPuntosDeVentaAlerta(int clienteId);
    }
}
