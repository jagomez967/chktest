SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AlertaCheckIn_add]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[AlertaCheckIn_add] AS' 
END
GO

ALTER PROCEDURE [dbo].[AlertaCheckIn_add]
	-- Add the parameters for the stored procedure here
	@idAlerta int
AS
BEGIN
---- 1) Creo un job que se ejecute cada 5 minutos
----  1a) Verifico que no existan alertas pasadas el periodo, es decir entre 5 minutos atras y la hora actual
----  1b) Si existe alerta, entonces disparo SP para verificar cumplimiento o no de los usuarios visitando el pdv
----  1c) Tengo GEO de los usuarios y horario. por c/u Genero una lista.


---- Diferencia entre Alerta consolidada y No Consolidada
---- La alerta consolidada tiene hora y fecha, ya esta resuelto
---- La alerta no Consolidada envia Mails individuales por cada usuario que NO cumple la condicion. Determinar que hacer ocn los uusario que SI la cumplen
---  O restringir a que el alerta SOLO sea consolidada si o si, para que de esta manera solo sea un solo mail agrupando aquellos que cumpplan o no 



---- 2) Agregar horario para las alertas, Agregar el mismo dentro de la verificacion de horario para el PDV
----  2a) CONFIAR en los horarios que nos envian desde el celular
----  2b) Verificar si el horario de envio de geoposicion se encuentra dentro del horario esperado, si no se encuentra entonces salgo
----  3b) 


	declare @mailHeader varchar(max)
	declare @MailSubject varchar(max)
	declare @MailFooter varchar(max)
	declare @MailBody varchar(max)
	
	set @mailHeader = '<!DOCTYPE html><html><head><title>Quiebre de Stock</title><meta charset="utf-8"><style type="text/css">'
	set @mailHeader = @mailHeader + 'html{height: 100%;width: 100%;background-color: #ddd;}body{height: 100%;width: 100%;padding:20px;}h1{color: #ffffff;padding:0;margin:0;}.container{width: 100%;height: 100%;}.header{margin: auto;width: 60%;height: auto;padding: 15px 50px 15px 50px;background-color: #4A5B64;text-align: center;vertical-align: middle;}.middle{margin: auto;width: 60%;height: 20px;padding: 15px 50px 15px 50px;background-color: #ffffff;white-space: nowrap;overflow: hidden;text-overflow: ellipsis;}h3{color:#FDA515;padding: 0;margin: 0;}p{padding:0;margin:0;}.data{margin: auto;height: auto;width: 60%;background-color: #ffffff;margin-top:10px;margin-bottom:10px;padding: 15px 50px 20px 50px;}table{width: 100%;}td{border-bottom: 1px #ddd solid;}thead{text-align: left;}</style></head><body><div class="container">'
	set @mailHeader = @mailHeader + '<div class="header"><h1>Alerta por Checkin</h1></div>'

	set @MailSubject = 'Informe de CheckIn'

	set @MailFooter = '</div></body></html>'


	set @MailBody = ''
	
	set @MailBody = @MailBody + '<div class="middle">'
	set @MailBody = @MailBody + '<p><strong>Hora Reporte: </strong>'
	set @MailBody = @MailBody + ''  --PENDIENTE HORA DE REPORTE
	set @MailBody = @MailBody + '</p></div>'

	set @MailBody = @MailBody + '<div class="data"><h3>Reporte de checkin</h3><table><tbody>'
	set @MailBody = @MailBody + '<tr> <th> USUARIO </th><th>ESTADO </th><th> </th> </tr>'

	--PARA CADA REGISTRO AGREGO USUARIO / ESTADO / ALGUN DATO EXTRA (MAPA, Hora ult estado, 

		INSERT INTO [dbo].[EmpresaMail]
           ([IdReporte]
           ,[MailFrom]
           ,[MailBody]
		   ,[MailSubject]
		   ,[Autorizado]
		   ,[Enviado]
		   ,[FechaCreacion]
		   ,[FechaAutorizacion]
		    ,[MailHeader]
		   ,[MailFooter]
		   ,[idAlerta]
		   )
     VALUES
           (0
		   ,'noreply@checkpos.com'
		   ,@MailBody
		   ,@MailSubject
		   ,1
		   ,0
		   ,getdate()
		   ,getdate()
		   ,@MailHeader
		   ,@MailFooter
		   ,@idALerta
		   )	
END
GO






