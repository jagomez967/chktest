SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Instancia_Get]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Instancia_Get] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[Instancia_Get]
AS
BEGIN
	SET NOCOUNT ON;

	SELECT [IdInstancia]
		  ,[Nombre]
		  ,[ImagenWeb]
		  ,[ImagenMovil]
		  ,[BaseDatos]
		  ,[Usuario]
		  ,[Clave]
		  ,[URL]
		  ,[AplicacionWeb]
		  ,[Latitud]
		  ,[Longitud]
		  ,[DiferenciaHora]
		  ,[DiferenciaMinutos]
  FROM [dbo].[Instancia]
  
END
GO
