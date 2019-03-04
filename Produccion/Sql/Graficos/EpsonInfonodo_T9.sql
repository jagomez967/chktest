IF NOT EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND OBJECT_ID = OBJECT_ID('dbo.EpsonInfonodo_T9'))
   exec('CREATE PROCEDURE [dbo].[EpsonInfonodo_T9] AS BEGIN SET NOCOUNT ON; END')
GO 
alter PROCEDURE [dbo].[EpsonInfonodo_T9] 
 
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
  idMarcaComp int  
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
   
 create table #Clientes  
 (  
  idCliente int  
 )  
  
 create table #Cantidad_Bandejas  
 (  
  idCantidad_Bandeja int  
 )  
 
 CREATE TABLE #Categoria
(
	idCategoria INT
)
  
 declare @cMarcas varchar(max)  
 declare @cProductos varchar(max)  
 declare @cCadenas varchar(max)  
 declare @cZonas varchar(max)  
 declare @cLocalidades varchar(max)  
 declare @cUsuarios varchar(max)  
 declare @cPuntosDeVenta varchar(max)  
 declare @cCompetenciaPrimaria varchar(max)  
 declare @cVendedores varchar(max)  
 declare @cTipoRtm varchar(max)  
 declare @cProvincias varchar(max)  
 declare @cTags varchar(max)  
 declare @cFamilia varchar(max)  
 declare @cTipoPDV varchar(max)  
 declare @cClientes varchar(max)  
 declare @cCantidad_Bandejas varchar(max)  
 DECLARE @cCategoria INT
  
 insert #fechaCreacionReporte (fecha) select clave as fecha from dbo.fnSplitString((select Valores from @Filtros where IdFiltro = 'fltFechaReporte'),',') where isnull(clave,'')<>''    
  
 insert #marcas (idmarca) select clave as idmarca from dbo.fnSplitString((select Valores from @Filtros where IdFiltro = 'fltMarcas'),',') where isnull(clave,'')<>''  
 set @cMarcas = @@ROWCOUNT  
  
 insert #Cantidad_Bandejas (idCantidad_Bandeja) select clave as idCantidad_Bandeja from dbo.fnSplitString((select Valores from @Filtros where IdFiltro = 'fltCantidad_Bandeja'),',') where isnull(clave,'')<>''  
 set @cCantidad_Bandejas = @@ROWCOUNT  
   
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
  
 insert #competenciaPrimaria (idMarcaComp) select clave as idMarcaComp from dbo.fnSplitString((select Valores from @Filtros where IdFiltro = 'fltCompetenciaPrimaria'),',') where isnull(clave,'')<>''  
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
   
 insert #clientes (IdCliente) select clave as idCliente from dbo.fnSplitString((select Valores from @Filtros where IdFiltro = 'fltClientes'),',') where isnull(clave,'')<>''  
 set @cClientes = @@ROWCOUNT 

