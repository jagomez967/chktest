SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MD_Modulo_GetAll]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[MD_Modulo_GetAll] AS' 
END
GO

ALTER PROCEDURE [dbo].[MD_Modulo_GetAll]
	-- Add the parameters for the stored procedure here
	 @IdModulo int = NULL
	,@Nombre varchar(500) = NULL
	,@Descripcion varchar(500) = NULL
	,@FechaAlta datetime = NULL
	,@FechaUltimaModificacion datetime = NULL
    ,@Activo bit
    ,@IdCliente INT
    
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT [IdModulo]
		  ,[Nombre]
		  ,[Descripcion]
		  ,[FechaAlta]
		  ,[FechaUltimaModificacion]
		  ,[Activo]
		  ,[IdCliente]
	FROM [dbo].[MD_Modulo]
	WHERE	(@IdCliente = IdCliente) AND
			(@IdModulo IS NULL OR @IdModulo = [IdModulo]) AND
			(@Nombre IS NULL OR [Nombre] like '%' + @Nombre +'%')
	ORDER BY   [Nombre]
	
	
END
GO
