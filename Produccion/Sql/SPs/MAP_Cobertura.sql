SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MAP_Cobertura]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[MAP_Cobertura] AS' 
END
GO
ALTER PROCEDURE [dbo].[MAP_Cobertura] 	
	 @IdEmpresa int = NULL
	,@Mes varchar(max) = NULL
	,@IdUsuario varchar(max) = NULL
AS


BEGIN


	SET NOCOUNT ON;

--DECLARE @IdEmpresa int
--DECLARE @Mes varchar(max) 
--DECLARE @IdUsuario varchar(max)

--SET @IdEmpresa = 270
--SET @Mes = '201406,201407,201408'
--SET @IdUsuario  = NULL

DECLARE @IdCliente int
SELECT  @IdCliente = IdCliente FROM Cliente WHERE IdEmpresa = @IdEmpresa
DECLARE @AUX TABLE (Mes char(6), Nombre varchar(255), Direccion varchar(255),Estado int, Latitud decimal(11,8), Longitud decimal(11,8), [Image] varchar(255))

--Select clave as Mes From dbo.fnSplitString(@Mes,',')

INSERT INTO @AUX
SELECT Meses.clave as Mes,
	REPLACE(PDV.Nombre,'''','') as Nombre
	,REPLACE(ISNULL(PDV.Direccion,''),'''','') as Direccion 
	,convert(int, dbo.PDVRelevadoSINO(Null,@IdEmpresa,CPV.IdPuntoDeVenta,Right(Meses.clave,2),Left(Meses.clave,4))) as Estado
	,PDV.Latitud
	,PDV.Longitud	
	,'Noimage.jpg' AS [Image]
FROM dbo.Cliente_PuntoDeVenta CPV
CROSS JOIN dbo.fnSplitString(@Mes,',') Meses
JOIN dbo.PuntoDeVenta PDV ON CPV.IdPuntoDeVenta = PDV.IdPuntoDeVenta
JOIN dbo.Usuario_Cliente UCL ON CPV.IdCliente = UCL.IdCliente
WHERE CPV.IdCliente = @IdCliente
	AND dbo.PuntoDeVenta_Cliente_Usuario_Mes_GetActivo(UCL.IDUsuario,@IdEmpresa,CPV.IdPuntoDeVenta,Right(Meses.clave,2), Left(Meses.clave,4)) = 1
	AND (@IdUsuario is NULL OR UCL.IdUsuario IN (SELECT clave FROM dbo.fnSplitString(@IdUsuario,','))) 
	AND (PDV.Latitud IS NOT NULL AND PDV.Longitud IS NOT NULL)


SELECT 
	Nombre
	,Direccion
	,Case When SUM(Estado) > 0 Then '1' Else '0' End as Estado
	,Latitud
	,Longitud
	,[Image]
FROM @AUX
GROUP BY
	Nombre
	,Direccion
	,Latitud
	,Longitud
	,[Image]

  
  
END
GO
