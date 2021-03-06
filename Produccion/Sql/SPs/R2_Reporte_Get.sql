SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[R2_Reporte_Get]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[R2_Reporte_Get] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[R2_Reporte_Get]
	@IdReporte2 int  
	
AS
BEGIN
	SET NOCOUNT ON;

	SELECT R.[IdReporte2]
		  ,R.[IdPuntoDeVenta]
	      ,R.[IdUsuario]
		  ,R.[FechaCreacion]
		  ,R.[FechaActualizacion]
		  ,R.[IdEmpresa]
		  ,R.[AuditoriaNoAutorizada]
		  ,[ResponsableDermo1]
    	  ,[IdResponsableDermo1]
          ,[ResponsableDermo2]
          ,[IdResponsableDermo2]
	FROM [dbo].[R2_Reporte] R
	WHERE @IdReporte2 = R.[IdReporte2]

END
GO
