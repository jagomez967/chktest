IF NOT EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND OBJECT_ID = OBJECT_ID('dbo.GetPriceRequestFormByGUID'))
   exec('CREATE PROCEDURE [dbo].[GetPriceRequestFormByGUID] AS BEGIN SET NOCOUNT ON; END')
Go
alter procedure [dbo].[GetPriceRequestFormByGUID]
(
	@ID uniqueidentifier
)
AS
BEGIN
	select	cad.nombre as account,
			r.idCadena as accountId,
			isnull(r.aspVariancePercent,0) as aspVariancePercent,
			isnull(r.aspVariancePrice,0) as aspVariancePrice,
			isnull(r.NetASP,0) as netAsp,
			isnull(r.NetASPCondition,0) as netAspCondition,
			isnull(r.idealGap,18) as idealGap,
			r.idProductoCompetencia as idSelectedCompetitor,
			r.idProducto as ownProductId,
			sm.idSubMarca as ownBrandID,
			p.nombre as ownProductName,
			sm.nombre as ownBrandName,
			isnull(r.precioPropio,0) as ownProductPrice,
			isnull(r.InventarioPropio,0) as ownProductInventory,
			0 as ownProductModelShare,
			isnull(r.UBP,0) as ownProductUBP, --Al pedo, no se usa, se toma el precio propio del producto 
			isnull(r.UBPProposal,0) as ownProductUBPP,    --este es ingresado
			r.idProductoCompetencia as competitorProductId,
			--submarca 2 as competitorBrandId,
			sm_c.idSubmarca as competitorBrandId,
			pc.nombre as competitorProductName,
			--submarca 2 as competitorBrandName,
			sm_c.nombre as competitorBrandName,
			isnull(r.precioCompetencia,0) as competitorProductPrice,
			isnull(r.InventarioCompetencia,0) as competitorProductInventory,
			0 as competitorProductModelShare,  --No se usa
			0 as competitorProductUBP,  --UBP es el precio del producto competidor. no lo cambio
			0 as competitorProductUBPP, --No existe propuesta para el producto competencia
			isnull(r.PriceGap,0) as PriceGap,   --Nuevo gap
			r.FotoPropia as selfPhoto,
			r.FotoCompetencia as CompetitorPhoto,
			cast(r.EOLPropio as bit) as SelfEOL,
			cast(r.EOLCompetencia as  bit) as CompetitorEOL
			from
				PriceRequestDetail r
				inner join producto p on p.idProducto = r.IdProducto
				inner join producto pc on pc.idProducto = r.IdProductoCompetencia
				inner join cadena cad on cad.idCadena = r.idCadena 
				inner join submarca sm on sm.idMarca = p.idMarca 							
				inner join submarca_producto smp on smp.idProducto = p.idProducto and smp.idSubMarca = sm.idSubMarca
				inner join submarca sm_c on sm_c.idMarca = pc.idMarca
				inner join SubMarca_Producto smp_c on smp_c.idProducto = pc.IdProducto and smp_c.idSubMarca = sm_c.idSubMarca
			where r.ID = @ID
END

go

exec GetPriceRequestFormByGUID '54670885-B9A7-4FD2-AEC2-DE736B097086'
--@idCliente = 178 , @producto = 'EPSON L380'