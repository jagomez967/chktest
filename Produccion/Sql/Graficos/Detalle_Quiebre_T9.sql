IF NOT EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND OBJECT_ID = OBJECT_ID('dbo.Detalle_Quiebre_T9'))
   exec('CREATE PROCEDURE [dbo].[Detalle_Quiebre_T9] AS BEGIN SET NOCOUNT ON; END')
GO
alter procedure [dbo].[Detalle_Quiebre_T9] 	
 
(  
 @IdCliente   int  
 ,@Filtros   FiltrosReporting readonly  
 ,@NumeroDePagina int = -1  
 ,@Lenguaje   varchar(10) = 'es'  
 ,@IdUsuarioConsulta int = 0  
 ,@TamañoPagina  int = 0  
)  
as  
begin  
/*  
   
 Para filtrar en un query hacer:  
 ===============================  
 * (isnull(@cZonas,0) = 0 or exists(select 1 from #zonas where idZona = p.IdZona))  
 * (isnull(@cCadenas,0) = 0 or exists(select 1 from #cadenas where idCadena = p.IdCadena))  
  
*/    
  
 SET LANGUAGE spanish  
 set nocount on  
  
 if @lenguaje = 'es' set language spanish  
 if @lenguaje = 'en' set language english  
  
 declare @strFDesde varchar(30)  
 declare @strFHasta varchar(30)  
 declare @fechaDesde datetime  
 declare @fechaHasta datetime  
   
 create table #fechaCreacionReporte  
 (  
  id int identity(1,1)  
  ,fecha varchar(10)  
 )  
  
 create table #zonas  
 (  
  idZona int  
 )  
  
 create table #cadenas  
 (  
  idCadena int  
 )  
  
 create table #localidades  
 (  
  idLocalidad int  
 )  
  
 create table #puntosdeventa  
 (  
  idPuntoDeVenta int  
 )  
  
 create table #usuarios  
 (  
  idUsuario int  
 )  
  
 create table #marcas  
 (  
  idMarca int  
 )  
  
 create table #productos  
 (  
  idProducto int  
 )  
  
 create table #competenciaPrimaria  
 (  
  idMarca int  
 )  
  
 create table #vendedores  
 (  
  idVendedor int  
 )  
  
 create table #tipoRtm  
 (  
  idTipoRtm int  
 )  
  
 create table #Provincias  
 (  
  idProvincia int  
 )  
  
 create table #Tags  
 (  
  IdTag int  
 )  
 create table #Familia  
 (  
  idFamilia int  
 )  
 create table #TipoPDV  
 (  
  idTipo int  
 )  
 create table #Categoria  
 (  
  idCategoria int  
 )  
  
 create table #CategoriaProducto  
 (  
  idCategoriaProducto int  
 )  
  
