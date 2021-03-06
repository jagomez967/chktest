IF NOT EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND OBJECT_ID = OBJECT_ID('dbo.GetWholeSalePrices'))
   EXEC('CREATE PROCEDURE [dbo].[GetWholeSalePrices] AS BEGIN SET NOCOUNT ON; END')
GO
ALTER procedure [dbo].[GetWholeSalePrices]
(
	@IdCliente int,
	@LstCanales as [dbo].[ItemType] readonly,
	@LstCadenas as [dbo].[ItemType] readonly,
	@LstCategorias as [dbo].[ItemType] readonly,
	@LstProductos as [dbo].[ItemType] readonly
)
as
begin

	set nocount on

	declare @cantCanales int
	declare @cantFamilias int
	declare @cantProductos int
	declare @cantCadenas int

	select @cantCanales  = count(1) from @LstCanales
	select @cantFamilias = count(*) from @LstCategorias
	select @cantProductos = count(*) from @LstProductos
	select @cantCadenas = count(*) from @LstCadenas

	declare @fechadesde datetime = DateAdd(Month, DateDiff(Month, 0, dateadd(month,-12,getdate())), 0)
	declare @fechahasta datetime = DateAdd(Month, DateDiff(Month, 0, dateadd(month,12,getdate())), 0)

	select	c.IdCliente as IdCliente,
			c.IdCadena as IdCadena,
			c.IdProducto as IdProducto,
			c.Fecha as Fecha,
			isnull(c.Precio,0) as Precio,
			ltrim(rtrim(tcad.Identificador)) as Canal,
			ltrim(rtrim(c.Currency)) as Currency
	from	EpsonWholeSalePrice c
			inner join Cadena cad on cad.idcadena = c.idcadena
			inner join TipoCadena tcad on tcad.IdTipoCadena = cad.IdTipoCadena
			inner join Producto p on p.idproducto=c.idproducto
			left join @LstCanales lstcan on ltrim(rtrim(lstcan.Value))=ltrim(rtrim(str(tcad.idTipoCadena)))
			left join @LstCategorias lstf on ltrim(rtrim(lstf.Value)) = ltrim(rtrim(str(p.IdFamilia)))
			left join @LstCadenas lstc on ltrim(rtrim(lstc.Value))=ltrim(rtrim(str(c.IdCadena)))
			left join @LstProductos lstp on ltrim(rtrim(lstp.Value))=ltrim(rtrim(str(c.IdProducto)))
	where	c.fecha between @fechadesde and @fechahasta
			and c.idcliente = @IdCliente
			and (@cantCanales = 0 or (@cantCanales>0 and lstcan.Value is not null))
			and (@cantFamilias = 0 or (@CantFamilias>0 and lstf.Value is not null))	
			and (@cantProductos = 0 or (@cantProductos>0 and lstp.Value is not null))
			and (@cantCadenas = 0 or (@cantCadenas>0 and lstc.Value is not null))
			--Esto es provisorio hasta agregar un flag de ActivoCap
			and p.idProducto NOT IN (19651, 19658, 19652, 19015, 19027, 12522, 19030, 19031)
end


  /*

  set nocount on

	declare @lstcadenas as [dbo].[ItemType]
	declare @lstproductos as [dbo].[ItemType]
	declare @lstcategorias as [dbo].[ItemType]

	insert @lstcadenas (Value) values ('4371')
	--insert @lstproductos (Value) values ('18616')
	--insert @lstcategorias (Value) values ('1080')
	
	exec GetWholeSalePrices2 178, 0, @lstcadenas, @lstcategorias, @lstproductos

	select * from producto where nombre like '%3110%'
	SELECT * FROM TipoCadena
  */






