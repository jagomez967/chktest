SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ReportePop_GetAll]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[ReportePop_GetAll] AS' 
END
GO
ALTER PROCEDURE [dbo].[ReportePop_GetAll]
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
	  SELECT P.IdPop
	        ,P.Nombre
	        ,(case when RP.IdPop is null then 'false' else 'true' end) as Estado
	        ,(case when RP.Cantidad is null then '0' else RP.Cantidad end) as Cantidad 
	        ,RP.Id
       FROM Pop P 
	   LEFT JOIN ReportePop RP ON (RP.IdReporte = @IdReporte and RP.IdMarca = @IdMarca and RP.IdPop = P.IdPop)        
	   INNER JOIN POP_Marca PM ON (PM.IdMarca = @IdMarca and P.IdPop = PM.IdPop) 
	   --INNER JOIN Cliente C ON (C.IdEmpresa = @IdEmpresa )
	   --INNER JOIN Pop_Cliente PC ON (PC.IdCliente = C.IdCliente and P.IdPop = PC.IdPop)
	   WHERE 
		P.Activo = 1
	   ORDER BY P.Nombre   
	  
END
GO
