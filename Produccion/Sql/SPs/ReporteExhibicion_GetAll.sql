SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ReporteExhibicion_GetAll]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[ReporteExhibicion_GetAll] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[ReporteExhibicion_GetAll] 
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
    SELECT EX.IdExhibidor
		  ,EX.Nombre
		  ,(case when RE.IdExhibidor IS NULL then 'false' else 'true' end) as Estado
		  ,(case when RE.Cantidad IS NULL then '0' else RE.Cantidad end) as Cantidad 
		  ,RE.Id
    FROM Exhibidor EX 
    LEFT JOIN ReporteExhibicion RE ON (RE.IdReporte = @IdReporte and RE.IdMarca = @IdMarca and RE.IdExhibidor = EX.IdExhibidor)        
    INNER JOIN Exhibidor_Marca EM ON (EM.IdMarca = @IdMarca and EX.IdExhibidor = EM.IdExhibidor)                      
    --INNER JOIN Cliente C ON (C.IdEmpresa= @IdEmpresa)
    --INNER JOIN Exhibidor_Cliente EC ON (EC.IdCliente = C.IdCliente and EX.IdExhibidor = EC.IdExhibidor)                      
    

END
GO
