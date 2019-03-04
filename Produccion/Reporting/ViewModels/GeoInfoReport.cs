
using Reporting.Domain.Entities;

namespace Reporting.ViewModels
{
    public class GeoInfoReport
    {
        public GeoInfoReport() { }
        public GeoInfoReport(GeoInfoReportModel m)
        {
            idReporte = m.idReporte;
            Name = m.Name;
            Categorie = m.Categorie;
            Chain = m.Chain;
            BusinessName = m.BusinessName;
            Direction = m.Direction;
            UserName = m.UserName;
            IdPDV = m.IdPDV;
            CreationDate = m.CreationDate;
            CloseDate = m.CloseDate;
            SendDate = m.SendDate;
            ReceptionDate = m.ReceptionDate;
            UpdateDate = m.UpdateDate;
            Signature = m.Signature;
        }
        public int idReporte{get; set;}

        public string Name { get; set; }
        public string Categorie { get; set; }
        public string Chain { get; set; }
        public string BusinessName { get; set; }
        public string Direction { get; set; }
        
        public string UserName { get; set; }
        public int IdPDV { get; set; }

        public string CreationDate { get; set; }
        public string CloseDate { get; set; }
        public string SendDate { get; set; }
        public string ReceptionDate { get; set; }
        public string UpdateDate { get; set; }
        public bool Signature { get; set; }
    }
}