SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Cadena_GetAllCliente]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Cadena_GetAllCliente] AS' 
END
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[Cadena_GetAllCliente]
	@IdEmpresa int	
AS
BEGIN
  SET NOCOUNT ON;

  Declare @IdCliente int	
  SELECT @IdCliente =  IdCliente FROM Cliente WHERE IdEmpresa = @IdEmpresa 
    
  SELECT CA.[IdCadena]
        ,CA.[Nombre]
  FROM [dbo].[Cadena] CA  
  INNER JOIN PuntoDeVenta PDV ON (PDV.IdCadena = CA.[IdCadena])
  INNER JOIN Cliente_PuntoDeVenta CPDV ON (PDV.IdPuntoDeVenta = CPDV.IdPuntoDeVenta AND CPDV.IdCliente = @IdCliente)
  GROUP BY  CA.[IdCadena], CA.[Nombre]
  ORDER BY CA.[Nombre]
  
END
GO
