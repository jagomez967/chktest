SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Sistema_GetAll]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Sistema_GetAll] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[Sistema_GetAll]	
AS
BEGIN
	
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT [IdSistema]
      ,[Nombre]
      ,[Descripcion]
      ,[Activo]
  FROM [Sistema]

END
GO
