SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[RS_Cobertura]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[RS_Cobertura] AS' 
END
GO
ALTER PROCEDURE [dbo].[RS_Cobertura] 	
	 @IdEmpresa int
	,@Dia varchar(max) = NULL
	,@Mes varchar(max) = NULL
	,@Ano varchar(max) = NULL
	,@Semana varchar(max) = NULL
	,@IdMarca varchar(max) = NULL
	,@IdProducto varchar(max) = NULL
	,@IdCadena varchar(max) = NULL
	,@IdPuntoDeVenta varchar(max) = NULL
	,@IdLocalidad varchar(max) = NULL
	,@IdZona varchar(max) = NULL
	,@IdUsuario varchar(max) = NULL
AS


BEGIN

	SET NOCOUNT ON;
	
--DECLARE @IdEmpresa int
--DECLARE @Dia varchar(max)
--DECLARE @Mes varchar(max) 
--DECLARE @Ano varchar(max) 
--DECLARE @Semana varchar(max) 
--DECLARE @IdMarca varchar(max) 
--DECLARE @IdProducto varchar(max)
--DECLARE @IdCadena varchar(max) 
--DECLARE @IdPuntoDeVenta varchar(max) 
--DECLARE @IdLocalidad varchar(max) 
--DECLARE @IdZona varchar(max) 
--DECLARE @IdUsuario varchar(max)
	
--SET @IdEmpresa = 270
--SET @Dia  = NULL
--SET @Mes  = '201406'
--SET @Ano  = NULL
--SET @Semana  = null
--SET @IdMarca  = NULL
--SET @IdProducto  = NULL
--SET @IdCadena  = NULL
--SET @IdPuntoDeVenta = NULL
--SET @IdLocalidad  = NULL
--SET @IdZona  = NULL
--SET @IdUsuario  = NULL
	
	
	DECLARE @IdCliente int, @Periodo varchar(5), @mes_ano varchar(max)
	DECLARE @Periodos_CobCli TABLE (Ano int, Mes int, Semana int)
	DECLARE @TablaGeneral TABLE (Semana int, Mes int, Ano int, IdPuntoDeVenta int, IdUsuario int, IdCadena int, IdZona int, Relevado bit)
	
	SELECT  @IdCliente = IdCliente FROM Cliente WHERE IdEmpresa = @IdEmpresa
	
	If @Ano is not null and @mes is null
	SET @mes_ano = '01,02,03,04,05,06,07,08,09,10,11,12'
	
	
	--Periodos
	
	IF @Semana is not null
	BEGIN
		SET @Periodo = 'S'
		INSERT INTO @Periodos_CobCli 
		SELECT Left(clave,4), month(dateadd(wk,Convert(int,Right(clave,2)),Left(clave,4) + '/01/01')), Right(clave,2)--aaaa mm ss
		FROM dbo.fnSplitString(@Semana,',')
	END
	
	IF @Mes is not null
	BEGIN
		SET @Periodo = 'M'
		INSERT INTO @Periodos_CobCli 
		SELECT Left(clave,4), Right(clave,2), null
		FROM dbo.fnSplitString(@Mes,',')
	END
	
	IF @Ano is not null
	BEGIN
		SET @Periodo = 'A'
		INSERT INTO @Periodos_CobCli 
		SELECT a.clave,b.clave,null
		FROM dbo.fnSplitString(@Ano,',') a, dbo.fnSplitString(@mes_ano,',') b
	END

--SELECT * FROM @Periodos_CobCli
	
--------------------------------------------------------------------
INSERT INTO @TablaGeneral
SELECT 
	P.Semana
	,P.Mes
	,P.Ano
	,PDV.IdPuntoDeVenta	
	,UCL.IdUsuario
	,PDV.IdCadena
	,PDV.IdZona
	,dbo.PDVRelevadoSINO(Null,@IdEmpresa,PDV.IdPuntoDeVenta,P.Mes,P.Ano) AS Relevado
FROM @Periodos_CobCli P, dbo.PuntoDeVenta PDV
INNER JOIN dbo.Usuario_Cliente UCL ON PDV.IdCliente = UCL.IdCliente
WHERE PDV.IdCliente = @IdCliente
and P.Ano is not null
AND dbo.PuntoDeVenta_Cliente_Usuario_Mes_GetActivo(UCL.IDUsuario,@IdEmpresa,PDV.IdPuntoDeVenta,P.Mes, P.Ano) = 1
AND (@IdCadena is NULL OR PDV.IdCadena IN (SELECT clave FROM dbo.fnSplitString(@IdCadena,',')))
ANd (@IdPuntoDeVenta is NULL OR PDV.IdPuntoDeVenta IN (SELECT clave FROM dbo.fnSplitString(@IdPuntoDeVenta,',')))
AND (@IdLocalidad is NULL OR PDV.IdLocalidad IN (SELECT clave FROM dbo.fnSplitString(@IdLocalidad,',')))
AND (@IdZona is NULL OR PDV.IdZona IN (SELECT clave FROM dbo.fnSplitString(@IdZona,',')))
AND (@IdUsuario is NULL OR UCL.IdUsuario IN (SELECT clave FROM dbo.fnSplitString(@IdUsuario,',')))

