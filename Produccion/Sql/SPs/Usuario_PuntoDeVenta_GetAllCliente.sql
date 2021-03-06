SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Usuario_PuntoDeVenta_GetAllCliente]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Usuario_PuntoDeVenta_GetAllCliente] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[Usuario_PuntoDeVenta_GetAllCliente]
	-- Add the parameters for the stored procedure here
	@IdPuntoDeVenta_Cliente_Usuario int = NULL,
	@IdPuntoDeVenta int = null,
	@IdCliente int = null,
	@IdUsuario int = null
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT UPDV.[IdPuntoDeVenta]
		  ,UPDV.[IdUsuario]
		  ,UPDV.[Id]
		  ,UPDV.[Activo]
		  ,U.IdUsuario
		  ,U.Apellido AS ApellidoUsuario
		  ,U.Nombre AS NombreUsuario
		  ,U.Apellido + ', ' + U.Nombre COLLATE DATABASE_DEFAULT AS Usuario
		  ,U.[DiferenciaHora]
		  ,U.[DiferenciaMinutos]
		  ,PDV.IdCliente
		  ,C.Nombre AS NombreCliente
	FROM [dbo].[Usuario_PuntoDeVenta] UPDV
	INNER JOIN Usuario U ON (UPDV.[IdUsuario] = U.[IdUsuario])
	INNER JOIN PuntoDeVenta PDV ON (UPDV.IdPuntoDeVenta = PDV.IdPuntoDeVenta)
	INNER JOIN Cliente C ON (PDV.IdCliente = C.IdCliente)
	WHERE UPDV.[IdPuntoDeVenta] = @IdPuntoDeVenta AND PDV.IdCliente = @IdCliente
	ORDER BY U.Apellido
	
END
GO
