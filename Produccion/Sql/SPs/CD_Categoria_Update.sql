SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CD_Categoria_Update]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[CD_Categoria_Update] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[CD_Categoria_Update]	
	 
	 @IdCategoria int
	,@IdSistema int 
	,@Nombre varchar(50)
	,@Activo bit
		
AS
BEGIN
	SET NOCOUNT ON;

	UPDATE [dbo].[CD_Categoria]
    SET [Nombre] = @Nombre
       ,[IdSistema] = @IdSistema
       ,[Activo] = @Activo
	WHERE @IdCategoria = [IdCategoria]

END
GO
