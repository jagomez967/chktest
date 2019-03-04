using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Reporting.Domain.Entities
{
    [Table("PuntoDeVenta")]
    public partial class PuntoDeVenta
    {
        public PuntoDeVenta()
        {
            Usuario_PuntoDeVenta = new HashSet<Usuario_PuntoDeVenta>();
            Reporte = new HashSet<Reporte>();
            EventosCalendario = new HashSet<Calendario>();
        }

        [Key]
        public int IdPuntoDeVenta { get; set; }

        public int Codigo { get; set; }

        [Required]
        [StringLength(200)]
        public string Nombre { get; set; }

        public long? Cuit { get; set; }

        [StringLength(200)]
        public string RazonSocial { get; set; }

        [StringLength(500)]
        public string Direccion { get; set; }

        [StringLength(8)]
        public string CodigoPostal { get; set; }

        [StringLength(50)]
        public string Telefono { get; set; }

        [StringLength(50)]
        public string Email { get; set; }

        [StringLength(100)]
        public string Contacto { get; set; }

        public int? TotalGondolas { get; set; }

        public int? TotalEstantesGondola { get; set; }

        public int? TotalEstantesInterior { get; set; }

        public int? TotalEstantesExterior { get; set; }

        public bool? TieneVidriera { get; set; }

        public int? IdLocalidad { get; set; }

        public int? IdZona { get; set; }

        public int? IdCadena { get; set; }

        public int? IdTipo { get; set; }

        public int? IdCategoria { get; set; }

        public int? IdDimension { get; set; }

        public int? IdPotencial { get; set; }

        public int? EspacioBacklight { get; set; }

        [StringLength(50)]
        public string CodigoSAP { get; set; }

        [StringLength(50)]
        public string CodigoAdicional { get; set; }

        public decimal? Latitud { get; set; }

        public decimal? Longitud { get; set; }

        public bool? AuditoriaNoAutorizada { get; set; }
        public int IdCliente { get; set; }

        public virtual ICollection<Usuario_PuntoDeVenta> Usuario_PuntoDeVenta { get; set; }
        public virtual ICollection<Reporte> Reporte { get; set; }
        public virtual Localidad Localidad { get; set; }
        public virtual ICollection<Calendario> EventosCalendario { get; set; }
        public virtual Cadena Cadena { get; set; }
    }
}
