SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CD_Campania_GetAll]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[CD_Campania_GetAll] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[CD_Campania_GetAll]
	-- Add the parameters for the stored procedure here
	@IdCampania int = NULL
   ,@IdSistema int 
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT [IdCampania]
		  ,[Codigo]
		  ,[Nombre]
		  ,[Decripcion]
		  ,[PorcDescuento]
		  ,[ValidaDesde]
		  ,[ValidaHasta]
		  ,[IdSistema]
		  ,[Activo]
	FROM [dbo].[CD_Campania]
	WHERE (@IdCampania IS NULL OR [IdCampania] = @IdCampania) 
	      AND [IdSistema] = @IdSistema
	ORDER BY [Nombre]
  
END
GO
