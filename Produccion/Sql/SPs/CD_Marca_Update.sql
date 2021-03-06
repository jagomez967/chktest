SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CD_Marca_Update]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[CD_Marca_Update] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[CD_Marca_Update]	
	 
	 @IdMarca int
	,@IdSistema int 
	,@Nombre varchar(50)
	,@Activo bit
		
AS
BEGIN
	SET NOCOUNT ON;

	UPDATE [dbo].[CD_Marca]
    SET [Nombre] = @Nombre
       ,[IdSistema] = @IdSistema
       ,[Activo] = @Activo
	WHERE @IdMarca = [IdMarca]

END
GO
