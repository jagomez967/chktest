using System.Collections.Generic;

namespace Reporting.ViewModels
{
    public class PriceRequestFormViewModel
    {
        public PriceRequestFormViewModel() {
            PriceRequests = new List<PriceRequestViewModel>();
        }
        public List<PriceRequestViewModel> PriceRequests { get; set; }
        public bool Editable { get; set; }
        public bool WaitAprrobe { get; set; }
        public string GUID { get; set; }
    }
}