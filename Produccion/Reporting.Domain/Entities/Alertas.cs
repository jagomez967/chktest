namespace Reporting.Domain.Entities
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;

    public partial class Alertas
    {
        public Alertas()
        {
            AlertasCampos = new HashSet<AlertasCampos>();
            AlertasProductos = new HashSet<AlertasProductos>();
            AlertasModulos = new HashSet<AlertasModulos>();
            EmpresaMail = new HashSet<EmpresaMail>();
            Distancia = 0;
            HoraInicio = "";
            HoraFin = "";
        }

        public int Id { get; set; }

        public int IdCliente { get; set; }

        public int IdUsuario { get; set; }

        [Required]
        public string Descripcion { get; set; }
        public bool Consolidado { get; set; }
        public bool Lunes { get; set; }
        public bool Martes { get; set; }
        public bool Miercoles { get; set; }
        public bool Jueves { get; set; }
        public bool Viernes { get; set; }
        public bool Sabado { get; set; }
        public bool Domingo { get; set; }

        [StringLength(100)]
        public string Hora { get; set; }

        [StringLength(50)]
        public string AccionTriggerSeleccionada { get; set; }

        [StringLength(50)]
        public string TipoReporteSeleccionado { get; set; }

        [Required]
        public string Destinatarios { get; set; }

        public string PuntosDeVenta { get; set; }

        public bool Activo { get; set; }
        public bool Eliminado { get; set; }

        public DateTime FechaCreacion { get; set; }

        public decimal? Distancia { get; set; }

        public string HoraInicio { get; set; }

        public string HoraFin { get; set; }

        public virtual Cliente Cliente { get; set; }


        public virtual ICollection<AlertasCampos> AlertasCampos { get; set; }

        public virtual ICollection<AlertasProductos> AlertasProductos { get; set; }

        public virtual ICollection<AlertasModulos> AlertasModulos { get; set; }

        public virtual ICollection<EmpresaMail> EmpresaMail { get; set; }
    }
}
