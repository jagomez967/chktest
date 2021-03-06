SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Localidad_DeleteCheck]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Localidad_DeleteCheck] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[Localidad_DeleteCheck]
	-- Add the parameters for the stored procedure here
	@IdLocalidad int
   ,@Cantidad  int out
   
AS
BEGIN
	
	SET NOCOUNT ON;
	SET @Cantidad = 0
	
    
	SELECT @Cantidad = COUNT(1)
	FROM [dbo].[PuntoDeVenta]  PDV
	INNER JOIN Localidad  L  ON (PDV.IdLocalidad = L.IdLocalidad and L.IdLocalidad = @IdLocalidad)
  
	
  
END
GO
