
namespace Reporting.ViewModels
{
    public class ReportDetailVM
    {
        public ReportDetailVM() { }
        public ReportDetailVM(string user, string img, string report, string date) {
            UserIMG = img;
            UserName = user;
            ReportId = report;
            Date = date;
        }
        public string UserIMG { get; set; }
        public string UserName { get; set; }
        public string ReportId { get; set; }
        public string Date { get; set; }
    }
}
