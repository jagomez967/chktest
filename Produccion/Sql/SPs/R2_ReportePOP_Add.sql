SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[R2_ReportePOP_Add]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[R2_ReportePOP_Add] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[R2_ReportePOP_Add]
	-- Add the parameters for the stored procedure here
	@IdReporte2 int
   ,@IdMarca int 
   ,@IdPop int
   ,@Cantidad int = NULL
	
AS
BEGIN
	SET NOCOUNT ON;

	INSERT INTO [R2_ReportePOP]
           ([IdReporte2]
           ,[IdPop]
           ,[IdMarca]
           ,[Cantidad])
     VALUES
           (@IdReporte2
           ,@IdPop
           ,@IdMarca
           ,@Cantidad)  
           
END
GO
