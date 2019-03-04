using System.Collections.Generic;
using Reporting.Domain.Concrete;
using Microsoft.AspNet.Identity;

namespace Reporting.MyHelpers
{
    public static class MyHelpers
    {
        public static bool IsInRole(string permiso)
        {
            UsuarioRepository usuarioRepository = new UsuarioRepository();

            var userId = System.Web.HttpContext.Current.User.Identity.GetUserId<int>();
            int clienteId = 0;

            var dict = (Dictionary<int, int>)System.Web.HttpContext.Current.Session["ClientesUsuarios"];

            if (dict != null && dict.ContainsKey(userId))
            {
                clienteId = dict[userId];
            }

            if (!usuarioRepository.IsAuthorized(clienteId, userId, permiso))
            {
                return false;
            }

            return true;
        }
    }
}