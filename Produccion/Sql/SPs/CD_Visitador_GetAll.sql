SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CD_Visitador_GetAll]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[CD_Visitador_GetAll] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[CD_Visitador_GetAll]
	-- Add the parameters for the stored procedure here
	 @IdVisitador int = NULL
	,@IdSistema int = NULL
	,@Nombre varchar(225) = NULL
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT V.[IdVisitador]
		  ,V.[Nombre]
		  ,V.[IdSistema]
		  ,V.[Activo]
		  ,S.Nombre AS SistemaNombre
	  FROM [dbo].[CD_Visitador] V
	  LEFT JOIN [dbo].[Sistema] S ON (S.IdSistema = V.IdSistema)
	  WHERE (@IdVisitador IS NULL OR @IdVisitador =V.[IdVisitador]) AND
			(@IdSistema IS NULL OR @IdSistema =V.[IdSistema]) AND
			(@Nombre IS NULL OR V.[Nombre] Like  '%' + @Nombre + '%')
	ORDER BY V.[Nombre]
   
END
GO
