SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Propiedad_GetAllCliente]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Propiedad_GetAllCliente] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[Propiedad_GetAllCliente]
	-- Add the parameters for the stored procedure here
	 @IdCliente INT = NULL
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT P.[IdPropiedad]
		  ,P.[Nombre]
		  ,P.[IdNegocio]
	  FROM [dbo].[Propiedad] P
	  INNER JOIN dbo.Negocio N ON (P.IdNegocio = N.IdNegocio)
	  INNER JOIN Empresa E ON (E.IdNegocio = N.IdNegocio) --AGREGADO
	  INNER JOIN Cliente C ON (C.IdEmpresa = E.IdEmpresa) --AGREGADO
	  WHERE (@IdCliente = C.IdCliente)
	  ORDER BY [Nombre]

END
GO
