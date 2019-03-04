namespace Reporting.Domain.Entities
{
    public partial class AlertasProductos
    {
        public int Id { get; set; }

        public int IdAlerta { get; set; }

        public int IdMarca { get; set; }

        public int IdProducto { get; set; }

        public virtual Alertas Alertas { get; set; }
    }
}
