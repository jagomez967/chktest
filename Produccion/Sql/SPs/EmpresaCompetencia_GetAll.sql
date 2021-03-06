SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[EmpresaCompetencia_GetAll]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[EmpresaCompetencia_GetAll] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[EmpresaCompetencia_GetAll]
	
	@IdEmpresa int
   ,@Nombre varchar(50) = null
	
AS
BEGIN
	SET NOCOUNT ON;
	SELECT EC.[IdEmpresa]
		  ,EC.[IdEmpresaCompetencia]
		  ,EC.[Id]
		  ,E.Nombre
		  ,N.Nombre AS "Negocio"
	FROM [dbo].[EmpresaCompetencia] EC
	INNER JOIN Empresa E ON (E.[IdEmpresa] = EC.[IdEmpresaCompetencia])
	INNER JOIN Negocio N ON (E.IdNegocio = N.IdNegocio)
	WHERE	EC.[IdEmpresa] = @IdEmpresa
	AND		(@Nombre IS NULL OR E.[Nombre] like '%' + @Nombre + '%')
	
END
GO
