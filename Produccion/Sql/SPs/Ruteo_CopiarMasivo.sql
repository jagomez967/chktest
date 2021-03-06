SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Ruteo_CopiarMasivo]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Ruteo_CopiarMasivo] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[Ruteo_CopiarMasivo]
	-- Add the parameters for the stored procedure here
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

-- Mosificar los parametros antes de usar. 
DECLARE @IdUsuario int
DECLARE @IdClienteOriginal int
DECLARE @IdClienteCopia int

DECLARE	@return_value int

DECLARE ruteo_cursor CURSOR FOR 
SELECT  [IdUsuario]
       ,[IdClienteOriginal]
       ,[IdClienteCopia]
  FROM [RuteoAbrilaKCCaAbbott$]  
  OPEN ruteo_cursor

FETCH NEXT FROM ruteo_cursor
INTO @IdUsuario, @IdClienteOriginal, @IdClienteCopia

WHILE @@FETCH_STATUS = 0
BEGIN
   
    
EXEC	@return_value = [dbo].[Ruteo_Copiar2]
		@IdClienteOriginal = @IdClienteOriginal,
		@IdClienteCopia = @IdClienteCopia,
		@IdUsuarioOriginal = @IdUsuario,
		@IdUsuarioCopiar = @IdUsuario,
		@Mes = 3,
		@Ano = 2013    
		
FETCH NEXT FROM ruteo_cursor
INTO @IdUsuario, @IdClienteOriginal, @IdClienteCopia
END 

CLOSE ruteo_cursor;
DEALLOCATE ruteo_cursor;


END
GO
