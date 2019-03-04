using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Reporting.Domain.Entities
{
    [Table("Reporte")]
    public partial class Reporte
    {
        [Key]
        public int IdReporte { get; set; }

        public int IdPuntoDeVenta { get; set; }

        public int IdUsuario { get; set; }

        public DateTime FechaCreacion { get; set; }

        public DateTime? FechaActualizacion { get; set; }

        public int? IdEmpresa { get; set; }

        public bool? AuditoriaNoAutorizada { get; set; }

        public decimal? Latitud { get; set; }

        public decimal? Longitud { get; set; }

        public string Firma { get; set; }

        public bool New { get; set; }

        public int DataMigrationId { get; set; }

        public int DataMigrationId2 { get; set; }

        public int? Precision { get; set; }

        public DateTime? Vejez { get; set; }

        public DateTime? FechaEnvio { get; set; }

        public DateTime? FechaRecepcion { get; set; }

        public int? IdCliente { get; set; }

        public virtual Empresa Empresa { get; set; }

        public virtual PuntoDeVenta PuntoDeVenta { get; set; }

        public virtual Usuario Usuario { get; set; }
    }
}
