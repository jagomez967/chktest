using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Reporting.Domain.Entities
{
    public class RequestDownPriceItemModel
    {
        public RequestDownPriceItemModel() {
            AccountList = new List<string>();
        }
        public string GUID { get; set; }
        public string Country { get; set; }
        public string UserName { get; set; }
        public string Date { get; set; }
        public string DateNextAlert { get; set; }
        public string ProductName { get; set; }
        public List<string> AccountList { get; set; }
        public PriceRequestStatusModel Status { get; set; }
        public string CountryCode { get; set; }
    }
}
