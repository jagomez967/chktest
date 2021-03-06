SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Segmento_PuntoDeVenta_Add]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Segmento_PuntoDeVenta_Add] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[Segmento_PuntoDeVenta_Add]
	-- Add the parameters for the stored procedure here
    @IdSegmento int
   ,@IdPuntoDeVenta int
   
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	INSERT INTO [dbo].[Segmento_PuntoDeVenta]
           ([IdSegmento]
           ,[IdPuntoDeVenta])
     VALUES
           (@IdSegmento
           ,@IdPuntoDeVenta)
           
END
GO
