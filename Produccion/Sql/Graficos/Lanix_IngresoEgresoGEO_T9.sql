IF NOT EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND OBJECT_ID = OBJECT_ID('dbo.Lanix_IngresoEgresoGEO_T9'))
   exec('CREATE PROCEDURE [dbo].[Lanix_IngresoEgresoGEO_T9] AS BEGIN SET NOCOUNT ON; END')
Go
alter procedure [dbo].[Lanix_IngresoEgresoGEO_T9]
(
	@IdCliente			int
	,@Filtros			FiltrosReporting readonly
	,@NumeroDePagina	int = -1
	,@Lenguaje			varchar(10) = 'es'
	,@IdUsuarioConsulta int = 0
	,@TamañoPagina		int = 0
)
as
begin
/*
	
	Para filtrar en un query hacer:
	===============================
	*	(isnull(@cZonas,0) = 0 or exists(select 1 from #zonas where idZona = p.IdZona))
	*	(isnull(@cCadenas,0) = 0 or exists(select 1 from #cadenas where idCadena = p.IdCadena))

*/		

	--SET LANGUAGE spanish
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
		,fecha	varchar(10)
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

		set @cClientes = (select count(1) from #clientes) 

	end


	insert #puntosdeventa(idPuntodeventa)
	select pdv.idPuntodeventa 
	from puntodeventa pdv
	inner join
	(select nombre from puntodeventa 
	where idPuntodeventa in (select idPuntodeventa from #puntosdeventa))pdx
	on pdx.nombre = pdv.nombre
	where pdv.idCliente in(select idCliente from #clientes)
	and not exists (select 1 from #puntosdeventa where idPuntodeventa = pdv.idPuntodeventa)
	
	insert #Provincias(idProvincia)
	select p.idProvincia 
	from Provincia p
	inner join
	(select nombre from Provincia
	where idProvincia in (select idProvincia from #Provincias))pdx
	on pdx.nombre = p.nombre
	where p.idCliente in(select idCliente from #clientes)
	and not exists (select 1 from #Provincias where idProvincia = p.idProvincia)

	insert #Zonas(idZona)
	select z.idZona 
	from Zona z
	inner join
	(select nombre from Zona
	where idZona in (select idZona from #Zonas))pdx
	on pdx.nombre = z.nombre
	where z.idCliente in(select idCliente from #clientes)
	and not exists (select 1 from #Zonas where idZona = z.idZona)

	insert #Localidades(idLocalidad)
	select l.idLocalidad
	from Localidad l
	inner join
	(select nombre from Localidad
	where idLocalidad in (select idLocalidad from #Localidades))pdx
	on pdx.nombre = l.nombre
	inner join Provincia p on p.idProvincia = l.idProvincia
	where p.idCliente in(select idCliente from #clientes)
	and not exists (select 1 from #Localidades where idLocalidad = l.idLocalidad)
		
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



	-------------------------------------------------------------------- END (Filtros) ----------------------------------------------------------------

	create table #datosFinal
	(
		id int identity(1,1),
		idUsuario	INT,
		usuario varchar(500),
		puntodeventa varchar(500),
		dia DATETIME,
		hIng TIME,
		hSal TIME,
		linkIng varchar(max),
		linkSal varchar(max),
		snShow	BIT
	)

	--insert #datosFinal (idusuario, usuario, idpuntodeventa, puntodeventa, dia, hIng, link)
	--select	u.idUsuario,
	--		us.Apellido+', '+us.Nombre collate database_default,
	--		u.idPuntoDeVenta,
	--		ltrim(rtrim(pdv.Nombre)),
	--		CONVERT(varchar(10), u.fecha,126),
	--		RIGHT(CONVERT(CHAR(20), u.fecha, 22), 11),
	--		u.link collate database_default
	--from UsuariosAlertaProximidad u
	--inner join Usuario us on us.idUsuario = u.idUsuario
	--inner join PuntoDeVenta pdv on pdv.idPuntoDeVenta = u.idPuntoDeVenta
	--where u.esSalida = 0 and pdv.idCliente in (142,143,144,145,146,147)
	--	and convert(date, Fecha) between convert(date, @fechaDesde) and convert(date, @fechaHasta)
	--order by u.fecha desc


	--update #datosFinal set hSal = RIGHT(CONVERT(CHAR(20), UsuariosAlertaProximidad.fecha, 22), 11)
	--from #datosFinal
	--inner join UsuariosAlertaProximidad on UsuariosAlertaProximidad.idUsuario = #datosFinal.idUsuario
	--	and UsuariosAlertaProximidad.idPuntoDeVenta = #datosFinal.idPuntoDeVenta
	--	and CONVERT(varchar(10), UsuariosAlertaProximidad.fecha,126) = #datosFinal.dia
	
	
	
	insert into #datosFinal (IdUsuario,usuario, puntodeventa, dia, hIng, hSal, linkIng, linkSal, snShow)
		select
			u.IdUsuario,
			u.Apellido+', '+ u.Nombre collate database_default, 
			ltrim(rtrim(pdv.Nombre)),
			Entrada.fecha,
			CONVERT(TIME,Entrada.fecha),
			CONVERT(TIME,Salida.fecha), 
			Entrada.link, 
			Salida.link,
			Entrada.snShow
		from UsuariosALertaProximidad Entrada
			left join UsuariosAlertaProximidad Salida
				on Entrada.idUsuario = Salida.idUsuario
			and cast(Entrada.Fecha as date) = cast(Salida.Fecha as date)
			and Entrada.Orden +1 = Salida.Orden
			and salida.EsSalida = 1
			inner join PuntoDeVenta pdv on pdv.idPuntoDeVenta = Entrada.idPuntoDeVenta
			inner join Usuario u on u.idUsuario = Entrada.idUsuario
		where Entrada.EsSalida = 0
			and (isnull(@cClientes,0) = 0 or exists (select 1 from #clientes where idCliente = pdv.idCliente))
			and (isnull(@cUsuarios,0) = 0 or exists (select 1 from #Usuarios where idUsuario = u.idUsuario))
			and (isnull(@cPuntosDeVenta,0) = 0 or exists(select 1 from #puntosdeventa where idPuntoDeVenta = pdv.IdPuntoDeVenta))
			and (isnull(@cZonas,0) = 0 or exists(select 1 from #zonas where idZona = pdv.IdZona))
			and (isnull(@cLocalidades,0) = 0 or exists(select 1 from #localidades where idLocalidad = pdv.IdLocalidad))
			and convert(date, Entrada.Fecha) between convert(date, @fechaDesde) and convert(date, @fechaHasta)
			--AND ENTRADA.SNSHOW = 1
		UNION
		select
			u.IdUsuario,
			u.Apellido+', '+u.Nombre collate database_default,
			ltrim(rtrim(pdv.Nombre)),
			SALIDA.fecha,
			CONVERT(TIME,Entrada.fecha),
			CONVERT(TIME,Salida.fecha), 
			Entrada.link, 
			Salida.link,
			Salida.snShow
		from UsuariosALertaProximidad SALIDA
			left join UsuariosAlertaProximidad ENTRADA
				on Entrada.idUsuario = Salida.idUsuario
			and cast(Entrada.Fecha as date) = cast(Salida.Fecha as date)
			and Entrada.Orden +1 = Salida.Orden
			and ENTRADA.EsSalida = 0
			inner join PuntoDeVenta pdv on pdv.idPuntoDeVenta = SALIDA.idPuntoDeVenta
			inner join Usuario u on u.idUsuario = SALIDA.idUsuario
		where SALIDA.EsSalida = 1
			and (isnull(@cClientes,0) = 0 or exists (select 1 from #clientes where idCliente = pdv.idCliente))
			and (isnull(@cUsuarios,0) = 0 or exists (select 1 from #Usuarios where idUsuario = u.idUsuario))
			and (isnull(@cPuntosDeVenta,0) = 0 or exists(select 1 from #puntosdeventa where idPuntoDeVenta = pdv.IdPuntoDeVenta))
			and (isnull(@cZonas,0) = 0 or exists(select 1 from #zonas where idZona = pdv.IdZona))
			and (isnull(@cLocalidades,0) = 0 or exists(select 1 from #localidades where idLocalidad = pdv.IdLocalidad))
			and convert(date, Salida.Fecha) between convert(date, @fechaDesde) and convert(date, @fechaHasta)
			--AND SALIDA.SNSHOW = 1
		order by 3 DESC


	


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
		insert #columnasConfiguracion (name, title, width) values ('usuario','Usuario',5),('puntodeventa','PuntoDeVenta',5),('dia','Dia',5),('hIng','Entrada',5),('hSal','Salida',5),('Permanencia','Permanencia',5),('linkIng','LinkIngreso',10),('linkSal','LinkSalida',10)

	if(@lenguaje='en')
		insert #columnasConfiguracion (name, title, width) values ('usuario','User',5),('puntodeventa','PointOfSale',5),('dia','Day',5),('hIng','Ingress',5),('hSal','Egress',5),('Permanencia','PermanenceTime',5),('linkIng','IngressLink',10),('linkSal','EgressLink',10)

	select name, title, width from #columnasConfiguracion

	--Datos
		SELECT DISTINCT
			usuario, 
			puntodeventa, 
			CONVERT(VARCHAR(10),dia,103) dia,
			ISNULL(CONVERT(VARCHAR(5),hIng,108),'') hIng,
			ISNULL(CONVERT(VARCHAR(5),hSal,108),'') hSal, 
			ISNULL(
				CASE WHEN ISNULL(CONVERT(VARCHAR(5),hSal,108),'') != '' THEN
					CASE CONVERT(VARCHAR,DATEDIFF(HOUR,hIng,hSal)) WHEN '0' 
						THEN '00:' + RIGHT('00' + CONVERT(VARCHAR,DATEDIFF(MINUTE,hIng,hSal)),2)
						ELSE
							CASE WHEN (60 + DATEPART(MINUTE,hSal)) - DATEPART(MINUTE,hIng) >= 60 
								THEN 
									RIGHT('00' + CONVERT(VARCHAR,DATEPART(HOUR,hSal) - DATEPART(HOUR,hIng)),2)  + ':' + RIGHT('00' + CONVERT(VARCHAR,(DATEPART(MINUTE,hSal)) - DATEPART(MINUTE,hIng)),2)  
								ELSE
									RIGHT('00' + CONVERT(VARCHAR,DATEPART(HOUR,hSal) - DATEPART(HOUR,hIng) - 1),2)  + ':' + RIGHT('00' + CONVERT(VARCHAR,(60 + DATEPART(MINUTE,hSal)) - DATEPART(MINUTE,hIng)),2)
							END
					END
				ELSE
					ISNULL(
						CASE CONVERT(VARCHAR,DATEDIFF(HOUR,hIng,(SELECT MAX(DIA) FROM #datosFinal WHERE idUsuario = DF.idUsuario AND CONVERT(VARCHAR(10),dia,103) = CONVERT(VARCHAR(10),df.dia,103) AND snShow = 0))) WHEN '0' 
							THEN '00:' + RIGHT('00' + CONVERT(VARCHAR,DATEDIFF(MINUTE,hIng,(SELECT MAX(DIA) FROM #datosFinal WHERE idUsuario = DF.idUsuario AND CONVERT(VARCHAR(10),dia,103) = CONVERT(VARCHAR(10),df.dia,103) AND snShow = 0))),2)
							ELSE
								CASE WHEN (60 + DATEPART(MINUTE,(SELECT MAX(DIA) FROM #datosFinal WHERE idUsuario = DF.idUsuario AND CONVERT(VARCHAR(10),dia,103) = CONVERT(VARCHAR(10),df.dia,103) AND snShow = 0))) - DATEPART(MINUTE,hIng) >= 60 
									THEN 
										RIGHT('00' + CONVERT(VARCHAR,DATEPART(HOUR,(SELECT MAX(DIA) FROM #datosFinal WHERE idUsuario = DF.idUsuario AND CONVERT(VARCHAR(10),dia,103) = CONVERT(VARCHAR(10),df.dia,103) AND snShow = 0)) - DATEPART(HOUR,hIng)),2)  + ':' + RIGHT('00' + CONVERT(VARCHAR,(DATEPART(MINUTE,(SELECT MAX(DIA) FROM #datosFinal WHERE idUsuario = DF.idUsuario AND CONVERT(VARCHAR(10),dia,103) = CONVERT(VARCHAR(10),df.dia,103) AND snShow = 0))) - DATEPART(MINUTE,hIng)),2)  
									ELSE
										RIGHT('00' + CONVERT(VARCHAR,DATEPART(HOUR,(SELECT MAX(DIA) FROM #datosFinal WHERE idUsuario = DF.idUsuario AND CONVERT(VARCHAR(10),dia,103) = CONVERT(VARCHAR(10),df.dia,103) AND snShow = 0)) - DATEPART(HOUR,hIng) - 1),2)  + ':' + RIGHT('00' + CONVERT(VARCHAR,(60 + DATEPART(MINUTE,(SELECT MAX(DIA) FROM #datosFinal WHERE idUsuario = DF.idUsuario AND CONVERT(VARCHAR(10),dia,103) = CONVERT(VARCHAR(10),df.dia,103) AND snShow = 0))) - DATEPART(MINUTE,hIng)),2)
								END
						END + ' (Estimada)'
					,'Indeterminada')
				END
			,''	) Permanencia,
			ISNULL(linkIng,'') linkIng,
			ISNULL(linkSal,'') linkSal
		FROM 
			#datosFinal DF
		WHERE
			id >= CASE WHEN @NumeroDePagina > 0 THEN ((@NUMERODEPAGINA - 1) * @TAMAÑOPAGINA + 1) ELSE id END 
			AND id <= CASE WHEN @NumeroDePagina > 0 THEN (@NUMERODEPAGINA * @TAMAÑOPAGINA) ELSE id END 
			AND ISNULL(CONVERT(VARCHAR(5),hIng,108),'') != ISNULL(CONVERT(VARCHAR(5),hSal,108),'')
			AND snShow = 1
		ORDER BY dia DESC, ISNULL(CONVERT(VARCHAR(5),hIng,108),'') DESC

end	