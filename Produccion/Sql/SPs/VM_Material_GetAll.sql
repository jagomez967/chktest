SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[VM_Material_GetAll]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[VM_Material_GetAll] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[VM_Material_GetAll]
	-- Add the parameters for the stored procedure here
	@IdMaterial int = NULL
   ,@IdCliente int = NULL
   ,@Nombre varchar(100) = NULL
   ,@Activo bit = NULL
	  AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT [IdMaterial]
		  ,[IdCliente]
		  ,[Nombre]
		  ,[Activo]
  FROM [dbo].[VM_Material]
  WHERE (@IdMaterial IS NULL OR @IdMaterial = [IdMaterial]) AND
        (@IdCliente IS NULL OR @IdCliente = [IdCliente]) AND
        (@Nombre IS NULL OR ([Nombre] Like '%' + @Nombre + '%')) AND
        (@Activo IS NULL OR @Activo = [Activo])
  ORDER BY [Nombre]
  
END
GO
