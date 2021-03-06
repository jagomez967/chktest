SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CD_Campania_GetAll2]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[CD_Campania_GetAll2] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[CD_Campania_GetAll2]
	-- Add the parameters for the stored procedure here
	@IdCampania int = NULL
   ,@IdSistema int = NULL
   ,@Nombre varchar(255) = NULL
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT C.[IdCampania]
		  ,C.[Codigo]
		  ,C.[Nombre]
		  ,C.[Decripcion]
		  ,C.[PorcDescuento]
		  ,C.[ValidaDesde]
		  ,C.[ValidaHasta]
		  ,C.[IdSistema]
		  ,S.Nombre AS SistemaNombre
		  ,C.[Activo]
	FROM [dbo].[CD_Campania] C
	LEFT JOIN Sistema S ON (S.IdSistema = C.IdSistema)  
	WHERE (@IdCampania IS NULL OR [IdCampania] = @IdCampania)  AND 
	      (@IdSistema IS NULL OR C.[IdSistema] = @IdSistema) AND
	      (@Nombre IS NULL OR C.[Nombre] like '%' + @Nombre + '%')
	ORDER BY [Nombre]
  
END
GO
