IF NOT EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND OBJECT_ID = OBJECT_ID('dbo.Whirpool_FS_Por_Categoria_Cocina_T9'))
   exec('CREATE PROCEDURE [dbo].[Whirpool_FS_Por_Categoria_Cocina_T9] AS BEGIN SET NOCOUNT ON; END')
GO 
alter PROCEDURE [dbo].[Whirpool_FS_Por_Categoria_Cocina_T9] 
 
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
  idPuntoDeVenta int, 
  IdEmpresa  int,
  idReporte int,  
  idUsuario int,
  Usuario varchar(300),
  mes varchar(50)
 )  
 
 create table #asignados
	(
		idUsuario int
		,qty_asignados int
		
	)

	create table #Relevados
	(
		idUsuario int
		,qty_relevados int
		,fecha datetime
	)
	
	create table #Visitados
	(
		idUsuario int
		,qty int
	)
	create table #maxidasignado
	(
		idCliente int,
		idUsuario int,
		IdPuntoDeVenta int,
		idMaxAsignado int
	)

	create table #tempReporte
	(
		idCliente int,
		idUsuario int,
		IdPuntoDeVenta int,
		mes date,
		idReporte int
	)
   
   
  -------------------------------------------------------------------- END (Tablas de trabajo)  
  /*busco asigandos*/
  insert #maxidasignado (idCliente, idUsuario, IdPuntoDeVenta, idMaxAsignado)
		select	pcu.IdCliente
				,pcu.IdUsuario
				,pcu.IdPuntoDeVenta
				,max(pcu.IdPuntoDeVenta_Cliente_Usuario) as id
		from PuntoDeVenta_Cliente_Usuario pcu
		inner join PuntoDeVenta p on p.IdPuntoDeVenta = pcu.IdPuntoDeVenta
		inner join usuario_cliente cu on cu.idcliente=pcu.idcliente and pcu.idusuario=cu.idusuario
		where convert(date,Fecha)<=convert(date,@fechaHasta)
		and pcu.idCliente = @idcliente
		and (isnull(@cZonas,0) = 0 or exists(select 1 from #zonas where idZona = p.IdZona))
		and (isnull(@cCadenas,0) = 0 or exists(select 1 from #cadenas where idCadena = p.IdCadena))
		and (isnull(@cLocalidades,0) = 0 or exists(select 1 from #localidades where idLocalidad = p.IdLocalidad))
		and (isnull(@cPuntosDeVenta,0) = 0 or exists(select 1 from #puntosdeventa where idPuntoDeVenta = p.IdPuntoDeVenta))
		and (isnull(@cUsuarios,0) = 0 or exists(select 1 from #usuarios where idUsuario = pcu.IdUsuario)) and pcu.IdUsuario not in (select idUsuario from usuario where escheckpos = 1)
		and (isnull(@cTipoRtm,0) = 0 or exists(select 1 from UsuarioPerfil upe where upe.IdUsuario=pcu.IdUsuario and upe.IdPerfil in (select IdTipo from #tipoRtm)))
		and (isnull(@cTipoPDV,0) = 0 or exists(select 1 from #TipoPDV where idTipo = p.idTipo))
	group by pcu.idCliente, pcu.idUsuario, pcu.idPuntoDeVenta

		delete from #maxidasignado where exists (select 1 from PuntoDeVenta_Cliente_Usuario p where p.IdPuntoDeVenta_Cliente_Usuario=#maxidasignado.idMaxAsignado and p.Activo=0)

		insert #asignados (idUsuario, qty_asignados)
		select idUsuario, count(distinct IdPuntoDeVenta)
		from #maxidasignado group by idUsuario
		
	/*busco relevados*/
	insert #tempReporte (idCliente, idUsuario, IdPuntoDeVenta, mes, idReporte)
	select	c.IdCliente
			,r.IdUsuario
			,r.IdPuntoDeVenta
			,convert(date,r.Fechacreacion)
			,max(r.idReporte)
	from reporte r
	inner join PuntoDeVenta p on p.IdPuntoDeVenta=r.IdPuntoDeVenta
	inner join Cliente c on c.idempresa = r.idempresa
	inner join usuario_cliente cu on cu.idcliente=c.idcliente and cu.idusuario=r.idusuario
	where convert(date,FechaCreacion) between convert(date,@fechaDesde) and convert(date,@fechaHasta)
	and c.idCliente = @idcliente
	and (isnull(@cZonas,0) = 0 or exists(select 1 from #zonas where idZona = p.IdZona))
	and (isnull(@cCadenas,0) = 0 or exists(select 1 from #cadenas where idCadena = p.IdCadena))
	and (isnull(@cLocalidades,0) = 0 or exists(select 1 from #localidades where idLocalidad = p.IdLocalidad))
	and (isnull(@cPuntosDeVenta,0) = 0 or exists(select 1 from #puntosdeventa where idPuntoDeVenta = p.IdPuntoDeVenta))
	and (isnull(@cUsuarios,0) = 0 or exists(select 1 from #usuarios where idUsuario = r.IdUsuario)) and r.IdUsuario not in (select idUsuario from usuario where escheckpos = 1)
	and (isnull(@cTipoRtm,0) = 0 or exists(select 1 from UsuarioPerfil upe where upe.IdUsuario=r.IdUsuario and upe.IdPerfil in (select IdTipo from #tipoRtm)))
	and (isnull(@cTipoPDV,0) = 0 or exists(select 1 from #TipoPDV where idTipo = p.idTipo))
	group by c.IdCliente ,r.idReporte ,r.IdUsuario ,r.IdPuntoDeVenta ,r.Fechacreacion


	insert #Relevados (qty_relevados, idusuario)
	select count(distinct IdPuntoDeVenta), idusuario
	from #tempReporte group by idusuario
	
	insert #Visitados (idUsuario, qty)
	select idUsuario, count(IdPuntoDeVenta) from #tempReporte group by idUsuario
	
	
   --------------------------------------------------------------------------------------------------------
   
	insert #Reporte (idReporte, idPuntoDeVenta,IdEmpresa,idUsuario, Usuario,mes  )  
	SELECT DISTINCT MAX(R.idReporte) idReporte,R.idPuntoDeVenta,R.idEmpresa,U.idusuario,ltrim(rtrim(u.nombre)) + '-' + ltrim(rtrim(u.apellido)) collate database_default,left(convert(varchar,r.fechacreacion,112),6) as mes
	FROM
		Reporte R
		INNER JOIN PuntoDeVenta PDV ON PDV.IdPuntoDeVenta = R.IdPuntoDeVenta
		INNER JOIN Cliente C ON C.IdEmpresa = R.IdEmpresa
		INNER JOIN Usuario U on U.idusuario = R.IdUsuario
	WHERE 
		CONVERT(DATE,R.FechaCreacion) >= @FechaDesde
		AND CONVERT(DATE,R.FechaCreacion) <= @FechaHasta
		AND C.idCliente = @idCliente
		AND (ISNULL(@cZonas,0) = 0 OR EXISTS (SELECT 1 FROM #zonas WHERE idZona = PDV.IdZona))
		AND (ISNULL(@cCadenas,0) = 0 OR EXISTS (SELECT 1 FROM #cadenas WHERE idCadena = PDV.IdCadena))
		AND (ISNULL(@cLocalidades,0) = 0 OR EXISTS (SELECT 1 FROM #localidades WHERE idLocalidad = PDV.IdLocalidad))
		AND (ISNULL(@cPuntosDeVenta,0) = 0 OR EXISTS (SELECT 1 FROM #puntosdeventa WHERE idPuntoDeVenta = PDV.IdPuntoDeVenta))
		
		AND (ISNULL(@cCategoria,0) = 0 OR EXISTS(SELECT 1 FROM #Categoria WHERE idCategoria = PDV.idCategoria))
		AND (ISNULL(@cTipoPDV,0) = 0 OR EXISTS(SELECT 1 FROM #TipoPDV WHERE idTipo = pdv.idTipo))
	GROUP BY
		LEFT(DATENAME(MONTH,R.FechaCreacion),3) + '-' + RIGHT(YEAR(R.FechaCreacion),2),
		R.idPuntoDeVenta,
		R.idEmpresa,
		U.idusuario,
		ltrim(rtrim(u.nombre)) + '-' + ltrim(rtrim(u.apellido)) collate database_default,
		left(convert(varchar,r.fechacreacion,112),6)
			
	  Create table #Floor_Share
		(
		id_usuario int,
		usuario varchar(300),
		cantidad_fs int,
		Marca_fs varchar(200),
		mes varchar(50),
		marca int,
		id_marca int
		)
	
			
	insert into #Floor_Share(id_marca, id_usuario,usuario, cantidad_fs,Marca_fs,mes,marca)
	SELECT ---Marca competencia
		M.idMarca,R.idUsuario, R.Usuario,SUM(ISNULL(RPOP.Cantidad,0)) qty,m.nombre,r.mes,0
	FROM 
		#Reporte R
		INNER JOIN ReportePop RPOP ON R.idReporte = RPOP.idReporte
		INNER JOIN Pop POP ON RPOP.idPop = POP.idPop
		INNER JOIN GrupoPop GPOP ON POP.idGrupoPop = GPOP.idGrupoPop
		INNER JOIN Pop_Marca MPOP ON POP.idPop = MPOP.idPop
		INNER JOIN Marca M ON MPOP.idMarca = M.idMarca
		INNER JOIN PuntoDeVenta PDV ON R.idPuntoDeVenta = PDV.idPuntoDeVenta
	WHERE 
		R.idEmpresa = 930 
		AND (ISNULL(@cMarcas,0) = 0 OR EXISTS(SELECT 1 FROM #marcas WHERE idMarca = M.IdMarca))
	GROUP BY
		M.idMarca,R.idUsuario, R.Usuario,m.nombre,r.mes
	union	
	SELECT  --Marca Propia
	M.idMarca,R.idUsuario, R.Usuario,SUM(ISNULL(RP.Cantidad,0) + ISNULL(RP.Cantidad2,0)) qty,m.nombre,r.mes,1
	FROM
		#Reporte R
		INNER JOIN ReporteProducto RP ON R.idReporte = RP.idReporte
		INNER JOIN Producto P ON RP.idProducto = P.idProducto
		INNER JOIN Marca M ON P.idMarca = M.idMarca
		
	WHERE
		R.idEmpresa = 930 
		AND (ISNULL(@cMarcas,0) = 0 OR EXISTS(SELECT 1 FROM #marcas WHERE idMarca = M.IdMarca))
	GROUP BY
		M.idMarca,R.idUsuario, R.Usuario,m.nombre,r.mes
	ORDER BY
		qty
		
		
	
	Create table #Floor_Share_qty
		(
		mes varchar(30),
		id_usuario int,
		usuario varchar(300),
		qty varchar(300),
		cantidad_fs decimal(5,2),
		Marca_fs varchar(200)
		)
		
	insert into #Floor_Share_qty(id_usuario,usuario,qty,cantidad_fs,Marca_fs)		
	select id_usuario,usuario, 
	CONVERT(int,CONVERT(NUMERIC(18,2),CONVERT(NUMERIC(18,2),100 * SUM(F.cantidad_fs)))),
	case when 
	(CONVERT(decimal(5,2),CONVERT(NUMERIC(18,2),CONVERT(NUMERIC(18,2),100 * sum(F.cantidad_fs))) / nullif((SELECT isnull(SUM(cantidad_fs),0) FROM #Floor_Share where f.id_usuario= id_usuario and f.id_marca = id_marca),0))) = 0 
	then 0 else 
	(CONVERT(decimal(5,2),CONVERT(NUMERIC(18,2),CONVERT(NUMERIC(18,2),100 * sum(F.cantidad_fs))) / nullif((SELECT isnull(SUM(cantidad_fs),0) FROM #Floor_Share where f.id_usuario= id_usuario and f.id_marca = id_marca),0)))
	end,
	Marca_fs
	from #Floor_Share f
	where f.marca = 1
	AND (ISNULL(@cUsuarios,0) = 0 OR EXISTS (SELECT 1 FROM #usuarios WHERE idUsuario = f.id_usuario)) AND f.id_usuario NOT IN (SELECT idUsuario FROM usuario WHERE escheckpos = 1)
	AND (ISNULL(@cMarcas,0) = 0 OR EXISTS(SELECT 1 FROM #marcas WHERE idMarca = f.id_marca))
	
	group by id_usuario,usuario,Marca_fs,id_marca
		
	
		
	Create table #Datos_final
		(
		id int identity(1,1),
		RTM varchar(300),
		Categoria varchar(300),
		Floor_Share varchar(300),
		Asignados int,
		Relevados int,
		Visitados int
		)
		
		
	insert into #Datos_final (RTM, Categoria, Floor_Share, Asignados,Relevados,Visitados)
	select f.usuario, f.Marca_fs, convert(varchar(300),f.cantidad_fs) + '%',a.qty_asignados, r.qty_relevados, v.qty
	from #Floor_Share_qty f
	inner join #asignados a on a.idUsuario = F.id_usuario
	inner join #Relevados r on r.idUsuario = F.id_usuario
	inner join #Visitados v on v.idUsuario = F.id_usuario
	
 --Cantidad de páginas  
 declare @maxpag int  
  
if(@TamañoPagina=0)  
 set @maxpag=1  
else  
 select @maxpag=ceiling(count(*)*1.0/@TamañoPagina) from #Datos_final
  
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
  ('RTM','RTM',5,1),('Categoria','Categoria',5,2),('Floor_Share','Floor_Share',5,3),  
  ('Asignados','Asignados',5,4),('Relevados','Relevados',5,5),  
  ('Visitados','Visitados',5,6) 
   
 if(@lenguaje='en')  
  insert #columnasConfiguracion (name, title, width,orden) values   
  ('RTM','RTM',5,1),('Categoria','Categoria',5,2),('Floor_Share','Floor_Share',5,3),  
  ('Asignados','Asignados',5,4),('Relevados','Relevados',5,5),  
  ('Visitados','Visitados',5,6) 
   
    
 select name, title, width,orden from #columnasConfiguracion order by orden, name  
   
 ----Datos  
 if(@NumeroDePagina>0)  
  select RTM, Categoria, Floor_Share, Asignados,Relevados,Visitados  
  from #Datos_final where id between ((@NumeroDePagina - 1) * @TamañoPagina + 1) and (@NumeroDePagina * @TamañoPagina)
  
   
 if(@NumeroDePagina=0)  
  select  RTM, Categoria, Floor_Share, Asignados,Relevados,Visitados  
  from #Datos_final where id between ((@maxpag - 1) * @TamañoPagina + 1) and (@maxpag * @TamañoPagina)  

  
 if(@NumeroDePagina<0)  
  select RTM, Categoria, Floor_Share, Asignados,Relevados,Visitados   
  from #Datos_final
   
end  
go


declare @p2 dbo.FiltrosReporting
insert into @p2 values(N'fltFechaReporte',N'M,20181001,20181030')
--insert into @p2 values(N'fltpuntosdeventa',N'189279')
--insert into @p2 values(N'fltusuarios',N'3915')
--insert into @p2 values(N'fltMarcas',N'2460')


exec Whirpool_FS_Por_Categoria_Cocina_T9 @IdCliente=187,@Filtros=@p2,@NumeroDePagina=-1,@Lenguaje='es'