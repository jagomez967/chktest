using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Reporting.ViewModels
{
    public class MetricasNivelViewModel
    {
        public MetricasNivelViewModel()
        {
            this.data = new List<MetricaDataViewModel>();
        }
        public bool usaTotal { get; set; }
        public double valorTotalAVG { get; set; }
        public double valorVarianzaTotal { get; set; }
        public string color { get; set; }
        public int nivel { get; set; }
        public List<MetricaDataViewModel> data { get; set; }
    }
    public class MetricaDataViewModel
    {
        public int id { get; set; }
        public double valor { get; set; }
        public double varianza { get; set; }
        public string logo { get; set; }
        public string color { get; set; }
        public int parentId { get; set; }
    }
}