
namespace Reporting.Domain.Entities
{
    public class PhotoProductModel
    {
        public int IdProducto { get; set; }
        public int IdImagen { get; set; }
        public string Base64 { get; set; }
        public int IdUsuario { get; set; }
        public string Usuario { get; set; }
        public int IdPuntoDeVenta { get; set; }
        public string PuntoDeVenta { get; set; }
        public string Direccion { get; set; }
        public int IdReporte { get; set; }
        public string Fecha { get; set; }
        public int IdEmpresa { get; set; }
        public bool FotoTag { get; set; }
    }
}