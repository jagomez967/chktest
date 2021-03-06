SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CD_Representante_Add]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[CD_Representante_Add] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[CD_Representante_Add]
	  
	  @Nombre varchar(255) = NULL
     ,@IdSistema int = NULL
     ,@Activo bit = NULL
     ,@IdRepresentante int  OutPut
     
     
AS
BEGIN

	SET NOCOUNT ON;
	INSERT INTO [dbo].[CD_Representante]
           ([Nombre]
           ,[IdSistema]
           ,[Activo])
     VALUES
           (@Nombre
           ,@IdSistema
           ,@Activo)
           
    SET @IdRepresentante = @@IDENTITY

END
GO
