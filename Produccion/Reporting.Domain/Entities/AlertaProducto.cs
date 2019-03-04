namespace Reporting.Domain.Entities
{
    public class AlertaProducto
    {
        public int Id { get; set; }
        public int IdProducto { get; set; }
        public int IdMarca { get; set; }
        public string MarcaDescr { get; set; }
        public string ProductoDescr { get; set; }
    }
}

