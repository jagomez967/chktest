namespace Reporting.Domain.Entities
{
        public class Product_M : ProductModel
        {
            public int BrandId { get; set; }
            public string Brand { get; set; }
            public decimal UBP { get; set; }
            public int Inventory { get; set; }
            public int SellOut { get; set; }
            public int SellIn { get; set; }
            public bool EOL { get; set; }
            public decimal UBPProposal { get; set; }
            public string Photo { get; set; }
        }
    
}
