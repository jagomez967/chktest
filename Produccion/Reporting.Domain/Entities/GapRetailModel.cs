using System.Collections.Generic;

namespace Reporting.Domain.Entities
{
    public class GapRetailModel
    {        
        public GapRetailModel()
        {
            Competitor = new List<ProductModel>();
        }
        public ProductModel Product { get; set; }
        public List<ProductModel> Competitor { get; set; } //Deberia, quizas, hacer lo mismo para GapProduct (sin discriminar Retail)
        public int AccountId { get; set; }
        public string Account { get; set; }        
        public string Color { get; set; }
    }
}
