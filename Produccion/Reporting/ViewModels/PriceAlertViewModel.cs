using System.Collections.Generic;

namespace Reporting.ViewModels
{
    public class PriceAlertViewModel
    {
        public PriceAlertViewModel()
        {
            GapList = new List<GapProductViewModel>();
        }
        public List<GapProductViewModel> GapList { get; set;}
    }
}