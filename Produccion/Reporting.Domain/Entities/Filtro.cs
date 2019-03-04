using System.Collections.Generic;

namespace Reporting.Domain.Entities
{
    public enum TipoFiltro
    {
        CheckBox = 1,
        Fecha = 2
    }
    public class Filtros
    {
        public Filtros()
        {
            this.FiltrosChecks = new List<FiltroCheck>();
            this.FiltrosFechas = new List<FiltroFecha>();
        }
        public List<FiltroCheck> FiltrosChecks { get; set; }
        public List<FiltroFecha> FiltrosFechas { get; set; }
    }

    public class FiltroCheck
    {
        public FiltroCheck()
        {
            this.Items = new List<ItemFiltro>();
        }
        public string Id { get; set; }
        public string Nombre { get; set; }
        public List<ItemFiltro> Items { get; set; }
    }

    public class FiltroFecha
    {
        public string Id { get; set; }
        public string Nombre { get; set; }
        public string TipoFechaSeleccionada { get; set; }
        public string DiaDesde { get; set; }
        public string DiaHasta { get; set; }
        public string SemanaDesde { get; set; }
        public string SemanaHasta { get; set; }
        public string MesDesde { get; set; }
        public string MesHasta { get; set; }
        public string TrimestreDesde { get; set; }
        public string TrimestreHasta { get; set; }
    }
    public class ItemFiltro
    {
        public string IdItem { get; set; }
        public string Descripcion { get; set; }
        public bool Selected { get; set; }
        public string TipoItem { get; set; }
        public bool isLocked { get; set; }
    }
}