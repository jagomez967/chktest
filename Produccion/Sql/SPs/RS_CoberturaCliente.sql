SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[RS_CoberturaCliente]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[RS_CoberturaCliente] AS' 
END
GO
ALTER PROCEDURE [dbo].[RS_CoberturaCliente] 	
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
	DECLARE @IdCliente int, @Periodo varchar(5), @mes_ano varchar(max)
	
	SELECT  @IdCliente = IdCliente FROM Cliente WHERE IdEmpresa = @IdEmpresa
	
	If @Ano is not null and @mes is null
	SET @mes_ano = '01,02,03,04,05,06,07,08,09,10,11,12'
	
	DECLARE @Periodos_CobCli TABLE (Ano int, Mes int, Semana int)
	
	--Periodos
	
	IF @Semana is not null
	BEGIN
		SELECT @Periodo = 'S'
		INSERT INTO @Periodos_CobCli 
		SELECT Left(clave,4), month(dateadd(wk,Convert(int,Right(clave,2)),Left(clave,4) + '/01/01')), Right(clave,2)
		FROM dbo.fnSplitString(@Semana,',')
	END
	
	IF @Mes is not null
	BEGIN
		SELECT @Periodo = 'M'
		INSERT INTO @Periodos_CobCli 
		SELECT Left(clave,4), Right(clave,2), null
		FROM dbo.fnSplitString(@Mes,',')
	END
	
	IF @Ano is not null
	BEGIN
		SELECT @Periodo = 'A'
		INSERT INTO @Periodos_CobCli 
		SELECT a.clave,b.clave,null
		FROM dbo.fnSplitString(@Ano,',') a, dbo.fnSplitString(@mes_ano,',') b
	END
		
			
	--1 Busca PDV del Cliente
	
	SELECT 
		CASE WHEN @Periodo = 'S' THEN convert(varchar,TMP.Ano) + '/' + REPLICATE('0',2-LEN(convert(varchar,TMP.Semana))) + convert(varchar,TMP.Semana)
			 WHEN @Periodo = 'M' THEN convert(varchar,TMP.Ano) + '/' + REPLICATE('0',2-LEN(convert(varchar,TMP.Mes))) + convert(varchar,TMP.Mes)
			 WHEN @Periodo = 'A' THEN convert(varchar,TMP.Ano)
			END as Periodo,
		COUNT(TMP.IdPuntoDeVenta) AS Objetivo,
		SUM(CONVERT(int,Relevado)) as Cobertura
	FROM 
		(SELECT P.Semana
				,P.Mes
				,P.Ano
				,CPV.IdPuntoDeVenta	
				,dbo.PDVRelevadoSINO(Null,@IdEmpresa,CPV.IdPuntoDeVenta,P.Mes,P.Ano) AS Relevado
		FROM Cliente_PuntoDeVenta CPV
		INNER JOIN @Periodos_CobCli P ON P.Ano is not null
		INNER JOIN PuntoDeVenta PDV ON CPV.IdPuntoDeVenta = PDV.IdPuntoDeVenta
		INNER JOIN Usuario_PuntoDeVenta UPV ON CPV.IdPuntoDeVenta = UPV.IdPuntoDeVenta
		INNER JOIN Usuario_Cliente UCL ON CPV.IdCliente = UCL.IdCliente
		WHERE CPV.IdCliente = @IdCliente
		AND dbo.PuntoDeVenta_Cliente_Usuario_Mes_GetActivo(UCL.IDUsuario,@IdEmpresa,CPV.IdPuntoDeVenta,P.Mes, P.Ano) = 1
		AND (@IdCadena is NULL OR PDV.IdCadena IN (SELECT clave FROM dbo.fnSplitString(@IdCadena,',')))
		ANd (@IdPuntoDeVenta is NULL OR PDV.IdPuntoDeVenta IN (SELECT clave FROM dbo.fnSplitString(@IdPuntoDeVenta,',')))
		AND (@IdLocalidad is NULL OR PDV.IdLocalidad IN (SELECT clave FROM dbo.fnSplitString(@IdLocalidad,',')))
		AND (@IdZona is NULL OR PDV.IdZona IN (SELECT clave FROM dbo.fnSplitString(@IdZona,',')))
		AND (@IdUsuario is NULL OR UCL.IdUsuario IN (SELECT clave FROM dbo.fnSplitString(@IdUsuario,','))) ) TMP
  
	GROUP BY CASE WHEN @Periodo = 'S' THEN convert(varchar,TMP.Ano) + '/' + REPLICATE('0',2-LEN(convert(varchar,TMP.Semana))) + convert(varchar,TMP.Semana)
				  WHEN @Periodo = 'M' THEN convert(varchar,TMP.Ano) + '/' + REPLICATE('0',2-LEN(convert(varchar,TMP.Mes))) + convert(varchar,TMP.Mes)
				  WHEN @Periodo = 'A' THEN convert(varchar,TMP.Ano)
				  END
	
	ORDER BY 1
END

GO
