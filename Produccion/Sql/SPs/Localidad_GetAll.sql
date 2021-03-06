SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Localidad_GetAll]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Localidad_GetAll] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[Localidad_GetAll]
	-- Add the parameters for the stored procedure here
	 @IdLocalidad int = NULL
	,@IdProvincia int = NULL
	,@Nombre varchar(50) =  NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT L.[IdLocalidad]
		  ,L.[IdProvincia]
	      ,L.[Nombre]
	      ,P.Nombre AS NombreProvincia
	FROM [dbo].[Localidad]	L
	LEFT JOIN Provincia P ON (P.IdProvincia = L.IdProvincia)
	WHERE (@IdLocalidad IS NULL OR @IdLocalidad = L.[IdLocalidad]) AND
	      (@IdProvincia IS NULL OR @IdProvincia = L.[IdProvincia]) AND
	      (@Nombre IS NULL OR L.[Nombre] like '%' + @Nombre + '%')
	ORDER BY L.[Nombre] 

END
GO
