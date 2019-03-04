IF NOT EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND OBJECT_ID = OBJECT_ID('dbo.SodimacAccuracy_T26'))
   exec('CREATE PROCEDURE [dbo].[SodimacAccuracy_T26] AS BEGIN SET NOCOUNT ON; END')
Go
alter procedure [dbo].[SodimacAccuracy_T26]
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
	create table #Categoria
	(
		idCategoria int
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
	declare @cCategoria varchar(max)

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
	
	
	insert #Categoria (IdCategoria) select clave as Categoria from dbo.fnSplitString((select Valores from @Filtros where IdFiltro = 'fltCategoria'),',') where isnull(clave,'')<>''
	set @cCategoria = @@ROWCOUNT
	

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

	create table #Equipo
	(
		idEquipo int
	)

	declare @cEquipo varchar(max)

	insert #Equipo (idEquipo) select clave as idTipo from dbo.fnSplitString((select Valores from @Filtros where IdFiltro = 'fltEquipo'),',') where isnull(clave,'')<>''
	set @cEquipo = @@ROWCOUNT

	-------------------------------------------------------------------- END (Filtros) ----------------------------------------------------------------

	declare @fechaDesdeMeses datetime
	declare @fechaHastaMeses datetime
	--set @fechaDesdeMeses=@fechaDesde
	--set @fechaHastaMeses=@fechaHasta
    --
	create table #Meses
	(
		mes varchar(8)
	)

	while(@fechaDesdeMeses<=@fechaHastaMeses)
	begin
		insert #Meses(mes) select convert(varchar, @fechaDesdeMeses,112)
		set @fechaDesdeMeses=dateadd(month,1,@fechaDesdeMeses)
	end
	
	IF MONTH(@fechaDesde) != MONTH(@fechaHasta) BEGIN
		SELECT @fechaDesde = CASE WHEN MONTH(@fechaDesde) > MONTH(@fechaHasta) THEN
			CONVERT(VARCHAR,YEAR(@fechaDesde)) + RIGHT('00'+CONVERT(VARCHAR,MONTH(@fechaDesde)),2) + '01'
		ELSE
			CONVERT(VARCHAR,YEAR(@fechaDesde)) + RIGHT('00'+CONVERT(VARCHAR,MONTH(@fechaHasta)),2) + '01'
		END
		, @fechaHasta = CASE WHEN MONTH(@fechaDesde) > MONTH(@fechaHasta) THEN
			CONVERT(VARCHAR,YEAR(@fechaDesde)) + RIGHT('00'+CONVERT(VARCHAR,MONTH(@fechaDesde)),2) + RIGHT(CONVERT(VARCHAR,DAY(dateadd(day,-1,DATEADD(M,1,dateadd(day, 1 - day(@fechaDesde), @fechaDesde))))),2)
		ELSE
			CONVERT(VARCHAR,YEAR(@fechaHasta)) + RIGHT('00'+CONVERT(VARCHAR,MONTH(@fechaHasta)),2) + RIGHT(CONVERT(VARCHAR,DAY(dateadd(day,-1,DATEADD(M,1,dateadd(day, 1 - day(@fechaHasta), @fechaHasta))))),2)
		END
	END
	ELSE BEGIN
		SELECT 
			@fechaDesde = CONVERT(VARCHAR,YEAR(@fechaDesde)) + RIGHT('00'+CONVERT(VARCHAR,MONTH(@fechaDesde)),2) + '01',
			@fechaHasta = CONVERT(VARCHAR,YEAR(@fechaHasta)) + RIGHT('00'+CONVERT(VARCHAR,MONTH(@fechaHasta)),2) + RIGHT(CONVERT(VARCHAR,DAY(dateadd(day,-1,DATEADD(M,1,dateadd(day, 1 - day(@fechaHasta), @fechaHasta))))),2)
	END
	-------------------------------------------------------------------- TEMPS (Filtros)
		create table #datos(
		iditem int,
		ItemText varchar(200),
		ItemSubText varchar (200),
		ItemValue int,
		ItemUnit varchar(200),
		LabelValor varchar(100),
		imagen varchar(max),
		idproducto int,
		nombre_producto varchar(200),
		SubItemValueColor varchar(200)
		)
		
		
	    Insert into #datos (iditem,ItemText,ItemSubText,ItemValue,ItemUnit,LabelValor,Imagen,nombre_producto,SubItemValueColor )
		SELECT
		U.IdUsuario IdItem,
		ISNULL(U.Apellido,'') + ', ' + ISNULL(U.Nombre,'') COLLATE DATABASE_DEFAULT AS ItemText,
		'Vendedor' as ItemSubText,
		 Cantidad ItemValue,
		' Unidad' as ItemUnit,
		'Ventas' as LabelValor,
		isnull(u.Imagen,'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') as Imagen,
		p.nombre,
		p.idproducto
		

	FROM 
		Reporte R
		INNER JOIN ReporteProducto RP ON R.idReporte = RP.idReporte
		INNER JOIN Producto P ON P.idProducto = RP.idProducto
		INNER JOIN Usuario U ON R.idUsuario = U.idUsuario
		INNER JOIN Cliente C ON	C.idEmpresa = R.idEmpresa
		INNER JOIN PuntoDeVenta PDV ON R.idPuntoDeVenta = PDV.idPuntoDeVenta
	WHERE
		ISNULL(RP.Cantidad,0) != 0 
		AND CONVERT(DATE,R.FechaCreacion) >= @fechaDesde
		AND CONVERT(DATE,R.FechaCreacion) <= @fechaHasta
		AND EXISTS (SELECT 1 FROM #clientes WHERE idCliente = C.idCliente)
		AND (ISNULL(@cZonas,0) = 0 OR EXISTS (SELECT 1 FROM #zonas WHERE idZona = PDV.IdZona))
		AND (ISNULL(@cCadenas,0) = 0 OR EXISTS (SELECT 1 FROM #cadenas WHERE idCadena = PDV.IdCadena))
		AND (ISNULL(@cLocalidades,0) = 0 OR EXISTS (SELECT 1 FROM #localidades WHERE idLocalidad = PDV.IdLocalidad))
		AND (ISNULL(@cPuntosDeVenta,0) = 0 OR EXISTS (SELECT 1 FROM #puntosdeventa WHERE idPuntoDeVenta = PDV.IdPuntoDeVenta))
		AND (ISNULL(@cUsuarios,0) = 0 OR EXISTS (SELECT 1 FROM #usuarios WHERE idUsuario = R.IdUsuario)) AND R.IdUsuario NOT IN (SELECT idUsuario FROM usuario WHERE escheckpos = 1)
		AND (ISNULL(@cTipoRtm,0) = 0 OR EXISTS (SELECT 1 FROM UsuarioPerfil UPE WHERE UPE.IdUsuario = R.IdUsuario AND UPE.IdPerfil IN (SELECT IdTipo FROM #tipoRtm)))
		AND (ISNULL(@cTipoPDV,0) = 0 OR EXISTS(SELECT 1 FROM #TipoPDV where idTipo = PDV.idTipo))
		AND c.IdCliente = CASE @idCliente WHEN 147 THEN 144 ELSE @idCliente END
		
		
		
		SELECT iditem,ItemText,ItemSubText,sum(ItemValue) as ItemValue,ItemUnit,LabelValor,Imagen,
		CASE WHEN SUM(ItemValue) <= 14 THEN '#FF0000' ELSE (CASE WHEN SUM(ItemValue) < 21 THEN '#FFCA33' ELSE '#00FF00' END) END Color
		FROM #datos
		group by iditem,ItemText,ItemSubText,ItemUnit,LabelValor,Imagen 
		order by ItemValue desc
		
	
	create table #datos_final
	(
	iditem int,
	IdsubItem int,
	SubItemText varchar(300),
	SubItemValue int,
	SubItemUnit varchar(100),
	imagen varchar(100)
	)
	insert into #datos_final (iditem,IdsubItem,SubItemText,SubItemValue,SubItemUnit,imagen)
	select 
	iditem, 
	idproducto as IdsubItem, 
	nombre_producto SubItemText, 
	sum(ItemValue) SubItemValue,
	ItemUnit as SubItemUnit,
	'' as imagen
	from #datos
	group by iditem,idproducto,nombre_producto,ItemUnit
	
	select iditem,IdsubItem,SubItemText,SubItemValue,SubItemUnit,imagen 
	from #datos_final
	order by SubItemValue desc
	
	
		
	
	
end
---go
---
---declare @p2 dbo.FiltrosReporting
---insert into @p2 values(N'fltFechaReporte',N'M,20180821,20180920')
-----insert into @p2 values(N'fltpuntosdeventa',N'99647')
---insert into @p2 values(N'fltusuarios',N'2710')
-----insert into @p2 values(N'fltMarcas',N'614')
---
---exec SodimacAccuracy_T26 @IdCliente=147,@Filtros=@p2,@NumeroDePagina=-1,@Lenguaje='es'
