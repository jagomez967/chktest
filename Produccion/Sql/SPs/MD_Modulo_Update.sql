SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MD_Modulo_Update]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[MD_Modulo_Update] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[MD_Modulo_Update]
	 @IdModulo int
	,@Nombre varchar(500)
	,@Descripcion varchar(500) = NULL
    ,@Activo bit
    ,@IdCliente INT
    
AS
BEGIN
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	UPDATE [dbo].[MD_Modulo]
    SET [Nombre] = @Nombre
       ,[Descripcion] = @Descripcion
       ,[FechaUltimaModificacion] = GETDATE()
       ,[Activo] = @Activo
       ,[IdCliente] = @IdCliente
	WHERE @IdModulo = [IdModulo] 
 
END
GO
