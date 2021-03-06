SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Usuario_PuntoDeVenta_GetAllUsuario]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Usuario_PuntoDeVenta_GetAllUsuario] AS' 
END
GO
ALTER PROCEDURE [dbo].[Usuario_PuntoDeVenta_GetAllUsuario]
	-- Add the parameters for the stored procedure here
	@IdEmpresa int   
   ,@IdUsuario int = NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT UPDV.IdUsuario
          ,ISNULL(U.[Apellido],'') + ', ' + ISNULL(U.[Nombre],'') COLLATE DATABASE_DEFAULT  As  ApellidoNombre
          ,UPDV.IdPuntoDeVenta 
    FROM Usuario_PuntoDeVenta UPDV 
    INNER JOIN PuntoDeVenta PDV ON (UPDV.IdPuntoDeVenta=PDV.IdPuntoDeVenta)
    INNER JOIN Cliente C ON (C.IdCliente=PDV.IdCliente) 
	INNER JOIN Usuario_Cliente UC ON (C.IdCliente = UC.IdCliente AND UPDV.IdUsuario = UC.IdUsuario)
    INNER JOIN Usuario U ON (UC.IdUsuario=U.IdUsuario and (@IdUsuario IS NULL OR @IdUsuario = U.IdUsuario))
    WHERE C.IdEmpresa = @IdEmpresa
    GROUP BY UPDV.IdUsuario,ISNULL(U.[Apellido],'') + ', ' + ISNULL(U.[Nombre],'')  COLLATE DATABASE_DEFAULT, UPDV.IdPuntoDeVenta
    	
END
GO
