IF NOT EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND OBJECT_ID = OBJECT_ID('dbo.GetForecasting'))
   EXEC('CREATE PROCEDURE [dbo].[GetForecasting] AS BEGIN SET NOCOUNT ON; END')
GO
ALTER PROCEDURE [dbo].[GetForecasting]
(
	@IdCliente int,
	@LstCanales as [dbo].[ItemType] readonly,
	@LstCadenas as [dbo].[ItemType] readonly,
	@LstFamilias as [dbo].[ItemType] readonly,
	@LstProductos as [dbo].[ItemType] readonly,
	@IdUsuario as int,
	@Fecha as datetime
)
as
begin

	SELECT 
		Value,
		ROW_NUMBER() OVER(ORDER BY Text ASC) idx
	INTO 
		#Prods
	FROM 
		@LstProductos
	/*
		Si LstCadenas es vacio entonces incluyo todas las cadenas
		Si LstFamilias es vacio entonces incluyo todas las cadenas
		Si LstProductos es vacio entonces incluyo todas las cadenas
	*/

	declare @cantCanales int
	declare @cantFamilias int
	declare @cantProductos int
	declare @cantCadenas int

	select @cantCanales  = count(1) from @LstCanales
	select @cantFamilias = count(*) from @LstFamilias
	select @cantProductos = count(*) from @LstProductos
	select @cantCadenas = count(*) from @LstCadenas

	declare @Idcadena int
	--if(select count(*) from @LstCadenas)=1
	if(@cantCadenas=1)
	begin
		select top 1 @IdCadena = cast(Value as int) from @LstCadenas
	end
	else
	begin
		set @IdCadena = 0
	end

	 DECLARE @diff  INT = 0
	 DECLARE @marchTest DATE
	 DECLARE @DATE DATE
	 SELECT @DATE = CONVERT(DATE,CONVERT(VARCHAR,YEAR(@Fecha)) + RIGHT('00' + CONVERT(VARCHAR,MONTH(@Fecha)),2) + '01')
	 IF((MONTH(@DATE) >= 9 AND MONTH(@DATE) <= 12) OR (MONTH(@DATE) >= 1 AND MONTH(@DATE) <= 3)) BEGIN
		SELECT @marchTest = CONVERT(DATE,CONVERT(VARCHAR,YEAR(@Fecha)+1)+'0331')
		SELECT @diff = (CONVERT(NUMERIC(18,2),DATEDIFF(DAY,@DATE,@marchTest))/30) - CASE WHEN MONTH(@DATE) >= 9 AND MONTH(@DATE) <= 12  THEN 0 ELSE 12 END
	 END

	declare @fechadesde datetime = DateAdd(Month, DateDiff(Month, 0, dateadd(month,-12,@Fecha)), 0)
	declare @fechahasta datetime = DateAdd(Month, DateDiff(Month, 0, dateadd(month,12 + @diff -1,@Fecha)), 0)

	--Productos
	select	distinct
		p.IdProducto as IdProducto
		,ltrim(rtrim(p.Nombre)) as Producto
		,f.IdFamilia as IdCategoria
		,ltrim(rtrim(f.Nombre)) as Categoria
		,case when @IdCadena>0 then dbo.ForecastingConfirmado(@IdCliente, @IdUsuario, @Idcadena, @fecha) else 0 end as Confirmado
		,p.IdExterno as IdExterno
		,pr.idx Orden
		,lstp.Value
		,lstf.Value
	from cliente c
		inner join empresa e on e.idempresa=c.idempresa
		inner join marca m on m.idempresa=e.idempresa
		inner join producto p on p.idmarca=m.idmarca
		inner join familia f on f.idfamilia=p.idfamilia
		left join @LstFamilias lstf on ltrim(rtrim(lstf.Value)) = ltrim(rtrim(str(p.IdFamilia)))
		left join @LstProductos lstp on ltrim(rtrim(lstp.Value)) = ltrim(rtrim(str(p.IdProducto)))
		left join #Prods pr on lstp.Value = pr.Value
	where	c.idcliente = @IdCliente
			and p.Nombre like '%EPSON%'
			and (@cantProductos = 0 or (@CantProductos>0 and lstp.Value is not null))
			and (@cantFamilias = 0 or (@CantFamilias>0 and lstf.Value is not null))
			--Esto es provisorio hasta agregar un flag de ActivoCap
            and p.idProducto NOT IN (19651, 19658, 19652, 19015, 19027, 12522, 19030, 19031)
	order by pr.idx

	SELECT f.[Id] as Id
		,tc.IdTipoCadena as IdCanal
		,ltrim(rtrim(tc.Nombre)) as Canal
		,fam.IdFamilia as IdCategoria
		,ltrim(rtrim(fam.Nombre)) as Categoria
		,f.[IdCadena] as IdCadena
		,cast(cast(year(f.[Fecha])*10000 + month(f.[Fecha])*100 + 1 as varchar(255)) as date) as Fecha
		,f.[IdProducto] as IdProducto
		,isnull(wspr.Precio,0) as WholeSalePrice
		,isnull(f.[PlanOriginalSellIn],0) as PlanOriginalSellIn
		,isnull(f.[PlanOriginalSellOut],0) as PlanOriginalSellOut
		,isnull(f.[PlanVendedorSellIn],0) as PlanVendedorSellIn
		,isnull(f.[PlanVendedorSellOut],0) as PlanVendedorSellOut
		,isnull(f.[SalesIn],0) as SalesIn
		,isnull(f.[SalesOut],0) as SalesOut
		,isnull(f.StockInicial,0) as StockInicial
		,isnull(f.[ChannelInv],0) as ChannelInv
		,isnull(f.[Doci],0) as Doci
		,isnull(f.[Sorr],0) as Sorr
		,dbo.ForecastingConfirmado(@IdCliente, @IdUsuario, @IdCadena, @fecha) as Cotizacion
		,ltrim(rtrim(tc.Identificador)) as CanalIdentificador
		,isnull(c.LimiteDoci,0) as LimiteDoci
		,pr.idx Orden
	FROM [dbo].[Forecasting] f
	inner join Cadena c on c.idcadena = f.idcadena
	inner join TipoCadena tc on tc.IdTipoCadena = c.IdTipoCadena
	inner join Producto p on p.idproducto = f.idproducto
	inner join Familia fam on fam.idfamilia=p.idfamilia
	left join @LstCanales lstcan on ltrim(rtrim(lstcan.Value))=ltrim(rtrim(str(tc.idTipoCadena)))
	left join @LstCadenas lstc on ltrim(rtrim(lstc.Value))=ltrim(rtrim(str(c.IdCadena)))
	left join @LstProductos lstp on ltrim(rtrim(lstp.Value))=ltrim(rtrim(str(p.IdProducto)))
	left join #Prods pr on lstp.Value = pr.Value
	left join @LstFamilias lstf on ltrim(rtrim(lstf.Value))=ltrim(rtrim(str(p.IdFamilia)))
	left join EpsonWholeSalePrice wspr on wspr.idcliente=f.idcliente and wspr.idcadena=f.idcadena and wspr.idproducto=f.idproducto and year(wspr.fecha)=year(f.fecha) and month(wspr.fecha)=month(f.fecha)
	where f.fecha between @fechadesde and @fechahasta and
		f.idcliente = @IdCliente
		and (@cantCanales = 0 or (@cantCanales>0 and lstcan.Value is not null))
		and (@cantCadenas = 0 or (@cantCadenas>0 and lstc.Value is not null))
		and (@cantProductos = 0 or (@CantProductos>0 and lstp.Value is not null))
		and (@cantFamilias = 0 or (@CantFamilias>0 and lstf.Value is not null))
		--Esto es provisorio hasta agregar un flag de ActivoCap
        and p.idProducto NOT IN (19651, 19658, 19652, 19015, 19027, 12522, 19030, 19031)
	order by f.IdCliente, f.Idcadena, pr.idx, f.fecha

	drop table #Prods

  end


  /*
  

	declare @lstcadenas as [dbo].[ItemType]
	declare @lstproductos as [dbo].[ItemType]
	declare @lstfamilias as [dbo].[ItemType]
	declare @lstCanales as [dbo].[ItemType]

	INSERT INTO @lstCanales (Value) VALUES ('3'),('4')
	
	exec GetForecasting 183, @LstCanales, @lstcadenas, @lstfamilias, @lstproductos, 238, '20190101'

  */











