using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Reporting.Domain.Abstract
{
    public interface ILenguajeRepository
    {
        List<KeyValuePair<string, string>> GetDiccionario(string idioma, string view);
    }
}
