SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CD_Cadena_GetAll]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[CD_Cadena_GetAll] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[CD_Cadena_GetAll]
	
	 @IdCadena int = NULL
	,@Nombre varchar(255) = NULL
AS
BEGIN
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT [IdCadena]
      ,[Nombre]
      ,[Activo]
  FROM [dbo].[CD_Cadena]
  WHERE (@IdCadena IS NULL OR @IdCadena = [IdCadena]) AND
        (@Nombre IS NULL OR [Nombre] like '%' + @Nombre + '%')
  ORDER BY [Nombre] 

END
GO
