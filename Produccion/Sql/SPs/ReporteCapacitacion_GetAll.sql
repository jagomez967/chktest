SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ReporteCapacitacion_GetAll]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[ReporteCapacitacion_GetAll] AS' 
END
GO
ALTER PROCEDURE [dbo].[ReporteCapacitacion_GetAll]
	@IdReporte int
	
AS
BEGIN
	SET NOCOUNT ON;

	SELECT [Id]
		  ,[IdReporte]
		  ,[Capacitacion]
		  ,[Contacto]
		  ,[Telefono]
		  ,[Fecha]
		  ,[HorarioInicio]
		  ,[HorarioFin]
	  FROM [dbo].[ReporteCapacitacion]
	  WHERE [IdReporte]=@IdReporte

END
GO
