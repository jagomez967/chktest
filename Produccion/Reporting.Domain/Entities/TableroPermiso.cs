namespace Reporting.Domain.Entities
{
    public class TableroPermiso
    {
        public int tableroId { get; set; }
        public string tableroNombre { get; set; }
        public bool propio { get; set; }
        public bool permiteEscritura { get; set; }
        public string propietario { get; set; }
        public int? orden { get; set; }
    }
}
