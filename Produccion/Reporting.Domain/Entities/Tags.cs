namespace Reporting.Domain.Entities
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    
    public partial class tags
    {
        public tags()
        {
            imagenesTags = new HashSet<imagenesTags>();
        }

        [Key]
        public int idTag { get; set; }

        public int idCliente { get; set; }

        [StringLength(100)]
        public string tabla { get; set; }

        [StringLength(100)]
        public string campos { get; set; }

        [StringLength(100)]
        public string valores { get; set; }

        [StringLength(100)]
        public string leyenda { get; set; }

        public bool activo { get; set; }

        public DateTime fecha { get; set; }

        public virtual Cliente Cliente { get; set; }

        public virtual ICollection<imagenesTags> imagenesTags { get; set; }
    }
}