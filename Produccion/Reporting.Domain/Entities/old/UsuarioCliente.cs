using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Reporting.Domain.Entities
{
    [Table("Usuario_Cliente")]
    public class UsuarioCliente
    {
        [Key]
        public int Id { get; set; }
        public int IdUsuario { get; set; }
        public int IdCliente { get; set; }

        [ForeignKey("IdUsuario")]
        public Usuario Usuario { get; set; }
        [ForeignKey("IdCliente")]
        public Cliente Cliente { get; set; }
    }
}
