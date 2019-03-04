using System.Collections.Generic;

namespace Reporting.Domain.Entities
{
    public class GapModel
    {
        public GapModel()
        {
            Accounts = new List<GapModelAccount>();
            Products = new List<GapModelProduct>();
            Detail = new List<GapModelDetail>();
        }

        public List<GapModelAccount> Accounts { get; set; }
        public List<GapModelProduct> Products { get; set; }
        public List<GapModelDetail> Detail { get; set; }
    }

    public class GapModelDetail
    {
        public int AccountId { get; set; }
        public int ProductId { get; set; }
        public int CompetitorId { get; set; }
        public decimal SelfPrice { get; set; }
        public decimal CompetitorPrice { get; set; }
        public decimal PriceGap { get; set; }
        public string Color { get; set; }
        public int SellIn { get; set; }
        public int Inventory { get; set; }  
        public bool Request { get; set; }
        public float OrderMath { get; set; }
    }
    public class GapModelAccount
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public string Image { get; set; }
    }
    public class GapModelProduct
    {
        public int Id { get; set;}
        public string Name { get; set;}
        public string Image { get; set;}
    }
}
