SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ProductoPedido_GetAll]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[ProductoPedido_GetAll] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[ProductoPedido_GetAll]
	-- Add the parameters for the stored procedure here
	 @IdProductoPedido int = NULL
    ,@IdMarcaPedido int = NULL
    ,@Nombre varchar(50) = NULL
    ,@IdEmpresa int = NULL
    
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT P.[IdProductoPedido]
		  ,P.[CodigoEAN]
		  ,P.[CodigoSAP]
		  ,P.[IdMarcaPedido]
		  ,P.[Nombre]
		  ,P.[Orden]
		  ,P.Activo
		  ,case 
			when P.[Activo] = 1 then 'SI' 			
			when P.[Activo] = 0 then 'NO' 			
		   end ActivoTexto  
          ,E.Nombre AS Empresa
          ,M.Nombre AS Marca
	FROM [dbo].[ProductoPedido] P
	INNER JOIN MarcaPedido M ON (M.[IdMarcaPedido] = P.[IdMarcaPedido] AND (@IdEmpresa IS NULL OR M.IdEmpresa = @IdEmpresa))
	INNER JOIN Empresa E ON (E.[IdEmpresa] = M.[IdEmpresa])
	WHERE (@IdProductoPedido IS NULL OR  P.[IdProductoPedido] = @IdProductoPedido) AND
	      (@IdMarcaPedido IS NULL OR P.[IdMarcaPedido] = @IdMarcaPedido) AND
	      (@Nombre IS NULL OR P.[Nombre] like '%' + @Nombre + '%')
	Order By P.Nombre
	      	    
END
GO
