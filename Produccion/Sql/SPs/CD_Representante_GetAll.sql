SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CD_Representante_GetAll]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[CD_Representante_GetAll] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[CD_Representante_GetAll]
	-- Add the parameters for the stored procedure here
	 @IdRepresentante int = NULL
	,@Nombre varchar(255) =  NULL
AS
BEGIN
	
	SET NOCOUNT ON;

	SELECT [IdRepresentante]
		  ,[Nombre]
		  ,[IdSistema]
		  ,[Activo]
  FROM [dbo].[CD_Representante]
  WHERE (@IdRepresentante IS NULL OR @IdRepresentante = [IdRepresentante]) AND
        (@Nombre IS NULL OR [Nombre] like '%' + @Nombre + '%')
  ORDER BY [Nombre]
  
END
GO
