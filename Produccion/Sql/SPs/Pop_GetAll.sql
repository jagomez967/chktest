SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Pop_GetAll]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Pop_GetAll] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[Pop_GetAll]
	-- Add the parameters for the stored procedure here
	@IdPop int = NULL
   ,@Nombre varchar(100) = NULL
   ,@Descripcion varchar(200) = NULL
   ,@Activo bit = 0
   ,@CodigoSap VARCHAR(50) = NULL
    
  AS
  
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT [IdPop]
	      ,[Nombre]
		  ,[Descripcion]
		  ,[Activo]
		  ,[CodigoSap]
	FROM [dbo].[Pop]
	WHERE (@IdPop IS NULL OR @IdPop=[IdPop]) AND
	      (@Nombre IS NULL OR [Nombre] like '%' + @Nombre +'%') AND
	      (@Descripcion IS NULL OR [Descripcion] like '%' + @Descripcion +'%') 

END
GO