create table #SubCategoria
(
	idSubCategoria int
)
  
 declare @cMarcas  int = 0
 declare @cProductos int = 0
 declare @cCadenas int = 0
 declare @cZonas int = 0
 declare @cLocalidades int = 0
 declare @cUsuarios int = 0
 declare @cPuntosDeVenta int = 0
 declare @cCompetenciaPrimaria int = 0
 declare @cVendedores int = 0
 declare @cTipoRtm int = 0  
 declare @cProvincias int = 0
 declare @cTags int = 0 
 declare @cFamilia int = 0
 declare @cTipoPDV int = 0
 declare @cCategoria int = 0
 declare @cCategoriaProducto int = 0
 declare @cSubCategoria int = 0
  
 insert #fechaCreacionReporte (fecha) select clave as fecha from dbo.fnSplitString((select Valores from @Filtros where IdFiltro = 'fltFechaReporte'),',') where isnull(clave,'')<>''    
  
 insert #marcas (idmarca) select clave as idmarca from dbo.fnSplitString((select Valores from @Filtros where IdFiltro = 'fltMarcas'),',') where isnull(clave,'')<>''  
 set @cMarcas = @@ROWCOUNT  
   
 insert #productos (idproducto) select clave as idproducto from dbo.fnSplitString((select Valores from @Filtros where IdFiltro = 'fltProductos'),',') where isnull(clave,'')<>''  
 set @cProductos = @@ROWCOUNT  
   
 insert #cadenas (idCadena) select clave as idCadena from dbo.fnSplitString((select Valores from @Filtros where IdFiltro = 'fltCadenas'),',') where isnull(clave,'')<>''  
 set @cCadenas = @@ROWCOUNT  
  
 insert #zonas (idZona) select clave as idZona from dbo.fnSplitString((select Valores from @Filtros where IdFiltro = 'fltZonas'),',') where isnull(clave,'')<>''  
 set @cZonas = @@ROWCOUNT  
  
 insert #localidades (idLocalidad) select clave as idLocalidad from dbo.fnSplitString((select Valores from @Filtros where IdFiltro = 'fltLocalidades'),',') where isnull(clave,'')<>''  
 set @cLocalidades = @@ROWCOUNT  
  
 insert #usuarios (idUsuario) select clave as idUsuario from dbo.fnSplitString((select Valores from @Filtros where IdFiltro = 'fltUsuarios'),',') where isnull(clave,'')<>''  
 set @cUsuarios = @@ROWCOUNT  
  
 insert #puntosdeventa (idPuntoDeVenta) select clave as idPuntoDeVenta from dbo.fnSplitString((select Valores from @Filtros where IdFiltro = 'fltPuntosDeVenta'),',') where isnull(clave,'')<>''  
 set @cPuntosDeVenta = @@ROWCOUNT  
  
 insert #competenciaPrimaria (idMarca) select clave as idMarca from dbo.fnSplitString((select Valores from @Filtros where IdFiltro = 'fltCompetenciaPrimaria'),',') where isnull(clave,'')<>''  
 set @cCompetenciaPrimaria = @@ROWCOUNT  
  
 insert #vendedores (idVendedor) select clave as idVendedor from dbo.fnSplitString((select Valores from @Filtros where IdFiltro = 'fltVendedores'),',') where isnull(clave,'')<>''  
 set @cVendedores = @@ROWCOUNT  
  
 insert #tipoRtm (idTipoRtm) select clave as idTipoRtm from dbo.fnSplitString((select Valores from @Filtros where IdFiltro = 'fltTipoDeRTM'),',') where isnull(clave,'')<>''  
 set @cTipoRtm = @@ROWCOUNT  
  
 insert #Provincias (idProvincia) select clave as idTipoRtm from dbo.fnSplitString((select Valores from @Filtros where IdFiltro = 'fltProvincias'),',') where isnull(clave,'')<>''  
 set @cProvincias = @@ROWCOUNT  
  
 insert #Tags (IdTag) select clave as idTipoRtm from dbo.fnSplitString((select Valores from @Filtros where IdFiltro = 'fltTags'),',') where isnull(clave,'')<>''  
 set @cTags = @@ROWCOUNT  
   
 insert #Familia (IdFamilia) select clave as idFamilia from dbo.fnSplitString((select Valores from @Filtros where IdFiltro = 'fltFamilia'),',') where isnull(clave,'')<>''  
 set @cFamilia = @@ROWCOUNT  
   
 insert #TipoPDV (IdTipo) select clave as idTipo from dbo.fnSplitString((select Valores from @Filtros where IdFiltro = 'fltTipoPDV'),',') where isnull(clave,'')<>''  
 set @cTipoPDV = @@ROWCOUNT  
   
 insert #Categoria (IdCategoria) select clave as Categoria from dbo.fnSplitString((select Valores from @Filtros where IdFiltro = 'fltCategoria'),',') where isnull(clave,'')<>''  
 set @cCategoria = @@ROWCOUNT  
  
 insert #CategoriaProducto (idCategoriaProducto) select clave as CategoriaProducto from dbo.fnSplitString((select Valores from @Filtros where IdFiltro = 'fltCategoriaProducto'),',') where isnull(clave,'')<>''  
 set @cCategoriaProducto = @@ROWCOUNT  
  
