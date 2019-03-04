using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Reporting.Domain.Entities
{
    [Table("ReportingObjeto")]
    public class Objeto
    {
        [Key]
        public int Id { get; set; }
        [ForeignKey("TipoObjeto")]
        public int IdTipoObjeto { get; set; }
        public string TextoHeader { get; set; }
        public string TextoFooter { get; set; }
        public string SPDatos { get; set; }
        public TipoChart Tipo { get; set; }
        [ForeignKey("Categoria")]
        public int CategoriaId { get; set; }
        public bool dataLabels { get; set; }
        public int stackLabels { get; set; }//0: nada, 1:Promedio(AVG), 2:Suma total(SUM)
        public virtual ObjetoCategoria Categoria { get; set; }
        public virtual TipoObjeto TipoObjeto { get; set; }
        public virtual ICollection<TableroObjeto> Tableros { get; set; }
    }
}
