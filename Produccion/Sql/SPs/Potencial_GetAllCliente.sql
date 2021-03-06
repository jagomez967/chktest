SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Potencial_GetAllCliente]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Potencial_GetAllCliente] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[Potencial_GetAllCliente]
	-- Add the parameters for the stored procedure here
	 @IdCliente int = NULL
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT P.[IdPotencial]
		  ,P.[Nombre]
	FROM [dbo].[Potencial] P
	INNER JOIN dbo.Negocio N ON (P.IdNegocio = N.IdNegocio)
	INNER JOIN Empresa E ON (E.IdNegocio = P.IdNegocio) --AGREGADO
	INNER JOIN Cliente C ON (C.IdEmpresa = E.IdEmpresa) --AGREGADO
	WHERE (@IdCliente = C.IdCliente)
	ORDER BY P.[Nombre]

END
GO
