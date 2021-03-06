SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[VM_Marca_GetAll]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[VM_Marca_GetAll] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[VM_Marca_GetAll]
	
	@IdMarca int = NULL
   ,@IdCliente int = NULL
   ,@Nombre varChar(50) = NULL
   ,@Activo bit = NULL
	
AS
BEGIN
	SET NOCOUNT ON;

	SELECT VM.[IdMarca]
		  ,VM.[IdCliente]
		  ,VM.[Nombre]
		  ,VM.[Activo]
  FROM [dbo].[VM_Marca] VM
  WHERE (@IdMarca IS NULL OR @IdMarca = VM.[IdMarca]) AND 
        (@IdCliente IS NULL OR @IdCliente = VM.[IdCliente]) AND
        (@Nombre IS NULL OR VM.[Nombre] like '%'+ @Nombre +'%') AND
        (@Activo IS NULL OR VM.[Activo]=@Activo)
  ORDER BY VM.[Nombre]

END
GO
