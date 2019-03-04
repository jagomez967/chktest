namespace Reporting.Domain.Entities
{
    using System.ComponentModel.DataAnnotations.Schema;
    
    public partial class Usuario_Cliente
    {
        public int IdCliente { get; set; }

        public int IdUsuario { get; set; }

        public int Id { get; set; }

        public string filtrojson { get; set; }
        public int? RolId { get; set; }
        public virtual Cliente Cliente { get; set; }
        public virtual Usuario Usuario { get; set; }
        [ForeignKey("RolId")]
        public virtual ReportingRoles Rol { get; set; }

    }
}
