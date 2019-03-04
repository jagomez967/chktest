namespace Reporting.Domain.Entities
{

    public partial class AlertasCampos
    {
        public int Id { get; set; }

        public int IdAlerta { get; set; }

        public int IdMarca { get; set; }

        public int IdModulo { get; set; }

        public int IdItem { get; set; }

        public virtual Alertas Alertas { get; set; }
    }
}
