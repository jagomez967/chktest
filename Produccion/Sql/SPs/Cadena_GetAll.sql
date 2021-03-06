SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Cadena_GetAll]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Cadena_GetAll] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[Cadena_GetAll]
	-- Add the parameters for the stored procedure here
    --@ListaNegocios ListaNegocios READONLY
    @IdCadena INT = NULL
   ,@Nombre varchar(50) = NULL
   
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT C.[IdCadena]
		  ,C.[Nombre]
		  ,C.[IdNegocio]
	FROM [dbo].[Cadena] C
	--INNER JOIN @ListaNegocios LN ON (LN.IdNegocio = C.[IdNegocio])
	WHERE (@IdCadena IS NULL OR @IdCadena = C.[IdCadena]) AND
	      (@Nombre IS NULL OR C.[Nombre] like '%' + @Nombre + '%')
	ORDER BY C.[Nombre]


END
GO
