SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Provincia_DeleteCheck]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Provincia_DeleteCheck] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[Provincia_DeleteCheck]
	-- Add the parameters for the stored procedure here
	@IdProvincia int
   ,@Cantidad  int out
   
AS
BEGIN
	
	SET NOCOUNT ON;
	SET @Cantidad = 0
	
    
	SELECT @Cantidad = COUNT(1)
	FROM [dbo].[Localidad] L
	INNER JOIN Provincia P  ON (L.IdProvincia = P.IdProvincia and P.IdProvincia = @IdProvincia)
  
	
  
END
GO
