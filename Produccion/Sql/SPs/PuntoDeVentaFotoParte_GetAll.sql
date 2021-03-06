SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PuntoDeVentaFotoParte_GetAll]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[PuntoDeVentaFotoParte_GetAll] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[PuntoDeVentaFotoParte_GetAll]
	@IdPuntoDeVentaFoto int
		
AS
BEGIN
	SET NOCOUNT ON;

	SELECT [IdPuntoDeVentaFotoParte]
		  ,[IdPuntoDeVentaFoto]
		  ,[Parte]
		  ,[FotoParte]
	  FROM [dbo].[PuntoDeVentaFotoParte]
	  WHERE [IdPuntoDeVentaFoto]=@IdPuntoDeVentaFoto
	  ORDER BY [Parte]
	  
END
GO
