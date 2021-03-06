SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetClientes]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[GetClientes] AS' 
END
GO
ALTER procedure [dbo].[GetClientes]
(
	@IdUsuario	int
)
as
begin
	--exec GetClientes 89

	select C.IdCliente, C.Nombre
	from cliente C
	inner join Usuario_Cliente UC on UC.IdCliente = C.IdCliente
	where UC.IdUsuario = @IdUsuario
	order by C.Nombre
end
GO
