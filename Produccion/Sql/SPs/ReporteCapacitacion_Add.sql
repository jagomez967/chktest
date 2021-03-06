SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ReporteCapacitacion_Add]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[ReporteCapacitacion_Add] AS' 
END
GO
ALTER PROCEDURE [dbo].[ReporteCapacitacion_Add]
	
	 @IdReporte int
    ,@Capacitacion bit
    ,@Contacto varchar(50) = NULL
    ,@Telefono varchar(20) = NULL
    ,@Fecha datetime = NULL
    ,@HorarioInicio varchar(10) = NULL
    ,@HorarioFin varchar(10) = NULL
    
    
AS
BEGIN
	
	SET NOCOUNT ON;

	INSERT INTO [dbo].[ReporteCapacitacion]
           ([IdReporte]
           ,[Capacitacion]
           ,[Contacto]
           ,[Telefono]
           ,[Fecha]
           ,[HorarioInicio]
           ,[HorarioFin])
     VALUES
           (@IdReporte
           ,@Capacitacion
           ,@Contacto
           ,@Telefono
           ,@Fecha
           ,@HorarioInicio
           ,@HorarioFin)

END
GO
