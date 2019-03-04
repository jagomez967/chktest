using System.Web.Mvc;
using Reporting.ViewModels;

namespace Reporting.Binders
{

    public class FiltrosModelBinder : DefaultModelBinder
    {
        protected override void OnModelUpdated(ControllerContext controllerContext, System.Web.Mvc.ModelBindingContext bindingContext)
        {
            FiltrosViewModel model = bindingContext.Model as FiltrosViewModel;

            foreach (FiltroCheckViewModel fc in model.FiltrosChecks)
            {
                if (fc.Id != null)
                {
                    if (model.FiltrosChecks[model.FiltrosChecks.IndexOf(fc)].Items == null)
                    {
                        model.FiltrosChecks[model.FiltrosChecks.IndexOf(fc)].Items = new System.Collections.Generic.List<ItemViewModel>();
                    }

                    if (model.FiltrosChecks[model.FiltrosChecks.IndexOf(fc)].Items.Count > 0)
                    {
                        model.FiltrosChecks[model.FiltrosChecks.IndexOf(fc)].Items.RemoveAll(i => !i.Selected);
                    }
                }
            }
            //FILTROS NUEVOS
            //Probar algo nuevo, simplificando el request para los filtros
            //HttpRequestBase request = controllerContext.HttpContext.Request;
            ////List<string> filtros = new List<string>();
            //Dictionary<string,string> filtros = new Dictionary<string, string>();
            //StringComparison comparison = StringComparison.InvariantCulture;
            //string idFiltro = "";

            //foreach (string key in request.Form)
            //{
            //    if (key.StartsWith("F.FC", comparison) ==true)
            //    {
            //        //Si se trata de un filtro, empieza con F.FC y temina con .id
            //        if (key.EndsWith(".id", comparison) ==true)
            //        {
            //            idFiltro = key.Substring(key.IndexOf("[") + 1, key.IndexOf("]") - key.IndexOf("[") -1);
            //            filtros.Add(idFiltro, request.Form[key]);
            //        }
            //    }
            //}

        }
    }
}