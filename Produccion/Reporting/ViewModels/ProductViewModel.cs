using System.ComponentModel.DataAnnotations;

namespace Reporting.ViewModels
{
    public class ProductViewModel
    {
        public ProductViewModel()
        {
            PriceGap = decimal.MinValue;
        }
        public int Id { get; set; }
        public string Name { get; set; }

        [DisplayFormat(DataFormatString = "{0:0.00}")]
        public decimal Price { get; set; }

        [DisplayFormat(DataFormatString = "{0:0.00}")]
        public decimal PriceGap { get; set; }
    }
}