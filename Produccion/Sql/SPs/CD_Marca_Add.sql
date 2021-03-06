SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CD_Marca_Add]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[CD_Marca_Add] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[CD_Marca_Add]	
	 
	 
	 @IdSistema int 
	,@Nombre varchar(50)
	,@Activo bit
	,@IdMarca int output
	
AS
BEGIN
	SET NOCOUNT ON;

	INSERT INTO [dbo].[CD_Marca]
           ([Nombre]
           ,[IdSistema]
           ,[Activo])
     VALUES
           (@Nombre
           ,@IdSistema
           ,@Activo)

	SET @IdMarca =  @@IDENTITY   
END
GO
