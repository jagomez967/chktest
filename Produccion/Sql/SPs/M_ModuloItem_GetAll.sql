SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[M_ModuloItem_GetAll]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[M_ModuloItem_GetAll] AS' 
END
GO
ALTER PROCEDURE [dbo].[M_ModuloItem_GetAll]
	 @IdModulo int 
	,@IdCliente int = null 
	
AS
BEGIN
	SET NOCOUNT ON;

	SELECT I.[IdModuloItem]
		  ,I.[CodigoItem]
		  ,I.[IdModulo]
		  ,I.[IdTipoItem]
		  ,T.Descripcion AS TipoItemDescriopcion
		  ,I.[Descripcion]
		  ,ISNULL(IC.Leyenda,I.[Leyenda]) AS Leyenda
		  ,ISNULL(IC.[Visibilidad],IC.[Visibilidad]) AS Visibilidad
		  ,ISNULL(IC.[Obligatorio],I.[Obligatorio]) AS Obligatorio
		  ,ISNULL(IC.[ValorMaximo],I.[ValorMaximo]) AS  ValorMaximo
		  ,ISNULL(IC.[Orden],0) AS Orden
		  ,I.[Activo] as Activo
		  ,case when IC.Orden is null or IC.Orden = 0 then I.Orden else IC.Orden end as Orden1
		  --,case when I.Orden is null or I.Orden = 0 then 999999 else I.Orden end as Orden2
	FROM M_ModuloItem I
	INNER JOIN M_TipoItem T ON  (T.IdTipoItem = I.IdTipoItem)
	INNER JOIN M_ModuloCliente MC
	ON I.IdModulo = MC.IdModulo AND MC.IdCLiente = @IdCliente
	INNER JOIN M_ModuloClienteItem IC
	ON IC.IdModuloCliente = MC.IdModuloCliente AND IC.IdModuloItem = I.IdModuloItem
	WHERE MC.IdModulo = @IdModulo
  ORDER BY Orden1
  
END

GO
