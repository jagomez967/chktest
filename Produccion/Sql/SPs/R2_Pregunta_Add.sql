SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[R2_Pregunta_Add]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[R2_Pregunta_Add] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[R2_Pregunta_Add]
	-- Add the parameters for the stored procedure here
	 
	 @Descripcion varchar(100)
    ,@IdTipoPregunta int
    ,@IdModulo int
    ,@Orden int = NULL
    ,@Activo bit
    ,@IdPregunta int out
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	INSERT INTO [dbo].[R2_Pregunta]
           ([Descripcion]
           ,[IdTipoPregunta]
           ,[IdModulo]
           ,[Orden]
           ,[Activo])
     VALUES
           (@Descripcion
           ,@IdTipoPregunta
           ,@IdModulo
           ,@Orden
           ,@Activo)

	SET @IdPregunta =  @@Identity
	
END
GO
