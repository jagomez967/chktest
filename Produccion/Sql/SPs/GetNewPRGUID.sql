SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetNewPRGUID]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[GetNewPRGUID] AS' 
END
GO
ALTER procedure [dbo].[GetNewPRGUID](@idCliente int,@idUsuario int = null)
AS 
BEGIN
	DECLARE @myNewPKTable TABLE (myNewPK UNIQUEIDENTIFIER)
	DEClARe @actualDate  DATETIME

	
	SET @actualDate = getdate()

	INSERT priceRequest(IdCliente,IdUsuario,Fecha,EstadoPR,activo)
	OUTPUT INSERTED.ID INTO @myNewPKTable
	VALUES(@idCliente,@IdUsuario,@actualDate,0,1)
	
	
	declare @fechaProximaAlerta datetime
	select @fechaProximaAlerta = dateadd(day,3,getdate()) 

	insert alertaPriceRequest(idPriceRequest,fecha)
	select myNewPk, @fechaProximaAlerta from @myNewPKTable

	SELECT myNewPK as [GUID] FROM @myNewPKTable

END
GO



 