using System;
using System.Collections.Generic;

namespace Reporting.ViewModels
{
    public class RequestTableByCountry
    {
        public RequestDownPriceTable RequestTable { get; set; }
        public string CountryCode { get; set; }
        public string Country { get; set; }
    }

    class RequestTableByCountryComp : IEqualityComparer<RequestTableByCountry>
    {
        public bool Equals(RequestTableByCountry x, RequestTableByCountry y)
        {
            return x.Country == y.Country && x.CountryCode == y.CountryCode;
        }

        public int GetHashCode(RequestTableByCountry obj)
        {
            return obj.Country.GetHashCode() ^
                   obj.CountryCode.GetHashCode();
        }
    }
}
