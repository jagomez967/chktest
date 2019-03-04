namespace Reporting.Domain.Entities
{
    public class NewPriceRequestForm
    {
        public int AccountId { get; set; }
        public int ProductId { get; set; }
        public int CompetitorId { get; set; }
        public int SelfInventory { get; set; }
        public int CompInventory { get; set; }
        public int SelfSellIn { get; set; }
        public int SelfSellOut { get; set; }
        public int CompSellIn { get; set; }
        public int CompSellOut { get; set; }

        public string SelfPhoto { get; set; }
        public string CompPhoto { get; set; }

        public decimal UBP { get; set; }
        public decimal NetAsp { get; set; }
        public decimal NetAspCondition { get; set; }
        public bool EOLSelf { get; set; }  
        public bool EOLComp { get; set; }
        public decimal SelfPrice { get; set; }
        public decimal CompPrice { get; set; }
        public decimal ASPVariancePrice { get; set; }
        public decimal ASPVariancePercent { get; set; }
        public decimal UBPProposal { get; set; }
        public decimal IdealGap { get; set; }
        public decimal PriceGap { get; set; }
    }
}