insert #SubCategoria (idSubCategoria) select clave as idSubCategoria from dbo.fnSplitString((select Valores from @Filtros where IdFiltro = 'fltSubCategoria'),',') where isnull(clave,'')<>''
set @cSubCategoria = @@ROWCOUNT

 select @strFDesde = fecha from #fechaCreacionReporte where id = 2  
 select @strFHasta = fecha from #fechaCreacionReporte where id = 3  
  
 if(@strFDesde='00010101' or @strFDesde is null)  
  set @fechaDesde = DATEADD(month, DATEDIFF(month, 0, GETDATE()), 0)  
 else  
  select @fechaDesde=fecha from #fechaCreacionReporte where id = 2  
  
 if(@strFHasta='00010101' or @strFHasta is null)  
  set @fechaHasta = getdate()  
 else  
  select @fechaHasta =  fecha from #fechaCreacionReporte where id = 3  
  
      
 create table #Equipo  
 (  
  idEquipo int  
 )  
  
 declare @cEquipo varchar(max)  
  
 insert #Equipo (idEquipo) select clave as idTipo from dbo.fnSplitString((select Valores from @Filtros where IdFiltro = 'fltEquipo'),',') where isnull(clave,'')<>''  
 set @cEquipo = @@ROWCOUNT  
  
 -------------------------------------------------------------------- END (Filtros) ----------------------------------------------------------------  
  
  
 create table #Meses  
 (  
  mes varchar(8)  
 )  
  
 create table #datos  
 (  
  idEmpresa int,  
  idMarca int,  
  idProducto int,  
  mes varchar(8),  
  quiebre varchar(1)  
 )  
  
 create table #MesesProductos  
 (  
  idEmpresa int,  
  idMarca int,  
  idProducto int,  
  mes varchar(8)  
 )  
  
 create table #datosFinal  
 (  
  id int identity(1,1),  
  fecharep varchar(20),  
  pdv varchar(300),  
  direccion varchar(300),  
  cadena varchar(300),  
  zona varchar(100),  
  rtm varchar(200),  
  marca varchar(50),  
  producto varchar(100),  
  equipo varchar(100),  
  vendedor varchar(100),  
  idReporte int,  
  quiebre int  
 )  
   
 create table #reportesMesPdv  
 (  
  idEmpresa int,  
  idPuntoDeVenta int,  
  mes varchar(20),  
  idReporte int,  
  idusuario int  
 )  
 -------------------------------------------------------------------- END (Temp)  
   
 insert #reportesMesPdv (idPuntoDeVenta, idEmpresa, mes, idReporte,idusuario)  
 select distinct r.idpuntodeventa, r.IdEmpresa, left(convert(varchar,r.fechacreacion,112),6), max(r.idreporte),r.IdUsuario  
 from Reporte r  
 inner join PuntoDeVenta pdv on pdv.IdPuntoDeVenta=r.IdPuntoDeVenta  
 inner join Cliente c on c.IdEmpresa=r.IdEmpresa  
 where c.IdCliente=@IdCliente  
   and convert(date,r.FechaCreacion) between convert(date,@fechaDesde) and convert(date,@fechaHasta)  
   and (isnull(@cZonas,0) = 0 or exists(select 1 from #zonas where idZona = pdv.IdZona))  
   and (isnull(@cCadenas,0) = 0 or exists(select 1 from #cadenas where idCadena = pdv.IdCadena))  
   and (isnull(@cLocalidades,0) = 0 or exists(select 1 from #localidades where idLocalidad = pdv.IdLocalidad))  
   and (isnull(@cPuntosDeVenta,0) = 0 or exists(select 1 from #puntosdeventa where idPuntoDeVenta = pdv.IdPuntoDeVenta))  
   and (isnull(@cUsuarios,0) = 0 or exists(select 1 from #usuarios where idUsuario = r.IdUsuario)) and r.IdUsuario not in (select idUsuario from usuario where escheckpos = 1)  
   and (isnull(@cVendedores,0) = 0 or exists(select 1 from PuntoDeVenta_Vendedor pve where pve.IdPuntoDeVenta=r.IdPuntoDeVenta and pve.IdVendedor in (select idVendedor from #vendedores)))  
   and (isnull(@cTipoRtm,0) = 0 or exists(select 1 from UsuarioPerfil upe where upe.IdUsuario=r.IdUsuario and upe.IdPerfil in (select IdTipoRTM from #tipoRtm)))     
   and (isnull(@cTipoPDV,0) = 0 or exists(select 1 from #TipoPDV where idTipo = pdv.idTipo))     
   and (isnull(@cCategoria,0) = 0 or exists(select 1 from #Categoria where idCategoria = pdv.idCategoria))  
   and (isnull(@cProvincias,0) = 0 or exists(select 1 from #provincias pro where pro.idProvincia in(select idProvincia from localidad loc where loc.idLocalidad = pdv.idLocalidad)))  
   and (isnull(@cEquipo,0) = 0 or exists(select 1 from puntodeventa_Vendedor pve2 where pve2.idPuntodeventa = pdv.idPuntodeventa  and pve2.idVendedor  
    in(select idVendedor from vendedor where idEquipo in(select idEquipo from #Equipo))))  
 group by r.IdPuntoDeVenta, r.IdEmpresa, r.IdUsuario, left(convert(varchar,r.fechacreacion,112),6)---left(convert(varchar,r.fechacreacion,112),6)  
   
 ---select * from #reportesMesPdv  
   
 insert #datosFinal (fecharep, pdv, direccion, cadena, zona, rtm, marca, producto, equipo, vendedor,idReporte, quiebre)  
 select convert(varchar,r.FechaCreacion,103) as FechaRep  
      ,cast(pdv.IdPuntoDeVenta as varchar) + ' - ' + ltrim(rtrim(pdv.Nombre)) as Pdv  
   ,ltrim(rtrim(pdv.direccion)) as Direccion  
   ,ltrim(rtrim(ca.Nombre)) as Cadena  
   ,ltrim(rtrim(z.nombre)) as Zona  
   ,ltrim(rtrim(u.Apellido)) + ', ' + ltrim(rtrim(u.Nombre)) COLLATE DATABASE_DEFAULT as Rtm  
   ,ltrim(rtrim(m.nombre)) as Marca  
   ,ltrim(rtrim(p.Nombre)) as Producto  
   ,ltrim(rtrim(eq.Nombre)) as Equipo  
   ,ltrim(rtrim(v.Nombre)) as Vendedor  
   ,a.idReporte  
   ,1  
 from reporte r  
 inner join #reportesMesPdv a on r.idreporte = a.idReporte  
 inner join ReporteProducto rp on rp.IdReporte=r.IdReporte  
 inner join Producto p on p.IdProducto=rp.IdProducto  
 inner join Marca m on m.IdMarca=p.IdMarca  
 inner join PuntoDeVenta pdv on pdv.IdPuntoDeVenta=a.IdPuntoDeVenta  
 inner join Cliente c on c.IdEmpresa=r.IdEmpresa  
 inner join zona z on z.IdZona=pdv.IdZona  
 inner join Usuario u on u.IdUsuario=r.IdUsuario  
 left join PuntoDeVenta_Vendedor pdvv on pdvv.idPuntoDeVenta = r.idPuntoDeVenta  
 left join Vendedor v on v.idVendedor = pdvv.idVendedor  
 left join Equipo eq on eq.idEquipo = v.idEquipo  
 left join Cadena ca on ca.idCadena = pdv.idCadena  
 where  (isnull(@cMarcas,0) = 0 or exists(select 1 from #marcas where idMarca = p.IdMarca))  
   and (isnull(@cProductos,0) = 0 or exists(select 1 from #productos where idProducto = p.IdProducto))  
   and (isnull(@cCategoriaProducto,0) = 0 or exists(select 1 from #CategoriaProducto where idCategoriaProducto = p.idCategoria))  
   and (isnull(@cFamilia,0) = 0 or exists(select 1 from #Familia where idFamilia = p.IdFamilia))   
   and (isnull(@cCompetenciaPrimaria,0) = 0 or exists (select 1 from #CompetenciaPrimaria where idMarca = p.idMarca))   
 and isnull(rp.stock,0)>0  
 and (isnull(@cSubCategoria,0) = 0 or exists(select 1 from #SubCategoria sc
														  inner join subCategoriaProducto scp 
																on sc.idSubCategoria = scp.idSubCategoria
														 where scp.idProducto = rp.IdProducto))
 ---order by convert(varchar,r.FechaCreacion,103), r.IdPuntoDeVenta, m.IdMarca, p.IdProducto   
 union  
 select convert(varchar,r.FechaCreacion,103) as FechaRep  
      ,cast(pdv.IdPuntoDeVenta as varchar) + ' - ' + ltrim(rtrim(pdv.Nombre)) as Pdv  
   ,ltrim(rtrim(pdv.direccion)) as Direccion  
   ,ltrim(rtrim(ca.Nombre)) as Cadena  
   ,ltrim(rtrim(z.nombre)) as Zona  
   ,ltrim(rtrim(u.Apellido)) + ', ' + ltrim(rtrim(u.Nombre)) COLLATE DATABASE_DEFAULT as Rtm  
   ,ltrim(rtrim(m.nombre)) as Marca  
   ,ltrim(rtrim(p.Nombre)) as Producto  
   ,ltrim(rtrim(eq.Nombre)) as Equipo  
   ,ltrim(rtrim(v.Nombre)) as Vendedor  
   ,a.idReporte  
   ,0  
 from reporte r  
 inner join #reportesMesPdv a on r.idreporte = a.idReporte  
 inner join ReporteProducto rp on rp.IdReporte=r.IdReporte  
 inner join Producto p on p.IdProducto=rp.IdProducto  
 inner join Marca m on m.IdMarca=p.IdMarca  
 inner join PuntoDeVenta pdv on pdv.IdPuntoDeVenta=a.IdPuntoDeVenta  
 inner join Cliente c on c.IdEmpresa=r.IdEmpresa  
 inner join zona z on z.IdZona=pdv.IdZona  
 inner join Usuario u on u.IdUsuario=r.IdUsuario  
 left join PuntoDeVenta_Vendedor pdvv on pdvv.idPuntoDeVenta = r.idPuntoDeVenta  
 left join Vendedor v on v.idVendedor = pdvv.idVendedor  
 left join Equipo eq on eq.idEquipo = v.idEquipo  
 left join Cadena ca on ca.idCadena = pdv.idCadena  
 where  (isnull(@cMarcas,0) = 0 or exists(select 1 from #marcas where idMarca = p.IdMarca))  
   and (isnull(@cProductos,0) = 0 or exists(select 1 from #productos where idProducto = p.IdProducto))  
   and (isnull(@cCategoriaProducto,0) = 0 or exists(select 1 from #CategoriaProducto where idCategoriaProducto = p.idCategoria))  
   and (isnull(@cFamilia,0) = 0 or exists(select 1 from #Familia where idFamilia = p.IdFamilia))   
   and (isnull(@cCompetenciaPrimaria,0) = 0 or exists (select 1 from #CompetenciaPrimaria where idMarca = p.idMarca))   
 and isnull(rp.stock,0)=0  
 and (isnull(@cSubCategoria,0) = 0 or exists(select 1 from #SubCategoria sc
														  inner join subCategoriaProducto scp 
																on sc.idSubCategoria = scp.idSubCategoria
														 where scp.idProducto = rp.IdProducto))

   
  
 declare @maxpag int  
 if(@TamañoPagina=0)  
  set @maxpag=1  
 else  
  select @maxpag=ceiling(count(*)*1.0/@TamañoPagina) from #datosFinal  
 select @maxpag  
  
 --Configuracion de columnas  
 create table #columnasConfiguracion  
 (  
  name varchar(50),  
  title varchar(50),  
  width int  
 )  
  
if(@lenguaje='es')  
BEGIN
if (@IdCliente=262)
begin
insert #columnasConfiguracion (name, title, width) values ('fecharep','Fecha',5),('pdv','PDV',5),('direccion','Dirección',5),('cadena','Cadena',5),('zona','Zona',5),('rtm','RTM',5),('marca','Marca',5),('producto','Producto',10),('equipo','Equipo',10),('vendedor','Vendedor',10),('quiebre','Presencia',10) 
end

if (@IdCliente!=262)
begin
insert #columnasConfiguracion (name, title, width) values ('fecharep','Fecha',5),('pdv','PDV',5),('direccion','Dirección',5),('cadena','Cadena',5),('zona','Zona',5),('rtm','RTM',5),('marca','Marca',5),('producto','Producto',10),('equipo','Equipo',10),('vendedor','Vendedor_',10),('quiebre','Quiebre',10)  
end
END 
 
 if(@lenguaje='en')  
BEGIN
  insert #columnasConfiguracion (name, title, width) values ('fecharep','Date',5),('pdv','POS',5),('direccion','Address',5),('cadena','Retail',5),('zona','Zone',5),('rtm','RTM',5),('marca','Branch',5),('producto','Product',10),('equipo','Team',10),('vendedor','Salesman',10),('quiebre','quiebre',10)  
END 
 
 select name, title, width from #columnasConfiguracion  
  
 --Datos  
 if(@NumeroDePagina>0)  
  select fecharep, pdv, direccion, cadena, zona, rtm, marca, producto, equipo, vendedor,quiebre from #datosFinal where id between ((@NumeroDePagina - 1) * @TamañoPagina + 1) and (@NumeroDePagina * @TamañoPagina)  
   
 if(@NumeroDePagina=0)  
  select fecharep, pdv, direccion, cadena, zona, rtm, marca, producto, equipo, vendedor,quiebre from #datosFinal where id between ((@maxpag - 1) * @TamañoPagina + 1) and (@maxpag * @TamañoPagina)  
    
 if(@NumeroDePagina<0)  
  select fecharep, pdv, direccion, cadena, zona, rtm, marca, producto, equipo, vendedor,quiebre from #datosFinal  
  
end  

go

