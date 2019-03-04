using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Reporting.Domain.Entities
{
    public class UsuarioPerfil
    {
        [Key, Column(Order = 0)]
        public int IdUsuario { get; set; }
        [Key, Column(Order = 1)]
        public int IdPerfil { get; set; }

        public virtual Usuario Usuario { get; set; }
    }
}
