SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[RS_CoberturaClienteUsuario]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[RS_CoberturaClienteUsuario] AS' 
END
GO
ALTER PROCEDURE [dbo].[RS_CoberturaClienteUsuario] 	
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
	
	
	SET NOCOUNT ON;
	DECLARE @IdCliente int
	DECLARE @fecha datetime, @mes_ano varchar(max)
	
	SELECT  @IdCliente = IdCliente FROM Cliente WHERE IdEmpresa = @IdEmpresa
	
	If @Ano is not null and @mes is null
	SET @mes_ano = '01,02,03,04,05,06,07,08,09,10,11,12'
	
	IF (SELECT COUNT(*) FROM tempdb..sysobjects WHERE name like '##Periodos_CobCliUsr%' AND xtype = 'U') > 0
	DROP TABLE ##Periodos_CobCliUsr
	
	CREATE TABLE ##Periodos_CobCliUsr(Ano int, Mes int, Semana int)
	
	--Periodos
	
	IF @Semana is not null
	BEGIN
		INSERT INTO ##Periodos_CobCliUsr 
		SELECT Left(clave,4), month(dateadd(wk,Convert(int,Right(clave,2)),Left(clave,4) + '/01/01')), Right(clave,2)
		FROM dbo.fnSplitString(@Semana,',')
	END
	
	IF @Mes is not null
	BEGIN
		INSERT INTO ##Periodos_CobCliUsr 
		SELECT Left(clave,4), Right(clave,2), null
		FROM dbo.fnSplitString(@Mes,',')
	END
	
	IF @Ano is not null
	BEGIN
		INSERT INTO ##Periodos_CobCliUsr 
		SELECT a.clave,b.clave,null
		FROM dbo.fnSplitString(@Ano,',') a, dbo.fnSplitString(@mes_ano,',') b
	END
		

SELECT 	TMP.IdUsuario,
		TMP.Nombre,		
		COUNT(TMP.IdPuntoDeVenta) AS Objetivo,
		SUM(CONVERT(int,TMP.Activo)) as Relevado,
		CASE WHEN COUNT(TMP.IdPuntoDeVenta) = 0
			 THEN 0
			 ELSE (SUM(CONVERT(int,TMP.Activo))/CONVERT(decimal(12,4),COUNT(TMP.IdPuntoDeVenta)))
			 END as Cobertura
FROM
	(SELECT UPDV.IdPuntoDeVenta             
		   ,UPDV.IdUsuario
		   ,ISNULL(U.[Apellido],'') + ', ' + ISNULL(U.[Nombre],'') COLLATE DATABASE_DEFAULT  As Nombre
		   ,dbo.PDVRelevadoSINO(UPDV.IdUsuario,@IdEmpresa,UPDV.[IdPuntoDeVenta],P.Mes,P.Ano) AS Activo
	  FROM Usuario_PuntoDeVenta UPDV
	  LEFT JOIN ##Periodos_CobCliUsr P ON P.Ano is not null
	  INNER JOIN PuntoDeVenta PDV ON (PDV.IdPuntoDeVenta = UPDV.IdPuntoDeVenta)
	  INNER JOIN Usuario U ON (U.IdUsuario = UPDV.IdUsuario AND IdGrupo = 2)
	  --INNER JOIN Cliente_PuntoDeVenta  CPDV ON (CPDV.IdCliente = @IdCliente AND CPDV.IdPuntoDeVenta = UPDV.IdPuntoDeVenta)
	  INNER JOIN Usuario_Cliente UC ON  (UC.IdCliente = @IdCliente AND UPDV.IdUsuario = UC.IdUsuario)
	  WHERE dbo.PuntoDeVenta_Cliente_Usuario_Mes_GetActivo(UC.IDUsuario,@IdEmpresa,UPDV.IdPuntoDeVenta,P.Mes, P.Ano) = 1
		AND (@IdCadena is NULL OR PDV.IdCadena IN (SELECT clave FROM dbo.fnSplitString(@IdCadena,',')))
		ANd (@IdPuntoDeVenta is NULL OR PDV.IdPuntoDeVenta IN (SELECT clave FROM dbo.fnSplitString(@IdPuntoDeVenta,',')))
		AND (@IdLocalidad is NULL OR PDV.IdLocalidad IN (SELECT clave FROM dbo.fnSplitString(@IdLocalidad,',')))
		AND (@IdZona is NULL OR PDV.IdZona IN (SELECT clave FROM dbo.fnSplitString(@IdZona,',')))
		AND (@IdUsuario is NULL OR UC.IdUsuario IN (SELECT clave FROM dbo.fnSplitString(@IdUsuario,','))) ) TMP
GROUP BY TMP.IdUsuario, TMP.Nombre


END

GO
