namespace Reporting.Domain.Entities
{
    public class PriceRequestModel
    {
        public string Account { get; set; }
        public int AccountId { get; set; }
        public decimal PriceGap { get; set; }
        public decimal IdealGap { get; set; }
    
        public decimal NetAsp { get; set; }
        public decimal NetAspCondition { get; set; }

        public Product_M Product { get; set; }
        public Product_M Competitor { get; set; }

    }
}
