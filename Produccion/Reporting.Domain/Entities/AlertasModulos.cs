namespace Reporting.Domain.Entities
{
    using System;

    public partial class AlertasModulos
    {
        public int Id { get; set; }

        public int IdAlerta { get; set; }

        public int IdModuloItem { get; set; }

        public int IdModuloClienteItem { get; set; }

        public string Leyenda { get; set; }

        public int EsMayor { get; set; }

        public int EsMenor { get; set; }

        public int EsIgual { get; set; }

        public Decimal? Valor { get; set; }

        public virtual Alertas Alertas { get; set; }
    }
}
