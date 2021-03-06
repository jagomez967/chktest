SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PuntoDeVentaCampania_GetAllReporte]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[PuntoDeVentaCampania_GetAllReporte] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[PuntoDeVentaCampania_GetAllReporte] 
	-- Add the parameters for the stored procedure here
    @IdEmpresa int   
   ,@IdUsuario int = NULL
   
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT PDVC.[IdCampania]
		  ,PDVC.[IdPuntoDeVenta]
		  ,CA.[IdMarca]
		  ,CA.[Nombre]
    FROM [dbo].[PuntoDeVentaCampania] PDVC
    INNER JOIN [Campania] CA ON (CA.[IdCampania] = PDVC.[IdCampania] AND CA.[Activo]=1)
    INNER JOIN [MARCA] M ON (M.[IdMarca] = CA.[IdMarca] AND M.IdEmpresa=@IdEmpresa)    
    INNER JOIN Cliente_PuntoDeVenta CPDV ON (PDVC.IdPuntoDeVenta = CPDV.IdPuntoDeVenta)
    INNER JOIN Cliente C ON (C.IdCliente=CPDV.IdCliente AND C.IdEmpresa=@IdEmpresa) 
    INNER JOIN Usuario_PuntoDeVenta UPDV ON (UPDV.IdPuntoDeVenta=CPDV.IdPuntoDeVenta)
	INNER JOIN Usuario_Cliente UC ON (C.IdCliente = UC.IdCliente AND UPDV.IdUsuario = UC.IdUsuario)
    INNER JOIN Usuario U ON (UC.IdUsuario=U.IdUsuario and (@IdUsuario IS NULL OR @IdUsuario = U.IdUsuario))
    WHERE PDVC.[Activo]=1 
    GROUP BY PDVC.[IdCampania],PDVC.[IdPuntoDeVenta],CA.[IdMarca],CA.[Nombre]
    
END
GO
