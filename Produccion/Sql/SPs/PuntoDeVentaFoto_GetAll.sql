SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PuntoDeVentaFoto_GetAll]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[PuntoDeVentaFoto_GetAll] AS' 
END
GO
ALTER PROCEDURE [dbo].[PuntoDeVentaFoto_GetAll]
	@IdPuntoDeVentaFoto int = NULL
   ,@IdPuntoDeVenta int = NULL
   ,@IdEmpresa int = NULL
   ,@IdUsuario int = NULL
   ,@Partes int = NULL
   ,@Estado bit = NULL
   ,@FechaCreacion Datetime = NULL
      
AS
BEGIN
	SET NOCOUNT ON;

	SELECT PDVF.[IdPuntoDeVentaFoto]
		  ,PDVF.[IdPuntoDeVenta]
		  ,PDVF.[IdEmpresa]
		  ,PDVF.[IdUsuario]
		  ,PDVF.[FechaCreacion]
		  ,PDVF.[Estado]
		  ,PDVF.[Partes]
		  ,PDVF.[Comentario]
		  ,E.Nombre AS EmpresaNombre
		  ,U.[Apellido] AS UsuarioApellido
		  ,U.[Nombre] AS UsuarioNombre		   
		  ,PDV.Nombre AS PDVNombre
		  ,PDV.Direccion AS PDVDireccion
  FROM [dbo].[PuntoDeVentaFoto] PDVF
  LEFT JOIN [Empresa]  E ON(E.IdEmpresa = PDVF.IdEmpresa)
  LEFT JOIN [Usuario]  U ON(U.IdUsuario = PDVF.IdUsuario)
  LEFT JOIN [PuntoDeVenta]  PDV ON(PDV.IdPuntoDeVenta = PDVF.IdPuntoDeVenta)
  WHERE 
	(@IdPuntoDeVentaFoto IS NULL OR @IdPuntoDeVentaFoto = PDVF.[IdPuntoDeVentaFoto]) AND
    (@IdPuntoDeVenta  IS NULL OR @IdPuntoDeVenta = PDVF.[IdPuntoDeVenta]) AND
    (@IdEmpresa IS NULL OR  @IdEmpresa = PDVF.[IdEmpresa]) AND
    (@IdUsuario IS NULL OR  @IdUsuario = PDVF.[IdUsuario])
   ORDER BY PDVF.[FechaCreacion] DESC

  
END



GO
