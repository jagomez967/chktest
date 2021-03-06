SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CD_Cadena_Add]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[CD_Cadena_Add] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[CD_Cadena_Add]
	
	 @Nombre varchar(255) = NULL
	,@Activo bit = NULL
	,@IdCadena int output
	
AS
BEGIN
	SET NOCOUNT ON;
	INSERT INTO [dbo].[CD_Cadena]
           ([Nombre]
           ,[Activo])
     VALUES
           (@Nombre
           ,@Activo)
           
     SET @IdCadena = @@IDENTITY 

END
GO
