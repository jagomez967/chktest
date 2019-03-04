namespace Reporting.ViewModels
{
    public class PriceRequestHistory
    {
        public string GUID { get; set; }
        public string Date { get; set; }
        public string User { get; set; }
        public PriceRequestStatus State { get; set; }
        public string Commentary { get; set; }
    }
}