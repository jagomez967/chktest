using System.Web;
using System.Web.Optimization;

namespace Reporting
{
    public class BundleConfig
    {
        // Para obtener más información sobre las uniones, visite http://go.microsoft.com/fwlink/?LinkId=301862
        public static void RegisterBundles(BundleCollection bundles)
        {
            bundles.Add(new ScriptBundle("~/bundles/jquery").Include(
                        "~/Scripts/jquery-{version}.js"));

            bundles.Add(new ScriptBundle("~/bundles/jqueryval").Include(
                        "~/Scripts/jquery.validate*"));

            // Utilice la versión de desarrollo de Modernizr para desarrollar y obtener información. De este modo, estará
            // preparado para la producción y podrá utilizar la herramienta de compilación disponible en http://modernizr.com para seleccionar solo las pruebas que necesite.
            bundles.Add(new ScriptBundle("~/bundles/modernizr").Include(
                        "~/Scripts/modernizr-*"));

            bundles.Add(new ScriptBundle("~/bundles/bootstrap").Include(
                      "~/Scripts/bootstrap.js",
                      "~/Scripts/respond.js"));

            bundles.Add(new ScriptBundle("~/bundles/OffCanvas").Include(
                    "~/Scripts/offcanvas-menu.js"));

            bundles.Add(new ScriptBundle("~/bundles/Graficos").Include(
                    "~/Scripts/highcharts.js",
                    "~/Scripts/highcharts-more.js",
                    "~/Scripts/drilldown.js",
                    "~/Scripts/exporting.js",
                    "~/Scripts/Graficos.js",
                    "~/Scripts/renderImagenes.js",
                    "~/Scripts/etiquetaLayout.js"
                    ));

            bundles.Add(new ScriptBundle("~/bundles/DropTabs").Include(
                    "~/Scripts/jquery.droptabs.js"));

            bundles.Add(new ScriptBundle("~/bundles/SlimScroll").Include(
                    "~/Scripts/jquery.slimscroll.js"));

            bundles.Add(new StyleBundle("~/Content/css").Include(
                    "~/Content/animate.css",
                    "~/Content/bootstrap.min.css",
                    "~/Content/style.css",
                    "~/Content/font-awesome.min.css",
                    "~/Content/kendo.office365.min.css",
                    "~/Content/kendo.common.min.css"));
            bundles.Add(new ScriptBundle("~/bundles/kendo").Include(
                    "~/Scripts/kendo.all.min.js"));
            bundles.Add(new ScriptBundle("~/bundles/d3").Include(
                    "~/Scripts/d3.min.js"));
        }
    }
}
