SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MantenimientoMaterial_Marca_GetAll]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[MantenimientoMaterial_Marca_GetAll] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[MantenimientoMaterial_Marca_GetAll]
	-- Add the parameters for the stored procedure here
	@IdMantenimientoMaterial int
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
  SELECT MMM.[IdMantenimientoMaterial_Marca]
        ,MMM.[IdMantenimientoMaterial]
        ,MMM.[IdMarca]
        ,MMM.[Activo]
        ,M.Nombre As Marca
        ,E.[Nombre] AS Empresa
        ,E.IdEmpresa 
  FROM [dbo].[MantenimientoMaterial_Marca] MMM
  INNER JOIN Marca M ON (M.[IdMarca] = MMM.[IdMarca])
  INNER JOIN Empresa E ON (M.[IdEmpresa] = E.[IdEmpresa])
  WHERE (@IdMantenimientoMaterial IS NULL OR MMM.[IdMantenimientoMaterial] = @IdMantenimientoMaterial)
  ORDER BY E.[Nombre], M.[Nombre]

END
GO
