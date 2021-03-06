SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CD_PuntoDeVenta_GetAll2]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[CD_PuntoDeVenta_GetAll2] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[CD_PuntoDeVenta_GetAll2]
	-- Add the parameters for the stored procedure here
	@IdPuntoDeVenta int = NULL
   ,@Nombre varchar(255) = NULL
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
		SELECT PDV.[IdPuntoDeVenta]
		  ,PDV.[Codigo]
		  ,PDV.[Nombre]
		  ,PDV.[Direccion]
		  ,PDV.[IdCadena]
		  ,C.Nombre AS CadenaNombre
		  ,PDV.[IdPuntoDeVentaMKT]
		  ,PDV.[IdRegion]
		  ,R.Nombre  AS RegionNombre
		  ,PDV.[Activo]		  
	  FROM [dbo].[CD_PuntoDeVenta] PDV
	  LEFT JOIN [dbo].[CD_Region] R ON (R.[IdRegion] = PDV.[IdRegion])
	  LEFT JOIN [dbo].[CD_Cadena] C ON (C.[IdCadena]  = PDV.[IdCadena])	  
	  WHERE (@IdPuntoDeVenta IS NULL OR @IdPuntoDeVenta = PDV.[IdPuntoDeVenta]) AND
		    (@Nombre IS NULL OR PDV.[Nombre] like '%' + @Nombre + '%')
	  ORDER BY PDV.[Nombre]
	
END
GO
