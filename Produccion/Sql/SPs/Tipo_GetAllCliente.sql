SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Tipo_GetAllCliente]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Tipo_GetAllCliente] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[Tipo_GetAllCliente]
	-- Add the parameters for the stored procedure here
	@IdTipo INT = NULL
   ,@Nombre varchar(50) = NULL
   ,@IdNegocio INT = NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT T.[IdTipo]
		  ,T.[Nombre]
		  ,T.[IdNegocio]
		  ,N.Nombre AS Negocio
	FROM [dbo].[Tipo] T
	INNER JOIN [dbo].[Negocio] N ON (N.[IdNegocio] = T.[IdNegocio])
	--INNER JOIN Empresa E ON (E.IdNegocio = N.IdNegocio) --AGREGADO
	---INNER JOIN Cliente C ON (E.IdEmpresa = C.IdEmpresa) --AGREGADO
	WHERE isnull(@idTipo,t.idTipo) = t.idTipo
		  AND (@IdNegocio = N.IdNegocio)
		  AND (@Nombre IS NULL OR T.[Nombre] like '%' + @Nombre + '%')
	ORDER BY T.[Nombre]
END
GO
