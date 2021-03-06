SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MAP_UsuarioSeguimientoCapas]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[MAP_UsuarioSeguimientoCapas] AS' 
END
GO
ALTER PROCEDURE [dbo].[MAP_UsuarioSeguimientoCapas]
	 @IdEmpresa int = NULL
	,@IdUsuario int = NULL
    ,@Fecha DateTime = NULL
    
AS
BEGIN
	
	SET NOCOUNT ON;

--DECLARE @IdUsuario int
--DECLARE @Fecha Datetime
--DECLARE @IdEmpresa int
    
--SET @IdUsuario = 392
--SET @Fecha = convert(datetime,'20140124',112)
--SET @IdEmpresa = 270

SELECT 
	[IdUsuarioGEO]
	,[IdUsuario]
	,[Fecha]
	,CONVERT(char(5),Fecha,108) as [Hora]
	,[Latitud]
,[Longitud]
FROM [dbo].[UsuarioGEO]
WHERE [IdUsuario] = @IdUsuario AND
	DAY([Fecha])= DAY(@Fecha) AND
	MONTH([Fecha])= MONTH(@Fecha) AND
	YEAR([Fecha])= YEAR(@Fecha) AND  [Latitud]<>0 AND  [Longitud]<>0
ORDER BY [Fecha] 

DECLARE @IdCliente int
SELECT  @IdCliente = IdCliente FROM Cliente WHERE IdEmpresa = @IdEmpresa

--PDV viejo
--SELECT 
--	REPLACE(PDV.Nombre,'''','') as Nombre
--	,PDV.Latitud as Latitud
--	,PDV.Longitud as Longitud
--	,REPLACE(ISNULL(PDV.Direccion,''),'''','') as Direccion
--	,Case When dbo.PDVRelevadoDiaSINO(@IdUsuario,@IdEmpresa,CPV.IdPuntoDeVenta,Convert(datetime,@Fecha,112)) = 1 Then 'Relevado' Else 'No Relevado' End as Estado
--	,'Noimage.jpg' AS [Image]
--FROM dbo.Cliente_PuntoDeVenta CPV
--JOIN dbo.PuntoDeVenta PDV ON CPV.IdPuntoDeVenta = PDV.IdPuntoDeVenta
--JOIN dbo.Usuario_Cliente UCL ON CPV.IdCliente = UCL.IdCliente
--WHERE UCL.IdUsuario = @IdUsuario
--	AND (dbo.PDVRelevadoDiaSINO(@IdUsuario,@IdEmpresa,CPV.IdPuntoDeVenta,Convert(datetime,@Fecha,112)) = 1)
--	AND CPV.IdCliente = @IdCliente
--	AND dbo.PuntoDeVenta_Cliente_Usuario_Dia_GetActivo(UCL.IDUsuario,@IdEmpresa,CPV.IdPuntoDeVenta,Convert(datetime,@Fecha,112)) = 1
--	AND (Isnull(PDV.Latitud,0) <> 0 AND Isnull(PDV.Longitud,0) <> 0)

--Muestro los PDV sin relevar.
SELECT 	 PDV.Latitud
		,PDV.Longitud		
		,REPLACE(ISNULL(PDV.Nombre,''),'''','') as Nombre
		,REPLACE(ISNULL(PDV.Direccion,''),'''','') as Direccion
		,'Noimage.jpg' AS [Image]		
		,R.IdReporte as IdReporte
		,R.FechaCreacion AS Fecha
		,CONVERT(char(5),R.FechaCreacion,108) as [Hora]
FROM dbo.Reporte  R
JOIN dbo.PuntoDeVenta PDV on PDV.IdPuntoDeVenta = R.IdPuntoDeVenta
WHERE R.IdEmpresa = @IdEmpresa
	AND R.IdUsuario = @IdUsuario
	AND YEAR(R.FechaCreacion) = YEAR(@Fecha)
	AND MONTH(R.FechaCreacion) = MONTH(@Fecha)
	AND DAY(R.FechaCreacion) = DAY(@Fecha)
	AND ((Isnull(R.Latitud,0) <> 0 AND Isnull(R.Longitud,0) <> 0) 
		OR (Isnull(PDV.Latitud,0) <> 0 AND Isnull(PDV.Longitud,0) <> 0))


SELECT 	 Case When Isnull(R.Latitud,0) = 0 OR Isnull(R.Longitud,0) = 0 Then PDV.Latitud Else R.Latitud End as Latitud
		,Case When Isnull(R.Latitud,0) = 0 OR Isnull(R.Longitud,0) = 0 Then PDV.Longitud Else R.Longitud End as Longitud
		,R.IdReporte as IdReporte
		,CONVERT(char(5),R.FechaCreacion,108) as [Hora]
		,R.FechaCreacion AS Fecha
		,REPLACE(ISNULL(PDV.Nombre,''),'''','') as Nombre
		,REPLACE(ISNULL(PDV.Direccion,''),'''','') as Direccion
		,'Noimage.jpg' AS [Image]
		,Case When Isnull(R.Latitud,0) = 0 OR Isnull(R.Longitud,0) = 0 Then 'GEOReportePDV' Else 'GEOReporte' End as TipoGEO
FROM dbo.Reporte  R
JOIN dbo.PuntoDeVenta PDV on PDV.IdPuntoDeVenta = R.IdPuntoDeVenta
WHERE R.IdEmpresa = @IdEmpresa
	AND R.IdUsuario = @IdUsuario
	AND YEAR(R.FechaCreacion) = YEAR(@Fecha)
	AND MONTH(R.FechaCreacion) = MONTH(@Fecha)
	AND DAY(R.FechaCreacion) = DAY(@Fecha)
	AND ((Isnull(R.Latitud,0) <> 0 AND Isnull(R.Longitud,0) <> 0) 
		OR (Isnull(PDV.Latitud,0) <> 0 AND Isnull(PDV.Longitud,0) <> 0))


SELECT MAX(R.FechaCreacion) AS Fecha		
FROM dbo.Reporte R
JOIN dbo.PuntoDeVenta PDV on PDV.IdPuntoDeVenta = R.IdPuntoDeVenta
WHERE		R.IdEmpresa = @IdEmpresa
	AND R.IdUsuario = @IdUsuario
	AND ((Isnull(R.Latitud,0) <> 0 AND Isnull(R.Longitud,0) <> 0) 
		OR (Isnull(PDV.Latitud,0) <> 0 AND Isnull(PDV.Longitud,0) <> 0))
GROUP BY R.IdEmpresa,  R.IdUsuario
	
END
GO
