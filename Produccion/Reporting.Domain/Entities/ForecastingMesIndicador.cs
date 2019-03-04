using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Reporting.Domain.Entities
{
     [Table("ForecastingMesIndicador")]
    public class ForecastingMesIndicador
    {
         [Key]
         public int Mes { get; set; }
         public int Indicador { get; set; }
    }
}
