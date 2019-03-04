namespace Reporting.Domain.Entities
{
    public class Item
    {
        public string IdItem { get; set; }
        public string IdParent { get; set; }
        public string Descripcion { get; set; }
        public bool Selected { get; set; }
        public string TipoItem { get; set; }
    }
}
