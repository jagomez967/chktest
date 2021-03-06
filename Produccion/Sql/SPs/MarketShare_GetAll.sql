SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MarketShare_GetAll]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[MarketShare_GetAll] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[MarketShare_GetAll]
	
	@IdMarketShare int = NULL
   ,@Nombre varchar(50) =  NULL
   ,@Nivel int = NUll
   ,@IdMarketSharePadre int = NULL
   ,@Activo bit = NULL
	
AS
BEGIN
	
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT [IdMarketShare]
		  ,[Nombre]
		  ,[Nivel]
		  ,[IdMarketSharePadre]
		  ,[Activo]
	FROM [dbo].[MarketShare]
	WHERE (@IdMarketShare IS NULL OR @IdMarketShare = [IdMarketShare]) AND
		  (@Nombre IS NULL OR @Nombre = [Nombre]) AND
		  (@Nivel IS NULL OR @Nivel = [Nivel]) AND
		  (@IdMarketSharePadre IS NULL OR @IdMarketSharePadre = [IdMarketSharePadre]) 
		  
	
END
GO
