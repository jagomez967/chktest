SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ReporteMarcaPropiedad_GetAll]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[ReporteMarcaPropiedad_GetAll] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[ReporteMarcaPropiedad_GetAll]
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
	  
      SELECT MP.IdMarcaPropiedad
            ,MP.Nombre
            ,MP.Opcional
            ,MP.NoExhibe
            ,MP.NoAutorizada
            ,MP.NoTrabaja
            ,(case when RMP.IdMarcaPropiedad IS NULL then 'false' else 'true' end) as Estado
            ,RMP.Id
		FROM MarcaPropiedad MP 
		LEFT JOIN ReporteMarcaPropiedad RMP ON (RMP.IdReporte=@IdReporte and MP.IdMarcaPropiedad = RMP.IdMarcaPropiedad)
        WHERE MP.IdMarca = @IdMarca

END
GO
