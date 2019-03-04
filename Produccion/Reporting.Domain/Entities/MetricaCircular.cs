namespace Reporting.Domain.Entities
{
    public class MetricaCircular
    {
        public int id { get; set; }
        public double valor { get; set; }
        public double varianza { get; set; }
        public string logo { get; set; }
        public string color { get; set; }
        public int parentId { get; set; }
        public int nivel { get; set; }
        public string Leyenda { get; set; }
    }
}
