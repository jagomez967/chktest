SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Espacio_GetAllCliente]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Espacio_GetAllCliente] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[Espacio_GetAllCliente]
	-- Add the parameters for the stored procedure here
	 @IdCliente int = NULL
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT [IdEspacio]
		  ,[Nombre]
    FROM [dbo].[Espacio]
  	WHERE (@IdCliente IS NULL OR  [IdCliente] = @IdCliente)
    ORDER BY [Nombre]

END
GO
