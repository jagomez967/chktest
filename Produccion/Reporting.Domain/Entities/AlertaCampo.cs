namespace Reporting.Domain.Entities
{
    public class AlertaCampo
    {
        public int Id { get; set; }
        public int IdMarca { get; set; }
        public int IdSeccion { get; set; }
        public int IdCampo { get; set; }
        public string MarcaDescr { get; set; }
        public string SeccionDescr { get; set; }
        public string CampoDescr { get; set; }
    }
}
