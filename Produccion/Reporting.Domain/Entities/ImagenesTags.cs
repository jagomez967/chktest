namespace Reporting.Domain.Entities
{
    using System;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;

    public partial class imagenesTags
    {
        [Key]
        [Column(Order = 0)]
        [DatabaseGenerated(DatabaseGeneratedOption.None)]
        public int idImagen { get; set; }

        [Key]
        [Column(Order = 1)]
        [DatabaseGenerated(DatabaseGeneratedOption.None)]
        public int idTag { get; set; }

        public DateTime fecha { get; set; }

        public int idUsuario { get; set; }

        public virtual tags tag { get; set; }

        public virtual PuntoDeVentaFoto PuntoDeVentaFoto { get; set; }
    }
}
