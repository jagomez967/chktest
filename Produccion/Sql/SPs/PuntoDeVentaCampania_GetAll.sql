SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PuntoDeVentaCampania_GetAll]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[PuntoDeVentaCampania_GetAll] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[PuntoDeVentaCampania_GetAll]
	-- Add the parameters for the stored procedure here
	@IdPuntoDeVenta int 

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT PDVC.[IdCampania]
		  ,PDVC.[IdPuntoDeVenta]
		  ,PDVC.[Activo] AS ActivoPuntoDeVentaCampania
		  ,C.[Nombre]
		  ,C.[Fecha]
		  ,C.[IdMarca]
		  ,C.[Activo]
		  ,M.Nombre AS Marca
		  ,E.[IdEmpresa]
		  ,E.Nombre AS Empresa
	  FROM [dbo].[PuntoDeVentaCampania] PDVC
	  INNER JOIN [Campania] C ON (PDVC.[IdCampania] = C.[IdCampania])
	  INNER JOIN Marca M ON (M.[IdMarca] = C.[IdMarca])
	  INNER JOIN Empresa E ON (E.[IdEmpresa] = M.[IdEmpresa])
	  WHERE PDVC.[IdPuntoDeVenta] = @IdPuntoDeVenta
  
END
GO
