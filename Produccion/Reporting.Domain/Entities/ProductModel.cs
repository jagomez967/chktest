
namespace Reporting.Domain.Entities
{
    public class ProductModel
    {
        public ProductModel()
        {
            PriceGap = decimal.MinValue;
        }
        public int Id { get; set; }
        public string Name { get; set; }
        public decimal Price { get; set; }
        public decimal PriceGap { get; set; }
    }
}
