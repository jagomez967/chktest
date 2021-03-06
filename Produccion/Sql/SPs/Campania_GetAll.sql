SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Campania_GetAll]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Campania_GetAll] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[Campania_GetAll]
	-- Add the parameters for the stored procedure here
	 @IdEmpresa int = NULL
	,@IdCampania int =  NULL
    ,@Nombre varchar(50) = NULL
    ,@IdMarca int = NULL
    
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT C.[IdCampania]
		  ,C.[Nombre]
		  ,C.[Fecha]
		  ,C.[IdMarca]
		  ,C.[Activo]
		  ,M.Nombre AS Marca
		  ,E.[IdEmpresa]
		  ,E.Nombre AS Empresa
	FROM [dbo].[Campania] C
	INNER JOIN Marca M ON (M.[IdMarca] = C.[IdMarca])
	INNER JOIN Empresa E ON (E.[IdEmpresa] = M.[IdEmpresa])
	WHERE (@IdCampania IS NULL OR @IdCampania = C.[IdCampania]) 
	  AND (@IdEmpresa IS NULL OR E.[IdEmpresa] = @IdEmpresa)		
	  AND (@Nombre IS NULL OR C.[Nombre] like '%' + @Nombre +'%') 
	  AND (@IdMarca IS NULL OR @IdMarca = C.[IdMarca])
	  
END
GO
