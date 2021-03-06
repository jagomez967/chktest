SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetItemsModulosAlerta]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[GetItemsModulosAlerta] AS' 
END
GO

ALTER procedure [dbo].[GetItemsModulosAlerta]
(
	@IdCliente	int,
	@IdAlerta int
)
as
begin
	

	SELECT	m.Id,m.IdAlerta,m.IdModuloClienteItem,m.IdModuloItem,m.Leyenda,m.EsIgual,m.EsMayor,m.EsMenor,m.Valor
	from alertasModulos m
	inner join alertas a
	on a.id = m.idAlerta
	where m.idAlerta = @idAlerta
	and a.idCliente = @idCliente
end

GO
