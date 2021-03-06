SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Categoria_GetAllCliente]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Categoria_GetAllCliente] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[Categoria_GetAllCliente]
	-- Add the parameters for the stored procedure here
	 @IdCliente int = NULL
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT C.[IdCategoria]
		  ,C.[Nombre]
	FROM  [dbo].[Categoria] C
	INNER JOIN Negocio N ON (C.IdNegocio = N.IdNegocio)
	INNER JOIN Empresa E ON (N.IdNegocio = E.IdNegocio) --AGREGADO
	INNER JOIN Cliente CLI ON (E.IdEmpresa = CLI.IdEmpresa) --AGREGADO
	WHERE (@IdCliente = CLI.IdCliente)
	ORDER BY C.[Nombre]

END
GO
