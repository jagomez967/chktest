SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MAP_Cobertura_Diaria]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[MAP_Cobertura_Diaria] AS' 
END
GO
ALTER PROCEDURE [dbo].[MAP_Cobertura_Diaria] 	
	 @IdEmpresa int = NULL
	,@Dia varchar(max) = NULL--aaaammdd
	,@IdUsuario varchar(max) = NULL
AS


BEGIN


	SET NOCOUNT ON;

--DECLARE @IdEmpresa int
--DECLARE @Dia varchar(max) 
--DECLARE @IdUsuario varchar(max)

--SET @IdEmpresa = 270
--SET @Dia = '20140805'
--SET @IdUsuario  = NULL

DECLARE @IdCliente int
SELECT  @IdCliente = IdCliente FROM Cliente WHERE IdEmpresa = @IdEmpresa


SELECT 
	REPLACE(PDV.Nombre,'''','') as Nombre
	,REPLACE(ISNULL(PDV.Direccion,''),'''','') as Direccion 
	,Case When dbo.PDVRelevadoDiaSINO(Null,@IdEmpresa,CPV.IdPuntoDeVenta,Convert(datetime,@Dia,112)) = 1 Then '1' Else '0' End as Estado
	,PDV.Latitud
	,PDV.Longitud	
	,'Noimage.jpg' AS [Image]
FROM dbo.Cliente_PuntoDeVenta CPV
JOIN dbo.PuntoDeVenta PDV ON CPV.IdPuntoDeVenta = PDV.IdPuntoDeVenta
JOIN dbo.Usuario_Cliente UCL ON CPV.IdCliente = UCL.IdCliente
WHERE CPV.IdCliente = @IdCliente
	AND dbo.PuntoDeVenta_Cliente_Usuario_Dia_GetActivo(UCL.IDUsuario,@IdEmpresa,CPV.IdPuntoDeVenta,Convert(datetime,@Dia,112)) = 1
	AND (@IdUsuario is NULL OR UCL.IdUsuario IN (SELECT clave FROM dbo.fnSplitString(@IdUsuario,','))) 
	AND (PDV.Latitud IS NOT NULL AND PDV.Longitud IS NOT NULL)


END
GO
