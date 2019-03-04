IF NOT EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND OBJECT_ID = OBJECT_ID('dbo.spExecuteDtsxJob'))
   EXEC('CREATE PROCEDURE [dbo].[spExecuteDtsxJob] AS BEGIN SET NOCOUNT ON; END')
GO
ALTER PROCEDURE spExecuteDtsxJob
(
	@Identificador	VARCHAR(200)
)
AS 
BEGIN

	CREATE TABLE #TMP 
	(
		LINE VARCHAR(MAX)
	)

	DECLARE @Excel	VARCHAR(MAX)
	DECLARE @Cmd	NVARCHAR(MAX)
	DECLARE @UltimaEjecucion DATETIME

	SELECT @Excel = PathExcel FROM DtsxJobParams WHERE Identificador = @Identificador
	SET @Cmd = 'INSERT INTO #TMP EXEC xp_cmdshell ''dir /T:W "' + @Excel + '" | findstr ' + (SELECT REVERSE(LEFT(REVERSE(@Excel),CHARINDEX('\',REVERSE(@Excel),0) -1 )))+ ''''
	SELECT @UltimaEjecucion = FechaUltimaEjecucion FROM DtsxJobParams WHERE Identificador = @Identificador

	EXEC sp_executesql @Cmd

	IF (SELECT DATEDIFF(MINUTE, @UltimaEjecucion, CONVERT(DATETIME,LEFT(LINE,20))) FROM #TMP WHERE ISNULL(LINE,'') != '') >=  0 BEGIN
		SET @Cmd = 'EXEC XP_CMDSHELL '' "C:\Program Files (x86)\Microsoft SQL Server\100\DTS\Binn\DTExec.exe" /f ' + (SELECT PathDtsx FROM DtsxJobParams WHERE Identificador = @Identificador) + ' /DE ' + (SELECT PassDtsx FROM DtsxJobParams WHERE Identificador = @Identificador) + ' '', NO_OUTPUT'
	
		EXEC sp_executesql @Cmd

		UPDATE
			DtsxJobParams
		SET 
			FechaUltimaEjecucion = GETDATE(),
			Result = 'OK'
		WHERE
			Identificador = @Identificador

	END

	DROP TABLE #TMP

END