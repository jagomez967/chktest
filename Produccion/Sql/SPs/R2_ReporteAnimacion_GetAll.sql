SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[R2_ReporteAnimacion_GetAll]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[R2_ReporteAnimacion_GetAll] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[R2_ReporteAnimacion_GetAll]
	-- Add the parameters for the stored procedure here
	@IdReporte2 int = NULL
   ,@IdMarca int
   
AS
BEGIN
	SET NOCOUNT ON;

    SELECT A.[IdAnimacion]
		  ,A.[IdMarca]
		  ,A.[Descripcion] AS AnimacionNombre
		  ,A.[Orden]
		  ,RA.[IdExhibidor]
		  ,(case when RA.[Stock] IS NULL then '0' else RA.[Stock] end) as Stock
		  ,(case when RA.[SellOut] IS NULL then '0' else RA.[SellOut] end) as SellOut
		  ,RA.[Comentarios]
	FROM  [R2_Animacion] A
	LEFT JOIN [R2_ReporteAnimacion] RA ON (RA.[IdReporte2] = @IdReporte2 AND A.[IdAnimacion] = RA.[IdAnimacion])
	WHERE (A.[IdMarca] = @IdMarca) AND
	      (A.[Activo]=1)
	ORDER BY A.Descripcion
	
END
GO
