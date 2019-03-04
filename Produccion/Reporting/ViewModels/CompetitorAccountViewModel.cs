namespace Reporting.ViewModels
{
    public class CompetitorAccountViewModel
    {
        public AccountViewModel Account { get; set; }
        public int Inventory { get; set; }
        public int SellIn { get; set; }
        public decimal SelfPrice { get; set; }
        public decimal CompetitorPrice { get; set; }
        public decimal AccountGap { get; set; }
        public string Color { get; set; }
        public bool Request { get; set; }
        public int SelfProductId { get; set; }
        public int CompetitorProductId { get; set; }
    }
}

