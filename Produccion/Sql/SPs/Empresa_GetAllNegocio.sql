SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Empresa_GetAllNegocio]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Empresa_GetAllNegocio] AS' 
END
GO
ALTER PROCEDURE [dbo].[Empresa_GetAllNegocio]

	@IdNegocio INT = NULL
   ,@Nombre varchar(50) = NULL
	
AS
BEGIN

	SET NOCOUNT ON;

	SELECT E.[IdEmpresa]
		  ,E.[Nombre]
	FROM [dbo].[Empresa] E
	WHERE (@IdNegocio IS NULL OR @IdNegocio = E.IdNegocio) AND
	      (@Nombre IS NULL OR E.[Nombre] like '%' + @Nombre + '%')
	ORDER BY E.[Nombre]

END
GO
