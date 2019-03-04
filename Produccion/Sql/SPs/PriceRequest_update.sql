SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PriceRequest_update]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[PriceRequest_update] AS' 
END
GO
ALTER procedure [dbo].[PriceRequest_update]
(
@GUID UNIQUEIDENTIFIER,
@IdCadena int,
@IdProducto int,
@IdProductoCompetencia int,
@InventarioPropio int = 0,
@InventarioCompetencia int = 0,
@FotoPropia varchar(max) = '',
@FotoCompetencia varchar(max),
@UBP decimal(18,3) = 0.0,
@UBPProposal decimal(18,3) = 0.0,
@NetASP decimal(18,3) = 0.0,
@NetASPCondition decimal(18,3) = 0.0,
@EOLPropio int,
@EOLCompetencia int ,
@PrecioPropio decimal(18,3) = 0.0,
@PrecioCompetencia decimal(18,3)= 0.0,
@PriceGap decimal(18,3) = 0.0,
@idealGap decimal(18,3) = 0.0,
@aspVariancePercent decimal(18,3) = 0.0,
@aspVariancePrice decimal(18,3) = 0.0)
AS 
BEGIN


	update pricerequestdetail
	set	inventarioPropio = @InventarioPropio,
		inventarioCompetencia = @InventarioCompetencia,
		fotoPropia = @fotoPropia,
		fotoCompetencia = @FotoCompetencia,
		UBP = @UBP,
		NetASP = @NetASP,
		NetASPCondition = @NetASPCondition,
		EOLPropio =@EOLPropio,
		EOLCompetencia = @EOLCompetencia,
		precioPropio = @PrecioPropio,
		precioCompetencia = @PrecioCompetencia,
		aspVariancePercent = @aspVariancePercent,
		aspVariancePrice = @aspVariancePrice,
		idealGap = @idealGap,
		priceGap = @PriceGap,
		UBPProposal = @UBPProposal
	where ID = @GUID 
	and idCadena = @idCadena
	and idProducto = @IdProducto	
	and idProductoCompetencia = @IdProductoCompetencia

END
GO



