SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[R2_ReporteMarca_Add]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[R2_ReporteMarca_Add] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[R2_ReporteMarca_Add]
    @IdReporte2 int
   ,@IdMarca int
   ,@SellOut int
   ,@ColocacionPOP bit
		
AS
BEGIN
	SET NOCOUNT ON;

	INSERT INTO [R2_ReporteMarca]
           ([IdReporte2]
           ,[IdMarca]
           ,[SellOut]
           ,[ColocacionPOP])
     VALUES
           (@IdReporte2
           ,@IdMarca
           ,@SellOut
           ,@ColocacionPOP)
           
END
GO
