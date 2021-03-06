SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DermoReporte_GetAll]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[DermoReporte_GetAll] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[DermoReporte_GetAll]
	-- Add the parameters for the stored procedure here
	
	 @IdDermoReporte int = NULL
	,@IdPuntoDeVenta int = NULL
    ,@IdUsuario int =  NULL
    ,@Fecha datetime = NULL
    ,@Problemas varchar(MAX) = NULL
    ,@Comentarios varchar(MAX) = NULL
    
AS   
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT DR.[IdDermoReporte]
		  ,DR.[IdPuntoDeVenta]
		  ,DR.[IdUsuario]
		  ,DR.[Fecha]
		  ,DR.[IdDermoAccion]
		  ,DR.[HorarioEntrada]
		  ,DR.[HorarioSalida]
		  ,DR.[TurnosTomados]
		  ,DR.[TurnoAsistencia]
		  ,DR.[ClientesCaptados]
		  ,DR.[Contactos]
		  ,DR.[VentasSinAccionLRP]
          ,DR.[VentasSinAccionVICHY]
          ,DR.[Visitas]
		  ,DR.[ClientesBeauty]
		  ,DR.[VoucherVichy]
		  ,DR.[VoucherLRP]
		  ,DR.[Problemas]
          ,DR.[Comentarios]
          ,DR.[ComprasLuegoAsesoriamiento]
          ,DR.[ObjetivoVentas]
          ,PDV.[Nombre] AS PDVNombre
          ,PDV.[Direccion]
          ,U.Apellido + ', ' + U.Nombre COLLATE DATABASE_DEFAULT  AS UsuarioNombre
          ,Z.Nombre AS ZonaNombre
	  FROM [dbo].[DermoReporte] DR
	  LEFT JOIN PuntoDeVenta PDV ON (DR.[IdPuntoDeVenta] = PDV.[IdPuntoDeVenta])
	  LEFT JOIN Zona Z ON (PDV.[IdZona] = Z.[IdZona])
	  LEFT JOIN DermoAccion DA ON (DR.[IdDermoAccion] = DA.[IdDermoAccion])
	  LEFT JOIN Usuario U ON (U.[IdUsuario] = DR.[IdUsuario])
	  WHERE (@IdDermoReporte IS NULL OR @IdDermoReporte = DR.[IdDermoReporte]) AND
			(@IdPuntoDeVenta IS NULL OR @IdPuntoDeVenta = DR.[IdPuntoDeVenta]) AND
			(@IdUsuario IS NULL OR @IdUsuario = DR.[IdUsuario])  AND
			(@Fecha IS NULL OR CONVERT(varchar(8), @Fecha, 112)  = CONVERT(varchar(8), DR.[Fecha], 112))
	  ORDER BY DR.[Fecha] DESC

END
GO
