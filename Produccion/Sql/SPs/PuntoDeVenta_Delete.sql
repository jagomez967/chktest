SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PuntoDeVenta_Delete]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[PuntoDeVenta_Delete] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[PuntoDeVenta_Delete]
	-- Add the parameters for the stored procedure here
	@IdPuntoDeVenta int
	
AS
BEGIN
	SET NOCOUNT ON;

	DELETE FROM [dbo].[Cliente_PuntoDeVenta]
    WHERE IdPuntoDeVenta = @IdPuntoDeVenta

	DELETE FROM [dbo].[Drogueria_PuntoDeVenta]
    WHERE IdPuntoDeVenta = @IdPuntoDeVenta

	DELETE FROM [dbo].[Foto_PuntoDeVenta]
    WHERE IdPuntoDeVenta = @IdPuntoDeVenta

	DELETE FROM [dbo].[Propiedad_PuntoDeVenta]
    WHERE IdPuntoDeVenta = @IdPuntoDeVenta

	DELETE FROM [dbo].[PuntoDeVenta_Cliente_Usuario]
    WHERE IdPuntoDeVenta = @IdPuntoDeVenta
    
    DELETE FROM [dbo].[PuntoDeVenta_Vendedor]
    WHERE IdPuntoDeVenta = @IdPuntoDeVenta

    DELETE FROM [dbo].[PuntoDeVentaCampania]
    WHERE IdPuntoDeVenta = @IdPuntoDeVenta
    
    DELETE FROM [dbo].[PuntoDeVentaNegocio]
    WHERE IdPuntoDeVenta = @IdPuntoDeVenta
    
    DELETE FROM [dbo].[Segmento_PuntoDeVenta]
    WHERE IdPuntoDeVenta = @IdPuntoDeVenta

    DELETE FROM [dbo].[SegmentoVisitas_PuntoDeVenta]
    WHERE IdPuntoDeVenta = @IdPuntoDeVenta

	DELETE FROM [dbo].[Usuario_PuntoDeVenta]
    WHERE IdPuntoDeVenta = @IdPuntoDeVenta

	DELETE FROM [dbo].[PuntoDeVenta]
    WHERE IdPuntoDeVenta = @IdPuntoDeVenta

END
GO
