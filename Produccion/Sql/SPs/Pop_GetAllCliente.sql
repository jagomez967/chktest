SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Pop_GetAllCliente]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Pop_GetAllCliente] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[Pop_GetAllCliente]
	-- Add the parameters for the stored procedure here
	@IdCliente INT = NULL
   ,@Nombre VARCHAR(100) = NULL
    
  AS
  
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here

	SELECT P.[IdPop]
	      ,P.[Nombre]
		  ,P.[Descripcion]
	FROM [dbo].[Pop] P
	WHERE (@IdCliente = P.IdCliente) AND
		  (@Nombre IS NULL OR [Nombre] like '%' + @Nombre +'%')

END
GO
