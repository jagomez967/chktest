using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Reporting.Domain.Entities
{
    [Table("ForecastingConfirmStatusLog")]
    public class ForecastingConfirmStatusLog
    {
        [Key]
        public int Id { get; set; }
        public int IdCliente { get; set; }
        public int IdCadena { get; set; }
        public int? IdProducto { get; set; }
        public DateTime Fecha { get; set; }
        public int IdUsuario { get; set; }
        public string OperationType { get; set; }
        public string Observaciones { get; set; }

        public virtual Cadena Cadena { get; set; }
        public virtual Producto Producto { get; set; }
        public virtual Usuario Usuario { get; set; }
    }
}