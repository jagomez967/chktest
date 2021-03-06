SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[M_ModuloCliente_Add]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[M_ModuloCliente_Add] AS' 
END
GO
ALTER PROCEDURE [dbo].[M_ModuloCliente_Add]
	-- Add the parameters for the stored procedure here
	 @IdCliente int
	,@IdModulo int
	,@Descripcion varchar(50)=''
	,@Activo bit
	,@IdModuloCliente int  output
	
AS
BEGIN
	SET NOCOUNT ON;

	SET @IdModuloCliente = 0
	
	SELECT @IdModuloCliente = [IdModuloCliente]
	FROM  [dbo].[M_ModuloCliente] 
	WHERE [IdCliente]=@IdCliente 
	AND   [IdModulo]=@IdModulo
	
	IF  (ISNULL(@IdModuloCliente,0) = 0)
    BEGIN 
		INSERT INTO [dbo].[M_ModuloCliente]
			   ([IdCliente],[IdModulo],[Descripcion],[Activo])
		 VALUES
			   (@IdCliente,@IdModulo,@Descripcion,@Activo)
		 SET @IdModuloCliente = @@Identity
	END
	ELSE
	BEGIN 
	   UPDATE [dbo].[M_ModuloCliente]
	   SET [Descripcion] = @Descripcion
		  ,[Activo] = @Activo
	   WHERE @IdModuloCliente = [IdModuloCliente]
	END

END

GO
