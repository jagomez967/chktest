SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ProductoCompetencia_Add]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[ProductoCompetencia_Add] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[ProductoCompetencia_Add]
	-- Add the parameters for the stored procedure here
    @IdProducto int
   ,@IdProductoCompetencia int
   ,@Reporte bit = NULL	
   
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	INSERT INTO [dbo].[ProductoCompetencia]
           ([IdProducto]
           ,[IdProductoCompetencia]
           ,[Reporte])
     VALUES
           (@IdProducto
           ,@IdProductoCompetencia
           ,@Reporte)
           

END
GO
