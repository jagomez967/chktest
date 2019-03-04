SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Tipo_GetAllNegocio]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Tipo_GetAllNegocio] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[Tipo_GetAllNegocio]
	-- Add the parameters for the stored procedure here
	@ListaNegocios ListaNegocios READONLY,
	@IdTipo int = NULL,
	@IdCliente int = NULL,
	@Nombre varchar(50) = NULL
   
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT 				T.[IdTipo], T.[Nombre], T.[IdNegocio]
	FROM				[dbo].[Tipo] T
	INNER JOIN			@ListaNegocios LN
	ON					LN.IdNegocio = T.IdNegocio
	WHERE				(@IdTipo IS NULL OR @IdTipo = [IdTipo]) AND
						(@Nombre IS NULL OR [Nombre] like '%' + @Nombre + '%')
	ORDER BY			[Nombre]

END
GO
