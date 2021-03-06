SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MD_ModuloMarca_GetAll]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[MD_ModuloMarca_GetAll] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[MD_ModuloMarca_GetAll]
	
	@IdMarca int
   ,@IdModulo int = NULL
	
AS
BEGIN
	SET NOCOUNT ON;

	SELECT MM.[IdModulo]
	      ,M.Nombre
		  ,MM.[IdMarca]
		  ,MM.[Orden]
		  ,MM.[Activo]
		  ,MM.[Ponderacion]
	  FROM [dbo].[MD_ModuloMarca] MM
	  INNER JOIN [MD_Modulo] M ON  (MM.[IdModulo] = M.[IdModulo] AND (@IdModulo IS NULL OR @IdModulo = M.[IdModulo]))
	  WHERE [IdMarca] = @IdMarca
	  
END
GO
