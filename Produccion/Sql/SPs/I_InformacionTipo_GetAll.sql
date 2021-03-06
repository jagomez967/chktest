SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[I_InformacionTipo_GetAll]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[I_InformacionTipo_GetAll] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[I_InformacionTipo_GetAll]
	-- Add the parameters for the stored procedure here
AS
BEGIN
	SET NOCOUNT ON;

	SELECT [IdInformacionTipo]
		  ,[Nombre]
		  ,[Activo]
	  FROM [dbo].[I_InformacionTipo]
	  WHERE [Activo]=1
	  ORDER BY [Nombre]
  
END
GO
