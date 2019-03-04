namespace Reporting.Domain.Entities
{
    public class OrderTab
    {
        public string Titulo { get; set; }
        public int Id { get; set; }
        public bool Active { get; set; }
        public int? Order { get; set; }
    }
}
