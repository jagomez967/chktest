SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetIdEmpresaPriceRequest]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[GetIdEmpresaPriceRequest] AS' 
END
GO
ALTER procedure [dbo].[GetIdEmpresaPriceRequest]
(
@GUID UNIQUEIDENTIFIER
)
AS
BEGIN

select c.idEmpresa as IdEmpresa
from PriceRequest p 
inner join cliente c
	on c.idCliente = p.IdCliente
where p.id = @GUID

END

