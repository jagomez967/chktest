SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Reporte_Get]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Reporte_Get] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[Reporte_Get]
	-- Add the parameters for the stored procedure here
	@IdReporte int  
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT R.[IdReporte]
		  ,R.[IdPuntoDeVenta]
	      ,R.[IdUsuario]
		  ,R.[FechaCreacion]
		  ,R.[FechaActualizacion]
		  ,R.[IdEmpresa]
		  ,R.[AuditoriaNoAutorizada]
		  ,R.Latitud 
		  ,R.Longitud		  
		  ,R.Firma
		  ,PDV.[Codigo] AS PDVCodigo
		  ,PDV.[Nombre] AS PDVNombre
		  ,PDV.[Direccion] AS PDVDireccion
		  ,U.[Apellido] AS UsuarioApellido
		  ,U.[Nombre] AS UsuarioNombre
	FROM [dbo].[Reporte] R
	INNER JOIN PuntoDeVenta PDV ON (PDV.IdPuntoDeVenta = R.IdPuntoDeVenta)
	INNER JOIN Usuario U ON (R.[IdUsuario] = U.[IdUsuario])
	WHERE @IdReporte = R.[IdReporte]

END
GO
