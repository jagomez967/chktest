SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Campania_GetAllCliente]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Campania_GetAllCliente] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[Campania_GetAllCliente]
	-- Add the parameters for the stored procedure here
	 @IdCliente int = NULL
	,@Nombre varchar(50) = NULL
    
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
	INNER JOIN Negocio N ON (E.IdNegocio = N.IdNegocio) 
	INNER JOIN Cliente CLI ON (E.IdEmpresa = CLI.IdEmpresa) --AGREGADO
	WHERE (@IdCliente IS NULL OR CLI.[IdCliente] = @IdCliente)		
	  AND (@Nombre IS NULL OR C.[Nombre] like '%' + @Nombre +'%')
	  
END
GO
