SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PriceRequest_add]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[PriceRequest_add] AS' 
END
GO
ALTER procedure [dbo].[PriceRequest_add]
(
@GUID UNIQUEIDENTIFIER,
@IdCadena int,
@IdProducto int,
@IdProductoCompetencia int,
@InventarioPropio int = 0,
@InventarioCompetencia int = 0,
@FotoPropia varchar(max) = '',
@FotoCompetencia varchar(max) = '',
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


	INSERT PriceRequestDetail (	ID,		IdCadena,		IdProducto,		IdProductoCompetencia,		InventarioPropio,
								InventarioCompetencia,	FotoPropia,		FotoCompetencia,			UBP,
								NetAsp,					NetASPCondition,EOLPropio,					EOLCompetencia,
								precioPropio,			precioCompetencia,
								aspVariancePercent,		aspVariancePrice,				
								idealGap,				priceGap,		UBPProposal)
	values(						@GUID,	@IdCadena,		@IdProducto,	@IdProductoCompetencia,		@InventarioPropio,
								@InventarioCompetencia,	@FotoPropia,	@FotoCompetencia,			@UBP,
								@NetASP,				@NetASPCondition,@EOLPropio,				@EOLCompetencia,
								@PrecioPropio,			@PrecioCompetencia,
								@aspVariancePercent,	@aspVariancePrice,
								@idealGap,				@PriceGap,		@UBPProposal)

END
GO




