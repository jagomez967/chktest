namespace Reporting.Domain.Entities
{
    using System;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;

    [Table("EmpresaMail")]
    public partial class EmpresaMail
    {
        [Key]
        public int IdEmpresaMail { get; set; }

        public int? IdReporte { get; set; }

        [StringLength(100)]
        public string MailFrom { get; set; }

        public string MailBody { get; set; }

        [StringLength(200)]
        public string MailSubject { get; set; }

        public string MailAdjuntos { get; set; }

        public bool? Autorizado { get; set; }

        public int? UsuarioAutorizacion { get; set; }

        public bool Enviado { get; set; }

        public DateTime? FechaCreacion { get; set; }

        public DateTime? FechaAutorizacion { get; set; }

        public DateTime? FechaEnvio { get; set; }

        public int? IdAlerta { get; set; }

        public string MailHeader { get; set; }

        public string MailFooter { get; set; }

        public virtual Alertas Alertas { get; set; }
    }
}
