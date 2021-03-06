SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Exhibidor_Update]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Exhibidor_Update] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[Exhibidor_Update]
	-- Add the parameters for the stored procedure here
	 @IdExhibidor int
	,@Nombre varchar(100)
	,@Descripcion varchar(200) = NULL
	,@IdCliente INT = NULL
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
    
    UPDATE [dbo].[Exhibidor]
	   SET [Nombre] = @Nombre
		  ,[Descripcion] = @Descripcion
	WHERE [IdExhibidor] = @IdExhibidor AND IdCliente = @IdCliente

END
GO
