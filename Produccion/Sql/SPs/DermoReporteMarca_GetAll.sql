SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DermoReporteMarca_GetAll]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[DermoReporteMarca_GetAll] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[DermoReporteMarca_GetAll] 
	-- Add the parameters for the stored procedure here
	 @IdEmpresa int
	,@IdDermoReporte int = NULL
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
 	 SELECT M.[IdMarca]
	  	   ,M.[Nombre] AS NombreMarca
		   ,DRM.IdDermoReporteMarca
		   ,DRM.Descuento
		   ,DRM.Regalo
		   ,DRM.Comentarios
		   ,DRM.Beauty
	  FROM [dbo].[Marca] M
	  LEFT JOIN  DermoReporteMarca DRM ON (DRM.[IdMarca] =  M.[IdMarca] AND (DRM.[IdDermoReporte] = @IdDermoReporte))
	  WHERE M.[IdEmpresa] = @IdEmpresa
	  ORDER BY M.[Orden]

END
GO
