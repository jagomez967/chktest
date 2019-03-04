using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using Ninject;
using Reporting.Domain.Abstract;
using Reporting.Domain.Concrete;

namespace Reporting.Infrastructure
{
    public class NinjectDependencyResolver : IDependencyResolver
    {
        private IKernel kernel;
        public NinjectDependencyResolver(IKernel kernelParam)
        {
            kernel = kernelParam;
            AddBindings();
        }
        public object GetService(Type serviceType)
        {
            return kernel.TryGet(serviceType);
        }
        public IEnumerable<object> GetServices(Type serviceType)
        {
            return kernel.GetAll(serviceType);
        }
        private void AddBindings()
        {
            kernel.Bind<ITableroRepository>().To<TableroRepository>();
            kernel.Bind<IGeoRepository>().To<GeoRepository>();
            kernel.Bind<IUsuarioRepository>().To<UsuarioRepository>();
            kernel.Bind<IClienteRepository>().To<ClienteRepository>();
            kernel.Bind<IImagenesRepository>().To<ImagenesRepository>();
            kernel.Bind<IDatosRepository>().To<DatosRepository>();
            kernel.Bind<IFiltroRepository>().To<FiltroRepository>();
            kernel.Bind<ICommonRepository>().To<CommonRepository>();
            kernel.Bind<IAbmsRepository>().To<AbmsRepository>();
        }
    }
}