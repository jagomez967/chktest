SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PuntoDeVenta_Cliente_Usuario_GetAll]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[PuntoDeVenta_Cliente_Usuario_GetAll] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[PuntoDeVenta_Cliente_Usuario_GetAll]
	-- Add the parameters for the stored procedure here
    @IdCliente int = NULL
   ,@IdPuntoDeVenta int = NULL
   ,@IdUsuario int = NULL
   
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
    SELECT P.[IdPuntoDeVenta]       
      ,CP.IdCliente
      ,UC.IdUsuario    
      ,C.Nombre As NombreCliente
      ,U.Nombre AS NombreUsuario
      ,U.Apellido AS ApellidoUsuario
      ,dbo.PuntoDeVenta_Cliente_Usuario_GetActivo(CP.IdCliente,P.[IdPuntoDeVenta], UC.IdUsuario) AS Activo
  FROM [dbo].[PuntoDeVenta]  P
  INNER JOIN Cliente_PuntoDeVenta CP  ON (CP.IdPuntoDeVenta =  P.IdPuntoDeVenta)
  INNER JOIN Cliente C ON (C.IdCliente = CP.IdCliente)
  INNER JOIN Usuario_PuntoDeVenta UP ON (UP.[IdPuntoDeVenta] = P.[IdPuntoDeVenta])
  INNER JOIN Usuario_Cliente UC ON (UC.IdCliente = CP.IdCliente AND UC.IdUsuario = UP.IdUsuario)
  INNER JOIN Usuario U ON(U.IdUsuario = UC.IdUsuario)
  WHERE (NOT UC.IdUsuario IS NULL) AND 
        (NOT CP.IdCliente IS NULL) AND 
		(CP.IdPuntoDeVenta = @IdPuntoDeVenta)
  GROUP BY P.[IdPuntoDeVenta],CP.IdCliente, UC.IdUsuario ,C.Nombre,U.Apellido, U.Nombre
  ORDER BY C.Nombre, U.Apellido, U.Nombre

	--SELECT [IdPuntoDeVenta_Cliente_Usuario]
	--	  ,[IdCliente]
	--	  ,[IdPuntoDeVenta]
	--	  ,[IdUsuario]
	--	  ,[Fecha]
	--	  ,[Activo]
 --  FROM [dbo].[PuntoDeVenta_Cliente_Usuario]
 --  WHERE (@IdCliente IS NULL OR @IdCliente = [IdCliente]) AND
	--	 (@IdPuntoDeVenta IS NULL OR @IdPuntoDeVenta = [IdPuntoDeVenta]) AND
	--	 (@IdUsuario IS NULL OR @IdUsuario = [IdUsuario])
END
GO
