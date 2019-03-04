using System.Web;
using System.Web.Optimization;

namespace Reporting
{
    public class BundleConfig
    {
        public static void RegisterBundles(BundleCollection bundles)
        {
            //JS
            bundles.Add(new ScriptBundle("~/bundles/commonjs").Include(
                "~/Scripts/html2canvas.js",
                "~/Scripts/jquery-3.3.1.min.js",
                "~/Scripts/jquery.circliful.js",
                "~/Scripts/jquery-ui-1.12.1.js",
                "~/Scripts/modernizr-*",
                "~/Scripts/bootstrap.js",
                "~/Scripts/jquery.validate*",
                "~/Scripts/offcanvas-menu.js",
                "~/Scripts/highcharts.js",
                "~/Scripts/highcharts-more.js",
                "~/Scripts/drilldown.js",
                "~/Scripts/solid-gauge.js",
                "~/Scripts/exporting.js",
                "~/Scripts/renderImagenes.js",
                "~/Scripts/etiquetaLayout.js",
                "~/Scripts/jquery.droptabs.js",
                "~/Scripts/jquery.slimscroll.js",
                "~/Scripts/d3.min.js",
                "~/Scripts/Graficos.js",
                "~/Scripts/InfiniteScroll.js",
                "~/Scripts/filtrosReporting.js",
                "~/Scripts/ExportGraficos.js",
                "~/Scripts/download.js",
                "~/Scripts/Timeline.js",
                "~/Scripts/moment.min.js",
                "~/Scripts/fullcalendar.min.js",
                "~/Scripts/select2.full.js",
                "~/Scripts/locale-all.js",
                "~/Scripts/bootstrap-switch.js",
                "~/Scripts/modernizr-custom.js",
                "~/Scripts/weekpicker.js",
                "~/Scripts/MonthPicker.js",
                "~/Scripts/datepicker-es.js",
                "~/Scripts/reporting.js",
                "~/Scripts/datatables.min.js",
                "~/Scripts/footable.min.js",
                "~/Scripts/bootstrap-multiselect.js"
                ));

            bundles.Add(new ScriptBundle("~/bundles/unobstrusive").Include(
                "~/Scripts/jquery.unobtrusive-ajax.min.js"));

            //CSS
            bundles.Add(new StyleBundle("~/Content/css").Include(
                "~/Content/animate.css",
                "~/Content/bootstrap.min.css",
                "~/Content/style.css",
                "~/Content/font-awesome.min.css",
                "~/Content/timeline-vertical.css",
                "~/Content/timeline-horizontal.css",
                "~/Content/jquery.circliful.css",
                "~/Content/fullcalendar.min.css",
                "~/Content/fullcalendar.min.print.css",
                "~/Content/select2.min.css",
                "~/Content/bootstrap-switch.css",
                "~/Content/datepicker.css",
                "~/Content/jquery-ui.css",
                "~/Content/jquery-ui.structure.css",
                "~/Content/jquery-ui.theme.css",
                "~/Content/MonthPicker.css",
                "~/Content/footable.bootstrap.min.css",
                "~/Content/bootstrap-multiselect.css",
                "~/Content/gmaps-sidebar.css",
                "~/Content/map-icons.css"
                ));
            
                  BundleTable.EnableOptimizations = true;
        }
    }
}
