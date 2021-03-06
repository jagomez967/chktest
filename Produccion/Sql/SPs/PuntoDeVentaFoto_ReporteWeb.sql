SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PuntoDeVentaFoto_ReporteWeb]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[PuntoDeVentaFoto_ReporteWeb] AS' 
END
GO
ALTER PROCEDURE [dbo].[PuntoDeVentaFoto_ReporteWeb]
	@IdPuntoDeVenta int = NULL 
   ,@FechaDesde DateTime = NULL
   ,@FechaHasta DateTime = NULL
   ,@IdEmpresa int = NULL
   ,@IdLocalidad int = NULL
   ,@IdZona int = NULL   
   ,@IdCadena int = NULL
   ,@IdUsuario int = NULL
   ,@observaciones varchar(max)=null
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
		  --,PDVF.[Foto]
		  ,'~/Fotos_2/' + cast(pdvf.IdEmpresa as varchar) + '/thumb' + CAST( [IdPuntoDeVentaFoto] as Varchar(20))+ '.jpg' AS PathFoto
		  ,E.Nombre AS EmpresaNombre
		  ,U.[Apellido] AS UsuarioApellido
		  ,U.[Nombre] AS UsuarioNombre		   
		  ,PDV.Nombre AS PDVNombre
		  ,PDV.Direccion AS PDVDireccion		  
  FROM [dbo].[PuntoDeVentaFoto] PDVF
  LEFT JOIN [Empresa]  E ON(E.IdEmpresa = PDVF.IdEmpresa)
  LEFT JOIN [Usuario]  U ON(U.IdUsuario = PDVF.IdUsuario)
  LEFT JOIN [PuntoDeVenta]  PDV ON(PDV.IdPuntoDeVenta = PDVF.IdPuntoDeVenta)
  WHERE  [Estado]=1 AND
       (@IdPuntoDeVenta IS NULL OR @IdPuntoDeVenta = PDVF.[IdPuntoDeVenta]) AND
       ([FechaCreacion] BETWEEN @FechaDesde AND @FechaHasta) AND
       (@IdEmpresa IS NULL OR @IdEmpresa = PDVF.[IdEmpresa]) AND
       (@IdLocalidad IS NULL OR @IdLocalidad = PDV.IdLocalidad) AND
       (@IdZona IS NULL OR @IdZona = PDV.IdZona) AND
       (@IdCadena IS NULL OR @IdCadena = PDV.IdCadena) AND        
       (@IdUsuario IS NULL OR @IdUsuario = PDVF.IdUsuario) and
	   (@observaciones is null or pdvf.comentario like '%'+@observaciones+'%')
   ORDER BY PDVF.[FechaCreacion] DESC
END

GO