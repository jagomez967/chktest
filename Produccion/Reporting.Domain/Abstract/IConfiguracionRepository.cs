using Reporting.Domain.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Reporting.Domain.Abstract
{
    public interface IConfiguracionRepository
    {
        bool EdicionSimpleUsuario(Usuario user);
    }
}