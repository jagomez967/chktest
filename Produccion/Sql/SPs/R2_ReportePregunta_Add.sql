SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[R2_ReportePregunta_Add]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[R2_ReportePregunta_Add] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[R2_ReportePregunta_Add]
    @IdReporte2 int
   ,@IdPregunta int
   ,@IdMarca int
   ,@Si bit
   ,@No bit
   ,@Observaciones varchar(MAX) = NULL
   
AS
BEGIN
	SET NOCOUNT ON;

	INSERT INTO [R2_ReportePregunta]
           ([IdReporte2]
           ,[IdPregunta]
           ,[IdMarca]
           ,[Si]
           ,[No]
           ,[Observaciones])
     VALUES
           (@IdReporte2
           ,@IdPregunta
           ,@IdMarca
           ,@Si
           ,@No
           ,@Observaciones)	
	
END
GO
