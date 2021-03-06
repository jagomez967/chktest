SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ReporteProducto_GetAll]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[ReporteProducto_GetAll] AS' 
END
GO

ALTER PROCEDURE [dbo].[ReporteProducto_GetAll]
	-- Add the parameters for the stored procedure here
     @IdReporte int = NULL
	,@IdMarca int
	,@IdEmpresa int

	
AS
BEGIN
--exec ReporteProducto_GetAll null,627,249
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
    
	SELECT P.IdProducto
	      ,P.Nombre
	      ,(case when RP.IdProducto IS NULL then 'false' else 'true' end) as Estado
	      ,(case when RP.Cantidad IS NULL then '0' else RP.Cantidad end) as Cantidad
	      ,(case when RP.Precio IS NULL then '0' else RP.Precio end) as Precio
		  ,(case when RP.Precio2 IS NULL then '0' else RP.Precio2 end) as Precio2
		  ,(case when RP.Precio3 IS NULL then '0' else RP.Precio3 end) as Precio3
	      ,(case when RP.Stock IS NULL then '1' else RP.Stock end) as Stock
	      ,(case when RP.NoTrabaja IS NULL then '0' else RP.NoTrabaja end) as NoTrabaja
	      ,RP.Id
	      ,@IdMarca AS IdMarca
	      ,RP.IdExhibidor	      
 	      ,(case when RP.Cantidad2 IS NULL then '0' else RP.Cantidad2 end) as Cantidad2
		  ,RP.IdExhibidor2
		  ,P.CodigoBarras as CodigoBarras      
		  ,F.IdFamilia as IdFamilia
		  ,F.Nombre as NombreFamilia
	FROM Producto P 	
	LEFT JOIN ReporteProducto RP ON (RP.[IdReporte] = @IdReporte and P.IdProducto = RP.IdProducto)
	left join Familia F on F.IdFamilia=P.IdFamilia
	WHERE P.IdMarca=@IdMarca  and P.Reporte=1
	order by p.orden, F.Nombre,P.nombre

END
GO
