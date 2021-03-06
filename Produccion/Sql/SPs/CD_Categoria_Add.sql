SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CD_Categoria_Add]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[CD_Categoria_Add] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[CD_Categoria_Add]	
	 
	 
	 @IdSistema int 
	,@Nombre varchar(50)
	,@Activo bit
	,@IdCategoria int output
	
AS
BEGIN
	SET NOCOUNT ON;

	INSERT INTO [dbo].[CD_Categoria]
           ([Nombre]
           ,[IdSistema]
           ,[Activo])
     VALUES
           (@Nombre
           ,@IdSistema
           ,@Activo)

	SET @IdCategoria =  @@IDENTITY   
END
GO
