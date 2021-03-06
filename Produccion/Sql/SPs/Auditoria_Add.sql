SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Auditoria_Add]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Auditoria_Add] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[Auditoria_Add]
	-- Add the parameters for the stored procedure here
    @IdSistema int = NULL
   ,@IdAuditoriaModulo int = NULL
   ,@IdUsuario int = NULL
   ,@Fecha datetime = NULL
   ,@IdDescripcion int = NULL
   ,@Descripcion varchar(500) = NULL
   ,@IP varchar(20) = NULL
   ,@NombrePC varchar(100) = NULL
AS

BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	INSERT INTO [dbo].[Auditoria]
           ([IdSistema]
           ,[IdAuditoriaModulo]
           ,[IdUsuario]
           ,[Fecha]
           ,[IdDescripcion]
           ,[Descripcion]
           ,[IP]
           ,[NombrePC])
     VALUES
           (@IdSistema
           ,@IdAuditoriaModulo
           ,@IdUsuario
           ,@Fecha
           ,@IdDescripcion
           ,@Descripcion
           ,@IP
           ,@NombrePC)
           

END
GO
