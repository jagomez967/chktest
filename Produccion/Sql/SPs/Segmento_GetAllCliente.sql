SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Segmento_GetAllCliente]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Segmento_GetAllCliente] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[Segmento_GetAllCliente]
	-- Add the parameters for the stored procedure here
	@IdCliente int = NULL
   ,@Nombre varchar(50) = NULL
   
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT S.[IdSegmento]
		  ,S.[Nombre]
		  --,E.[Nombre] AS Empresa
	FROM [dbo].[Segmento] S
	--INNER JOIN Cliente C ON (S.IdCliente = C.IdCliente)
	--INNER JOIN Empresa E ON (E.IdCliente = @IdCliente)
	WHERE (S.IdCliente = @IdCliente) AND
	(@Nombre IS NULL OR S.[Nombre] like '%' + @Nombre +'%')

END
GO
