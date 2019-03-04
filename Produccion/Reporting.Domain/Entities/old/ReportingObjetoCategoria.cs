using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
namespace Reporting.Domain.Entities
{
    [Table("ReportingObjetoCategoria")]
    public class ObjetoCategoria
    {
        [Key]
        public int Id { get; set; }
        public string Nombre { get; set; }
        public virtual ICollection<Objeto> Objetos { get; set; }

    }
}
