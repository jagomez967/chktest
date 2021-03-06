SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[RS_CoberturaClienteZona]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[RS_CoberturaClienteZona] AS' 
END
GO
ALTER PROCEDURE [dbo].[RS_CoberturaClienteZona] 	
	 @IdEmpresa int
	,@Dia varchar(max)=NULL
	,@Mes varchar(max)=NULL
	,@Ano varchar(max)=NULL
	,@Semana varchar(max)=NULL
	,@IdMarca varchar(max)=NULL
	,@IdProducto varchar(max)=NULL
	,@IdCadena varchar(max)=NULL
	,@IdPuntoDeVenta varchar(max)=NULL
	,@IdLocalidad varchar(max)=NULL
	,@IdZona varchar(max)=NULL
	,@IdUsuario varchar(max)=NULL
	
AS
BEGIN
	
	
	DECLARE @IdCliente int
	DECLARE @fecha datetime, @mes_ano varchar(max)
	
	SELECT  @IdCliente = IdCliente FROM Cliente WHERE IdEmpresa = @IdEmpresa
	
	If @Ano is not null and @mes is null
	SET @mes_ano = '01,02,03,04,05,06,07,08,09,10,11,12'
	
	IF (SELECT COUNT(*) FROM tempdb..sysobjects WHERE name like '##Periodos_CobCliZon%' AND xtype = 'U') > 0
	DROP TABLE ##Periodos_CobCliZon
	
	CREATE TABLE ##Periodos_CobCliZon(Ano int, Mes int, Semana int)
	
	--Periodos
	
	IF @Semana is not null
	BEGIN
		INSERT INTO ##Periodos_CobCliZon 
		SELECT Left(clave,4), month(dateadd(wk,Convert(int,Right(clave,2)),Left(clave,4) + '/01/01')), Right(clave,2)
		FROM dbo.fnSplitString(@Semana,',')
	END
	
	IF @Mes is not null
	BEGIN
		INSERT INTO ##Periodos_CobCliZon 
		SELECT Left(clave,4), Right(clave,2), null
		FROM dbo.fnSplitString(@Mes,',')
	END
	
	IF @Ano is not null
	BEGIN
		INSERT INTO ##Periodos_CobCliZon 
		SELECT a.clave,b.clave,null
		FROM dbo.fnSplitString(@Ano,',') a, dbo.fnSplitString(@mes_ano,',') b
	END

	
	--1 Busca PDV del Cliente
	
	SELECT  Z.Nombre as Zona,
			COUNT(TMP.IdPuntoDeVenta) AS Objetivo,
			SUM(CONVERT(int,Relevado)) as Relevado,
			CASE WHEN COUNT(TMP.IdPuntoDeVenta) = 0
			 THEN 0
			 ELSE (SUM(CONVERT(int,Relevado))/CONVERT(decimal(12,4),COUNT(TMP.IdPuntoDeVenta)))
			 END as Cobertura
	FROM 
	(SELECT ##Periodos_CobCliZon.Semana
			,##Periodos_CobCliZon.Mes
			,##Periodos_CobCliZon.Ano
			,IdPuntoDeVenta	
			,dbo.PDVRelevadoSINO(Null,@IdEmpresa,[IdPuntoDeVenta],##Periodos_CobCliZon.Mes,##Periodos_CobCliZon.Ano) AS Relevado
		FROM Cliente_PuntoDeVenta, ##Periodos_CobCliZon 
		WHERE IdCliente = @IdCliente
		AND dbo.PuntoDeVenta_Cliente_Usuario_Mes_PDV_GetActivo(@IdCliente,IdPuntoDeVenta,##Periodos_CobCliZon.Mes, ##Periodos_CobCliZon.Ano) = 1) TMP
  
	INNER JOIN PuntoDeVenta PV on PV.IdPuntoDeVenta = TMP.IdPuntoDeVenta
	INNER JOIN Usuario_PuntoDeVenta UPV on PV.IdPuntoDeVenta = UPV.IdPuntoDeVenta
	INNER JOIN Zona Z on PV.IdZona = Z.IdZona
	WHERE
		(@IdCadena is NULL OR PV.IdCadena IN (SELECT clave FROM dbo.fnSplitString(@IdCadena,',')))
		ANd (@IdPuntoDeVenta is NULL OR PV.IdPuntoDeVenta IN (SELECT clave FROM dbo.fnSplitString(@IdPuntoDeVenta,',')))
		AND (@IdLocalidad is NULL OR PV.IdLocalidad IN (SELECT clave FROM dbo.fnSplitString(@IdLocalidad,',')))
		AND (@IdZona is NULL OR PV.IdZona IN (SELECT clave FROM dbo.fnSplitString(@IdZona,',')))
		AND (@IdUsuario is NULL OR UPV.IdUsuario IN (SELECT clave FROM dbo.fnSplitString(@IdUsuario,','))) 
	GROUP BY Z.Nombre

		    
END
GO
