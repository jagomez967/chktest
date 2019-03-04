
namespace Reporting.Domain.Concrete
{
    using System.Data.Entity;
    using Reporting.Domain.Entities;

    public class RepContext : DbContext
    {
        public virtual DbSet<Cadena> Cadena { get; set; }
        public virtual DbSet<TipoCadena> TipoCadena { get; set; }
        public virtual DbSet<Cliente> Cliente { get; set; }
        public virtual DbSet<Empresa> Empresa { get; set; }
        public virtual DbSet<Negocio> Negocio { get; set; }
        public virtual DbSet<Categoria> Categoria { get; set; }
        public virtual DbSet<Familia> Familia { get; set; }
        public virtual DbSet<Marca> Marca { get; set; }
        public virtual DbSet<Producto> Producto { get; set; }
        public virtual DbSet<Forecasting> Forecasting { get; set; }
        public virtual DbSet<ForecastingConfirmStatus> ForecastingConfirmStatus { get; set; }
        public virtual DbSet<ForecastingConfirmStatusLog> ForecastingConfirmStatusLog { get; set; }
        public virtual DbSet<ForecastingMesIndicador> ForecastingMesIndicador { get; set; }
        public virtual DbSet<UsuarioPerfil> UsuarioPerfil { get; set; }
        public virtual DbSet<ReportingClienteObjeto> ReportingClienteObjeto { get; set; }
        public virtual DbSet<ReportingFamiliaObjeto> ReportingFamiliaObjeto { get; set; }
        public virtual DbSet<ReportingFamiliaNombreCliente> ReportingFamiliaNombreCliente { get; set; }
        public virtual DbSet<ReportingFiltroNombreCliente> ReportingFiltroNombreCliente { get; set; }
        public virtual DbSet<ReportingObjeto> ReportingObjeto { get; set; }
        public virtual DbSet<ReportingObjetoCategoria> ReportingObjetoCategoria { get; set; }
        public virtual DbSet<ReportingTablero> ReportingTablero { get; set; }
        public virtual DbSet<ReportingTableroObjeto> ReportingTableroObjeto { get; set; }
        public virtual DbSet<ReportingTableroUsuario> ReportingTableroUsuario { get; set; }
        public virtual DbSet<Usuario> Usuario { get; set; }
        public virtual DbSet<ReportingAspNetUsuario> ReportingAspNetUsuario { get; set; }
        public virtual DbSet<Usuario_Cliente> Usuario_Cliente { get; set; }
        public virtual DbSet<PuntoDeVentaFoto> PuntoDeVentaFotos { get; set; }
        public virtual DbSet<PuntoDeVenta> PuntoDeVenta { get; set; }
        public virtual DbSet<ReportingFiltros> ReportingFiltros { get; set; }
        public virtual DbSet<ReportingFiltrosModulo> ReportingFiltrosModulo { get; set; }
        public virtual DbSet<ReportingModulos> ReportingModulos { get; set; }
        public virtual DbSet<ReportingRoles> ReportingRoles { get; set; }
        public virtual DbSet<ReportingRolPermisos> ReportingRolPermisos { get; set; }
        public virtual DbSet<ClientePuntoDeVentaLayout> ClientePuntoDeVentaLayout { get; set; }
        public virtual DbSet<Zona> Zona { get; set; }
        public virtual DbSet<ReportingPermisos> ReportingPermisos { get; set; }
        public virtual DbSet<ReportingVisibilidadEntreUsuario> ReportingVisibilidadEntreUsuario { get; set; }
        public virtual DbSet<Alertas> Alertas { get; set; }
        public virtual DbSet<AlertasCampos> AlertasCampos { get; set; }
        public virtual DbSet<AlertasProductos> AlertasProductos { get; set; }
        public virtual DbSet<AlertasModulos> AlertasModulos { get; set; }
        public virtual DbSet<tags> tags { get; set; }
        public virtual DbSet<imagenesTags> imagenesTags { get; set; }
        public virtual DbSet<EmpresaMail> EmpresaMail { get; set; }
        public virtual DbSet<Usuario_PuntoDeVenta> Usuario_PuntoDeVenta { get; set; }
        public virtual DbSet<Calendario> Calendario { get; set; }
        public virtual DbSet<ReportingFamiliaObjetoCliente> ReportingFamiliaObjetoCliente { get; set; }
        public virtual DbSet<ReportingFiltrosCliente> ReportingFiltrosCliente { get; set; }
        public virtual DbSet<Reporte> Reporte { get; set; }
        public virtual DbSet<CalendarioConcepto> CalendarioConceptos { get; set; }
        public virtual DbSet<FamiliaClientes> FamiliaClientes { get; set; }
        protected override void OnModelCreating(DbModelBuilder modelBuilder)
        {
            modelBuilder.Entity<Empresa>()
                .Property(e => e.Nombre)
                .IsFixedLength()
                .IsUnicode(false);

            modelBuilder.Entity<Empresa>()
                .Property(e => e.Logo)
                .IsUnicode(false);

            modelBuilder.Entity<Reporte>()
                .Property(e => e.Latitud)
                .HasPrecision(11, 8);

            modelBuilder.Entity<Reporte>()
                .Property(e => e.Longitud)
                .HasPrecision(11, 8);

            modelBuilder.Entity<Reporte>()
                .Property(e => e.Firma)
                .IsUnicode(false);

            modelBuilder.Entity<Usuario>()
                .HasMany(e => e.Reporte)
                .WithRequired(e => e.Usuario)
                .WillCascadeOnDelete(false);

            modelBuilder.Entity<Usuario>()
                .HasMany(e => e.EventosCalendario)
                .WithRequired(e => e.Usuario)
                .WillCascadeOnDelete(false);

            modelBuilder.Entity<Cliente>()
                .Property(e => e.Nombre)
                .IsUnicode(false);

            modelBuilder.Entity<Cliente>()
                .Property(e => e.Imagen)
                .IsUnicode(false);

            modelBuilder.Entity<Cliente>()
                .HasMany(e => e.Usuario_Cliente)
                .WithRequired(e => e.Cliente)
                .WillCascadeOnDelete(false);

            modelBuilder.Entity<Cliente>()
                .HasMany(e => e.FamiliaClientes)
                .WithRequired(e => e.Cliente)
                .WillCascadeOnDelete(false);

            modelBuilder.Entity<Cliente>()
                .HasMany(e => e.ReportingFamiliaObjetoCliente)
                .WithRequired(e => e.Cliente)
                .WillCascadeOnDelete(false);

            modelBuilder.Entity<Cliente>()
                .HasMany(e => e.ReportingFiltrosCliente)
                .WithRequired(e => e.Cliente)
                .WillCascadeOnDelete(false);

            modelBuilder.Entity<ReportingFiltros>()
                .HasMany(e => e.ReportingFiltrosCliente)
                .WithRequired(e => e.Filtro)
                .WillCascadeOnDelete(false);

            modelBuilder.Entity<Cliente>()
                .HasMany(e => e.CalendarioConceptos)
                .WithRequired(e => e.Cliente)
                .WillCascadeOnDelete(false);

            modelBuilder.Entity<Cliente>()
                .HasMany(e => e.ReportingFiltrosModulo)
                .WithRequired(e => e.Cliente)
                .WillCascadeOnDelete(false);

            modelBuilder.Entity<Cliente>()
                .HasMany(e => e.ReportingClienteObjeto)
                .WithRequired(e => e.Cliente)
                .WillCascadeOnDelete(false);

            modelBuilder.Entity<Alertas>()
                .HasMany(e => e.AlertasCampos)
                .WithRequired(e => e.Alertas)
                .HasForeignKey(e => e.IdAlerta)
                .WillCascadeOnDelete(false);

            modelBuilder.Entity<Alertas>()
                .HasMany(e => e.AlertasProductos)
                .WithRequired(e => e.Alertas)
                .HasForeignKey(e => e.IdAlerta)
                .WillCascadeOnDelete(false);

            modelBuilder.Entity<Alertas>()
                .HasMany(e => e.AlertasModulos)
                .WithRequired(e => e.Alertas)
                .HasForeignKey(e => e.IdAlerta)
                .WillCascadeOnDelete(false);


            modelBuilder.Entity<Cliente>()
                .Property(e => e.Nombre)
                .IsUnicode(false);

            modelBuilder.Entity<Cliente>()
                .Property(e => e.Imagen)
                .IsUnicode(false);

            modelBuilder.Entity<Cliente>()
                .Property(e => e.hashCliente)
                .IsUnicode(false);

            modelBuilder.Entity<Cliente>()
                .Property(e => e.link)
                .IsUnicode(false);

            modelBuilder.Entity<Cliente>()
                .HasMany(e => e.tags)
                .WithRequired(e => e.Cliente)
                .WillCascadeOnDelete(false);

            modelBuilder.Entity<Cliente>()
                .HasMany(e => e.ReportingRoles)
                .WithRequired(e => e.Cliente)
                .WillCascadeOnDelete(false);

            modelBuilder.Entity<Cliente>()
                .HasMany(e => e.ReportingVisibilidadEntreUsuario)
                .WithRequired(e => e.Cliente)
                .WillCascadeOnDelete(false);

            modelBuilder.Entity<ReportingRoles>()
                .Property(e => e.nombre)
                .IsUnicode(false);

            modelBuilder.Entity<ReportingRoles>()
                .HasMany(e => e.ReportingRolPermisos)
                .WithRequired(e => e.ReportingRoles)
                .HasForeignKey(e => e.idRol)
                .WillCascadeOnDelete(false);

            modelBuilder.Entity<ReportingPermisos>()
                .Property(e => e.permiso)
                .IsUnicode(false);

            modelBuilder.Entity<ReportingPermisos>()
                .HasMany(e => e.ReportingRolPermisos)
                .WithRequired(e => e.ReportingPermisos)
                .HasForeignKey(e => e.idPermiso)
                .WillCascadeOnDelete(false);

            modelBuilder.Entity<ReportingFamiliaObjeto>()
                .HasMany(e => e.ReportingObjeto)
                .WithRequired(e => e.ReportingFamiliaObjeto)
                .HasForeignKey(e => e.IdFamiliaObjeto)
                .WillCascadeOnDelete(false);

            modelBuilder.Entity<ReportingFamiliaNombreCliente>()
                .Property(e => e.Nombre)
                .IsUnicode(false);

            modelBuilder.Entity<ReportingFamiliaNombreCliente>()
                .Property(e => e.Nombre)
                .IsUnicode(false);

            modelBuilder.Entity<ReportingFamiliaObjeto>()
                .HasMany(e => e.ReportingFamiliaNombreCliente)
                .WithOptional(e => e.ReportingFamiliaObjeto)
                .HasForeignKey(e => e.idFamilia);



            modelBuilder.Entity<ReportingFiltroNombreCliente>()
                .Property(e => e.Nombre)
                .IsUnicode(false);

            modelBuilder.Entity<ReportingFiltroNombreCliente>()
                .Property(e => e.Nombre)
                .IsUnicode(false);

            modelBuilder.Entity<ReportingFiltros>()
                .HasMany(e => e.ReportingFiltroNombreCliente)
                .WithOptional(e => e.ReportingFiltros)
                .HasForeignKey(e => e.idFiltro);

            modelBuilder.Entity<ReportingFiltros>()
                .Property(e => e.identificador)
                .IsUnicode(false);

            modelBuilder.Entity<ReportingFiltros>()
                .Property(e => e.nombre)
                .IsUnicode(false);

            modelBuilder.Entity<ReportingFiltros>()
                .Property(e => e.storedProcedure)
                .IsUnicode(false);

            modelBuilder.Entity<ReportingFiltros>()
                .HasMany(e => e.ReportingFiltrosModulo)
                .WithRequired(e => e.ReportingFiltros)
                .HasForeignKey(e => e.idFiltro)
                .WillCascadeOnDelete(false);

            modelBuilder.Entity<ReportingModulos>()
                .Property(e => e.Nombre)
                .IsUnicode(false);

            modelBuilder.Entity<ReportingModulos>()
                .HasMany(e => e.ReportingFiltrosModulo)
                .WithRequired(e => e.ReportingModulos)
                .HasForeignKey(e => e.idModulo)
                .WillCascadeOnDelete(false);

            modelBuilder.Entity<ReportingModulos>()
                .HasMany(e => e.ReportingTablero)
                .WithOptional(e => e.ReportingModulos)
                .HasForeignKey(e => e.IdModulo);

            modelBuilder.Entity<ReportingObjeto>()
                .HasMany(e => e.ReportingClienteObjeto)
                .WithRequired(e => e.ReportingObjeto)
                .HasForeignKey(e => e.IdObjeto)
                .WillCascadeOnDelete(false);

            modelBuilder.Entity<ReportingObjeto>()
                .HasMany(e => e.ReportingTableroObjeto)
                .WithRequired(e => e.ReportingObjeto)
                .HasForeignKey(e => e.IdObjeto)
                .WillCascadeOnDelete(false);

            modelBuilder.Entity<ReportingObjetoCategoria>()
                .HasMany(e => e.ReportingFamiliaObjeto)
                .WithRequired(e => e.ReportingObjetoCategoria)
                .HasForeignKey(e => e.IdCategoria)
                .WillCascadeOnDelete(false);

            modelBuilder.Entity<ReportingTablero>()
                .HasMany(e => e.ReportingTableroObjeto)
                .WithRequired(e => e.ReportingTablero)
                .HasForeignKey(e => e.IdTablero)
                .WillCascadeOnDelete(false);

            modelBuilder.Entity<ReportingTablero>()
                .HasMany(e => e.ReportingTableroUsuario)
                .WithRequired(e => e.ReportingTablero)
                .HasForeignKey(e => e.IdTablero)
                .WillCascadeOnDelete(false);

            modelBuilder.Entity<Usuario>()
                .Property(e => e.Usuario1)
                .IsUnicode(false);

            modelBuilder.Entity<Usuario>()
                .Property(e => e.Clave)
                .IsUnicode(false);

            modelBuilder.Entity<Usuario>()
                .Property(e => e.Nombre)
                .IsUnicode(false);

            modelBuilder.Entity<Usuario>()
                .Property(e => e.Email)
                .IsUnicode(false);

            modelBuilder.Entity<Usuario>()
                .Property(e => e.Telefono)
                .IsUnicode(false);

            modelBuilder.Entity<Usuario>()
                .Property(e => e.Comentarios)
                .IsUnicode(false);

            modelBuilder.Entity<Usuario>()
                .Property(e => e.Apellido)
                .IsUnicode(false);

            modelBuilder.Entity<Usuario>()
                .Property(e => e.imagen)
                .IsUnicode(false);

            modelBuilder.Entity<Usuario>()
                .HasMany(e => e.Usuario_Cliente)
                .WithRequired(e => e.Usuario)
                .WillCascadeOnDelete(false);

            modelBuilder.Entity<Usuario>()
                .HasMany(e => e.ReportingAspNetUsuario)
                .WithRequired(e => e.Usuario)
                .WillCascadeOnDelete(false);

            modelBuilder.Entity<tags>()
                .HasMany(e => e.imagenesTags)
                .WithRequired(e => e.tag)
                .WillCascadeOnDelete(false);

            modelBuilder.Entity<PuntoDeVentaFoto>()
                .HasMany(e => e.imagenesTags)
                .WithRequired(e => e.PuntoDeVentaFoto)
                .HasForeignKey(e => e.idImagen)
                .WillCascadeOnDelete(false);

            modelBuilder.Entity<Alertas>()
                .HasMany(e => e.EmpresaMail)
                .WithOptional(e => e.Alertas)
                .HasForeignKey(e => e.IdAlerta);

            modelBuilder.Entity<PuntoDeVenta>()
                .HasMany(e => e.Usuario_PuntoDeVenta)
                .WithRequired(e => e.PuntoDeVenta)
                .WillCascadeOnDelete(false);

            modelBuilder.Entity<CalendarioConcepto>()
                .HasMany(e => e.EventosCalendario)
                .WithRequired(e => e.Concepto)
                .WillCascadeOnDelete(false);

            modelBuilder.Entity<PuntoDeVenta>()
                .HasMany(e => e.EventosCalendario)
                .WithRequired(e => e.PuntoDeVenta)
                .WillCascadeOnDelete(false);

            modelBuilder.Entity<Usuario>()
                .HasMany(e => e.Usuario_PuntoDeVenta)
                .WithRequired(e => e.Usuario)
                .WillCascadeOnDelete(false);

            modelBuilder.Entity<Localidad>()
                .Property(e => e.Nombre)
                .IsUnicode(false);

            modelBuilder.Entity<Provincia>()
                .Property(e => e.Nombre)
                .IsUnicode(false);
        }
    }
}
