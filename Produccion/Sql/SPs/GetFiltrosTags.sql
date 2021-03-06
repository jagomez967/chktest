SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetFiltrosTags]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[GetFiltrosTags] AS' 
END
GO
ALTER procedure [dbo].[GetFiltrosTags]
(
	@IdCliente	int,
	@Top int = 0,
 @texto varchar(max)=''
)
as
BEGIN
	SET ROWCOUNT @Top

	create table #Clientes
	(
		idCliente int
	)
	declare @cClientes varchar(max)


	set @cClientes = 0

	if @cClientes = 0 
	begin
		insert #clientes(idCliente) 
		select fc.idCliente from familiaClientes fc
		where familia in (select familia from familiaClientes where idCliente = @idCliente
									and activo = 1)
		if @@rowcount = 0
		BEGIN
			insert #clientes(idcliente)
			values ( @idCliente) 
		END
	end



	SELECT idTag AS IdItem
		,leyenda AS Descripcion
	FROM tags
	WHERE idcliente in(select idCliente from #Clientes)
	AND  (isnull(@texto,'') = '' or leyenda like @texto +'%' COLLATE DATABASE_DEFAULT)
	--AND ACTIVO = 1
	SET ROWCOUNT 0
END


GO
