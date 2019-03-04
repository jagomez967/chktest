namespace Reporting.Domain.Entities
{
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;
    
    [Table("Cliente")]
    public partial class Cliente
    {
        public Cliente()
        {
            Usuario_Cliente = new HashSet<Usuario_Cliente>();
            ReportingFiltrosModulo = new HashSet<ReportingFiltrosModulo>();
            ReportingClienteObjeto = new HashSet<ReportingClienteObjeto>();
            ReportingFamiliaNombreCliente = new HashSet<ReportingFamiliaNombreCliente>();
            ReportingFiltroNombreCliente = new HashSet<ReportingFiltroNombreCliente>();
            ReportingRoles = new HashSet<ReportingRoles>();
            ReportingVisibilidadEntreUsuario = new HashSet<ReportingVisibilidadEntreUsuario>();
            Alertas = new HashSet<Alertas>();
            tags = new HashSet<tags>();
            ReportingFamiliaObjetoCliente = new HashSet<ReportingFamiliaObjetoCliente>();
            ReportingFiltrosCliente = new HashSet<ReportingFiltrosCliente>();
            CalendarioConceptos = new HashSet<CalendarioConcepto>();
            FamiliaClientes = new HashSet<FamiliaClientes>();
            Forecasting = new HashSet<Forecasting>();
            TiposCadena = new HashSet<TipoCadena>();
        }

        [Key]
        public int IdCliente { get; set; }

        [Required]
        [StringLength(50)]
        public string Nombre { get; set; }

        public int? IdEmpresa { get; set; }

        public bool? Transfer { get; set; }

        public bool? Dermoestetica { get; set; }

        public bool? Mantenimiento { get; set; }

        public bool? VisitadorMedico { get; set; }

        public bool? Capacitacion { get; set; }

        public string Imagen { get; set; }

        public bool? CodigoBarras { get; set; }

        public string ImagenWeb { get; set; }

        public string ImagenMovil { get; set; }

        public decimal? Latitud { get; set; }

        public decimal? Longitud { get; set; }

        public int? DiferenciaHora { get; set; }

        public int? DiferenciaMinutos { get; set; }

        public bool flgMarcaBlanca { get; set; }

        public string countrySymbol { get; set; }

        [StringLength(100)]
        public string hashCliente { get; set; }

        [StringLength(100)]
        public string link { get; set; }

        public bool? PermiteFotosDeBiblioteca { get; set; }

        public bool StockDefaultValue { get; set; }

        public bool? EsClienteAgrupado { get; set; }

        [StringLength(100)]
        public string marcaLabel { get; set; }

        public virtual ICollection<Usuario_Cliente> Usuario_Cliente { get; set; }
        public virtual ICollection<ReportingFamiliaNombreCliente> ReportingFamiliaNombreCliente { get; set; }
        public virtual ICollection<ReportingFiltroNombreCliente> ReportingFiltroNombreCliente { get; set; }
        public virtual ICollection<ReportingFiltrosModulo> ReportingFiltrosModulo { get; set; }
        public virtual ICollection<ReportingClienteObjeto> ReportingClienteObjeto { get; set; }
        public virtual ICollection<ReportingRoles> ReportingRoles { get; set; }
        public virtual ICollection<ReportingVisibilidadEntreUsuario> ReportingVisibilidadEntreUsuario { get; set; }
        public virtual ICollection<Alertas> Alertas { get; set; }
        public virtual ICollection<tags> tags { get; set; }
        public virtual ICollection<ReportingFamiliaObjetoCliente> ReportingFamiliaObjetoCliente { get; set; }
        public virtual ICollection<ReportingFiltrosCliente> ReportingFiltrosCliente { get; set; }
        public virtual ICollection<CalendarioConcepto> CalendarioConceptos { get; set; }
        public virtual ICollection<FamiliaClientes> FamiliaClientes { get; set; }
        public virtual ICollection<Forecasting> Forecasting { get; set; }
        public virtual ICollection<TipoCadena> TiposCadena { get; set; }
        public virtual Empresa Empresa { get; set; }
    }
}
