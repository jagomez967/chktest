using System.Collections.Generic;

namespace Reporting.ViewModels
{
    public class CompetitorGapViewModel
    {
        public CompetitorGapViewModel()
        {
            Accounts = new List<CompetitorAccountViewModel>();
        }
        public int ProductId { get; set; }
        public string ProductName { get; set; }
        public List<CompetitorAccountViewModel> Accounts { get; set; }
    }
}