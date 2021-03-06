SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Zona_DeleteCheck]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Zona_DeleteCheck] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[Zona_DeleteCheck]
	-- Add the parameters for the stored procedure here
	@IdZona int
   ,@Cantidad  int out
   
AS
BEGIN
	
	SET NOCOUNT ON;
	SET @Cantidad = 0
	
    
	SELECT @Cantidad = COUNT(1)
	FROM [dbo].[PuntoDeVenta]  PDV
	INNER JOIN Zona  Z  ON (PDV.IdZona = Z.IdZona and Z.IdZona = @IdZona)
  
	
  
END
GO
