SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MantenimientoMaterial_GetAll]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[MantenimientoMaterial_GetAll] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[MantenimientoMaterial_GetAll]
	-- Add the parameters for the stored procedure here
	 @IdMantenimientoMaterial int = NULL 
	,@Nombre varchar(100) = NULL
	,@Activo bit = NULL
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT [IdMantenimientoMaterial]
		  ,[Nombre]
		  ,[Observaciones]
		  ,[Activo]
	FROM [dbo].[MantenimientoMaterial]
	WHERE (@IdMantenimientoMaterial IS NULL OR [IdMantenimientoMaterial] = @IdMantenimientoMaterial) AND
	      (@Nombre IS NULL OR [Nombre] like '%' + @Nombre + '%') AND
	      (@Activo IS NULL OR [Activo] = @Activo)
	ORDER BY [Nombre]

END
GO
