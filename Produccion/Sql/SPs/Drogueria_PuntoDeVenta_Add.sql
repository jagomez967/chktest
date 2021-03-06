SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Drogueria_PuntoDeVenta_Add]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Drogueria_PuntoDeVenta_Add] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[Drogueria_PuntoDeVenta_Add]
	-- Add the parameters for the stored procedure here
    @IdPuntoDeVenta int
   ,@IdDrogueria int
   ,@Codigo varchar(50)
   
AS
BEGIN

	SET NOCOUNT ON;

	DELETE  [dbo].[Drogueria_PuntoDeVenta]
    WHERE [IdPuntoDeVenta] = @IdPuntoDeVenta AND IdDrogueria = @IdDrogueria
          
	

	INSERT INTO [dbo].[Drogueria_PuntoDeVenta]
           ([IdPuntoDeVenta],[IdDrogueria],[Codigo])
     VALUES
           (@IdPuntoDeVenta,@IdDrogueria,@Codigo)

END
GO