--SELECT * FROM @TablaGeneral


--------------------------------------------------------------------			
-- COBERTURA CLIENTE
SELECT 
	CASE WHEN @Periodo = 'S' THEN convert(varchar,TMP.Ano) + '/' + REPLICATE('0',2-LEN(convert(varchar,TMP.Semana))) + convert(varchar,TMP.Semana)
		 WHEN @Periodo = 'M' THEN convert(varchar,TMP.Ano) + '/' + REPLICATE('0',2-LEN(convert(varchar,TMP.Mes))) + convert(varchar,TMP.Mes)
		 WHEN @Periodo = 'A' THEN convert(varchar,TMP.Ano)
		END as Periodo,
	COUNT(TMP.IdPuntoDeVenta) AS Objetivo,
	SUM(CONVERT(int,Relevado)) as Cobertura
FROM @TablaGeneral TMP
GROUP BY CASE WHEN @Periodo = 'S' THEN convert(varchar,TMP.Ano) + '/' + REPLICATE('0',2-LEN(convert(varchar,TMP.Semana))) + convert(varchar,TMP.Semana)
			  WHEN @Periodo = 'M' THEN convert(varchar,TMP.Ano) + '/' + REPLICATE('0',2-LEN(convert(varchar,TMP.Mes))) + convert(varchar,TMP.Mes)
			  WHEN @Periodo = 'A' THEN convert(varchar,TMP.Ano)
			  END

ORDER BY 1


--------------------------------------------------------------------
-- COBERTURA POR USUARIO
SELECT 	TMP.IdUsuario,
		ISNULL(U.[Apellido],'') + ', ' + ISNULL(U.[Nombre],'') COLLATE DATABASE_DEFAULT  As Nombre,	
		COUNT(TMP.IdPuntoDeVenta) AS Objetivo,
		SUM(CONVERT(int,TMP.Relevado)) as Relevado,
		CASE WHEN COUNT(TMP.IdPuntoDeVenta) = 0 THEN 0
			 ELSE (SUM(CONVERT(int,TMP.Relevado))/CONVERT(decimal(12,4),COUNT(TMP.IdPuntoDeVenta)))
			 END as Cobertura
FROM @TablaGeneral TMP
JOIN dbo.Usuario U on U.IdUsuario = TMP.IdUsuario
GROUP BY TMP.IdUsuario, 
	ISNULL(U.[Apellido],'') + ', ' + ISNULL(U.[Nombre],'') COLLATE DATABASE_DEFAULT


--------------------------------------------------------------------
--COBERTURA POR RETAIL
SELECT   
		CA.Nombre as Retail,
		COUNT(TMP.IdPuntoDeVenta) AS Objetivo,
		SUM(CONVERT(int,Relevado)) as Relevado,
		CASE WHEN COUNT(TMP.IdPuntoDeVenta) = 0 THEN 0
		 ELSE (SUM(CONVERT(int,TMP.Relevado))/CONVERT(decimal(12,4),COUNT(TMP.IdPuntoDeVenta)))
		 END as Cobertura
FROM @TablaGeneral TMP
INNER JOIN [Cadena] CA on TMP.IdCadena = CA.IdCadena
GROUP BY CA.Nombre
	

--------------------------------------------------------------------
--COBERTURA POR ZONA
SELECT  Z.Nombre as Zona,
		COUNT(TMP.IdPuntoDeVenta) AS Objetivo,
		SUM(CONVERT(int,TMP.Relevado)) as Relevado,
		CASE WHEN COUNT(TMP.IdPuntoDeVenta) = 0
		 THEN 0
		 ELSE (SUM(CONVERT(int,TMP.Relevado))/CONVERT(decimal(12,4),COUNT(TMP.IdPuntoDeVenta)))
		 END as Cobertura
FROM @TablaGeneral TMP
INNER JOIN Zona Z on TMP.IdZona = Z.IdZona 
GROUP BY Z.Nombre


--------------------------------------------------------------------
--RELEVADOS POR ZONA
SELECT  '('+LEFT(Nombre,2)+')' as CodigoZona,
		Z.Nombre as Zona,
		SUM(CONVERT(int,TMP.Relevado)) as Relevado
FROM @TablaGeneral TMP
INNER JOIN Zona Z on TMP.IdZona = Z.IdZona 
GROUP BY Z.Nombre


END

GO