INSERT  INTO #Categoria (IdCategoria) SELECT clave AS Categoria FROM dbo.fnSplitString((SELECT Valores FROM @Filtros WHERE IdFiltro = 'fltCategoria'),',')WHERE ISNULL(clave,'')<>''
SET @cCategoria = @@ROWCOUNT 
   
 if @cClientes = 0   
 begin  
  insert #clientes(idCliente)   
  select fc.idCliente from familiaClientes fc  
  where familia in (select familia from familiaClientes where idCliente = @idCliente  
         and activo = 1)  
  if @@rowcount = 0  
  BEGIN  
   insert #clientes(idcliente)  
   values ( @idCliente)   
  END  
 end  
   
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
  
 -------------------------------------------------------------------- END (Tablas de trabajo) 
 
  create table #Reporte  
 (  
  id int identity(1,1),
  Fecha_de_Reporte varchar(20), 
  PuntoDeVenta  varchar(200),
  Usuario varchar(200),
  Direccion varchar(200),
  Zona varchar(300),
  Tipo_Nodo varchar(50),
  Impresion  varchar(300),
  Contactos varchar(300),
  Ventas int
 )  
 
 
 insert into #Reporte  ( Fecha_de_Reporte, PuntoDeVenta, Usuario, Direccion, Zona, Tipo_Nodo, Impresion, Contactos,Ventas)
 select Convert(varchar(10),CONVERT(date,r.fechacreacion,106),103) as [Fecha de Reporte],pdv.nombre as [Punto de venta], u.apellido +', '+ u.nombre collate database_default as [Usuario],
	pdv.direccion as [Dirección], z.nombre as [Zona],
	case 
		when md_tipo.Valor1 = 1 then 'ILQQ'
		when md_tipo.Valor2 = 1 then 'EPW'
		when md_tipo.Valor3 = 1 then 'Otras Acciones'
		else ' '
	end	as [Tipo nodo],
	md_imp.Valor4 as [Impresion],
	md_cnt.Valor4 as [Contactos],
	sum(isnull(rp.Cantidad,0)) as [Ventas]
	from reporte r 
	inner join puntodeventa pdv on pdv.idPuntodeventa = r.idPUntodeventa 
	inner join zona z on z.idZona = pdv.idZona
	inner join usuario u on u.idUsuario = r.idUsuario
	inner join reporteProducto rp on rp.idReporte = r.idReporte
	inner join producto p on p.IdProducto = rp.IdProducto 
	inner join cliente c on c.IdEmpresa = r.IdEmpresa 
	left join MD_ReporteModuloItem md_tipo on md_tipo.IdReporte = r.IdReporte
										and md_tipo.IdItem = 11700
	left join MD_ReporteModuloItem md_imp on md_imp.IdReporte = r.IdReporte
										and md_imp.IdItem = 11701
	left join MD_ReporteModuloItem md_cnt on md_cnt.IdReporte = r.IdReporte
										and md_cnt.IdItem = 11702
	where c.idCliente = @idCliente 
		and convert(date,FechaCreacion) between convert(date,@fechaDesde) and convert(date,@fechaHasta)			
			and (isnull(@cZonas,0) = 0 or exists(select 1 from #zonas where idZona = pdv.IdZona))
			and (isnull(@cCadenas,0) = 0 or exists(select 1 from #cadenas where idCadena = pdv.IdCadena))
			and (isnull(@cProvincias,0) = 0 or exists(select 1 from #Provincias where idProvincia in(select idProvincia from localidad where idLocalidad = pdv.idLocalidad)))
			and (isnull(@cLocalidades,0) = 0 or exists(select 1 from #localidades where idLocalidad = pdv.IdLocalidad))
			and (isnull(@cPuntosDeVenta,0) = 0 or exists(select 1 from #puntosdeventa where idPuntoDeVenta = pdv.IdPuntoDeVenta))
			and (isnull(@cUsuarios,0) = 0 or exists(select 1 from #usuarios where idUsuario = r.IdUsuario)) and r.IdUsuario not in (select idUsuario from usuario where escheckpos = 1)
			and (isnull(@cVendedores,0) = 0 or exists(select 1 from PuntoDeVenta_Vendedor pve where pve.IdPuntoDeVenta=r.IdPuntoDeVenta and pve.IdVendedor in (select idVendedor from #vendedores)))
			and (isnull(@cTipoRtm,0) = 0 or exists(select 1 from UsuarioPerfil upe where upe.IdUsuario=r.IdUsuario and upe.IdPerfil in (select IdTipoRTM from #tipoRtm)))
			and (isnull(@cTipoPDV,0) = 0 or exists(select 1 from #TipoPDV where idTipo = pdv.idTipo))			
	group by pdv.nombre, u.apellido + ', ' + u.nombre collate database_default,
	pdv.direccion,z.nombre,Convert(varchar(10),CONVERT(date,r.fechacreacion,106),103),
	case 
		when md_tipo.Valor1 = 1 then 'ILQQ'
		when md_tipo.Valor2 = 1 then 'EPW'
		when md_tipo.Valor3 = 1 then 'Otras Acciones'
		else ' '
	end	,
	md_imp.valor4 ,
	md_cnt.valor4
	
	
	--select * from #Reporte   
	
 --Cantidad de páginas  
 declare @maxpag int  
  
if(@TamañoPagina=0)  
 set @maxpag=1  
else  
 select @maxpag=ceiling(count(*)*1.0/@TamañoPagina) from #Reporte  
  
select @maxpag  

 --Configuracion de columnas  
   
 create table #columnasConfiguracion  
 (  
  name varchar(50),  
  title varchar(50),  
  width int,  
  orden int  
    
 )  
   
 if(@lenguaje='es')  
  insert #columnasConfiguracion (name, title, width,orden) values   
  ('Fecha_de_Reporte','Fecha_de_Reporte',5,1),('PuntoDeVenta','PuntoDeVenta',5,2),('Usuario','Usuario',5,3),  
  ('Direccion','Direccion',5,4),('Zona','Zona',5,5),  
  ('Tipo_Nodo','Tipo_Nodo',5,6), ('Impresion','Impresion',5,7),  ('Contactos','Contactos',5,8),('Ventas','Ventas',5,8)  
   
 if(@lenguaje='en')  
  insert #columnasConfiguracion (name, title, width,orden) values   
    ('Fecha_de_Reporte','Fecha_de_Reporte',5,1),('PuntoDeVenta','PuntoDeVenta',5,2),('Usuario','Usuario',5,3),  
  ('Direccion','Direccion',5,4),('Zona','Zona',5,5),  
  ('Tipo_Nodo','Tipo_Nodo',5,6), ('Impresion','Impresion',5,7),  ('Contactos','Contactos',5,8),('Ventas','Ventas',5,8)  
    
 select name, title, width,orden from #columnasConfiguracion order by orden, name  
   
 ----Datos  
 if(@NumeroDePagina>0)  
  select Fecha_de_Reporte, PuntoDeVenta, Usuario, Direccion, Zona, Tipo_Nodo, Impresion, Contactos,Ventas
  from #Reporte   where id between ((@NumeroDePagina - 1) * @TamañoPagina + 1) and (@NumeroDePagina * @TamañoPagina)
  
   
 if(@NumeroDePagina=0)  
  select  Fecha_de_Reporte, PuntoDeVenta, Usuario, Direccion, Zona, Tipo_Nodo, Impresion, Contactos,Ventas
  from #Reporte where id between ((@maxpag - 1) * @TamañoPagina + 1) and (@maxpag * @TamañoPagina)  

  
 if(@NumeroDePagina<0)  
  select Fecha_de_Reporte, PuntoDeVenta, Usuario, Direccion, Zona, Tipo_Nodo, Impresion, Contactos,Ventas
  from #Reporte
   
end  
--go
--
--
--declare @p2 dbo.FiltrosReporting
--insert into @p2 values(N'fltFechaReporte',N'M,20190101,20190202')
----insert into @p2 values(N'fltpuntosdeventa',N'200657')
-----insert into @p2 values(N'fltusuarios',N'4643')
----insert into @p2 values(N'fltMarcas',N'614')
--
--exec EpsonInfonodo_T9 @IdCliente=222,@Filtros=@p2,@NumeroDePagina=-1,@Lenguaje='es'
