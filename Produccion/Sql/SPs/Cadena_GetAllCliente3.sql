SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Cadena_GetAllCliente3]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Cadena_GetAllCliente3] AS' 
END
GO
ALTER PROCEDURE [dbo].[Cadena_GetAllCliente3] 
	 
	@IdCliente int
   ,@Nombre varchar (50) = NULL
	
AS
BEGIN
	
  SET NOCOUNT ON;

  SELECT CA.[IdCadena]
        ,CA.[Nombre]
  FROM [dbo].[Cadena] CA  
  INNER JOIN dbo.Negocio N ON (CA.IdNegocio = N.IdNegocio)
  INNER JOIN Empresa E ON (N.IdNegocio = E.IdNegocio) --AGREGADO
  INNER JOIN Cliente C ON (E.IdEmpresa = C.IdEmpresa) --AGREGADO
  --INNER JOIN PuntoDeVenta PDV ON (PDV.IdCadena = CA.[IdCadena])
  --INNER JOIN Cliente_PuntoDeVenta CPDV ON (PDV.IdPuntoDeVenta = CPDV.IdPuntoDeVenta AND CPDV.IdCliente = @IdCliente)
  WHERE (C.IdCliente = @IdCliente) AND
		(@Nombre IS NULL OR CA.[Nombre] like '%' + @Nombre + '%')
  GROUP BY  CA.[IdCadena], CA.[Nombre]
  ORDER BY CA.[Nombre]
  
END
GO
