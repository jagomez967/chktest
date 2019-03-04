namespace Reporting.Domain.Entities
{
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;

    [Table("Usuario")]
    public partial class Usuario
    {
        public Usuario()
        {
            Usuario_Cliente = new HashSet<Usuario_Cliente>();
            ReportingAspNetUsuario = new HashSet<ReportingAspNetUsuario>();
            ReportingVisibilidadEntreUsuarioPadre = new HashSet<ReportingVisibilidadEntreUsuario>();
            ReportingVisibilidadEntreUsuarioHijo = new HashSet<ReportingVisibilidadEntreUsuario>();
            Usuario_PuntoDeVenta = new HashSet<Usuario_PuntoDeVenta>();
            Reporte = new HashSet<Reporte>();
            EventosCalendario = new HashSet<Calendario>();
            Perfiles = new HashSet<UsuarioPerfil>();
        }

        [Key]
        public int IdUsuario { get; set; }

        public int? IdGrupo { get; set; }

        [Column("Usuario")]
        [Required]
        [StringLength(100)]
        public string Usuario1 { get; set; }

        [Required]
        public string Clave { get; set; }

        [StringLength(50)]
        [Required]
        public string Nombre { get; set; }

        [StringLength(100)]
        public string Email { get; set; }

        [StringLength(50)]
        public string Telefono { get; set; }

        [StringLength(200)]
        public string Comentarios { get; set; }

        [StringLength(50)]
        [Required]
        public string Apellido { get; set; }

        public bool? CambioPassword { get; set; }

        public bool? Activo { get; set; }
        public bool PermiteModificarCalendario { get; set; }

        public string imagen { get; set; }
        public bool esCheckPos { get; set; }
        public int UltimoClienteSeleccionado { get; set; }
        public string Idioma { get; set; }
        public virtual ICollection<Usuario_Cliente> Usuario_Cliente { get; set; }
        public virtual ICollection<ReportingAspNetUsuario> ReportingAspNetUsuario { get; set; }
        [ForeignKey("IdUsuario")]
        public virtual ICollection<ReportingVisibilidadEntreUsuario> ReportingVisibilidadEntreUsuarioPadre { get; set; }
        [ForeignKey("IdUsuarioHijo")]
        public virtual ICollection<ReportingVisibilidadEntreUsuario> ReportingVisibilidadEntreUsuarioHijo { get; set; }
        public virtual ICollection<Usuario_PuntoDeVenta> Usuario_PuntoDeVenta { get; set; }
        public virtual ICollection<Reporte> Reporte { get; set; }
        public virtual ICollection<Calendario> EventosCalendario { get; set; }
        public virtual ICollection<UsuarioPerfil> Perfiles { get; set; }
    }
}
