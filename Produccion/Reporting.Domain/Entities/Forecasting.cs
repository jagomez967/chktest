using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Reporting.Domain.Entities
{
    [Table("Forecasting")]
    public partial class Forecasting
    {
        public int Id { get; set; }
        public int IdCliente { get; set; }
        public int IdCadena { get; set; }
        public DateTime Fecha { get; set; }
        public int IdProducto { get; set; }
        [Column(TypeName = "numeric")]
        public decimal StreetPrice { get; set; }
        [Column(TypeName = "numeric")]
        public decimal NetASP { get; set; }
        public int PlanOriginalSellIn { get; set; }
        public int PlanOriginalSellOut { get; set; }
        public int PlanVendedorSellIn { get; set; }
        public int PlanVendedorSellOut { get; set; }
        public int SalesIn { get; set; }
        public int SalesOut { get; set; }
        public int StockInicial { get; set; }
        public int? IdUsuario { get; set; }
        public int ChannelInv { get; set; }

        public virtual Cliente Cliente { get; set; }
        public virtual Producto Producto { get; set; }
        public virtual Cadena Cadena { get; set; }
    }
}
