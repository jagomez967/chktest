SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ReporteVidriera_GetAll]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[ReporteVidriera_GetAll] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[ReporteVidriera_GetAll]
	-- Add the parameters for the stored procedure here
	 @IdReporte int = NULL
	,@IdMarca int
	,@IdEmpresa int
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT RV.Armada
	      ,RV.NecesitaMantenimiento
	      ,RV.IdCampania 
	      ,RV.IdMarca
	      ,CA.Nombre AS NombreCampania
	FROM ReporteVidriera RV 
	INNER JOIN Campania CA ON (RV.IdCampania = CA.IdCampania)
    where RV.IdReporte=@IdReporte 
      and RV.IdMarca=@IdMarca 
END
GO
