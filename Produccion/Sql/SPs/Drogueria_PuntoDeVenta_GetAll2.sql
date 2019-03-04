SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Drogueria_PuntoDeVenta_GetAll2]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Drogueria_PuntoDeVenta_GetAll2] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[Drogueria_PuntoDeVenta_GetAll2]
	
	@IdPuntoDeVenta int = NULL
	
AS
BEGIN
	
	SET NOCOUNT ON;
   
	SELECT [IdDrogueria]          
          ,[IdPuntoDeVenta]
          ,[Codigo]
          ,'' AS Nombre
    FROM dbo.Drogueria_PuntoDeVenta
    
END
GO
