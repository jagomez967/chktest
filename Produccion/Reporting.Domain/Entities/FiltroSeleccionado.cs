namespace Reporting.Domain.Entities
{
    public class FiltroSeleccionado
    {
        public string Filtro { get; set; }
        public string TipoFecha { get; set; }
        public TipoFiltro TipoFiltro { get; set; }
        public string[] Valores { get; set; }
    }
}
