
namespace Reporting.Domain.Entities
{
    public class GapProductModel
    {
        public ProductModel Product { get; set; }
        public decimal PriceGap { get; set; }
        public string Color { get; set; }
    }
}
