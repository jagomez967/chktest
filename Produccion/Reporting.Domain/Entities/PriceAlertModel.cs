using System.Collections.Generic;

namespace Reporting.Domain.Entities
{
    public class PriceAlertModel
    {
        public PriceAlertModel()
        {
            GapList = new List<GapProductModel>();
        }
        public List<GapProductModel> GapList { get; set; }
    }
}
