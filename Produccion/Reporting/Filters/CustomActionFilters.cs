using Reporting.Domain.Concrete;
using System.Web.Mvc;
using Microsoft.AspNet.Identity;
using System.Collections.Generic;

namespace Reporting.Filters
{
    public class Autorizar : ActionFilterAttribute
    {
        public string Permiso { get; set; }
        public override void OnActionExecuting(ActionExecutingContext filterContext)
        {
            if (filterContext.ActionDescriptor.IsDefined(typeof(AllowAnonymousAttribute), false) || filterContext.ActionDescriptor.ControllerDescriptor.IsDefined(typeof(AllowAnonymousAttribute), true))
            {
                base.OnActionExecuting(filterContext);
                return;
            }

            UsuarioRepository usuarioRepository = new UsuarioRepository();
            ClienteRepository clienteRepository = new ClienteRepository();

            var userId = System.Web.HttpContext.Current.User.Identity.GetUserId<int>();
            int userIdPerformance = usuarioRepository.GetUsuarioPerformance(userId);

            int clienteId = 0;

            if (System.Web.HttpContext.Current.Session["ClientesUsuarios"] == null)
            {
                System.Web.HttpContext.Current.Session["ClientesUsuarios"] = new Dictionary<int, int>();
            }

            var dict = (Dictionary<int, int>)System.Web.HttpContext.Current.Session["ClientesUsuarios"];


            if (!dict.ContainsKey(userId))
            {
                clienteId = usuarioRepository.GetUltimoClienteSeleccionado(userIdPerformance);
                if (clienteId > 0)
                {
                    dict.Add(userId, clienteId);
                }
                else
                {
                    var clienteSel = clienteRepository.GetClientes(userIdPerformance);
                    if (clienteSel == null || clienteSel.Count == 0)
                    {
                        dict.Add(userId, 0);
                        clienteId = 0;
                    }
                    else
                    {
                        dict.Add(userId, clienteSel[0].IdCliente);
                        clienteId = clienteSel[0].IdCliente;
                    }
                }
            }
            else
            {
                clienteId = dict[userId];
            }


            if (!usuarioRepository.IsAuthorized(clienteId, userId, Permiso))
            {
                var ac = new ViewResult
                {
                    ViewName = "_Error501"
                };

                filterContext.Result = ac;
            }
            base.OnActionExecuting(filterContext);
        }
    }
}