namespace Reporting.Domain.Entities
{
    public partial class ReportingRolPermisos
    {
        public int id { get; set; }

        public int idRol { get; set; }

        public int idPermiso { get; set; }

        public virtual ReportingPermisos ReportingPermisos { get; set; }

        public virtual ReportingRoles ReportingRoles { get; set; }
    }
}