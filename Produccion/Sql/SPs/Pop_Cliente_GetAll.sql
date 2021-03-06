SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Pop_Cliente_GetAll]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Pop_Cliente_GetAll] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[Pop_Cliente_GetAll]
	-- Add the parameters for the stored procedure here
	@IdPop int
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT PC.[Id]
		  ,PC.[IdCliente]
		  ,PC.[IdPop]
		  ,C.Nombre
		  ,C.[ImagenWeb]
		  ,C.[ImagenMovil]
		  ,C.[Latitud]
		  ,C.[Longitud]
		  ,C.[DiferenciaHora]
		  ,C.[DiferenciaMinutos]
	FROM [dbo].[Pop_Cliente] PC
	INNER JOIN Cliente C ON (C.[IdCliente] = PC.[IdCliente])
	WHERE PC.[IdPop] = @IdPop

END
GO
