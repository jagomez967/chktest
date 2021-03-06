SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DermoReporteEmpresaCompetencia_GetAll]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[DermoReporteEmpresaCompetencia_GetAll] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[DermoReporteEmpresaCompetencia_GetAll]
	-- Add the parameters for the stored procedure here
	 @IdEmpresa int
	,@IdDermoReporte int = NULL
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	  SELECT  DREC.[IdDermoReporteEmpresaCompetencia]
	         ,DE.[IdEmpresaCompetencia]
		     ,E.[Nombre] AS NombreEmpresa
		     ,DREC.Descuento
		     ,DREC.Regalo
		     ,DREC.RegaloProducto
		     ,DREC.Beauty
	  FROM [dbo].[DermoEmpresaCompetencia] DE
	  INNER JOIN Empresa E ON (E.[IdEmpresa] = DE.[IdEmpresaCompetencia])
	  LEFT JOIN DermoReporteEmpresaCompetencia DREC ON (DE.[IdEmpresaCompetencia] =  DREC.[IdEmpresa] AND (DREC.[IdDermoReporte] = @IdDermoReporte))
	  WHERE DE.[IdEmpresa] =@IdEmpresa	  
	  
END
GO
