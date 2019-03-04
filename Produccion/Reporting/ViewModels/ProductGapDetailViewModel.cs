using System.Collections.Generic;

namespace Reporting.ViewModels
{
    public class ProductGapDetailViewModel
    {
        public ProductGapDetailViewModel()
        {
            Competitors = new List<CompetitorGapViewModel>();
        }

        public int ProductId { get; set; }
        public string ProductName { get; set; }
        public string Color { get; set; }
        public string Image { get; set; }
        public decimal PriceGap { get; set; }

        public int SellIn { get; set; }
        public int SellOut { get; set; }
        public int Inventory { get; set; }
        public List<CompetitorGapViewModel> Competitors { get; set; }

        //VARIABLES QUE NO LES ENCONTRE UN LUGAR O NO ENTIENDO DE DONDE SALEN
        public int TotalCompetitors { get; set; }
        public int TotalStores { get; set; }

        public float OrderMath { get; set; }
    }
}