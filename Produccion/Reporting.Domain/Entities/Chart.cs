namespace Reporting.Domain.Entities
{
    public enum TipoChart
    {
        Error = -1,
        Column = 1,
        Pie = 2,
        StackedColumn = 3,
        Area = 4,
        PieLineCol = 5,
        StackedColumnDrillDown = 6,
        ColumnDrillDown = 7,
        StackedPercentColumnDrillDown = 8,
        Tabla = 9,
        LineChart = 10,
        PieDrillDown = 11,
        MetEncuestas = 12,
        SpiderWebChart = 13,
        StackedColumnPercent = 14,
        Imagenes = 15,
        EtiquetaLayout = 16,
        Timeline = 17,
        PieSemiCircle = 18,
        MultiTendencia = 19,
        TablaOrden = 20,
        Scatter = 21,
        Spiline = 22,
        SimpleKPI = 23,
        Measure = 24,
        TableWithTotals = 25,
        CircleWithDetail = 26,
        PieWheel = 27,
        FlatStackedColumn = 28,
        SolidGauge = 29,
        ClassicTable = 30,
        SparkLine = 31,
        BigKPI = 32
    }
    public class Chart
    {
        public TipoChart Tipo { get; set; }
        public string SpDatos { get; internal set; }
    }
}
