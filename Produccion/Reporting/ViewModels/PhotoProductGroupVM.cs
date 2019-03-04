using System.Collections.Generic;

namespace Reporting.ViewModels
{
    public class PhotoProductGroupVM
    {
        public PhotoProductGroupVM() {
            ListPhoto = new List<PhotoProductViewModel>();
        }
        public List<PhotoProductViewModel> ListPhoto { get; set; }
        public bool IsEditable { get; set; }
        public int AccountId { get; set; }
        public int ProductId { get; set; }
    }
}