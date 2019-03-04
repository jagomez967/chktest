namespace Reporting.ViewModels
{
    public class PriceRequestViewModel
    {
        public string Account { get; set; }
        public int AccountId { get; set; }
        public decimal PriceGap { get; set; } //Lo calculo desde la base 
        
        public decimal IdealGap { get; set; }            
        public decimal NetAsp { get; set; }
        public decimal NetAspCondition { get; set; }

        public decimal AspVariancePrice {
            get {
                return (NetAspCondition == 0 ? 0 : NetAsp - NetAspCondition);
            }
        }
        public decimal AspVariancePercent {
            get {
                return (NetAspCondition == 0 ? 0: ((NetAsp / NetAspCondition) * 100) - 100); //http://www.disfrutalasmatematicas.com/numeros/porcentaje-diferencia.html
            }
        }        

        public ProductPR Product { get; set; }
        public ProductPR Competitor { get; set; }
    }
}