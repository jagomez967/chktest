namespace Reporting.Domain.Entities
{
    using System;
    using System.ComponentModel.DataAnnotations.Schema;
    
    [Table("Calendario")]
    public partial class Calendario
    {
        public int Id { get; set; }
        public int IdCliente { get; set; }
        public int IdPuntoDeVenta { get; set; }
        public int IdUsuario { get; set; }
        public DateTime FechaInicio { get; set; }
        public int? ConceptoId { get; set; }
        public string Observaciones { get; set; }
        public string CodigoEvento { get; set; }

        public virtual PuntoDeVenta PuntoDeVenta { get; set; }
        public virtual Usuario Usuario { get; set; }
        public virtual CalendarioConcepto Concepto { get; set; }
    }
}
