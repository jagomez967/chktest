SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MarcaPedido_GetAll]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[MarcaPedido_GetAll] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[MarcaPedido_GetAll]
	-- Add the parameters for the stored procedure here
	@IdMarcaPedido int = NULL
   ,@Nombre varchar(50) = NULL
   ,@IdEmpresa int = NULL
   AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT MP.[IdMarcaPedido]
		  ,MP.[IdEmpresa]
		  ,MP.[Nombre]
		  ,MP.[Orden]
		  ,E.Nombre AS Empresa
  FROM [dbo].[MarcaPedido] MP
  INNER JOIN Empresa E ON (E.[IdEmpresa] = MP.[IdEmpresa])
  WHERE (@IdMarcaPedido IS NULL OR MP.[IdMarcaPedido] = @IdMarcaPedido) AND
        (@IdEmpresa IS NULL OR MP.[IdEmpresa] = @IdEmpresa) AND
        (@Nombre IS NULL OR MP.[Nombre] like '%' + @Nombre + '%')
  ORDER BY MP.[Nombre]

END
GO
