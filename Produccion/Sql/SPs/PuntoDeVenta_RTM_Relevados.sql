SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PuntoDeVenta_RTM_Relevados]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[PuntoDeVenta_RTM_Relevados] AS' 
END
GO
ALTER PROCEDURE [dbo].[PuntoDeVenta_RTM_Relevados] 	
	 @IdUsuario int 
	,@IdEmpresa int
	,@Mes int
	,@Ano int 
	
AS
BEGIN
	
	SET NOCOUNT ON;

CREATE TABLE #Table1 (IdPuntoDeVenta int
                     ,CodigoPDV int
                     ,NombrePDV varchar(200)
                     ,Direccion varchar(500)
                     ,NombreProvincia varchar(200)
                     ,NombreLocalidad varchar(200)
                     ,NombreZona  varchar(200)
                     ,FechaCarga DateTime
                     ,Cantidad int
                     ,Activo bit)
	INSERT INTO #Table1     
SELECT UPDV.[IdPuntoDeVenta]            
		  ,PDV.[Codigo] CodigoPDV
		  ,PDV.Nombre NombrePDV
		  ,PDV.[Direccion]
		  ,P.Nombre NombreProvincia      
		  ,L.Nombre NombreLocalidad
		  ,Z.Nombre NombreZona
		  ,dbo.PDVRelevado(@IdUsuario,@IdEmpresa,UPDV.[IdPuntoDeVenta],@Mes,@Ano) AS FechaCarga
		  ,dbo.PDVRelevadoCantidad(@IdUsuario,@IdEmpresa,UPDV.[IdPuntoDeVenta],@Mes,@Ano) AS Cantidad
		  ,dbo.PuntoDeVenta_Cliente_Usuario_Mes_GetActivo(@IdUsuario,@IdEmpresa,UPDV.[IdPuntoDeVenta],@Mes,@Ano) AS Activo
  FROM [dbo].[Usuario_PuntoDeVenta] UPDV
  INNER JOIN Usuario U ON (U.IdUsuario = UPDV.IdUsuario AND IdGrupo = 2)
  INNER JOIN PuntoDeVenta PDV ON (PDV.IdPuntoDeVenta = UPDV.IdPuntoDeVenta)
  LEFT JOIN Localidad L ON (L.IdLocalidad = PDV.IdLocalidad)
  LEFT JOIN Provincia P ON (P.IdProvincia = L.IdProvincia)
  LEFT JOIN Zona Z ON (PDV.IdZona = Z.IdZona)
  INNER JOIN Cliente  C ON (PDV.IdCliente = C.IdCliente AND C.IdEmpresa = @IdEmpresa)
  WHERE UPDV.IdUsuario = @IdUsuario 
  ORDER BY FechaCarga,PDV.Nombre

  SELECT count(1) as Cantidad
  FROM #Table1 
  WHERE  Activo = 1
  
  SELECT count(1) as Cantidad
  FROM #Table1
  WHERE FechaCarga IS NULL AND Activo = 1
    
  SELECT count(1) as Cantidad
  FROM #Table1
  WHERE NOT FechaCarga  IS NULL AND Activo = 1

  SELECT IdPuntoDeVenta
        ,CodigoPDV
        ,NombrePDV
        ,Direccion
        ,NombreProvincia
        ,NombreLocalidad
        ,NombreZona
       ,CONVERT(nvarchar(30), FechaCarga,103) +  ' ' + CONVERT(nvarchar(30), FechaCarga,108) AS FechaCarga     
       ,CASE 
			WHEN FechaCarga IS NULL THEN 'Pendiente'
		ELSE 'Relevado' 
		END Estado      
	   ,Cantidad 
   FROM #Table1
   WHERE Activo = 1

  
  SELECT R.[IdReporte]
        ,PDV.Codigo
        ,PDV.Nombre
        ,PDV.Direccion
        ,CONVERT(nvarchar(30), R.[FechaCreacion],103) +  ' ' + CONVERT(nvarchar(30), R.[FechaCreacion],108) AS FechaCreacion                   
        ,CONVERT(nvarchar(30), R.[FechaActualizacion],103) +  ' ' + CONVERT(nvarchar(30), R.[FechaActualizacion],108) AS FechaActualizacion                   
        ,R.[IdEmpresa]
        ,E.Nombre as NombreEmpresa
        ,dbo.PuntoDeVenta_RTM_Relevados_CantidadEditados(R.[IdReporte]) As CantidadEdiciones
  FROM [dbo].[Reporte] R  
  INNER JOIN PuntoDeVenta PDV ON (PDV.IdPuntoDeVenta = R.IdPuntoDeVenta)
  INNER JOIN Empresa E ON (E.IdEmpresa = R.IdEmpresa)
  WHERE R.[IdUsuario] = @IdUsuario AND
		R.[IdEmpresa] = @IdEmpresa AND  
		DATEPART (month, R.FechaCreacion) = @Mes AND 
		DATEPART (year,  R.FechaCreacion) = @Ano    
 ORDER BY R.FechaCreacion
		    
END



GO
