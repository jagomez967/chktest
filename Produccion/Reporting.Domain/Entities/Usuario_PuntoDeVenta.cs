namespace Reporting.Domain.Entities
{
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;

    public partial class Usuario_PuntoDeVenta
    {
        [Key]
        public int Id { get; set; }
        public int IdPuntoDeVenta { get; set; }

        public int IdUsuario { get; set; }

        public bool New { get; set; }

        public int DataMigrationId { get; set; }

        public int DataMigrationId2 { get; set; }

        public bool? Activo { get; set; }

        [ForeignKey("IdPuntoDeVenta")]
        public virtual PuntoDeVenta PuntoDeVenta { get; set; }

        [ForeignKey("IdUsuario")]
        public virtual Usuario Usuario { get; set; }
    }
}
