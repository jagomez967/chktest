SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CD_Visitador_Add]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[CD_Visitador_Add] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[CD_Visitador_Add] 
	
	 @Nombre varchar(255) = NULL
    ,@IdSistema int= NULL
    ,@Activo bit= NULL
    ,@IdVisitador int OutPut
AS
BEGIN
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	INSERT INTO [dbo].[CD_Visitador]
           ([Nombre]
           ,[IdSistema]
           ,[Activo])
     VALUES
           (@Nombre
           ,@IdSistema
           ,@Activo)
           
    SET @IdVisitador = @@IDENTITY
    
END
GO
