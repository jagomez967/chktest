SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetModulosAlerta]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[GetModulosAlerta] AS' 
END
GO
ALTER procedure [dbo].[GetModulosAlerta]
(
	@IdCliente	int
)
as
begin

	SELECT	m.idModuloClienteItem Id, m.IdModuloItem,m.Leyenda
	from m_moduloClienteItem m
	inner join m_moduloCliente mc
	on mc.idModuloCliente = m.idmoduloCliente
	inner join m_moduloItem mt
	on mt.idModuloItem = m.idModuloItem
	where mc.idCliente = @idCliente
	and mc.idModulo = 3
	and m.Activo = 1
	and mc.Activo = 1
	and m.visibilidad = 1
	and mt.idTipoItem = 5

end

GO
