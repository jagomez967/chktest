SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Sistema_Error_Add]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Sistema_Error_Add] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[Sistema_Error_Add]
	-- Add the parameters for the stored procedure here
    @Fecha datetime = NULL
   ,@Message varchar(2000) = NULL
   ,@Source varchar(2000) = NULL
   ,@StackTrace varchar(2000) = NULL
   ,@Sistema varchar(50) = NULL
   ,@Modulo varchar(50) = NULL
   ,@Funcion varchar(50) = NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	INSERT INTO [dbo].[Sistema_Error]
           ([Fecha]
           ,[Message]
           ,[Source]
           ,[StackTrace]
           ,[Sistema]
           ,[Modulo]
           ,[Funcion])
     VALUES
           (@Fecha
           ,@Message
           ,@Source
           ,@StackTrace
           ,@Sistema
           ,@Modulo
           ,@Funcion)
           
END
GO
