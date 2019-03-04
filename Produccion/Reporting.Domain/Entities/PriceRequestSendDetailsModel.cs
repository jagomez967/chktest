using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Reporting.Domain.Entities
{
    public class PriceRequestSendDetailsModel
    {
        public string GUID { get; set; }
        public int Id { get; set; }
        public string Country { get; set; }
        public string Date { get; set; }
        public string User { get; set; }
    }
}
