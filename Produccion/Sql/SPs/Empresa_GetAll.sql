SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Empresa_GetAll]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Empresa_GetAll] AS' 
END
GO
ALTER PROCEDURE [dbo].[Empresa_GetAll]

	@IdEmpresa INT = NULL
   ,@Nombre varchar(50) = NULL
	
AS
BEGIN

	SET NOCOUNT ON;

	SELECT E.[IdEmpresa]
		  ,E.[IdNegocio]
		  ,E.[Nombre]
		  ,N.[Nombre] Negocio
		  ,C.IdCliente
	FROM [dbo].[Empresa] E
	INNER JOIN [dbo].[Negocio] N ON (N.[IdNegocio] = E.[IdNegocio])
	LEFT JOIN Cliente C ON (C.IdEmpresa = E.IdEmpresa)
	WHERE (@IdEmpresa IS NULL OR @IdEmpresa = E.[IdEmpresa]) AND
	      (@Nombre IS NULL OR E.[Nombre] like '%' + @Nombre + '%')
	ORDER BY E.[Nombre],N.[Nombre]

END
GO
