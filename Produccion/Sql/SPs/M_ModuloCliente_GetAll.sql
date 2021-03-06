SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[M_ModuloCliente_GetAll]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[M_ModuloCliente_GetAll] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[M_ModuloCliente_GetAll]
	@IdCliente int
	
AS
BEGIN
	SET NOCOUNT ON;

	SELECT M.[IdModulo]
		  ,M.[Codigo]
		  ,ISNULL(MC.Descripcion,M.[Descripcion]) AS Descripcion
		  ,ISNULL(MC.[Activo], M.[Activo]) AS Activo		  
	  FROM [M_Modulo] M
	  LEFT JOIN M_ModuloCliente MC ON (M.IdModulo = MC.IdModulo AND (@IdCliente = MC.IdCliente))
	  WHERE MC.IdCliente IS NOT NULL
	  ORDER BY  M.[IdModulo]
  
END
GO
