namespace Reporting.Domain.Entities
{
    public class GeoInfoPdv
    {
        public string PlaceID { get; set; }
        public string Name { get; set; }
        public string Categorie { get; set; }
        public string Chain { get; set; }
        public string BusinessName { get; set; }
        public string Direction { get; set; }
        public string PostalCode { get; set; }
        public string Phone { get; set; }

        public string LastReportUser { get; set; }
        public string LastReportDate { get; set; }
        public string Contact { get; set; }
        public string Email { get; set; }
    }
}