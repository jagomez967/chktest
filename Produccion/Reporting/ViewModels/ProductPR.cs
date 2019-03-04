using Reporting.Domain.Entities;

namespace Reporting.ViewModels
{
    public class ProductPR : ProductViewModel
    {
        public ProductPR() { }
        public ProductPR(Product_M p) {
            Id = p.Id;
            Name = p.Name;
            Price = p.Price;
            PriceGap = p.PriceGap;
            Brand = p.Brand;
            BrandId = p.BrandId;
            Inventory = p.Inventory;
            SellIn = p.SellIn;
            SellOut = p.SellOut;
            EOL = p.EOL;
            UBP = p.UBP;
            UBPProposal = p.UBPProposal;
            Photo = p.Photo;
        }
        public int BrandId { get; set; }
        public string Brand { get; set; }

        public int Inventory { get; set; }
        public int SellIn { get; set; }
        public int SellOut { get; set; }

        public bool EOL { get; set; }
        public decimal UBP { get; set; }
        public decimal UBPProposal { get; set; }

        public string Photo { get; set; }
    }
}