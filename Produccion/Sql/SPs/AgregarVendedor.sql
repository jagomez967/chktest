SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AgregarVendedor]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[AgregarVendedor] AS' 
END
GO
ALTER procedure [dbo].[AgregarVendedor]

	@IdVendedor int,
	@IdPuntoDeVenta int,
	@IdCliente int
	
	
AS
BEGIN
	SET NOCOUNT ON;
	
	
if dbo.ExistePDVVendedor(@IdPuntoDeVenta, @IdVendedor, @IdCliente) = 1
begin
delete from PuntoDeVenta_Vendedor where Id in
	(select Id from PuntoDeVenta_Vendedor pdv
	inner join Vendedor v on v.IdVendedor = pdv.IdVendedor
	inner join Equipo e on e.IdEquipo = v.IdEquipo
	where pdv.IdPuntoDeVenta = @IdPuntoDeVenta and e.IdCliente = @IdCliente and pdv.IdVendedor != @IdVendedor)
if not exists (select 1 from PuntoDeVenta_Vendedor where IdVendedor = @IdVendedor and IdPuntoDeVenta = @IdPuntoDeVenta)
begin
	insert into PuntoDeVenta_Vendedor (IdVendedor, IdPuntoDeVenta)
	values (@IdVendedor, @IdPuntoDeVenta)
end
end
else
begin
if not exists (select 1 from PuntoDeVenta_Vendedor where IdVendedor = @IdVendedor and IdPuntoDeVenta = @IdPuntoDeVenta)
begin
	insert into PuntoDeVenta_Vendedor (IdVendedor, IdPuntoDeVenta)
	values (@IdVendedor, @IdPuntoDeVenta)
end
end

end


GO
