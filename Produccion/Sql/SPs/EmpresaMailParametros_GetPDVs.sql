SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[EmpresaMailParametros_GetPDVs]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[EmpresaMailParametros_GetPDVs] AS' 
END
GO
ALTER procedure [dbo].[EmpresaMailParametros_GetPDVs]
(
	@IdEmpresa int
)
as
begin
	--exec EmpresaMailParametros_GetPDVs 21
	--SELECT PDV.[IdPuntoDeVenta]
	--	  ,PDV.[Nombre]
 -- FROM [dbo].[PuntoDeVenta] PDV
 -- WHERE not exists(Select 1 from EmpresaMailParametros where EmpresaMailParametros.IdEmpresa = @IdEmpresa and EmpresaMailParametros.IdPuntoDeVenta = PDV.IdPuntoDeVenta)
 -- order by PDV.Nombre
	DECLARE @IdCliente int
	
	SELECT @IdCliente =  IdCliente FROM Cliente WHERE IdEmpresa = @IdEmpresa

	CREATE TABLE #PCU (IdCliente int, IdPuntoDeVenta int)

	INSERT INTO #PCU (IdCliente, IdPuntoDeVenta)
	SELECT [IdCliente]
		   ,[IdPuntoDeVenta]
	  FROM [dbo].[PuntoDeVenta_Cliente_Usuario] PCU
	  WHERE [IdCliente]=@IdCliente AND
			[IdPuntoDeVenta_Cliente_Usuario] IN  
		   (SELECT MAX([IdPuntoDeVenta_Cliente_Usuario])
			FROM [dbo].[PuntoDeVenta_Cliente_Usuario]
			WHERE [IdCliente] = PCU.IdCliente AND
				  [IdPuntoDeVenta] = PCU.IdPuntoDeVenta)
			AND [Activo]=1

	SELECT PDV.IdPuntoDeVenta as IdPuntoDeVenta
			  ,ltrim(rtrim(str(PDV.Codigo))) + ' - ' + ltrim(rtrim(PDV.Nombre)) as Nombre
		FROM Cliente_PuntoDeVenta CPDV	
		INNER JOIN PuntoDeVenta PDV ON (PDV.IdPuntoDeVenta = CPDV.IdPuntoDeVenta)	
		INNER JOIN #PCU PCU ON (PCU.IdPuntoDeVenta = PDV.IdPuntoDeVenta)
		WHERE @IdCliente = CPDV.IdCliente
			and not exists(Select 1 from EmpresaMailParametros where EmpresaMailParametros.IdEmpresa = @IdEmpresa and EmpresaMailParametros.IdPuntoDeVenta = PCU.IdPuntoDeVenta)
		ORDER BY PDV.Nombre
		
		DROP TABLE #PCU	
end
GO
