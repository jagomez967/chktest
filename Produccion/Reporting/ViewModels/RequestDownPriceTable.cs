using System.Collections.Generic;

namespace Reporting.ViewModels
{
    public class RequestDownPriceTable
    {
        public RequestDownPriceTable()
        {
            ListItem = new List<RequestDownPriceItem>();
        } 
        public List<RequestDownPriceItem> ListItem { get; set; }
        public bool IsAdmin { get; set; }
        public bool IsPm { get; set; }
    }
}