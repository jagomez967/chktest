SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ReporteExhibicion_Add]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[ReporteExhibicion_Add] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[ReporteExhibicion_Add]
	-- Add the parameters for the stored procedure here
    @IdReporte int
   ,@IdMarca int
   ,@IdExhibidor int
   ,@Cantidad int = NULL
   
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	if @Cantidad IS NULL SET @Cantidad = 0

    -- Insert statements for procedure here
	INSERT INTO [dbo].[ReporteExhibicion]
           ([IdReporte]
           ,[IdMarca]
           ,[IdExhibidor]
           ,[Cantidad])
     VALUES
           (@IdReporte
           ,@IdMarca
           ,@IdExhibidor
           ,@Cantidad)
           
END
GO
