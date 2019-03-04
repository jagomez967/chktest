using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Reporting.Domain.Entities
{
    public class SimpleFamilyClient
    {
        public int Id { get; set; }
        public string Familia { get; set; }
        public string DisplayText { get; set; }
        public string DisplayTextBoard { get; set; }
    }
}
