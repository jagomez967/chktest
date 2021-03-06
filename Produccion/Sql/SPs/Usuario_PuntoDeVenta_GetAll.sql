SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Usuario_PuntoDeVenta_GetAll]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Usuario_PuntoDeVenta_GetAll] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[Usuario_PuntoDeVenta_GetAll]
	-- Add the parameters for the stored procedure here
	@IdPuntoDeVenta int
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT UPDV.[IdPuntoDeVenta]
		  ,UPDV.[IdUsuario]
		  ,UPDV.[Id]
		  ,U.Apellido
		  ,U.Nombre
		  ,U.Apellido + ', ' + U.Nombre COLLATE DATABASE_DEFAULT AS Usuario
		  ,U.[DiferenciaHora]
		  ,U.[DiferenciaMinutos]
	FROM [dbo].[Usuario_PuntoDeVenta] UPDV
	INNER JOIN Usuario U ON (UPDV.[IdUsuario] = U.[IdUsuario])
	WHERE UPDV.[IdPuntoDeVenta] = @IdPuntoDeVenta
	ORDER BY U.Apellido
	
END
GO
