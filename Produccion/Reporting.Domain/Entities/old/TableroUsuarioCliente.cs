using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Reporting.Domain.Entities
{
    [Table("ReportingTableroUsuarioCliente")]
    public class TableroUsuarioCliente
    {
        [Key]
        public int Id { get; set; }
        [ForeignKey("Tablero")]
        public int TableroId { get; set; }
        [ForeignKey("Usuario")]
        public int IdUsuario { get; set; }
        public bool PermiteEscritura { get; set; }
        
        public virtual Tablero Tablero { get; set; }
        public virtual Usuario Usuario { get; set; }
    }
}
