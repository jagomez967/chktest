using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Reporting.Domain.Entities
{
    [Table("ReportingGrafico")]
    public class Grafico
    {
        [Key]
        public int Id { get; set; }
        public string SpData { get; set; }
        public string SpYAxisLabels { get; set; }
    }
}
