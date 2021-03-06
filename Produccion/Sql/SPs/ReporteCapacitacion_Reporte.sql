SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ReporteCapacitacion_Reporte]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[ReporteCapacitacion_Reporte] AS' 
END
GO
ALTER PROCEDURE [dbo].[ReporteCapacitacion_Reporte]
	-- Add the parameters for the stored procedure here	
	 @IdEmpresa int
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT ISNULL(U.[Apellido],'') + ', ' + ISNULL(U.[Nombre],'') COLLATE DATABASE_DEFAULT  As UsuarioApellidoNombre   
		  ,PDV.Nombre  As PuntoDeVentaNombre
		  ,PDV.Direccion As PuntoDeVentaDireccion		  
		  ,RC.[Contacto]
		  ,RC.[Telefono]      
		  ,CONVERT(VARCHAR(10), RC.[Fecha], 103) AS Fecha
		  ,RC.[HorarioInicio]
		  ,RC.[HorarioFin]
		  ,CONVERT(VARCHAR(10), R.[FechaCreacion], 103) AS FechaCreacion
	  FROM [dbo].[ReporteCapacitacion] RC
	  INNER JOIN Reporte R ON (R.[IdReporte] = RC.[IdReporte] AND @IdEmpresa = R.IdEmpresa)
	  INNER JOIN Usuario U ON (U.IdUsuario = R.IdUsuario)    
	  INNER JOIN PuntoDeVenta PDV ON (PDV.IdPuntoDeVenta = R.IdPuntoDeVenta)    
	  WHERE RC.[Capacitacion]=1

END
GO
