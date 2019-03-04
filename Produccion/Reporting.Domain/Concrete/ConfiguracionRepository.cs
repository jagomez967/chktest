using System;
using System.Collections.Generic;
using System.Linq;
using Reporting.Domain.Abstract;
using Reporting.Domain.Entities;
using System.Text;
using System.Threading.Tasks;

namespace Reporting.Domain.Concrete
{
    public class ConfiguracionRepository:IConfiguracionRepository
    {
        private RepContext context = new RepContext();
        public bool EdicionSimpleUsuario(Usuario user)
        {
            try
            {
                Usuario usuario = new Usuario();
                usuario = context.Usuario.FirstOrDefault(u => u.IdUsuario == user.IdUsuario);
                usuario.Nombre = user.Nombre;
                usuario.Apellido = user.Apellido;

                context.Entry(usuario);
                context.SaveChanges();
                
                return true;
            }
            catch (Exception)
            {
                return false;
            }
        }
    }
}

