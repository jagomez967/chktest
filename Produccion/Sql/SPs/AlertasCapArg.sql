IF NOT EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND OBJECT_ID = OBJECT_ID('dbo.AlertasCapArg'))
   exec('CREATE PROCEDURE [dbo].[AlertasCapArg] AS BEGIN SET NOCOUNT ON; END')
GO
ALTER PROCEDURE AlertasCapArg
AS
BEGIN
	SET LANGUAGE SPANISH
	DECLARE @Hoy			DATE
	DECLARE @FechaInicial	DATE
	DECLARE @FechaFinal		DATE
	DECLARE @PrimerHabil	DATE
	DECLARE @CuartoHabil	DATE
	DECLARE @QuintoHabil	DATE

	SELECT @Hoy = GETDATE()
	SELECT @FechaInicial =  CONVERT(DATE,CONVERT(VARCHAR,DATEPART(YEAR,@Hoy)) + RIGHT('00' + CONVERT(VARCHAR,DATEPART(MONTH,@Hoy)),2) + '01')
	SELECT @FechaFinal =  DATEADD(DAY,-1,DATEADD(MONTH,1,@FechaInicial))

	;WITH DateTable
	AS
	(
		SELECT CONVERT(DATE,@FechaInicial) Fecha
		UNION ALL
		SELECT DATEADD(DAY, 1, Fecha)
		FROM DateTable
		WHERE DATEADD(DAY, 1, Fecha) < CONVERT(DATE,@FechaFinal)
	)SELECT 
		ROW_NUMBER() OVER(ORDER BY Fecha) Id,
		Fecha,
		DATENAME(WEEKDAY,Fecha) Dia
	INTO 
		#DAYS
	FROM 
		DateTable
	WHERE
		DATENAME(WEEKDAY,Fecha)  NOT IN ('Domingo','Sábado')
	OPTION (MAXRECURSION 31)

	SELECT @PrimerHabil = Fecha  FROM #DAYS WHERE Id = 1
	SELECT @CuartoHabil = Fecha  FROM #DAYS WHERE Id = 4
	SELECT @QuintoHabil = Fecha  FROM #DAYS WHERE Id = 5

	DROP TABLE #DAYS

	SELECT DISTINCT
		U.idUsuario,
		U.Apellido + ', ' + U.Nombre COLLATE DATABASE_DEFAULT Nombre,
		C.idCadena
	INTO
		#TmpConfirmadas
	FROM 
		Forecasting F
		INNER JOIN Usuario U ON F.idUsuario = U.idUsuario
		INNER JOIN Cadena C ON F.idCadena = C.idCadena
		INNER JOIN ForecastingConfirmStatusLog FCL ON U.idUsuario = FCL.idUsuario
			AND C.idCadena = FCL.idCadena
			AND MONTH(F.Fecha) = MONTH(FCL.Fecha)
			AND YEAR(F.Fecha) = YEAR(FCL.Fecha)
	WHERE 
		F.idCliente = 178 
		AND ISNULL(F.idUsuario,0) != 0  
		AND U.esCheckPos = 0 
		AND F.Fecha >= @FechaInicial 
		AND F.Fecha <= @FechaFinal
		AND (SELECT TOP 1 OperationType FROM ForecastingConfirmStatusLog WHERE idUsuario = U.idUsuario AND idCadena = C.idCadena AND idCliente = F.idCliente AND ISNULL(idProducto,0) = 0  ) = 'CONFIRM'


	SELECT DISTINCT 
		U.idUsuario,
		U.Apellido + ', ' + U.Nombre COLLATE DATABASE_DEFAULT Nombre,
		C.idCadena
	INTO
		#TmpAsignadas
	FROM
		Usuario_PuntoDeVenta UPDV 
		INNER JOIN Usuario U  ON UPDV.idUsuario = U.idUsuario
		INNER JOIN PuntoDeVenta PDV ON UPDV.idPuntoDeVenta = PDV.idPuntoDeVenta
		INNER JOIN Cadena C ON PDV.idCadena = C.idCadena
		INNER JOIN Forecasting F ON U.idUsuario = F.idUsuario
			AND F.idCadena = C.idCadena
	WHERE
		PDV.idCliente = 178
		AND U.esCheckPos = 0
		AND F.Fecha >= @FechaInicial 
		AND F.Fecha <= @FechaFinal
	
	SELECT 
		TA.idUsuario,
		TA.Nombre,
		U.Email,
		CASE COUNT(1) WHEN 0 THEN 1 ELSE 0 END Confirmado
	INTO
		#TmpUsuarioConfirma
	FROM 
		#TmpAsignadas TA 
		INNER JOIN Usuario U ON TA.idUsuario = U.idUsuario
		LEFT JOIN #TmpConfirmadas TC ON TA.idCadena = TC.idCadena
	WHERE 
		ISNULL(TC.idCadena,0) = 0 
	GROUP BY 
		TA.idUsuario,
		TA.Nombre,
		U.Email
	
	IF @Hoy = @PrimerHabil BEGIN
		--SELECT 'Alerta Primer día hábil'
		INSERT INTO EmpresaMail 
		SELECT 0,'noreply@checkpos.com',NULL,'
		<html>
		<head><meta http-equiv=Content-Type content="text/html; charset=UTF-8">
		<style type="text/css">
		<!--
		span.cls_002{font-family:Arial,serif;font-size:58.7px;color:rgb(0,0,0);font-weight:normal;font-style:normal;text-decoration: none}
		div.cls_002{font-family:Arial,serif;font-size:58.7px;color:rgb(0,0,0);font-weight:normal;font-style:normal;text-decoration: none}
		span.cls_003{font-family:Arial,serif;font-size:65.2px;color:rgb(255,103,125);font-weight:bold;font-style:normal;text-decoration: none}
		div.cls_003{font-family:Arial,serif;font-size:65.2px;color:rgb(255,103,125);font-weight:bold;font-style:normal;text-decoration: none}
		span.cls_004{font-family:Arial,serif;font-size:30.0px;color:rgb(0,0,0);font-weight:normal;font-style:normal;text-decoration: none}
		div.cls_004{font-family:Arial,serif;font-size:30.0px;color:rgb(0,0,0);font-weight:normal;font-style:normal;text-decoration: none; letter-spacing: 9px;}
		span.cls_005{font-family:Arial,serif;font-size:19.1px;color:rgb(0,0,0);font-weight:normal;font-style:normal;text-decoration: none}
		div.cls_005{font-family:Arial,serif;font-size:19.1px;color:rgb(0,0,0);font-weight:normal;font-style:normal;text-decoration: none}
		span.cls_006{font-family:Arial,serif;font-size:19.1px;color:rgb(255,255,255);font-weight:normal;font-style:normal;text-decoration: none}
		div.cls_006{font-family:Arial,serif;font-size:19.1px;color:rgb(255,255,255);font-weight:normal;font-style:normal;text-decoration: none}
		-->
		</style>
		</head>
		<body>
		<div style="position:absolute;top:0px;width:1920px;height:1080px;overflow:hidden">
		<div style="position:absolute;left:0px;top:0px">
		<img src="https://login.checkpos.com/1/Reporting/images/AlertasCAP/background1.jpg" width=1920 height=1080></div>
		<div style="position:absolute;left:516.71px;top:310.26px" class="cls_002"><span class="cls_002">OTRO MES MAS - OTRO MES MENOS</span></div>
		<div style="position:absolute;left:1000.71px;top:437.69px" class="cls_003"><span class="cls_003">QUEDAN 5 DIAS</span></div>
		<div style="position:absolute;left:1011.71px;top:502.28px" class="cls_004"><span class="cls_004">PARA CONFIRMAR CAP</span></div>
		<div style="position:absolute;left:1011.71px;top:602.75px" class="cls_005"><span class="cls_005">HOY</span></div>
		<div style="position:absolute;left:1475.71px;top:602.75px" class="cls_005"><span class="cls_005">DIA 5</span></div>
		<a href="https://login.checkpos.com/1/Reporting/Forecasting/SalesInOut"><div style="position:absolute;left:1407.86px;top:753.21px" class="cls_006"><span class="cls_006">Ver CAP</span></div></a>
		</div>
		</body>
		</html>
		','Alerta CAP',NULL,1,NULL,0,GETDATE(),GETDATE(),GETDATE(),0,0,0,(SELECT id FROM Alertas WHERE Destinatarios LIKE Email COLLATE DATABASE_DEFAULT + '%' AND id IN (SELECT Id FROM Alertas WHERE Descripcion IN ('CAP Sin Confirmar 1er Dia DIST ARG','CAP Sin Confirmar 1er Dia RET ARG'))),NULL,NULL,NULL,NULL FROM #TmpUsuarioConfirma WHERE Confirmado = 0
	END

	IF @Hoy = @CuartoHabil BEGIN
		--SELECT 'Alerta Cuarto día hábil'
		INSERT INTO EmpresaMail
		SELECT 0,'noreply@checkpos.com',NULL,'
		<html>
		<head><meta http-equiv=Content-Type content="text/html; charset=UTF-8">
		<style type="text/css">
		<!--
		span.cls_002{font-family:Arial,serif;font-size:58.7px;color:rgb(0,0,0);font-weight:normal;font-style:normal;text-decoration: none}
		div.cls_002{font-family:Arial,serif;font-size:58.7px;color:rgb(0,0,0);font-weight:normal;font-style:normal;text-decoration: none}
		span.cls_004{font-family:Arial,serif;font-size:30.0px;color:rgb(0,0,0);font-weight:normal;font-style:normal;text-decoration: none}
		div.cls_004{font-family:Arial,serif;font-size:30.0px;color:rgb(0,0,0);font-weight:normal;font-style:normal;text-decoration: none; letter-spacing: 9px;}
		span.cls_005{font-family:Arial,serif;font-size:19.1px;color:rgb(0,0,0);font-weight:normal;font-style:normal;text-decoration: none}
		div.cls_005{font-family:Arial,serif;font-size:19.1px;color:rgb(0,0,0);font-weight:normal;font-style:normal;text-decoration: none}
		span.cls_006{font-family:Arial,serif;font-size:19.1px;color:rgb(255,255,255);font-weight:normal;font-style:normal;text-decoration: none}
		div.cls_006{font-family:Arial,serif;font-size:19.1px;color:rgb(255,255,255);font-weight:normal;font-style:normal;text-decoration: none}
		span.cls_007{font-family:Arial,serif;font-size:77.3px;color:rgb(255,103,125);font-weight:bold;font-style:normal;text-decoration: none}
		div.cls_007{font-family:Arial,serif;font-size:77.3px;color:rgb(255,103,125);font-weight:bold;font-style:normal;text-decoration: none}
		-->
		</style>
		</head>
		<body>
		<div style="position:absolute;width:1920px;height:1080px;overflow:hidden">
		<div style="position:absolute;left:0px;top:0px">
		<img src="https://login.checkpos.com/1/Reporting/images/AlertasCAP/background2.jpg" width=1920 height=1080></div>
		<div style="position:absolute;left:587.71px;top:310.26px" class="cls_002"><span class="cls_002">OTRO MES MAS - OTRO MES MENOS</span></div>
		<div style="position:absolute;left:1071.71px;top:419.72px" class="cls_007"><span class="cls_007">QUEDA 1 DIA</span></div>
		<div style="position:absolute;left:1082.71px;top:502.28px" class="cls_004"><span class="cls_004">PARA CONFIRMAR CAP</span></div>
		<div style="position:absolute;left:1082.71px;top:602.75px" class="cls_005"><span class="cls_005">HOY</span></div>
		<div style="position:absolute;left:1546.71px;top:602.75px" class="cls_005"><span class="cls_005">DIA 5</span></div>
		<a href="https://login.checkpos.com/1/Reporting/Forecasting/SalesInOut"><div style="position:absolute;left:1480.86px;top:753.21px" class="cls_006"><span class="cls_006">Ver CAP</span></div></a>
		</div>
		</body>
		</html>
		','Alerta CAP',NULL,1,NULL,0,GETDATE(),GETDATE(),GETDATE(),0,0,0,(SELECT id FROM Alertas WHERE Destinatarios LIKE Email COLLATE DATABASE_DEFAULT + '%' AND id IN (SELECT Id FROM Alertas WHERE Descripcion IN ('CAP Sin Confirmar 4to Dia DIST ARG','CAP Sin Confirmar 4to Dia RET ARG'))),NULL,NULL,NULL,NULL FROM #TmpUsuarioConfirma WHERE Confirmado = 0
	END

	IF @Hoy = @QuintoHabil BEGIN
		--SELECT 'Alerta Quinto día hábil'
		INSERT INTO EmpresaMail
		SELECT 0,'noreply@checkpos.com',NULL,'
		<html>
		<head><meta http-equiv=Content-Type content="text/html; charset=UTF-8">
		<style type="text/css">
		<!--
		span.cls_002{font-family:Arial,serif;font-size:58.7px;color:rgb(0,0,0);font-weight:normal;font-style:normal;text-decoration: none}
		div.cls_002{font-family:Arial,serif;font-size:58.7px;color:rgb(0,0,0);font-weight:normal;font-style:normal;text-decoration: none}
		span.cls_004{font-family:Arial,serif;font-size:30.0px;color:rgb(0,0,0);font-weight:normal;font-style:normal;text-decoration: none}
		div.cls_004{font-family:Arial,serif;font-size:30.0px;color:rgb(0,0,0);font-weight:normal;font-style:normal;text-decoration: none;  letter-spacing: 10px;}
		span.cls_005{font-family:Arial,serif;font-size:19.1px;color:rgb(0,0,0);font-weight:normal;font-style:normal;text-decoration: none}
		div.cls_005{font-family:Arial,serif;font-size:19.1px;color:rgb(0,0,0);font-weight:normal;font-style:normal;text-decoration: none}
		span.cls_006{font-family:Arial,serif;font-size:19.1px;color:rgb(255,255,255);font-weight:normal;font-style:normal;text-decoration: none}
		div.cls_006{font-family:Arial,serif;font-size:19.1px;color:rgb(255,255,255);font-weight:normal;font-style:normal;text-decoration: none}
		span.cls_008{font-family:Arial,serif;font-size:58.0px;color:rgb(255,103,125);font-weight:bold;font-style:normal;text-decoration: none}
		div.cls_008{font-family:Arial,serif;font-size:58.0px;color:rgb(255,103,125);font-weight:bold;font-style:normal;text-decoration: none}
		-->
		</style>
		</head>
		<body>
		<div style="position:absolute;width:1920px;height:1080px;overflow:hidden">
		<div style="position:absolute;left:0px;top:0px ;background-size:contain;;">
		<img src="https://login.checkpos.com/1/Reporting/images/AlertasCAP/background3.jpg" width=1920 height=1080></div>
		<div style="position:absolute;left:483.71px;top:310.26px" class="cls_002"><span class="cls_002">OTRO MES MAS - OTRO MES MENOS</span></div>
		<div style="position:absolute;left:967.71px;top:444.83px" class="cls_008"><span class="cls_008">VENCIO LA FECHA</span></div>
		<div style="position:absolute;left:978.71px;top:502.28px" class="cls_004"><span class="cls_004">PARA CONFIRMAR  CAP</span></div>
		<div style="position:absolute;left:978.71px;top:602.75px" class="cls_005"><span class="cls_005">HOY</span></div>
		<div style="position:absolute;left:1442.71px;top:602.75px" class="cls_005"><span class="cls_005">DIA 5</span></div>
		<a href="https://login.checkpos.com/1/Reporting/Forecasting/SalesInOut"><div style="position:absolute;left:1370.86px;top:753.21px" class="cls_006"><span class="cls_006">Ver CAP</span></div></a>
		</div>
		</body>
		</html>
		','Alerta CAP',NULL,1,NULL,0,GETDATE(),GETDATE(),GETDATE(),0,0,0,(SELECT id FROM Alertas WHERE Destinatarios LIKE Email COLLATE DATABASE_DEFAULT + '%' AND id IN (SELECT Id FROM Alertas WHERE Descripcion IN ('CAP Sin Confirmar 5to Dia DIST ARG','CAP Sin Confirmar 5to Dia RET ARG'))),NULL,NULL,NULL,NULL FROM #TmpUsuarioConfirma WHERE Confirmado = 0
	END

	IF (SELECT COUNT(1) FROM #TmpUsuarioConfirma WHERE Confirmado = 1) != 0 AND (SELECT COUNT(1) FROM EmpresaMail WHERE idAlerta IN (1140,1136,1132,1128) AND Enviado = 1 AND YEAR(FechaCreacion) = YEAR(@Hoy) AND MONTH(FechaCreacion) = MONTH(@Hoy)) = 0  BEGIN
		--SELECT 'Alerta Confirmado'
		INSERT INTO EmpresaMail
		SELECT 0,'noreply@checkpos.com',NULL,'
		<html>
		<head><meta http-equiv=Content-Type content="text/html; charset=UTF-8">
		<style type="text/css">
		<!--
		span.cls_002{font-family:Arial,serif;font-size:58.7px;color:rgb(0,0,0);font-weight:normal;font-style:normal;text-decoration: none}
		div.cls_002{font-family:Arial,serif;font-size:58.7px;color:rgb(0,0,0);font-weight:normal;font-style:normal;text-decoration: none}
		span.cls_004{font-family:Arial,serif;font-size:30.0px;color:rgb(0,0,0);font-weight:normal;font-style:normal;text-decoration: none}
		div.cls_004{font-family:Arial,serif;font-size:30.0px;color:rgb(0,0,0);font-weight:normal;font-style:normal;text-decoration: none;  letter-spacing: 10px;}
		span.cls_005{font-family:Arial,serif;font-size:19.1px;color:rgb(0,0,0);font-weight:normal;font-style:normal;text-decoration: none}
		div.cls_005{font-family:Arial,serif;font-size:19.1px;color:rgb(0,0,0);font-weight:normal;font-style:normal;text-decoration: none}
		span.cls_006{font-family:Arial,serif;font-size:19.1px;color:rgb(255,255,255);font-weight:normal;font-style:normal;text-decoration: none}
		div.cls_006{font-family:Arial,serif;font-size:19.1px;color:rgb(255,255,255);font-weight:normal;font-style:normal;text-decoration: none}
		span.cls_010{font-family:Arial,serif;font-size:147.7px;color:rgb(255,103,125);font-weight:bold;font-style:normal;text-decoration: none}
		div.cls_010{font-family:Arial,serif;font-size:147.7px;color:rgb(255,103,125);font-weight:bold;font-style:normal;text-decoration: none}
		span.cls_009{font-family:Times,serif;font-size:73.0px;color:rgb(0,117,222);font-weight:normal;font-style:normal;text-decoration: none}
		div.cls_009{font-family:Times,serif;font-size:73.0px;color:rgb(0,117,222);font-weight:normal;font-style:normal;text-decoration: none}
		-->
		</style>
		</head>
		<body>
		<div style="position:absolute;width:1920px;height:1080px;overflow:hidden">
		<div style="position:absolute;left:0px;top:0px">
		<img src="https://login.checkpos.com/1/Reporting/images/AlertasCAP/background4.jpg" width=1920 height=1080></div>
		<div style="position:absolute;left:671.71px;top:310.26px" class="cls_002"><span class="cls_002">OTRO MES MAS - OTRO MES MENOS</span></div>
		<div style="position:absolute;left:1155.71px;top:384.73px" class="cls_010"><span class="cls_010">WOW!</span></div>
		<div style="position:absolute;left:1176.39px;top:535.28px" class="cls_004"><span class="cls_004">CAP  CONFIRMADO</span></div>
		<div style="position:absolute;left:1166.71px;top:602.75px" class="cls_005"><span class="cls_005">HOY</span></div>
		<div style="position:absolute;left:1630.71px;top:602.75px" class="cls_005"><span class="cls_005">DIA 5</span></div>
		<a href="https://login.checkpos.com/1/Reporting/Forecasting/SalesInOut"><div style="position:absolute;left:1560.86px;top:753.21px" class="cls_006"><span class="cls_006">Ver CAP</span></div></a>
		<div style="position:absolute;left:421.71px;top:734.38px" class="cls_009"><span class="cls_009"><img src="https://login.checkpos.com/1/Reporting/images/AlertasCAP/et.png"></img></span></div>
		</div>
		</body>
		</html>
		','Alerta CAP',NULL,1,NULL,0,GETDATE(),GETDATE(),GETDATE(),0,0,0,(SELECT id FROM Alertas WHERE Destinatarios LIKE Email COLLATE DATABASE_DEFAULT + '%' AND id IN (SELECT Id FROM Alertas WHERE Descripcion IN ('CAP confirmado DIST ARG','CAP Confirmado RET ARG'))),NULL,NULL,NULL,NULL FROM #TmpUsuarioConfirma WHERE Confirmado = 1
	END 

	DROP TABLE #TmpConfirmadas
	DROP TABLE #TmpAsignadas
	DROP TABLE #TmpUsuarioConfirma
END