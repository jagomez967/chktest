SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MD_Modulo_GetAllCliente]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[MD_Modulo_GetAllCliente] AS' 
END
GO
ALTER PROCEDURE [dbo].[MD_Modulo_GetAllCliente]
	-- Add the parameters for the stored procedure here
	 @IdModulo int = NULL
	,@IdCliente int = NULL
	,@Nombre varchar(500) = NULL
	,@Descripcion varchar(500) = NULL
	,@FechaAlta datetime = NULL
	,@FechaUltimaModificacion datetime = NULL
    ,@Activo bit
    
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

IF(@IdCliente IS NOT NULL)
BEGIN
    -- Insert statements for procedure here
	SELECT M.[IdModulo]
		  ,M.[Nombre]
		  ,M.[Descripcion]
		  ,M.[FechaAlta]
		  ,M.[FechaUltimaModificacion]
		  ,M.[Activo]
	FROM [dbo].[MD_Modulo] M
	INNER JOIN MD_ModuloCliente MC
	ON MC.IdCliente = @IdCliente AND M.IdModulo = MC.IdModulo
	WHERE (@IdModulo IS NULL OR @IdModulo = M.[IdModulo]) AND
	      (@Nombre IS NULL OR M.[Nombre] like '%' + @Nombre +'%')
	ORDER BY   [Nombre]
END
ELSE
BEGIN
    SELECT M.[IdModulo]
		  ,M.[Nombre]
		  ,M.[Descripcion]
		  ,M.[FechaAlta]
		  ,M.[FechaUltimaModificacion]
		  ,M.[Activo]
	FROM [dbo].[MD_Modulo] M
	WHERE (@Nombre IS NULL OR M.[Nombre] like '%' + @Nombre +'%')
END	
END
GO
