namespace Reporting.Domain.Entities
{
    public class PuntoDeVentaAlerta
    {
        public int idZona { get; set; }
        public int idCadena { get; set; }
        public int idPuntoDeVenta { get; set; }
        public string ZonaDescr { get; set; }
        public string CadenaDescr { get; set; }
        public string PuntoDeVentaDescr { get; set; }
        public string RazonSocial { get; set; }
    }
}
