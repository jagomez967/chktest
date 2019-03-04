using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Reporting.Domain.Entities
{
    public class PriceRequestHistoryModel
    {

        public string GUID { get; set; }
        public string Date { get; set; }
        public string User { get; set; }
        public PriceRequestStatusModel State { get; set; }
        public string Commentary { get; set; }

    }
}
