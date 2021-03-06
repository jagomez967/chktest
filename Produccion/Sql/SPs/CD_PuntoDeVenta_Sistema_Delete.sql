SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CD_PuntoDeVenta_Sistema_Delete]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[CD_PuntoDeVenta_Sistema_Delete] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[CD_PuntoDeVenta_Sistema_Delete]
	-- Add the parameters for the stored procedure here
    @IdPuntoDeVenta int   
   ,@IdSistema int = NULL  
   
AS
BEGIN
	SET NOCOUNT ON;
	
	DELETE FROM [dbo].[CD_PuntoDeVenta_Sistema]
    WHERE (@IdPuntoDeVenta = [IdPuntoDeVenta]) AND 
          (@IdSistema IS NULL OR  @IdSistema = IdSistema)
          
END
GO
