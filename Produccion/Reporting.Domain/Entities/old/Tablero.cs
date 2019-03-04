using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Reporting.Domain.Entities
{
    [Table("ReportingTablero")]
    public class Tablero
    {
        public Tablero()
        {
            this.Objetos = new List<TableroObjeto>();
            this.TableroUsuariosClientes = new List<TableroUsuarioCliente>();
        }

        [Key]
        public int Id { get; set; }
        public string Nombre { get; set; }
        public string Descripcion { get; set; }
        public int IdUsuario { get; set; }  
        public int IdCliente { get; set; }



        [ForeignKey("IdCliente")]
        public Cliente Cliente { get; set; }

        [ForeignKey("IdUsuario")]
        public Usuario Usuario { get; set; }

        public virtual ICollection<TableroObjeto> Objetos { get; set; }
        public virtual ICollection<TableroUsuarioCliente> TableroUsuariosClientes { get; set; }
        
    }
}