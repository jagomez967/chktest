SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Dimension_GetAllCliente]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Dimension_GetAllCliente] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[Dimension_GetAllCliente]
	-- Add the parameters for the stored procedure here
	 @IdCliente int = NULL
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT D.[IdDimension]
		  ,D.[Nombre]
	FROM [dbo].[Dimension] D
	INNER JOIN dbo.Negocio N ON (D.IdNegocio = N.IdNegocio)
	INNER JOIN Empresa E ON (E.IdNegocio = N.IdNegocio) --AGREGADO
	INNER JOIN Cliente C ON (E.IdEmpresa = C.IdEmpresa) --AGREGADO
	WHERE (@IdCliente = C.IdCliente)
	ORDER BY D.[Nombre]

END
GO
