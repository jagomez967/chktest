using Reporting.Domain.Entities;

namespace Reporting.ViewModels
{
    public class GeoInfoPdvVM
    {
        public GeoInfoPdvVM() { }
        public GeoInfoPdvVM(string _BusinessName, string _Categorie, string _Chain, string _Direction,
                            string _Name, string _Phone, string _PostalCode, string _ultimoReporte, 
                            string _usuarioReporte, string _Contact, string _Email, int _idPuntoDeVenta)
        {
            BusinessName = _BusinessName;
            Categorie = _Categorie;
            Chain = _Chain;
            Direction = _Direction;
            Name = _Name;
            Phone = _Phone;
            PostalCode = _PostalCode;
            LastReportDate = _ultimoReporte;
            LastReportUser = _usuarioReporte; 
            Contact = _Contact;
            Email = _Email;
            IdPDV = _idPuntoDeVenta;
        }

        public GeoInfoPdvVM(GeoInfoPdv m) {
            BusinessName = m.BusinessName;
            Categorie = m.Categorie;
            Chain = m.Chain;
            Direction = m.Direction;
            Name = m.Name;
            Phone = m.Phone;
            PostalCode = m.PostalCode;
            Contact = m.Contact;
            Email = m.Email;
        }



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
        public int IdPDV { get; set; }
    }
}
