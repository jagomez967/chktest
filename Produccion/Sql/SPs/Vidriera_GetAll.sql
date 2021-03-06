SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Vidriera_GetAll]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Vidriera_GetAll] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[Vidriera_GetAll]
	-- Add the parameters for the stored procedure here
	 @IdVidriera int = NULL
	,@IdPuntoDeVenta int = NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT V.[IdVidriera]
		  ,V.[IdPuntoDeVenta]
		  ,V.[IdDimension]
	      ,V.[IdVisibilidad]
		  ,V.[IdEspacio]
	      ,V.[Nombre]
		  ,V.[Comentarios]
		  ,D.Nombre AS Dimension
		  ,VS.Nombre AS Visibilidad
		  ,E.Nombre AS Espacio
	FROM [dbo].[Vidriera] V
	INNER JOIN Dimension D ON (V.[IdDimension] = D.[IdDimension])
	INNER JOIN Visibilidad VS ON  (V.[IdVisibilidad] = VS.[IdVisibilidad])
	INNER JOIN Espacio E ON (V.[IdEspacio] = E.[IdEspacio])
	WHERE (@IdVidriera IS NULL OR @IdVidriera = V.[IdVidriera]) AND
	      (@IdPuntoDeVenta IS NULL OR @IdPuntoDeVenta = V.[IdPuntoDeVenta])  
	
END
GO
