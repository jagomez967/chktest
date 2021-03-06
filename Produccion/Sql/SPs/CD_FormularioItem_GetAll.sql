SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CD_FormularioItem_GetAll]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[CD_FormularioItem_GetAll] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[CD_FormularioItem_GetAll]
	
	@IdFormulario int
   ,@IdSistema int 
		
AS
BEGIN

	SET NOCOUNT ON;

	SELECT FI.[IdFormulario]
		  ,FI.[IdProducto]
		  ,FI.[Cantidad]
		  ,FI.[Activo] AS ActivoItem
		  ,P.[Codigo]
		  ,P.[CodigoEAN]
		  ,P.[CodigoSAP]
		  ,P.[Nombre]
		  ,P.[IdMarca]
		  ,P.[Orden]
		  ,P.[Activo]  
	FROM [dbo].[CD_FormularioItem] FI
	INNER JOIN CD_Producto P ON P.[IdProducto] = FI.[IdProducto]
	INNER JOIN CD_Formulario F ON (F.[IdFormulario] = FI.[IdFormulario])
	INNER JOIN CD_Campania C ON (C.IdCampania = F.IdCampania AND C.IdSistema = @IdSistema)
	WHERE FI.[IdFormulario] = @IdFormulario AND FI.[Activo]=1
	ORDER BY P.[Orden]
    
  END
GO
