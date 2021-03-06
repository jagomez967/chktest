SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MD_Modulo_Add]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[MD_Modulo_Add] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[MD_Modulo_Add]
	
     @Nombre varchar(500)
    ,@Descripcion varchar(500) = NULL
    ,@Activo bit
    ,@IdCliente int
    ,@IdModulo  int output
     
AS
BEGIN
	SET NOCOUNT ON;

	INSERT INTO [dbo].[MD_Modulo]
           ([Nombre]
           ,[Descripcion]
           ,[FechaAlta]
           ,[FechaUltimaModificacion]
           ,[Activo]
           ,[IdCliente])
     VALUES
           (@Nombre
           ,@Descripcion
           ,GETDATE()
           ,GETDATE()
           ,@Activo
           ,@IdCliente)
           
     SET @IdModulo = @@IDENTITY
     
END
GO
