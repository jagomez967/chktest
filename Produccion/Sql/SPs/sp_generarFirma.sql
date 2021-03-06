SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_generarFirma]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[sp_generarFirma] AS' 
END
GO
ALTER procedure [dbo].[sp_generarFirma](
@idReporte int
)

AS
BEGIN
declare @basePath varchar(max)
declare @folderName varchar(max)
declare @imageFilename varchar(max)
declare @serverName varchar(max)
--declare @idReporte int
declare @firma varchar(max)

set @basePath = 'C:\Users\CheckPosAdminHernan\Documents'
set @folderName = 'resultsDB'
set @serverName = 'localhost'



declare @cmd varchar(2000)
declare @cmdaux varchar(2000)

DECLARE @output INT

	delete from FirmasJPG
	
	set @imageFileName = 'firma_'+CAST(@idReporte as varchar)+'.jpg'
	

	
	select @cmd = 'del /q /f ' + @basePath + '\' + @folderName + '\' + @imageFileName	
--	select @cmd

	select @cmdAux = 'DIR "'+ @basePath + '\' + @folderName + '\' + @imageFileName+'" /B'
	--select @cmdAux
EXEC @output = XP_CMDSHELL @cmdAux
IF @output = 1
BEGIN
      PRINT 'File Donot exists'
END
ELSE
BEGIN
	exec master.sys.xp_cmdShell @cmd
    PRINT 'File exists'
END


	
	 INSERT INTO FirmasJPG (PhotoBinary)
	 SELECT CAST(N'' AS xml).value('xs:base64Binary(sql:column("Firma"))', 'varbinary(max)')
            FROM reporte
            WHERE idReporte = @idReporte
			
	declare @command as varchar(2000)
	--SELECT TOP 100 PhotoBinary FROM checkPOS_unificada_final_2.dbo.FirmasJPG
	SET @command = 'bcp "SELECT TOP 1 PhotoBinary FROM checkPOS_unificada_final_2.dbo.FirmasJPG" queryout "' + @basePath + '\' + @folderName + '\' + @imageFileName + '"  -U checkposAle -P ch8_POS_9873_@* -S ' + @ServerName + ' -f "C:\Users\CheckPosAdminHernan\Documents\photobinary.fmt"';
    EXEC xp_cmdshell @command
	--fetch next from FIRMAS_CUR
	--into @idReporte, @firma;
	

	select @cmdAux = 'DIR "'+ @basePath + '\' + @folderName + '\' + @imageFileName+'" /B'
	--select @cmdAux															   q



END
GO
