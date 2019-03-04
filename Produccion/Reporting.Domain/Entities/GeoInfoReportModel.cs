using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Reporting.Domain.Entities
{
    public class GeoInfoReportModel
    {
        public int idReporte { get; set; }

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
