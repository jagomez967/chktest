SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Drogueria_PuntoDeVenta_GetAll_Cliente]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Drogueria_PuntoDeVenta_GetAll_Cliente] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[Drogueria_PuntoDeVenta_GetAll_Cliente]
	
	@IdPuntoDeVenta int = NULL
   ,@IdEmpresa int
   
AS
BEGIN
	
	SET NOCOUNT ON;
	DECLARE @IdCliente int
	
	SELECT @IdCliente = C.IdCliente FROM CLiente C WHERE C.IdEmpresa = @IdEmpresa 
	
  
	SELECT D.[IdDrogueria]
          ,D.[Nombre]
          ,DPDV.IdPuntoDeVenta
          ,DPDV.Codigo
    FROM [dbo].[Drogueria] D
    INNER JOIN [Drogueria_Cliente]  DC ON (DC.IdDrogueria = D.IdDrogueria AND DC.IdCliente = @IdCliente)	
    LEFT JOIN dbo.Drogueria_PuntoDeVenta DPDV ON (DPDV.IdDrogueria = D.IdDrogueria AND DPDV.IdPuntoDeVenta = @IdPuntoDeVenta)
  
END
GO
