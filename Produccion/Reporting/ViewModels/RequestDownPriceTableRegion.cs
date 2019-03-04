using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Reporting.ViewModels
{
    public class RequestDownPriceTableRegion
    {
        public RequestDownPriceTableRegion() {
            Countries = new List<RequestTableByCountry>();
        }
        public List<RequestTableByCountry> Countries { get; set; }
    }
}