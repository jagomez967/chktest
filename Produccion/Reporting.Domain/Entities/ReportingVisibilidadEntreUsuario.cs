using System.ComponentModel.DataAnnotations.Schema;

namespace Reporting.Domain.Entities
{
    [Table("ReportingVisibilidadEntreUsuario")]
    public partial class ReportingVisibilidadEntreUsuario
    {
        public int Id { get; set; }
        public int IdCliente { get; set; }
        public int IdUsuario { get; set; }
        public int IdUsuarioHijo { get; set; }

        public virtual Cliente Cliente { get; set; }
        [ForeignKey("IdUsuario")]
        public virtual Usuario Padre { get; set; }
        [ForeignKey("IdUsuarioHijo")]
        public virtual Usuario Hijo { get; set; }
    }
}
