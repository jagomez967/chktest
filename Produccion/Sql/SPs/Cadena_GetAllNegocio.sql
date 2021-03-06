SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Cadena_GetAllNegocio]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Cadena_GetAllNegocio] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[Cadena_GetAllNegocio] 
	-- Add the parameters for the stored procedure here
	@IdNegocio int = NULL
   ,@Nombre VARCHAR(50) = NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT		C.IdCadena, C.Nombre, N.Nombre AS Negocio
	FROM		Cadena C
	INNER JOIN Negocio N ON (C.IdNegocio = N.IdNegocio)
	WHERE		(@IdNegocio IS NULL OR @IdNegocio = C.[IdNegocio]) AND
				(@Nombre IS NULL OR C.[Nombre] like '%' + @Nombre + '%')
	ORDER BY	C.Nombre
END
GO
