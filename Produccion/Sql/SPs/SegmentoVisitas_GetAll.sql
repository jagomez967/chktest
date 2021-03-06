SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SegmentoVisitas_GetAll]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SegmentoVisitas_GetAll] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[SegmentoVisitas_GetAll]
	-- Add the parameters for the stored procedure here
	@IdSegmentoVisitas int = NULL
   ,@IdEmpresa INT = NULL
   ,@Nombre varchar(50) =  NULL
   
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT S.[IdSegmentoVisitas]
		  ,S.[IdEmpresa]
		  ,S.[Nombre]
		  ,E.[Nombre] AS Empresa
	FROM [dbo].[SegmentoVisitas] S
	INNER JOIN Empresa E ON (E.[IdEmpresa] = S.[IdEmpresa])
	WHERE (@IdSegmentoVisitas IS NULL OR  S.[IdSegmentoVisitas]=@IdSegmentoVisitas) AND
		  (@IdEmpresa IS NULL OR  S.[IdEmpresa]=@IdEmpresa) AND
	      (@Nombre IS NULL OR S.[Nombre] like '%' + @Nombre + '%')

END
GO
