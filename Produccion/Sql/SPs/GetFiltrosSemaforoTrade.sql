--GetFiltrosSemaforoTrade
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetFiltrosSemaforoTrade]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[GetFiltrosSemaforoTrade] AS' 
END
GO
ALTER procedure [dbo].GetFiltrosSemaforoTrade
(
	@IdCliente	int,
	@Top int = 0,
	@texto varchar(max)=''
)
as
BEGIN
	SET ROWCOUNT @Top
	
	--Este filtro deberia solo aplicar en EpsonTrade_DistribucionFisica_T30, es un hack para una necesidad puntual.
	--Perdon.
	/*
	Verde:   Amarillo: Sin Exhibición + Sin Stock (Con sell in) Rojo: Sin Exhibición + Stock (Con Sell In) Azul: Exhibición + Sin Stock (Con Sell in )
	--
	Nueva version: 
	 Cambio rojo por amarillo
	  Amarillo: Sin Exhibicion , con stock.
	  Rojo: Sin exhibicon y sin stock
	 Verde y Azul siguen igual
	*/
	SELECT 100 IdItem,'VERDE (Exh + Stock)' Descripcion
	UNION
	SELECT 200 IdItem,'AMARILLO (Sin Exh + Stock)' Descripcion
	UNION
	SELECT 300 IdItem,'ROJO (Sin Exh + Sin Stock)' Descripcion
	UNION
	SELECT 400 IdItem,'AZUL (Exh + Sin Stock)' Descripcion

	SET ROWCOUNT 0
END


GO
