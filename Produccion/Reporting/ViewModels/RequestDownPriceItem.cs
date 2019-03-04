using System.Collections.Generic;

namespace Reporting.ViewModels
{
    public class RequestDownPriceItem
    {
        public RequestDownPriceItem() {
            AccountList = new List<string>();
        }
        public string GUID { get; set; }
        public string Country { get; set; }
        public string UserName { get; set; }
        public string Date { get; set; }
        public string DateNextAlert { get; set; }
        public string ProductName { get; set; }
        public List<string> AccountList { get; set; }
        public PriceRequestStatus Status { get; set; }
        public string CountryCode { get; internal set; }
    }
}