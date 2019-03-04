namespace Reporting.Domain.Entities
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;

    [Table("PuntoDeVentaFoto")]
    public partial class PuntoDeVentaFoto
    {
        public PuntoDeVentaFoto()
        {
            imagenesTags = new HashSet<imagenesTags>();
        }

        [Key]
        public int IdPuntoDeVentaFoto { get; set; }

        public int IdPuntoDeVenta { get; set; }

        public int IdEmpresa { get; set; }

        public int IdUsuario { get; set; }

        public DateTime FechaCreacion { get; set; }

        public bool? Estado { get; set; }

        public int? Partes { get; set; }

        [StringLength(500)]
        public string Comentario { get; set; }

        public int? IdReporte { get; set; }

        public virtual ICollection<imagenesTags> imagenesTags { get; set; }
    }
}
