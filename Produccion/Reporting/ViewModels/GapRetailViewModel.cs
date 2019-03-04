using System.Collections.Generic;

namespace Reporting.ViewModels
{
    public class GapRetailViewModel
    {
        public GapRetailViewModel()
        {
            Competitor = new List<ProductViewModel>();
        }
        public ProductViewModel Product { get; set; }
        public List<ProductViewModel> Competitor { get; set; }
        public int AccountId { get; set;}
        public string Account { get; set; }        
        public string Color { get; set; }
    }
}